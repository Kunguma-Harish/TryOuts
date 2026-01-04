#ifndef __NL_RESOURCEHANDLER_H
#define __NL_RESOURCEHANDLER_H

#include <string>
#include <mutex>
#include <set>

#include <nucleus/Looper.hpp>
// #include <nucleus/core/ZWindow.hpp>
#include <app/handler/ImageHandler.hpp>
#include <app/handler/ThreadFactory.hpp>
#include <nucleus/interface/IDataListener.hpp>
#include <skia-extension/GLRect.hpp>
#include <skia-extension/util/FnTypes.hpp>
#include <app/nl_api/CallBacks.hpp>
#include <nucleus/util/RenderTreeUtil.hpp>

#include <include/core/SkBitmap.h>

#ifdef __EMSCRIPTEN__
#include <emscripten/emscripten.h>
#include <emscripten/bind.h>
#endif

class NLDataController;
class ZWindow;
class ImageHandler;
class SkImage;
class GrDirectContext;

namespace graphikos {
namespace painter {
// enum ImgStatus {
//     DEFAULT = 0,
//     REQUESTED = 1,
//     RECEIVED = 2,
//     FAILED = 3
// };

struct ImageData {
    // Constructor
    ImageData(sk_sp<SkImage> image, size_t size, std::string key, ImgStatus status);
    
    // General image management
    void addGroupId(std::string id);
    bool hasGroupId(std::string id);
    
    // Core image data
    sk_sp<SkImage> image;                  // Main image representation
    size_t size;                           // Memory size of image
    std::string key;                       // Unique identifier
    std::vector<std::string> groupIds;     // Groups this image belongs to
    ImgStatus status;                      // Current loading status
    bool isGif = false;                    // Whether this is an animated GIF
    
    // Placeholder and formatting information
    std::optional<SkSize> placeholderSize; // Size for placeholder before image loads
    SkScalar baselineOffset;               // For emoji positioning

    // for resolution based image quality replacement
    bool holdsHighResolution = false;
    
    //------------------------------------------------------------------------------
    // GIF Animation Support with Performance Optimizations
    //------------------------------------------------------------------------------
    
    // GIF state
    std::shared_ptr<SkCodec> codec;        // Codec for GIF decoding
    std::vector<sk_sp<SkImage>> frames;    // Cached decoded frames
    int counter = -1;                      // Reference counter for memory management
    
    // Frame metadata for optimized rendering
    std::vector<int> requiredFrames;       // Dependency mapping between frames
    std::vector<int> frameDurations;       // Duration of each frame in milliseconds
        
    // GIF rendering optimization
    SkBitmap reusableBitmap;               // Instance-specific bitmap for decoding
    
    // Memory management
    void clearFrames();                    // Clear cached frames to save memory
    void increaseCounter();                // Increase usage reference count
    void decreaseCounter();                // Decrease reference count, clear if zero
    
    //------------------------------------------------------------------------------
    // Optimized GIF Frame Decoding Methods
    //------------------------------------------------------------------------------
    
    // Main entry point for frame access - uses all optimizations
    sk_sp<SkImage> createImage(int frameIndex);
    
    
    // Alternative implementation that reuses bitmap memory
    sk_sp<SkImage> createImageWithReuse(int frameIndex);
    
    // Preloading for smoother animation
    void preloadInitialFrames();           // Preload first few frames on GIF load
    
    // Frame dependency analysis for optimized decoding
    void analyzeFrameDependencies();       // Analyze GIF structure for optimization
    
    //------------------------------------------------------------------------------
    // Helper methods (implementation details) 
    //------------------------------------------------------------------------------
    

