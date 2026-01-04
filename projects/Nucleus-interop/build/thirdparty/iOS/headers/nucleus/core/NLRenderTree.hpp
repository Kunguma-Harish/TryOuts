#ifndef __NL_NLRENDERTREE_H
#define __NL_NLRENDERTREE_H

#include <nucleus/core/NLSkRTree.hpp>
#include <include/core/SkPicture.h>
#include <nucleus/recorder/NLPictureRecorder.hpp>
#include <skia-extension/GLRect.hpp>
#include <nucleus/util/RenderTreeUtil.hpp>
#include <unordered_map>


class NLCache;
class NLDeferredDetails;

struct CacheContainer {
    std::shared_ptr<NLPictureRecorder> nlPicture;
    SkRect bound = SkRect::MakeEmpty();
    bool restore = false;
    int saveCount = 0;
    bool containsErrorLines = false;

    struct ShapeIndex {
        int shpsi = 0;
        int shpei = 0;
        int txtsi = 0;
        int txtei = 0;
        int txterrorsi = 0;
        int txterrorei = 0;
        int drawCallsCount = 0;
    } shapeIndexSet;
    bool isInnerShape = false;
};

class NLRenderTree {
private:
    std::unordered_map<std::string, CacheContainer> cacheContainerMap; // <shapeId, cacheContainer>
    std::shared_ptr<TreeContainer> renderOrderTreeContainer;           //Flat treeContainer used for drawing playback

    bool onLoadRendering = true;
    bool highlightDuplicateShapes = false;
    graphikos::painter::GLRect maxCoverageRect;

    // for performance:
    int totalLeafNodes = 0;
    int totalContainerTypes = 0; // group shape mask frame etc.
    int totalSizeInKB = 0;

public:
    NLRenderTree();
    void clear();
    // populaters
    void addToCache(const std::string& shapeId, std::shared_ptr<NLPictureRecorder> nlPicture, SkRect bounds, int drawCallsCount = 0, bool isRestore = false, int saveCount = 0, int index = -1);
    void addShapeIndexToCache(const std::string& shapeId, int si, int ei, bool isRestore, int saveCount);
    void addTextIndexToCache(const std::string& shapeId, int si, int ei, int errorLineSi, int errorLineEi);
    void addToCache(const std::string& shapeId, CacheContainer cache);
    void addErrorLinesStatusToCache(const std::string& shapeId, bool containsErrorLines);

    void setMaxCoverageRect(graphikos::painter::GLRect bound);
    void appendMaxCoverageRect(graphikos::painter::GLRect bound);
    void setBound(const std::string& shapeId, SkRect bound);

    //getters
    CacheContainer getCacheContainer(const std::string& shapeId);
    std::shared_ptr<NLPictureRecorder> getNLPicture(const std::string& shapeId);
    graphikos::painter::GLRect getMaxCoverageRect();
    SkRect getBound(const std::string& shapeId);
    const std::vector<std::string>& getrenderOrderTreeShapeIds();

    //treeContainer accessors
    std::shared_ptr<TreeContainer> getTreeContainer();
    void constructRenderOrderTree();
    int getTreeIndex(std::string shapeId);

    bool isAlreadyCached(const std::string& shapeId);
    bool isAlreadyCachedUnderMap(const std::string& shapeId);
    bool isOnLoadRendering();
    void updateRenderingStatus();

    graphikos::painter::GLRect getMaxCoverageRectGivenshapeIds(std::vector<std::string> shapeIds);
    std::vector<std::string> getShapeIdsInRect(SkRect rect);
    graphikos::painter::GLRect getMostDenseRegion(float width, float height);
    int getWeightedDrawCallCount(const SkRect& queryRect, const SkMatrix& matrix, const int& uLimit);

    //playback
    bool playback(SkCanvas* canvas, const std::vector<std::string> selectedShapeIds = {});
    bool playback(SkCanvas* canvas, NLDeferredDetails* dd, const std::vector<std::string> selectedShapeIds = {});
    bool playback(std::shared_ptr<TreeContainer> treeContainer, SkCanvas* canvas, NLDeferredDetails* dd, const std::vector<std::string> selectedShapeIds = {});
    bool playback(std::shared_ptr<TreeContainer> treeContainer, SkCanvas* canvas, NLDeferredDetails* dd, std::vector<int> indices, const std::vector<std::string> selectedShapeIds = {});
    void playback(SkCanvas* canvas, std::string shapeId, const std::vector<std::string> selectedShapeIds = {});
    bool playbackPicture(const std::string& shapeId, const CacheContainer cache, SkCanvas* canvas, NLDeferredDetails* dd);
    bool customPlayback(const std::string& shapeId, SkCanvas* canvas, NLDeferredDetails* dd);

    void invalidateCache(const std::string& shapeId, std::shared_ptr<TreeContainer> _treeContainer);
    // bool updateGifs(graphikos::painter::IProvider* provider);

    std::function<std::shared_ptr<NLPictureRecorder>(std::string)> fetchParentNLPicture = nullptr;
    std::function<std::vector<int>(std::string, int lowerLimit, int upperLimit)> fetchErorrLineShapes = nullptr;

    std::function<bool()> fetchErrorLinesStatus = nullptr;

    std::shared_ptr<NLCache> rootCache = nullptr;
    // does this map should be here or it should be in cachebuilder ?
    std::unordered_map<std::string, std::shared_ptr<NLCache>> cacheMap;
    // will be removed after using field string, as of now stores caches inside components
    std::unordered_map<std::string, std::shared_ptr<NLCache>> componentCacheMap;

    static bool UseNewCache;

    
    //performance stats
    void updateShapesCount();
    std::unordered_map<std::string, int> getPerformanceStats();

private:
    void sortByX();
    void sortByY();
};

#endif
