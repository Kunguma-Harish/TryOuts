#ifndef I_PROVIDER_HPP
#define I_PROVIDER_HPP

#include <iostream>
#include <string>
#include <thread>
#include <vector>
#include <optional>

#include <skia-extension/GLRect.hpp>
#include <painter/RenderSettings.hpp>

#include <painter/GifData.hpp>

#define EMOJI_IMAGE_FONT_SIZE 160.0

namespace com {
namespace zoho {
namespace common {
class Reaction;
}
namespace shapes {
class Color;
class FontShape;
class Fill;
class TextBody;
class Paragraph;
class ParaStyle;
class PortionProps;
class Properties;
class ShapeObject;
class TextBoxProps;
class TableStyle;
class PictureFill_PictureFillType;
class PictureValue;
class Picture;
class TextBody;
class Stroke;

enum ShapeNodeType : int;
}
}
}
namespace graphikos {
namespace painter {
struct ShapeDetails;
struct GLPoint;
struct ShapeObjectsDetails;

namespace internal {
struct TextBulletDetails;
}
}
}
namespace google {
namespace protobuf {
template <typename T>
class RepeatedPtrField;
}
}

namespace Show {
enum GeometryField_ShapeGeometryType : int;
enum GeometryField_PresetShapeGeometry : int;
}

class SkShader;
class SkImage;
class ZRenderBackend;
struct DrawingContext;

template <typename T>
class sk_sp;

/// @todo remove later, required in NilaProvider
class NLDataController;

namespace skia {
namespace textlayout {
class Paragraph;
}
}

namespace graphikos {
namespace painter {
class IProvider {
public:
    bool isNew = false;
    NLDataController* data = nullptr;
    com::zoho::shapes::Color* styleColor = nullptr;

    IProvider();
    virtual ~IProvider();
    virtual com::zoho::shapes::Properties* getStyleProps(std::string styleId, std::string docId);
    virtual com::zoho::shapes::ParaStyle* getStyleForParaStyle(std::string styleId, std::string docId);
    virtual com::zoho::shapes::PortionProps* getStyleForPortionProps(std::string styleId, std::string docId);
    virtual com::zoho::shapes::ShapeObject* getLeaderShape(std::string shapeId, std::string docId, com::zoho::shapes::ShapeObject& currentShape);
    virtual com::zoho::shapes::TextBoxProps* getTextPropsDefaults();
    virtual com::zoho::shapes::PortionProps* getLinkProps();
    virtual com::zoho::shapes::ParaStyle* getTableParastyle();
    virtual void renderIcons(com::zoho::shapes::ShapeObject* mergedData, const DrawingContext& dc, com::zoho::shapes::ShapeObject* originalShapeObject, com::zoho::shapes::Transform* mergedTransform) {};

    const virtual com::zoho::shapes::ParaStyle* getParaStyleDefault(int level);
    const virtual com::zoho::shapes::ParaStyle* getParaStyleShapeDefault(int level);
    virtual com::zoho::shapes::Fill* getDefaultFill();
    void setData(NLDataController* data);

    const virtual std::map<std::string, std::vector<std::string>> getFallbackFontFamilies();
    virtual void markRequiredFont(std::string fontFamily, int weight, bool italic, std::string shapeId, bool isDefaultFont);
    virtual sk_sp<SkImage> getImage(const com::zoho::shapes::PictureValue& picValue, GLRect rect, std::thread::id threadId, com::zoho::shapes::Picture* picture);
    virtual void setImageShader(const com::zoho::shapes::PictureValue& picValue, sk_sp<SkShader> shader, GLRect rect, GLRect refreshRect, SkMatrix matrix, com::zoho::shapes::PictureFill_PictureFillType* picFillType);
    virtual sk_sp<SkImage> getPlaceHolderImage(std::string id = "");
    // Used to know the size of the image before it is received.
    virtual std::optional<SkSize> getPlaceholderSizeOfImage(std::string id);
    virtual SkScalar getBaselineOffsetForEmojiImage(std::string id);
    virtual bool isAudio(com::zoho::shapes::ShapeObject* shapeObject);

    virtual std::vector<std::shared_ptr<GifData>> getGifDataFromCache(std::string key);
    virtual std::vector<std::string> getIdsForKey(std::string key);
    virtual std::vector<std::string> getKeysFromCache();
    virtual void updateShaderDetails(int frameindex, std::string key, GifData& gifData);
    virtual std::vector<std::vector<GLRect>> getRectsForGif(std::vector<std::string> keys);
    virtual bool playGif(std::string shapeId);
    virtual void setGifStopFn(std::function<void(std::string)> stopFn);
    virtual void onSetGifFn(std::function<void(std::string)> setFn);
    virtual void setImageDataAsGif(std::string shapeId);

    virtual com::zoho::shapes::FontShape* getFontShape(std::string postscriptName);

    virtual void setIsNew(bool newMode);
    virtual void setStyleColor(com::zoho::shapes::Color* color);
    /* specific to show */
    virtual void getColorFromType(com::zoho::shapes::Color* color);
    virtual com::zoho::shapes::TableStyle* getTableStyle(std::string styleId);
    virtual std::vector<float> getTableRowHeights(const std::string& tableId);
    virtual bool isTableIgnoreMinimumWidth(const std::string& tableId);

    virtual void setTableRowHeights(std::string& tableId, std::vector<float>& rowheights);
    virtual void setShapeHeightCache(std::string& shapeId, std::string& parentId, float height);
    virtual std::string getUserName(std::string& zuid, std::string& shapeId);

