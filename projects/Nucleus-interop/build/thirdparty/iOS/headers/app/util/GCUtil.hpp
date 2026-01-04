#ifndef __NL_GCUTIL_H
#define __NL_GCUTIL_H
#ifdef NL_ENABLE_FILESYSTEM_API
#include <filesystem>
#endif

#include <fstream>
#include <map>
#include <include/core/SkBitmap.h>
#include <app/ApplicationContext.hpp>
#include <nucleus/core/ZRenderBackend.hpp>
#include <nucleus/nucleus_export.h>
#include <skia-extension/GLPath.hpp>
#include <skia-extension/util/FnTypes.hpp>

class SkData;
class ZWindow;
struct Asset;
class NLView;
class ZEvents;

#ifdef __EMSCRIPTEN__
extern "C" {
char* generate_uuid();
}
#endif
namespace com {
namespace zoho {
namespace shapes {
class HyperLink;
enum HyperLink_LinkOpenType : int;
}
}
}

namespace graphikos {
namespace common {

class NUCLEUS_EXPORT GCUtil {
private:
    const static std::vector<std::uint8_t> GIFBytesOne;
    const static std::vector<std::uint8_t> GIFBytesTwo;

public:
    static std::vector<uint8_t> GetBytesFromFile(std::string path);
    /**
   * @brief Copies a bitmap pixel content into another bitmap
   *
   * @param bitmap will be copied from
   * @param copy copied to.
   */
    static void copyBitmap(SkBitmap bitmap, SkBitmap copy);

    static std::vector<uint8_t> ReadFromPath(std::filesystem::path filePath);

    static char* ReadFromPipe();

    /**
     * Exports the given Asset to the given folder
     * @return bool Whether the given asset was written or not
     */
    static bool WriteAsset(std::shared_ptr<Asset> asset, std::filesystem::path exportFilePath);

    /**
     * Cast a std::string* to sk_sp<SkImage>
     * Without giving ownership
     */
    static sk_sp<SkImage> GetSkImage(const std::string* bytes);

    /**
     * Search the given directory and return a map of images.
     * @return A map with imageId as value and the image data as value
     */
    std::map<std::string, std::vector<uint8_t>> getImages(std::string imagesDirectory);

    // CREATE_CALLBACK_STATIC(OnOpenUrl, void(com::zoho::shapes::HyperLink*));

    /*returns if the given header is GIF or not */
    static bool isGif(std::uint8_t* ImageBytes);

    static std::string platformWrapper_generate_uuid();
};
}
}

#endif
