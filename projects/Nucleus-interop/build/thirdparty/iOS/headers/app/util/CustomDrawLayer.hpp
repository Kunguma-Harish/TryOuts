#include <nucleus/core/layers/NLLayer.hpp>

class CustomDrawLayer : public NLLayer {
private:
    std::function<void(SkCanvas* canvas, SkMatrix totalMatrix)> drawHandler;

public:
    CustomDrawLayer(NLLayerProperties* layerProperties, graphikos::painter::GLRect viewPortRect, std::function<void(SkCanvas* canvas, SkMatrix totalMatrix)> drawHandler) : NLLayer(layerProperties, viewPortRect) {
        this->drawHandler = drawHandler;
    }

    bool onDraw(SkCanvas* canvas, NLDeferredDetails* dd, SkMatrix totalMatrix, bool applyContentScale = true) override {
        canvas->save();
        if (applyContentScale) {
            totalMatrix.postScale(this->getContentScale(), this->getContentScale());
        }
        canvas->concat(totalMatrix);
        canvas->concat(getTotalMatrix());
        drawHandler(canvas, totalMatrix);
        canvas->restore();
        return true;
    }
};