    void ensureFrameDependenciesAnalyzed(); // Lazy-load dependency information
    SkBitmap& getReusableBitmap();          // Get shared bitmap for decoding
    int getRequiredFrameForIndex(int frameIndex); // Get dependency for a frame
    void ensureRequiredFrameDecoded(int requiredFrame); // Ensure dependency is ready
    sk_sp<SkImage> decodeFrameWithDependencies(int frameIndex, int requiredFrame, SkBitmap& bitmap);
    void preloadNextFrameIfNeeded(int frameIndex, SkBitmap& bitmap); // Smart preloading
};

struct ShaderDetail;

class ResourceHandler : public IDataListener, public IRenderListener {
private:
    std::mutex resourceMutex;
    size_t cacheLimit = 3221225472;
    size_t usedMemory = 0;
    size_t highResolutionMemory = 0;
    size_t usedMemoryForGif = 0;
    GrDirectContext* context = nullptr;
    std::thread::id threadId;
    ZWindow* offscreenWindow = nullptr;
    ZWindow* mainWindow = nullptr;
    std::shared_ptr<ImageHandler> imageHandler = nullptr;
    std::vector<ImageData> imageCache;
    std::map<std::string, std::vector<ShaderDetail>>* imageInfoMap;
    std::unordered_map<std::string, std::vector<std::string>>* keyIdsMap;
    std::unordered_map<std::string, std::string>* shapeIdsKeyMap; // for optimizing
    std::unordered_map<std::string, std::string>* shapeIdValueIdMap;
    std::unordered_map<std::string, std::shared_ptr<GifData>>* shapeIdGifDataMap;
    std::unordered_map<std::string, int> fontDataMap;
    std::string currentGroupId = "";
    bool dontClearCache = false;
    bool dontclearGifCache = false;

    struct FontKey {
        std::string family;
        int weight;
        bool italic;

        bool operator==(const FontKey& other) const {
            return family == other.family && weight == other.weight && italic == other.italic;
        }
    };
    struct FontKeyHash {
        std::size_t operator()(const FontKey& k) const {
            return ((std::hash<std::string>()(k.family) ^ (std::hash<int>()(k.weight) << 1)) >> 1) ^ (std::hash<bool>()(k.italic) << 1);
        }
    };
    std::unordered_map<FontKey, std::pair<std::set<std::string>, bool>, FontKeyHash> unresolvedFontIndexList;

    std::unordered_map<std::string, std::vector<std::shared_ptr<GifData>>>* gifsCache; // for every key there will be several shapes with the same picture. this is to control the rendering of each and every shape.

    CallBacks* cbs = nullptr;
    std::shared_ptr<TreeContainer> imageTreeContainer = nullptr;
    graphikos::painter::GLRect previousViewPort;

    void stopSingleGif(const std::string& shapeId);
    void stopAllGifs();
    std::set<std::string> runningGifShapeIds;

public:
    ResourceHandler();
    void setCallBackClass(CallBacks* cbs);
    CallBacks* getCallBackClass();
    void setImageHandler(std::shared_ptr<ImageHandler> imageHandler);
    void setImageShader(const std::string& valueId, const std::string& key, const std::string& url, std::string docId, sk_sp<SkShader> shader, const graphikos::painter::GLRect& rect, const graphikos::painter::GLRect& refreshRect, const SkMatrix& matrix, com::zoho::shapes::PictureFill_PictureFillType* picFillType);
    void setImageInShader(sk_sp<SkImage> image, std::string key, std::string id = "");
    sk_sp<SkImage> getCompressedImage(sk_sp<SkImage> image);
    std::vector<ImageData>::iterator getImageData(std::string key);
    size_t getGPUMemoryUsed();
    bool hasImageData(std::string key);
    void init(GrDirectContext* context, std::thread::id threadId, ZWindow* offScreenWindow, ZWindow* mainWindow);
    GrDirectContext* getGrDirectContext();
    void onDataChange(std::string docId);
    void setImgRect(std::string key, graphikos::painter::GLRect rect, bool checkForDuplicate = false);
    std::vector<ShaderDetail>& getImgRect(std::string key);

    void refreshImageRect(std::vector<ShaderDetail>& shaderDetails, std::string key);
    sk_sp<SkImage> getImage(const std::string& valueId, const std::string& key, const std::string& url, const graphikos::painter::GLRect& rect, std::thread::id thread_id);
    std::optional<SkSize> getPlaceholderSizeOfImage(std::string id);
    SkScalar getBaselineOffsetForEmojiImage(std::string id);
    void cacheImage(sk_sp<SkImage> image, std::string key, ImgStatus status, GrDirectContext* context);
#if defined(NL_ENABLE_NEXUS)
    CREATE_CALLBACK_NEXUS(OnRefreshRect, void, const graphikos::painter::GLRect&, const std::string&);
#else
    CREATE_CALLBACK(OnRefreshRect, void(const graphikos::painter::GLRect&, const std::string&));
#endif

