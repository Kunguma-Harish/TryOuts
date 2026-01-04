#ifndef __NL_VANIPROVIDER_H
#define __NL_VANIPROVIDER_H

#include <painter/IProvider.hpp>
#include <include/core/SkData.h>
#include <vani/RemoteBoardRenderSettings.hpp>

#ifdef __EMSCRIPTEN__
extern "C" {
char* get_I18Name(const char* name);
}
#endif

namespace com {
namespace zoho {
namespace shapes {
class Stroke;
class ShapeObject;
class Properties;
class PictureFill_PictureFillType;
}
namespace kits {
enum DesignDiagramFields_Cardinality : int;
class BaseKit;
}
}
}
namespace Show {
enum StrokeField_MarkerType : int;
}
using Cardinality = com::zoho::kits::DesignDiagramFields_Cardinality;
using Markertype = Show::StrokeField_MarkerType;
class VaniProvider : public graphikos::painter::IProvider {
public:
    VaniProvider();
    RemoteBoardRenderSettings remoteboardRenderSettings;

    virtual const graphikos::painter::RenderSettings& getRenderSettings() override { return remoteboardRenderSettings.rs; }
    virtual void setRenderSettings(const graphikos::painter::RenderSettings& renderSetting) override {
        remoteboardRenderSettings.rs = renderSetting.clone();
    }
    virtual graphikos::painter::RenderSettings& mutableRenderSettings() override { return remoteboardRenderSettings.rs; }
    com::zoho::shapes::Properties* getStyleProps(std::string styleId, std::string documentId) override;
    com::zoho::shapes::ShapeObject* getLeaderShape(std::string shapeId, std::string docId, com::zoho::shapes::ShapeObject& currentShape) override;
    const std::map<std::string, std::vector<std::string>> getFallbackFontFamilies() override;
    void markRequiredFont(std::string fontFamily, int weight, bool italic, std::string shapeId, bool isDefaultFont) override;
    std::optional<SkSize> getPlaceholderSizeOfImage(std::string id) override;
    SkScalar getBaselineOffsetForEmojiImage(std::string id) override;
    sk_sp<SkImage> getImage(const com::zoho::shapes::PictureValue& picValue, graphikos::painter::GLRect rect, std::thread::id threadId, com::zoho::shapes::Picture* picture) override;
    void setImageShader(const com::zoho::shapes::PictureValue& picValue, sk_sp<SkShader> shader, graphikos::painter::GLRect rect, graphikos::painter::GLRect refreshRect, SkMatrix matrix, com::zoho::shapes::PictureFill_PictureFillType* picFillType) override;
    com::zoho::shapes::ParaStyle* getStyleForParaStyle(std::string styleId, std::string docId) override;
    com::zoho::shapes::PortionProps* getStyleForPortionProps(std::string styleId, std::string docId) override;

    std::vector<std::shared_ptr<graphikos::painter::GifData>> getGifDataFromCache(std::string key) override;
    std::vector<std::string> getKeysFromCache() override;
    std::vector<std::vector<graphikos::painter::GLRect>> getRectsForGif(std::vector<std::string> keys) override;
    std::string getKeyForShapeId(std::string shapeId) override;
    std::vector<std::string> getIdsForKey(std::string key) override;
    void updateShaderDetails(int frameindex, std::string key, graphikos::painter::GifData& gifData) override;
    void setGifStopFn(std::function<void(std::string)> stopFn) override;
    void onSetGifFn(std::function<void(std::string)> setFn) override;
    bool playGif(std::string shapeId) override;
    void setImageDataAsGif(std::string shapeId) override;

    void getColorFromType(com::zoho::shapes::Color* color) override;
    com::zoho::shapes::TableStyle* getTableStyle(std::string styleId) override;
    std::vector<float> getTableRowHeights(const std::string& tableId) override;
    bool isTableIgnoreMinimumWidth(const std::string& tableId) override;
    void setTableRowHeights(std::string& tableId, std::vector<float>& rowheights) override;
    void setShapeHeightCache(std::string& shapeId, std::string& parentId, float height) override;
    std::string getUserName(std::string& zuid, std::string& shapeId) override;
    com::zoho::shapes::Fill* getFillFromTheme(int index) override;

