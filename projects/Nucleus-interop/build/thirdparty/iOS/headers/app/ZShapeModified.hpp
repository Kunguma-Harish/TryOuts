#ifndef __NL_ZSHAPEMODIFIED_H
#define __NL_ZSHAPEMODIFIED_H
#include <app/util/ZEditorUtil.hpp>
#include <skia-extension/util/FnTypes.hpp>
#ifdef __EMSCRIPTEN__
#include <emscripten.h>
#include <emscripten/bind.h>
#endif

namespace asset {
enum class phTypeEnum;
enum class Type;
};

struct TextModifyData;
struct ShapeData;
struct DrawTool {
    bool isCustomDraw = false;
    asset::Type type;
    bool shapeRecognition;
    std::vector<float> color;
    float strokeWidth = 2;
    DrawTool();
};

struct DrawData {
    bool inDrawMode = false;
    Show::GeometryField_PresetShapeGeometry action;     // RECT/OVAL/STAR
    com::zoho::shapes::ShapeNodeType shapeObjType;      // SHAPE/CONNECTOR
    Show::GeometryField_ShapeGeometryType shapeGeoType; // PRESET/CUSTOM
    asset::Type shapeDrawType;                          // text/connector/frame
    DrawTool drawTool;                                  // pen/highlighter
    asset::Type formatType;                             // for text
    asset::phTypeEnum phType;
    bool cornerRadius = false;  // connector corner radius
    std::string shapeName = ""; // frameName
    DrawData();
};

class EditorCallBacks;
class ZShapeModified {
protected:
    EditorCallBacks* editorCallBacks = nullptr;

public:
    // below two variables are used to check if the text is thrown
    bool isTextDeltaThrown = false;
    std::string textShapeId = ""; // used for caching previous selected shape as it causes issue in text data

    ZShapeModified(EditorCallBacks* cbs);
    bool updateThroughDelta = false;
    virtual bool textDirectDataChange(TextModifyData textData, bool triggerDataUpdated = true);
    virtual bool textThrow(TextModifyData textData, std::vector<ShapeData> shapeDatas, std::vector<SelectedShape> selectedShapes, bool autoFit = false);
    virtual bool tableTextDelete(std::vector<TextModifyData>& textData, std::vector<SelectedShape>& selectedShapes);

    void updateData(std::vector<ModifyData> dataToBeModified, std::vector<ShapeData> dependencyData, graphikos::painter::GLPoint mousePoint = graphikos::painter::GLPoint(), bool isExternalShape = false, bool shapesDuplicated = false, bool fromUI = false, NLDataController* controller = nullptr);
    virtual void updateDataThroughDelta(std::vector<ModifyData> dataToBeModified, std::vector<ShapeData> dependencyData, graphikos::painter::GLPoint mousePoint = graphikos::painter::GLPoint(), bool isExternalShape = false, bool shapesDuplicated = false, bool fromUI = false, NLDataController* controller = nullptr);
    static std::vector<ShapeData> getShapeModifiedData(std::vector<ModifyData>& dataToBeModified, graphikos::painter::IProvider* provider, bool shapesDuplicated = false);
    void directDataUpdate(std::vector<ModifyData> dataToBeModified);
    virtual void addShapeObject(com::zoho::shapes::ShapeObject* shapeObject, graphikos::painter::GLPoint mousePoint, NLDataController* data);
#if defined(NL_ENABLE_NEXUS)
    CREATE_CALLBACK_NEXUS(DataUpdated, void, bool, std::vector<std::string>);
#else
    CREATE_CALLBACK(DataUpdated, void(bool, std::vector<std::string>));
#endif
    virtual void addAndModifyShapeObjects(com::zoho::shapes::ShapeObject* shapeObject, graphikos::painter::GLPoint mousePoint, NLDataController* data, std::vector<ShapeData> dependencyShapeData);
};
#endif
