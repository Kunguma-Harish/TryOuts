#ifndef __NL_RENDERLAYER_H
#define __NL_RENDERLAYER_H

#include <nucleus/core/layers/NLLayer.hpp>
#include <nucleus/core/NLRenderTree.hpp>

class NLRenderLayer : public NLLayer {
protected:
    std::vector<std::shared_ptr<NLRenderTree>> pictures;
    graphikos::painter::GLRect coverageRect = graphikos::painter::GLRect();

public:
    //essentials
    NLRenderLayer();
    NLRenderLayer(NLLayerProperties* properties, graphikos::painter::GLRect viewPortRect, SkColor layerColor, NLRenderer::Mode mode);

    void onDataChange() override;
    virtual void onDataChange(std::vector<std::shared_ptr<NLRenderTree>> pictures);
    virtual void onDataChange(std::shared_ptr<NLRenderTree> picture);

    graphikos::painter::GLRect getCoverageRect() override;
    void updateCoverageRect() override;
    int getWeightedDrawCallCount(const SkRect& queryRect, const SkMatrix& matrix, const int& uLimit) override;
    bool hasData() override;
    std::vector<std::shared_ptr<NLRenderTree>> getPictures();

    bool onDraw(SkCanvas* canvas, NLDeferredDetails* dd, SkMatrix totalMatrix = SkMatrix(), bool applyContentScale = true) override;
};

#endif