#pragma once
#include <app/private/TextEditorControllerImpl.hpp>
#include <sktexteditor/editor.h>

class VaniTextEditorController : public TextEditorControllerImpl {
private:
    bool removeIconRendered = false;
    graphikos::painter::GLPoint lastSavedMousePoint;
    graphikos::painter::GLRect removeIconRect;
    size_t paraIndexForRemove = std::string::npos; // Used for para delete in checklists
    void renderParaRemoveIcon(graphikos::painter::GLPoint mouse);
    graphikos::painter::GLPoint getPointsForParaRemoveIcon(graphikos::painter::GLPoint point, float iconWidth, float iconHeight);

public:
    std::shared_ptr<NLInstanceLayer> paraRemoveIconLayer = nullptr;
    VaniTextEditorController(NLDataController* dataController, ZSelectionHandler* selectionHandler, ControllerProperties* properties, NLEditorProperties* editorProperties, std::shared_ptr<NLLayer> bboxLayer, std::shared_ptr<ZBBox> bbox);
    bool onMouseMove(const graphikos::painter::GLPoint& mouse, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onMouseDown(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onMouseUp(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onDrag(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLPoint& prevPoint, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    graphikos::painter::GLPoint getRemoveIconPosition();
    graphikos::painter::GLRect getRemoveIconRect(); // needed for qa testing
    void textDidChange(sktexteditor::Editor* editor) override;
    void onDetach() override; // need to remove paradeleteicon on shape removal
    void setMarginAndIndentOnBulletRemoval(com::zoho::shapes::ParaStyle* paraStyle) override;
};
