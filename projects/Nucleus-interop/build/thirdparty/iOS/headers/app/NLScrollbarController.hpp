#ifndef __NL_SCROLLBARCONTROLLER_H
#define __NL_SCROLLBARCONTROLLER_H

#include <app/controllers/NLEventController.hpp>
#include <skia-extension/GLRect.hpp>
#include <skia-extension/GLPath.hpp>

class SkPaint;
class NLShapeLayer;

class NLScrollbarController : public NLEventController {
    graphikos::painter::GLRect rangeRect = graphikos::painter::GLRect();
    float scrollbarWidth = NL_SCROLL_BAR_WIDTH;
    SkPaint scrollbarPaint = SkPaint();
    std::shared_ptr<NLShapeLayer> scrollbarShapelayer = nullptr;
    void populateScrollbar(SkMatrix totalMatrix);

public:
    NLScrollbarController(ControllerProperties* properties, NLLayerProperties* layerProperties, graphikos::painter::GLRect viewPortRect);
    void setRangeRect(graphikos::painter::GLRect rangeRect);
    void setScrollbarWidth(float scrollbarWidth);
    void setScrollbarPaint(SkPaint scrollbarPaint);

    void onAttach() override;
    void onDetach() override;
    void onDataChange(graphikos::painter::GLRect rangeRect, SkMatrix renderMatrix);

    void onViewTransformed(const ViewTransform& viewTransform, const SkMatrix& totalMatrix) override;
    bool onResize(const graphikos::painter::GLRect viewPortRect, const SkMatrix& matrix) override;
};

#endif