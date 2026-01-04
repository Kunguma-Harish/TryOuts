#ifndef __NL_FINITEZONECONTROLLER_H
#define __NL_FINITEZONECONTROLLER_H

#include <app/controllers/NLScrollEventController.hpp>
#include <nucleus/core/layers/NLInstanceLayer.hpp>
#include <app/controllers/NLEditorProperties.hpp>
#include <nucleus/core/layers/NLRenderLayer.hpp>

class FiniteZoneController : public NLScrollEventController {
private:
    std::shared_ptr<NLRenderLayer> editorLayer = nullptr;
    std::shared_ptr<NLDataController> dataController = nullptr;
    NLEditorProperties* editorProperties = nullptr;
    bool viewingShape = false;

public:
    FiniteZoneController(std::shared_ptr<NLDataController> dataController, ControllerProperties* properties, NLEditorProperties* editorProperties, ZSelectionHandler* selectionHandler);
    void onAttach() override;
    void onDetach() override;
    void onDataChange() override;
    void refreshControllerRect(graphikos::painter::GLRect rect, std::string imageKey, bool instantRefresh = false) override;

    void setLayerColor(SkColor layerColor) override;

    void viewShape(std::string shapeId, NLPivot pivot = CENTER);
    void exitViewingShape();

    bool onMouseDown(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onMouseUp(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;

    bool onKeyDown(int keyCode, int modifier, bool repeat, std::string keyCharacter, const SkMatrix& matrix) override;
};

#endif