    std::vector<std::shared_ptr<GifData>> getGifDataFromCache(std::string key);
    void cacheGif(std::string key, ImgStatus status, std::shared_ptr<SkCodec> codec);
    void setGif(std::vector<uint8_t>& data, std::string key, GrDirectContext* context);
    void setGif(std::vector<uint8_t>& data, std::string key);
    bool playGif(std::string shapeId);
    void createGifData(std::string clientKey, std::string shapeId, std::string valueId);
    void removeGifData(std::string shapeId);
    void stopGifs(std::string shapeId = "");
    std::function<void(std::string)> gifStopped;
    std::function<void(std::string)> onSetGif;
    void setImageDataAsGif(std::string shapeId);

    void rectRendered(std::string key, std::string valueId);
    void setImageTexture(ResourceDetails imageDetail, std::string key);
    void upSampleImageTexture(ResourceDetails imageDetail, std::string key);
    void downSampleImageTexture(std::string key);

    void updateShaderDetails(int frameindex, std::string key, GifData& gifData);
    std::vector<std::string> getKeysFromGifCache();
    std::vector<std::vector<GLRect>> getRects(std::vector<std::string> keys);
    std::vector<std::string> getIdsFromKey(std::string);
    std::string getKeyForShapeId(std::string shapeId);
    void addPicturesToKeyPicturesMap(std::string key, std::string shapeId, com::zoho::shapes::Picture* Picture);
    std::vector<std::string> getShapeIdsFromGifCache(std::string key);
    void setImage(ResourceDetails& imageDetail, std::string key);
    sk_sp<SkImage> getSkImageFromImageDetails(ResourceDetails imageDetail, std::string key);
    std::string getShapeIdFromValueId(std::string clientKey, std::string valueId);
    std::vector<std::string> getValueIdsFromClientKeyMap(std::string clientKey);

    // testing...
    void printImgIds(int status);

    ~ResourceHandler();

#ifdef __EMSCRIPTEN__
    emscripten::val getBytes(std::string id);
    size_t getUsedMemory() {
        return usedMemory;
    }
    void setCacheLimit(size_t _cacheLimit) {
        cacheLimit = _cacheLimit;
    }
    size_t getCacheLimit() {
        return cacheLimit;
    }
    void clearImageCache() {
        usedMemory = 0;
        imageCache.clear();
    }
#endif

    graphikos::painter::Callback<void(std::vector<std::string>, std::vector<std::string>)> reRenderShapesForFontAdd = std::function<void(std::vector<std::string>, std::vector<std::string>)>([](std::vector<std::string> ids, std::vector<std::string> addedFamilies) -> void {});
    /// Request to download or fetch font data with family name, weight and italic. Weight can be -1, if not available. In the case of default font, weight will be -1 and italic will be false and all styles must be downloaded.
    void requestFont(std::string familyName, int weight, bool italic, std::string shapeId, bool isDefaultFont);
    void addFontFile(uint8_t* data, size_t len, std::string familyName, int weight, bool italic);
    // void addFontFiles(uintptr_t dPtr, uintptr_t sPtr, std::vector<std::string> familyNames, int numberOfFonts);
    /// For clients that download all styles for a family, they can call this function to notify that all styles have been downloaded.
    /// In the case of default font, since all styles needs to be downloaded, it is mandatory to call this function.
    void completedAllRequestsForFamily(std::string familyName);
    void cleanUpReceivedImages() ;

    //ViewportTextureManager
    void onViewPortChange(SkRect query);
    std::vector<int> getImagesInViewport(graphikos::painter::GLRect query);
    void uploadHighResolutionImages(const std::string& key);
    void unloadHighResolutionImages(const std::string& key);
    
    std::unordered_map<std::string, int> getFontDataMap();
    std::unordered_set<std::string> upsampledImages;
};
}
}

#endif