    std::multimap<std::string, com::zoho::shapes::Transform> getContainerNameAndTransform() override;

    com::zoho::shapes::TextBoxProps* getTextPropsDefaults() override;
    com::zoho::shapes::Fill* getDefaultFill() override;
    com::zoho::shapes::Fill getPlaceHolderFill();
    com::zoho::shapes::PortionProps* getLinkProps() override;
    com::zoho::shapes::ParaStyle* getTableParastyle() override;
    com::zoho::shapes::ShapeObject* getRemoveIcon() override;
    void duplicateShapeObject(com::zoho::shapes::ShapeObject* duplicateShapeObject) override;

    const com::zoho::shapes::ParaStyle* getParaStyleDefault(int level) override;
    const com::zoho::shapes::ParaStyle* getParaStyleShapeDefault(int level) override;

    std::shared_ptr<com::zoho::shapes::ShapeObject> getDrawShapeData(int _shapeDrawType, com::zoho::shapes::ShapeNodeType shapeObjType, Show::GeometryField_ShapeGeometryType shapeGeoType, int drawToolType, Show::GeometryField_PresetShapeGeometry action, std::vector<float> drawToolColor, float strokeWidth, int formatType, int phType) override;

    com::zoho::shapes::ShapeObject* getMergeShapeData(com::zoho::shapes::ShapeObject& shape) override;
    void disableRenderTriggers(com::zoho::shapes::ShapeObject& shape, DrawingContext& dc) override;
    com::zoho::shapes::ShapeObject* getAudioShapeObject(com::zoho::shapes::ShapeObject* shapeObject, bool isTextEdit = false);
    com::zoho::shapes::ShapeObject* _getEmbedShapeObject(com::zoho::shapes::ShapeObject* shapeObject);
    com::zoho::shapes::ShapeObject* getVideoShapeObject(com::zoho::shapes::ShapeObject* shapeObject);
    com::zoho::shapes::ShapeObject* getFileShapeObject(com::zoho::shapes::ShapeObject* shapeObject);
    std::string getFileName(com::zoho::shapes::ShapeObject* shapeObject);
    com::zoho::shapes::ShapeObject* getEmbedShapeObject(com::zoho::shapes::ShapeObject* shapeObject);
    bool isAudio(com::zoho::shapes::ShapeObject* shapeObject) override;
    void renderIcons(com::zoho::shapes::ShapeObject* mergedData, const DrawingContext& dc, com::zoho::shapes::ShapeObject* originalShapeObject, com::zoho::shapes::Transform* mergedTransform) override;

    com::zoho::shapes::ShapeObject* convertPlaceHolderData(com::zoho::shapes::ShapeObject& shape);
    com::zoho::shapes::ShapeObject* convertConnectorData(com::zoho::shapes::ShapeObject& shape);
    void mergeConnectorTextBody(com::zoho::shapes::TextBody* textBody) override;
    bool isEmptyPara(com::zoho::shapes::Paragraph* para) override;
    com::zoho::shapes::ShapeObject* convertEmbedData(com::zoho::shapes::ShapeObject& shape);
    com::zoho::shapes::Stroke* getPlaceholderStroke();
    bool isPictureStrokeAvailable(com::zoho::shapes::ShapeObject& shape);
    com::zoho::shapes::ShapeObject* convertPictureData(com::zoho::shapes::ShapeObject& shape);
    void stopGifs(std::string shapeId = "") override;

    void changeShapeIdsOfGroupShape(com::zoho::shapes::ShapeObject* shape, std::string shapeId);

