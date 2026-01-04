#ifndef __NL_PICTURECROPCONTROLLER_H
#define __NL_PICTURECROPCONTROLLER_H

#include <app/controllers/NLEventController.hpp>
#include <app/controllers/NLEditorProperties.hpp>
#include <nucleus/core/layers/NLInstanceLayer.hpp>
#include <app/ZBBox.hpp>
#include <app/util/ZEditorUtil.hpp>

class NLDataController;

struct ZCropData {
    bool isCropMode = false;
    bool alreadyCropped = false;

    ZEditorUtil::EditingData imageEditingData;
    ZEditorUtil::EditingData frameEditingData;

    com::zoho::shapes::Transform* imageEditingTransform = nullptr;
    com::zoho::shapes::Transform* frameEditingTransform = nullptr;

    SkMatrix frameScaleMatrix = SkMatrix();
    SkMatrix imageScaleMatrix = SkMatrix();

    graphikos::painter::ShapeObjectsDetails cropImageDetails;
    graphikos::painter::ShapeObjectsDetails cropFrameDetails;

    bool isCornerOnCropImage = false;
};

class ImageCropController : public NLEventController {
private:
    NLEditorProperties* editorProperties = nullptr;
    NLDataController* data = nullptr;
    ZCropData cropData;
    bool dragStart = false;

    std::shared_ptr<NLShapeLayer> imageBBoxLayer = nullptr; // normal bbox
    std::shared_ptr<NLShapeLayer> frameBBoxLayer = nullptr; // frame bbox

    void setCropImage();
    void renderImageBBoxes(const DrawingContext& dc);
    void renderFrameBBoxes(const DrawingContext& dc);
    void renderCropShapeObjects();

    bool pointInCropImage(graphikos::painter::GLPoint mouse, graphikos::painter::GLRect frame, bool onModifier, const SkMatrix& matrix);

public:
    ImageCropController(NLDataController* dataController, ControllerProperties* properties, ZSelectionHandler* selectionHandler, NLEditorProperties* editorProperties);

    void onAttach() override;
    void onDetach() override;
    bool onMouseDown(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onDrag(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLPoint& prevPoint, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onMouseUp(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onMouseMove(const graphikos::painter::GLPoint& mouse, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onRightClickDown(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onKeyDown(int keyCode, int modifier, bool repeat, std::string keyCharacter, const SkMatrix& matrix) override;

    bool isCropMode();

    void setBBoxLayer(std::shared_ptr<NLShapeLayer> _shapeLayer);

    void renderCropBBoxes();
    void set();
    void reset();
    void crop();

    std::map<std::string, graphikos::painter::GLPoint> getCropFramePoints();
    std::map<std::string, graphikos::painter::GLPoint> getCropImagePoints();
};

#endif