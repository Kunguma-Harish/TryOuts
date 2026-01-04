#ifndef __NL_SKPICTURELAYER_H
#define __NL_SKPICTURELAYER_H

#include <nucleus/core/layers/NLLayer.hpp>
class NLPictureRecorder;

class NLSkPictureLayer : public NLLayer {
private:
    std::shared_ptr<NLPictureRecorder> picture = nullptr;
    graphikos::painter::GLRect coverageRect = graphikos::painter::GLRect();

public:
    NLSkPictureLayer(NLLayerProperties* layerProperties, graphikos::painter::GLRect viewPortRect, SkColor layerColor, NLRenderer::Mode mode);
    bool onDraw(SkCanvas* canvas, NLDeferredDetails* dd, SkMatrix totalMatrix = SkMatrix(), bool applyContentScale = true) override;
    bool hasData() override;
    void onDataChange(std::shared_ptr<NLPictureRecorder> picture);
    void onDataChange() override;
    graphikos::painter::GLRect getCoverageRect() override;
    void updateCoverageRect() override;
};

#endif