    void renderReactions(com::zoho::shapes::ShapeObject* shape, const DrawingContext& dc, com::zoho::shapes::Transform& mergedTransform) override;
    void getReactionDetails(std::vector<graphikos::painter::ShapeDetails>* shapedetailsArray, graphikos::painter::GLPoint point, com::zoho::shapes::ShapeObject* shape, com::zoho::shapes::Transform mergedTransform) override;
    graphikos::painter::GLRect getReactionRegion(google::protobuf::RepeatedPtrField<com::zoho::common::Reaction>* reactions, com::zoho::shapes::Transform* shapeTransform, graphikos::painter::Matrices matrices) override;
    std::string getAudioName(com::zoho::shapes::ShapeObject* shapeObject, bool includeAudioFormat = true);
    std::string getAudioDuration(com::zoho::shapes::ShapeObject* shapeObject);
    std::unordered_map<std::string, int> getFontDataMap();
    size_t getGPUMemoryUsed();
    std::string getI18Name(std::string name) override;
    bool isTabularShape(com::zoho::shapes::ShapeObject* shapeObject) override;
    bool canAddRowAbove(com::zoho::shapes::ShapeObject* shapeObject, std::tuple<int, int> minMaxRows) override;
    bool canAddRowBelow(com::zoho::shapes::ShapeObject* shapeObject, std::tuple<int, int> minMaxRows) override;
    // bool canAddColLeft(com::zoho::shapes::ShapeObject* shapeObject) override;
    // bool canAddColRight(com::zoho::shapes::ShapeObject* shapeObject) override;
    bool canSwapRow(com::zoho::shapes::ShapeObject* shapeObject, int fromRow, int toRow) override;
    bool canSwapCol(com::zoho::shapes::ShapeObject* shapeObject, int fromCol, int toCol) override;
    bool canDeleteCol(com::zoho::shapes::ShapeObject* shapeObject) override;
    bool canDeleteRow(com::zoho::shapes::ShapeObject* shapeObject, std::tuple<int, int> minMaxRows) override;
    // bool isColSwapAllowed(com::zoho::shapes::ShapeObject* shapeObject) override;
    // bool isRowSwapAllowed(com::zoho::shapes::ShapeObject* shapeObject) override;
    bool canRenderAddDeleteIcon(com::zoho::shapes::ShapeObject* shapeObject, bool rowIcons, bool colIcons) override;
    bool isSpecialTable(com::zoho::shapes::ShapeObject* shapeObject) override;
    bool canResizeCellBorders(com::zoho::shapes::ShapeObject* shapeObject) override;
    bool canRenderCellSelection(com::zoho::shapes::ShapeObject* shapeObject) override;
    bool renderNormalSelectionForTable(com::zoho::shapes::ShapeObject* shapeObject) override;
    bool canDrawNewTableOnSwap(com::zoho::shapes::ShapeObject* shapeObject) override;
    bool canAddCardinality(com::zoho::shapes::ShapeObject* startShapeObject, com::zoho::shapes::ShapeObject* endShapeObject) override;
    bool updateAssociatedCardinality(const com::zoho::shapes::Stroke& stroke, com::zoho::shapes::ShapeObject* startShapeObject, com::zoho::shapes::ShapeObject* endShapeObject, com::zoho::shapes::ShapeObject* connectorObject) override;
    Cardinality getAssociatedCardinality(Markertype markerType);
    bool isERDTable(com::zoho::shapes::ShapeObject* shapeObject);
    bool isComponentShape(graphikos::painter::ShapeObjectsDetails& shpDetails, graphikos::painter::ShapeObjectsDetails& parentShapeDetail) override;
    std::vector<std::string> getAllValidComponentShapes(com::zoho::shapes::ShapeObject* shapeObject, bool includeBaseKit) override;
    bool canEnableTextEditingForChild(com::zoho::shapes::ShapeObject* shapeObject) override;
    graphikos::painter::GLRect getShapeBounds(std::string shapeId) override;
    bool isTextEditableKit(const com::zoho::kits::BaseKit baseKit);
};
#endif
