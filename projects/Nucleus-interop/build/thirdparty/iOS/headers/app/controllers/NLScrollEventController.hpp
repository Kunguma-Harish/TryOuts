#ifndef __NL_SCROLLEVENTCONTROLLER_H
#define __NL_SCROLLEVENTCONTROLLER_H

#include <app/controllers/NLController.hpp>
#include <app/controllers/NLSelectionController.hpp>
#include <nucleus/core/layers/NLScrollLayer.hpp>
#include <app/controllers/NLFitController.hpp>

class NLAnimLayer;

class NLScrollEventController : public NLController, public NLSelectionController, public NLScrollLayer, public NLFitController {
    std::shared_ptr<NLAnimLayer> viewChangeAnimLayer = nullptr;

public:
    NLScrollEventController(ControllerProperties* properties, ZSelectionHandler* selectionHandler, NLLayerProperties* layerProperties, graphikos::painter::GLRect viewPortRect);
    void updateControllerMatrix(graphikos::painter::GLRect fitToRect, graphikos::common::FitToScreenUtil::FitType, bool needAnimation = false, float fitRatio = 0);
    virtual void animateViewChange(SkMatrix fitMatrix);
    virtual void refreshControllerRect(graphikos::painter::GLRect rect, std::string imageKey, bool instantRefresh = false);

    void selectAndFitShape(graphikos::painter::ShapeDetails shapedetails, bool triggerEvent, bool needToFit, bool needAnimation, bool maintainScale, bool alwaysFit);
    void fitShapesToVisibleArea(graphikos::painter::GLRect rect, graphikos::common::FitToScreenUtil::FitType, bool needAnimation = false, bool alwaysFit = false, float fitRatio = 0) override;
};

#endif