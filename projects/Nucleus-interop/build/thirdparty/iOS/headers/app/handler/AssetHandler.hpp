#ifndef __NL_ASSETHANDLER_H
#define __NL_ASSETHANDLER_H

#include <iostream>
#include <atomic>
#include <map>
#include <skia-extension/util/FnTypes.hpp>
#include <painter/IProvider.hpp>

#include <app/ApplicationContext.hpp>
#include <app/handler/ThreadFactory.hpp>
#include <nucleus/core/backends/ZRasterRenderBackend.hpp>
#include <nucleus/nucleus_export.h>
#include <app/structs/AssetStructs.hpp>

class SkData;

namespace graphikos {
namespace painter {
class ShapeDetails;
}
}

#ifdef __EMSCRIPTEN__
#include <emscripten.h>
#include <emscripten/bind.h>
#include <emscripten/val.h>
#endif

class CallBacks;
// auto AssetComp = [](const int& a1, const int& a2) {
//     return a1 < a2;
// };

class NUCLEUS_EXPORT AssetHandler {
protected:
    /// @todo add atomic
    std::map<int, std::shared_ptr<Asset>> assets;
    std::atomic<int> assetId = -1;

    NLDataController* dataController = nullptr;
    ControllerProperties* properties = nullptr;

    const uint8_t* imgPtr = nullptr;
    size_t length;

    // this function works only when using GL backend
    std::vector<ImageTile> getImageTiles(std::vector<std::vector<sk_sp<SkImage>>> tiles, int totalWidth, int totalHeight);

public:
    AssetHandler(NLDataController* dataController, ControllerProperties* properties);

    std::shared_ptr<Asset> getShapeAsAsset(ExportDetails exportDetails, std::shared_ptr<ZRenderBackend> renderBackend = nullptr, std::shared_ptr<NLOffscreenLayer> offScreenLayer = nullptr);
    void free(int assetId);

    std::shared_ptr<Asset> getShapeAsset(ExportDetails exportDetails, const uint8_t* shapeData, const size_t shapeDatalen, const uint8_t* gTransData, const size_t gTransDatalen, const uint8_t* matrixData, const size_t matrixDatalen, std::shared_ptr<ZRenderBackend> renderBackend = nullptr);
    std::shared_ptr<Asset> getShapeAsset(ExportDetails exportDetails, graphikos::painter::GLRect clipRect = graphikos::painter::GLRect(), std::shared_ptr<ZRenderBackend> renderBackend = nullptr);
    std::shared_ptr<Asset> getShapeAsset(ExportDetails exportDetails, com::zoho::shapes::ShapeObject* shapeObject, graphikos::painter::GLRect clipRect = graphikos::painter::GLRect(), std::shared_ptr<ZRenderBackend> renderBackend = nullptr);

    std::shared_ptr<Asset> getAssetsFromShapeDetails(ExportDetails exportDetails, graphikos::painter::ShapeDetails shapedetails, std::shared_ptr<ZRenderBackend> renderBackend = nullptr);
    std::shared_ptr<Asset> getRenderTreeAsAsset(ExportDetails exportDetails, std::shared_ptr<NLRenderTree> renderTree, std::shared_ptr<ZRenderBackend> renderBackend = nullptr, graphikos::painter::GLRect clipRect = graphikos::painter::GLRect());

    std::tuple<sk_sp<SkSurface>, std::shared_ptr<ZRenderBackend>> buildBackend(ExportDetails exportDetails, std::shared_ptr<ZRenderBackend> renderBackend = nullptr);

    std::shared_ptr<Asset> getShapeAsImageWithScale(int scaleX, int scaleY, int clarityScale, std::string shapeId, bool isAspectRatio, bool withProps);
    std::string convertShapesToSVG(GL_Ptr<google::protobuf::Message> shapeObject);
    std::string getdStringForShapeId(std::string shapeId);

    void getBytesFromShapeId(ExportDetails exportDetails);

    static std::string GetAssetTypeName(AssetType assetType);
    static AssetType GetAssetType(std::string assetType);
    void dumpAssets();

    // moved from vani asset handler
    std::shared_ptr<Asset> getDownloadAsset(std::vector<std::string> shapeIds, ExportDetails exportDetails, int extraSpace, std::shared_ptr<ZRenderBackend> renderBackend = nullptr);
    std::shared_ptr<Asset> getDownloadAssetForGivenRect(graphikos::painter::GLRect rect, ExportDetails exportDetails, int extraSpace, std::shared_ptr<ZRenderBackend> renderBackend = nullptr);
    std::shared_ptr<Asset> getAsset(std::vector<std::string> shapeIds, ExportDetails exportDetails, int extraSpace, graphikos::painter::GLRect maxCoverageRect, std::shared_ptr<ZRenderBackend> renderBackend = nullptr);
    bool canRenderShapeForDownload(std::string shapeId);

    void renderGivenDownloadShapeId(std::string shapeId, SkCanvas* canvas);
    std::shared_ptr<Asset> exportAsMultiplePagedPDF(std::vector<std::string> shapeIds);
    std::shared_ptr<Asset> exportFlowAsPDF(std::vector<std::string> shapeIds);
    std::vector<uint8_t> getShapeAsset(ExportDetails exportDetails,std::string json);
    std::vector<uint8_t> getShapeAssetUsingJSON(ExportDetails exportDetails,std::string json);
    virtual ~AssetHandler();
};

/// TODO: temp function and need to remove it
sk_sp<SkImage> tilesMerger(std::vector<std::vector<sk_sp<SkImage>>> tiles, int totalWidth, int totalHeight);
sk_sp<SkData> imagesToData(std::vector<std::vector<sk_sp<SkImage>>> tiles, int totalWidth, int totalHeight, ImageType imageType);

#endif
