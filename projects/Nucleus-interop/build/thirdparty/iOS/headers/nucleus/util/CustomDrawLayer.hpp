#include <nucleus/core/layers/NLLayer.hpp>

class CustomDrawLayer : public NLLayer {
private:
    std::function<void(SkCanvas* canvas)> drawHandler;

public:
    CustomDrawLayer(NLLayerProperties* properties, graphikos::painter::GLRect viewPortRect, std::function<void(SkCanvas* canvas)> drawHandler) : NLLayer(properties, viewPortRect) {
        this->drawHandler = drawHandler;
    }

    bool onDraw(SkCanvas* canvas, NLDeferredDetails* dd, SkMatrix totalMatrix, bool applyContentScale = true) override {
        canvas->save();
        totalMatrix.postScale(this->getContentScale(), this->getContentScale());
        canvas->concat(totalMatrix);
        canvas->concat(getTotalMatrix());
        drawHandler(canvas);
        canvas->restore();
        return true;
    }
};
