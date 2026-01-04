#ifndef __NL_VANIANCHORCONTROLLER_H
#define __NL_VANIANCHORCONTROLLER_H

#include <string>
#include <app/controllers/NLEventController.hpp>
#include <app/controllers/NLEditorProperties.hpp>
#include <nucleus/core/layers/NLInstanceLayer.hpp>
#include <app/CustomTextEditorController.hpp>

namespace com {
namespace zoho {
namespace shapes {
class ShapeObject;
}
}
}

#define ANCHORTEXTLIMIT 100

class VaniAnchorController : public NLEventController {
    std::string anchorHighlighted = "";
    bool isAnchorTextEditMode = false;
    std::string anchorSelectedId = "";
    std::shared_ptr<NLDataController> data = nullptr;
    graphikos::painter::ShapeDetails hoverShapeDetails;
    com::zoho::shapes::ShapeObject* editAnchorShapeObject = nullptr;
    std::shared_ptr<NLInstanceLayer> editIconLayer = nullptr;
    std::shared_ptr<NLInstanceLayer> editAnchorShapeLayer = nullptr;
    std::shared_ptr<CustomTextEditorController> customTextEditor;

    std::vector<EditingLayer> editingLayers;
    std::shared_ptr<NLLayer> editingLayer;
    std::shared_ptr<NLRenderLayer> nonEditingLayer;
    NLEditorProperties* editorProperties = nullptr;

public:
    VaniAnchorController(std::shared_ptr<NLDataController> dataController, ZSelectionHandler* selectionHandler, ControllerProperties* properties, NLEditorProperties* editorProperties, std::shared_ptr<CustomTextEditorController> customTextEditor);
    void onAttach() override;
    void onDetach() override;
    void onDataChange() override;
    bool onMouseDown(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onMouseUp(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onRightClickDown(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onKeyDown(int keyCode, int modifier, bool repeat, std::string keyCharacter, const SkMatrix& matrix) override;
    bool onDoubleClickEnd(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onTripleClickEnd(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onMouseMove(const graphikos::painter::GLPoint& mouse, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onDrag(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLPoint& prevPoint, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;

    bool isAnchor(std::string id);
    void switchToNonEditAnchor(com::zoho::shapes::ShapeObject* anchorShapeObject, bool isEscapeKey = false);
    std::string getAnchorAction(com::zoho::shapes::ShapeObject* anchorShapeObject, graphikos::painter::GLPoint mouse);
    void performAnchorAction(com::zoho::shapes::ShapeObject* anchorShapeObject, std::string action);
    void showEditIconOnHover(com::zoho::shapes::ShapeObject* anchorShapeObject);
    void reInitTextOnAnchor(com::zoho::shapes::ShapeObject* anchorShapeObject);
    com::zoho::shapes::ShapeObject* checkIfAnchorClicked(graphikos::painter::GLPoint mouse);
    void switchToEditAnchor(std::string anchorId);
    void setAnchorHighlighted(std::string value);
    std::string getAnchorHighlighted();
    std::string getAnchorSelectedId();
    bool getIsAnchorTextEditMode();
    std::string getAnchorTitle(std::string anchorId);
    void attachEditingAnchorLayer();
    void detachEditingAnchorLayer();
    void updateAnchorData(graphikos::painter::GLPoint start, graphikos::painter::GLPoint end);
    void onAnchorModify(std::vector<std::string> shapeIds, std::vector<int> opTypes);
    graphikos::painter::GLRect getEditAnchorShapeBound();
};

#endif