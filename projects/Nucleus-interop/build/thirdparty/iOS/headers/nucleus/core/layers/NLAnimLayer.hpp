#ifndef __NL_ANIMLAYER_H
#define __NL_ANIMLAYER_H

#include <nucleus/core/layers/NLScrollLayer.hpp>
#include <nucleus/core/NLAnimationData.hpp>
#include <nucleus/core/NLAnimationUtil.hpp>
#include <nucleus/util/FitToScreenUtil.hpp>

class NLAnimLayer : public NLScrollLayer {
private:
    NLAnimationData* animData = nullptr;

public:
    NLAnimLayer(NLAnimationData animdata, NLLayerProperties* properties, graphikos::painter::GLRect viewPortRect, SkColor layerColor = SK_ColorTRANSPARENT);
    void onLoop(SkMatrix parentMatrix = SkMatrix()) override;
    void setAnimData(NLAnimationData animdata);
    NLAnimationData* getNlAnimData() {
        return animData;
    }
    void startAnimation();
    void setAfterAnimationCallback(std::function<void()> func);
    void setStartAnimationCallback(std::function<void()> func);
    void interruptAnimation();
    void willRemoveFromParent() override;
    void setDetachLayer(bool detachLayer);

    ~NLAnimLayer();
};

#endif