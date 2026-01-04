#ifndef __NL_ASSETSTRUCTS_H
#define __NL_ASSETSTRUCTS_H
#include <iostream>
#include <skia-extension/util/FnTypes.hpp>
#include <nucleus/nucleus_export.h>
#include <map>
#include <skia/include/core/SkRefCnt.h>
#include <skia/include/core/SkData.h>
#include <include/gpu/GrBackendSurface.h>


class SkImage;

enum class AssetType {
    NONE,
    JSON,
    IMAGE,
    SVG,
    PDF,
    PROTO,
    TEXTURE

};
enum class ImageType {
    NOTYPE,
    PNG,
    JPEG,
    BMP
};

struct NUCLEUS_EXPORT ExportDetails {
    int width, height;
    float clarityScale = 1;
    std::string shapeId;
    bool isAspectRatio, withProps;
    AssetType type = AssetType::IMAGE;
    ImageType imageType = ImageType::PNG;
    float contentScale = 1;
    std::string callbackId = "", exportId = "";
    bool convertTextAsPath = true;
};

struct ImageTile {
    unsigned int texID;
    int width;
    int height;
    int row;
    int col;
};

struct ResourceDetails {
    void* mtlTexture = nullptr;
    int textureId = -1;
    float width = 0;
    float height = 0;
    std::string sizeString = "";
    bool isGif = false;
    bool async = false;
    std::vector<uint8_t> encoded;
    GrBackendTexture backendTexture;
};

struct NUCLEUS_EXPORT Asset {
    static std::map<std::string, AssetType> types;

    Asset();
    Asset(int assetId, std::string shapeId, AssetType assetType, sk_sp<SkData> data);
    Asset(int assetId, std::string shapeId, AssetType assetType, std::vector<ImageTile> tiles, std::vector<std::vector<sk_sp<SkImage>>> images);
    int id = -1;
    /// @todo refactor to uid
    std::string shapeId, subType;
    float width = 0;  //needed for image decode
    float height = 0; // needed for image decode
    size_t rowBytes = 0;
    AssetType type;
    sk_sp<SkData> data = nullptr;
    std::vector<ImageTile> tiles;
    std::vector<std::vector<sk_sp<SkImage>>> images;
#if defined(NL_ENABLE_NEXUS)
    NXByteMemoryView getUint8Array() {
        return NXByteMemoryView(data->bytes(), data->size());
    }
#endif

    /// @todo remove this later and add in bindings
    ~Asset();
};
#endif