    virtual com::zoho::shapes::ShapeObject* getDeleteIcon();
    virtual com::zoho::shapes::ShapeObject* getRemoveIcon();
    virtual void duplicateShapeObject(com::zoho::shapes::ShapeObject* duplicateShapeObject);
    virtual com::zoho::shapes::Fill* getFillFromTheme(int index);
    virtual std::multimap<std::string, com::zoho::shapes::Transform> getContainerNameAndTransform();

    virtual std::shared_ptr<com::zoho::shapes::ShapeObject> getDrawShapeData(int _shapeDrawType, com::zoho::shapes::ShapeNodeType shapeObjType, Show::GeometryField_ShapeGeometryType shapeGeoType, int drawToolType, Show::GeometryField_PresetShapeGeometry action, std::vector<float> drawToolColor, float strokeWidth, int formatType, int phType);

    virtual com::zoho::shapes::ShapeObject* getMergeShapeData(com::zoho::shapes::ShapeObject& shape);

    virtual void disableRenderTriggers(com::zoho::shapes::ShapeObject& shape, DrawingContext& dc);
    virtual void mergeConnectorTextBody(com::zoho::shapes::TextBody* textBody);
    virtual bool isEmptyPara(com::zoho::shapes::Paragraph* para);
    virtual const graphikos::painter::RenderSettings& getRenderSettings() = 0;
    virtual void setRenderSettings(const graphikos::painter::RenderSettings& renderSetting) = 0;
    virtual graphikos::painter::RenderSettings& mutableRenderSettings() = 0;
    std::string getEditingTextID() { return this->getRenderSettings().editingTextID; }
    void setEditingTextID(std::string textId) { this->mutableRenderSettings().editingTextID = textId; }
    virtual void onSelectionChange() {};

    virtual void renderReactions(com::zoho::shapes::ShapeObject* shape, const DrawingContext& dc, com::zoho::shapes::Transform& mergedTransform);
    virtual void getReactionDetails(std::vector<graphikos::painter::ShapeDetails>* shapedetailsArray, GLPoint point, com::zoho::shapes::ShapeObject* shape, com::zoho::shapes::Transform mergedTransform);
    virtual std::string getKeyForShapeId(std::string shapeId);
    virtual void stopGifs(std::string shapeId = "");
    virtual std::string getI18Name(std::string name) { return ""; };

    virtual graphikos::painter::GLRect getReactionRegion(google::protobuf::RepeatedPtrField<com::zoho::common::Reaction>* reactions, com::zoho::shapes::Transform* shapeTransform, Matrices matrices);
    virtual bool isTabularShape(com::zoho::shapes::ShapeObject* shapeObject);
    virtual bool canAddRowAbove(com::zoho::shapes::ShapeObject* shapeObject, std::tuple<int, int> minMaxRows);
    virtual bool canAddRowBelow(com::zoho::shapes::ShapeObject* shapeObject, std::tuple<int, int> minMaxRows);
    virtual bool canSwapRow(com::zoho::shapes::ShapeObject* shapeObject, int fromRow, int toRow);
    virtual bool canSwapCol(com::zoho::shapes::ShapeObject* shapeObject, int fromCol, int toCol);
    virtual bool canDeleteCol(com::zoho::shapes::ShapeObject* shapeObject);
    virtual bool canDeleteRow(com::zoho::shapes::ShapeObject* shapeObject, std::tuple<int, int> minMaxRows);
    virtual bool canRenderAddDeleteIcon(com::zoho::shapes::ShapeObject* shapeObject, bool rowIcons, bool colIcons);
    virtual bool isSpecialTable(com::zoho::shapes::ShapeObject* shapeObject);
    virtual bool canResizeCellBorders(com::zoho::shapes::ShapeObject* shapeObject);
    virtual bool renderNormalSelectionForTable(com::zoho::shapes::ShapeObject* shapeObject);
    virtual bool canRenderCellSelection(com::zoho::shapes::ShapeObject* shapeObject);
    virtual bool canDrawNewTableOnSwap(com::zoho::shapes::ShapeObject* shapeObject);
    virtual bool canAddCardinality(com::zoho::shapes::ShapeObject* startShapeObject, com::zoho::shapes::ShapeObject* endShapeObject);
    virtual bool updateAssociatedCardinality(const com::zoho::shapes::Stroke& stroke, com::zoho::shapes::ShapeObject* startShapeObject, com::zoho::shapes::ShapeObject* endShapeObject, com::zoho::shapes::ShapeObject* connectorObject);
    virtual bool isComponentShape(graphikos::painter::ShapeObjectsDetails& shpDetails, graphikos::painter::ShapeObjectsDetails& parentShapeDetail);
    struct ParaData {
        size_t paraIndex;
        std::shared_ptr<skia::textlayout::Paragraph> paragraph;
        graphikos::painter::internal::TextBulletDetails* bulletDetails;
        float xOffset;
        float yOffset;
        float paraHeight;
        float spacing;
        std::string paraId;
        bool containsBulletPlaceholder;
    };
    virtual std::optional<std::vector<ParaData>> getTextEditingParaData(std::string textBodyId) { return std::nullopt; };
    virtual void updateAutoLayoutConnectorTransform(com::zoho::shapes::ShapeObject* connectorShape);
    virtual std::vector<std::string> getAllValidComponentShapes(com::zoho::shapes::ShapeObject* shapeObject, bool includeBaseKit = false);
    virtual bool canEnableTextEditingForChild(com::zoho::shapes::ShapeObject* shapeObject);
    virtual GLRect getShapeBounds(std::string shapeId);
};
}
}
#endif
