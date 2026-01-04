#ifndef __NL_ZMODIFIERSCONTROLLER_H
#define __NL_ZMODIFIERSCONTROLLER_H

#include <app/controllers/NLEventController.hpp>
#include <app/controllers/NLEditorProperties.hpp>
#include <nucleus/core/layers/NLInstanceLayer.hpp>
#include <app/ZBBox.hpp>
#include <app/ZShapeModified.hpp>

class NLDataController;
class ZData;
class ConnectorController;

namespace com {
namespace zoho {
namespace shapes {
class Preset;
}
}
}

struct ZModifiersData {
    bool isModifierEditing = false;
    int handleNum;
    com::zoho::shapes::ShapeObject* shapeObject = nullptr;

    std::vector<graphikos::painter::GLPoint> p1;
    std::vector<graphikos::painter::GLPoint> p2;
    std::vector<graphikos::painter::GLPoint> p3;
    std::vector<graphikos::painter::GLPoint> p4;
    std::vector<float> point;
    std::vector<float> diff;

    graphikos::painter::GLPoint offset;
};

class ModifiersController : public NLEventController {
private:
    NLDataController* data = nullptr;
    ZModifiersData modData;
    std::shared_ptr<ConnectorController> connectorController = nullptr;
    bool dragHandled = false;
    bool dragStart = false;
    NLEditorProperties* editorProperties = nullptr;
    int selectedHandle = -1;

public:
    std::shared_ptr<NLInstanceLayer> modifierIcon = nullptr; // for rendering   modifier icon
    ModifiersController(NLDataController* dataController, ZSelectionHandler* selectionHandler, ControllerProperties* properties, NLEditorProperties* editorProperties);

    void onAttach() override;
    void onDetach() override;
    bool onMouseDown(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onMouseUp(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onMouseHold(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLPoint& prevPoint, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onDrag(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLPoint& prevPoint, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onMouseMove(const graphikos::painter::GLPoint& mouse, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onDoubleClick(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onDoubleClickEnd(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onTripleClick(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onTripleClickEnd(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onTextInput(std::string inputStr, int compositionStatus, const SkMatrix& matrix) override;
    bool onKeyDown(int keyCode, int modifier, bool repeat, std::string keyCharacter, const SkMatrix& matrix) override;

    void setConnectorController(std::shared_ptr<ConnectorController> _connectorController);

    bool isModifierEditingMode();
    com::zoho::shapes::ShapeObject* getModifierShape();

    bool renderModifierBboxes(std::vector<SelectedShape>& selectedShapesInfos);
    bool _renderModifierBboxes(com::zoho::shapes::ShapeObject* shapeObject, const DrawingContext& dc);
    void renderModifierShapeObject();
    void computeModifierValues(Show::GeometryField_PresetShapeGeometry presetType, com::zoho::shapes::Preset* preset, com::zoho::common::Dimension* dim);
    void reset();

    std::vector<graphikos::painter::GLPoint> getModifierPoints();
};
#endif
