#ifndef __NL_SCROLLLAYER_H
#define __NL_SCROLLLAYER_H
#include <nucleus/core/layers/NLLayer.hpp>

class NLScrollLayer : public NLLayer {
public:
    enum NLPivot {
        TOP_LEFT = 1,
        TOP_RIGHT = 2,
        BOTTOM_LEFT = 3,
        BOTTOM_RIGHT = 4,
        CENTER = 5
    };
    NLScrollLayer(NLLayerProperties* properties, graphikos::painter::GLRect viewPortRect, SkColor layerColor = SK_ColorTRANSPARENT);
    void setContentRect(graphikos::painter::GLRect contentRect, NLPivot pivot = NLPivot::CENTER);
    graphikos::painter::GLRect getContentRect();
    NLPivot getPivot();
    void allowScroll(bool allowScrollX, bool allowScrollY);
    void allowMagnify(bool allowMagnifyX, bool allowMagnifyY);
    bool doesAllowScroll();
    bool doesAllowMagnify();
    bool onTranslate(float transX, float transY) override;
    bool onMagnify(float magnification, graphikos::painter::GLPoint byPoint) override;
    bool onTransform(const SkMatrix& matrix, bool preConcat) override;
    void updateViewMatrix(SkMatrix matrix) override;

private:
    bool allowScrollX = false;
    bool allowScrollY = false;
    bool allowMagnifyX = false;
    bool allowMagnifyY = false;
    graphikos::painter::GLRect contentRect = graphikos::painter::GLRect();
    NLPivot pivot = NLPivot::CENTER;
};

#endif