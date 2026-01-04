#pragma once
#include <app/NLDataController.hpp>
#include <app/controllers/NLEventController.hpp>
#include <app/ZShapeRecognition.hpp>
#include <app/ZShapeModified.hpp>
#include <app/controllers/NLEditorProperties.hpp>
#include <nucleus/core/layers/NLShapeLayer.hpp>
#include <nucleus/core/layers/NLInstanceLayer.hpp>

namespace Show {
enum GeometryField_PresetShapeGeometry : int;
enum GeometryField_ShapeGeometryType : int;
}
namespace com {
namespace zoho {
namespace shapes {
class CustomGeometry_Path;
enum ShapeNodeType : int;
}
}
}

struct Segments {
    graphikos::painter::GLPoint _handleIn;
    graphikos::painter::GLPoint _handleOut;
    graphikos::painter::GLPoint _point;
};

struct PathData {
    std::vector<graphikos::painter::GLPoint> pathPoints;
    float joinOffset = 5;
    std::shared_ptr<com::zoho::shapes::ShapeObject> data;
    graphikos::painter::GLRect rect;
    float errorDistance = 10;
    std::vector<Segments> segments;
    Show::GeometryField_ShapeGeometryType genre;
    std::string drawType;
};

struct CustomDrawData {
    graphikos::painter::GLPoint prevPoint;
    PathData path;
    std::shared_ptr<ZShapeRecognition> shapeRecognition;
};

struct PresetDrawData {
    std::shared_ptr<com::zoho::shapes::ShapeObject> presetShapeObject;
    bool shapeDrawn = false;
    graphikos::painter::Matrices matrices;
    bool flipX = false;
    bool flipY = false;
};

class DrawController : public NLEventController {
private:
    std::shared_ptr<NLRenderLayer> drawNLRLayer;
    std::shared_ptr<CustomDrawData> customDrawData;
    bool isContinuousDraw = false;

    void setCursor();

    //customDraw
    void appendPoint(com::zoho::shapes::PathObject* path);
    void drawShape();
    void updateTransform(const graphikos::painter::GLPoint& point);
    void RecognizeShape(com::zoho::shapes::Properties* shapeProps, const ZShapeRecognitionData& recognizeData);
    com::zoho::shapes::CustomGeometry_Path getPathObject();
    com::zoho::shapes::CustomGeometry_Path simplify();
    graphikos::painter::GLPoint add(const graphikos::painter::GLPoint& pt1, const graphikos::painter::GLPoint& pt2);
    graphikos::painter::GLPoint subtract(const graphikos::painter::GLPoint& pt1, const graphikos::painter::GLPoint& pt2);
    graphikos::painter::GLPoint multiply(const graphikos::painter::GLPoint& pt1, const graphikos::painter::GLPoint& pt2);
    graphikos::painter::GLPoint divide(const graphikos::painter::GLPoint& pt1, const graphikos::painter::GLPoint& pt2);
    float dot(const graphikos::painter::GLPoint& pt1, const graphikos::painter::GLPoint& pt2);
    graphikos::painter::GLPoint normalize(const graphikos::painter::GLPoint& point, float length);
    float getLength(const graphikos::painter::GLPoint& pt1);
    float getDistance(const graphikos::painter::GLPoint& pt1, const graphikos::painter::GLPoint& pt2);
    void addCurve(const graphikos::painter::GLPoint& curve0, const graphikos::painter::GLPoint& curve1, const graphikos::painter::GLPoint& curve2, const graphikos::painter::GLPoint& curve3);
    std::vector<float> chordLengthParameterize(float first, float last);
    void fitCubic(float first, float last, const graphikos::painter::GLPoint& tan1, const graphikos::painter::GLPoint& tan2);
    std::map<std::string, int> findMaxError(float first, float last, const std::vector<graphikos::painter::GLPoint>& curve, std::vector<float> u);
    graphikos::painter::GLPoint evaluate(int degree, const std::vector<graphikos::painter::GLPoint>& curve, float t);
    bool reparameterize(float first, float last, std::vector<float>& u, const std::vector<graphikos::painter::GLPoint>& curve);
    float findRoot(const std::vector<graphikos::painter::GLPoint>& curve, const graphikos::painter::GLPoint& point, float u);
    std::vector<graphikos::painter::GLPoint> generateBezier(float first, float last, std::vector<float> uPrime, const graphikos::painter::GLPoint& tan1, const graphikos::painter::GLPoint& tan2);
    void recalculatePathPoints(google::protobuf::RepeatedPtrField<com::zoho::shapes::CustomGeometry_Path>* pathList, float dx, float dy, float width, float height);
    void attachLayers();
    void detachLayers();

    //presetDraw
    void drawPresetShape(float scale = 1.0f);

protected:
    NLEditorProperties* editorProperties = nullptr;
    std::shared_ptr<NLShapeLayer> drawShapeLayer;
    NLDataController* data = nullptr;
    std::shared_ptr<PresetDrawData> presetDrawData;
    DrawData drawObject = DrawData();

    virtual void drawContainerName(float scale = 1.0f);

public:
    DrawController(NLDataController* dataController, ZSelectionHandler* selectionHandler, ControllerProperties* properties, NLEditorProperties* editorProperties);

    void onAttach() override;
    void onDetach() override;
    bool onMouseUp(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onMouseDown(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onMouseMove(const graphikos::painter::GLPoint& mouse, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onDrag(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLPoint& prevPoint, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onKeyDown(int keyCode, int modifier, bool repeat, std::string keyCharacter, const SkMatrix& matrix) override;
    bool onRightClickDown(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;

    bool isDrawMode();
    void setContinuousDrawing(bool isContinuousDraw);
    void setDrawObject(const DrawData& drawData);
    virtual void clear();
    void clearDrawMode();

    ~DrawController();
};