#ifndef __NL_DEFERREDRENDERER_H
#define __NL_DEFERREDRENDERER_H

#include <nucleus/core/NLSimpleRenderer.hpp>

class Looper;
class NLRenderer;
class NLCanvas;
class NLDeferredDetails;

class NLDeferredRenderer : public NLSimpleRenderer {
public:
    struct RenderingDetails {
        RenderingDetails(sk_sp<SkSurface> surface, SkMatrix totalMatrix);
        // is it required ??
        std::shared_ptr<NLDeferredDetails> dd = nullptr;
        SkMatrix totalMatrix = SkMatrix();
        sk_sp<SkSurface> surface = nullptr;
        std::shared_ptr<NLCanvas> canvas;
        std::function<void()> continueRendering;
};

    NLDeferredRenderer(NLRenderer* renderer, int rectRenderSlotsSize = 5);
    void init(bool isDataChanged) override;
    void render(SkMatrix renderMatrix) override;
    void onLoop(SkMatrix renderMatrix) override;
    void startMatrixChangedTime() override;
    void startResizeTimer() override;
    ~NLDeferredRenderer() override;

protected:
    size_t activeRectRenderSlots;
    std::vector<std::shared_ptr<RenderingDetails>> rectRenderSlots;

private:
    std::shared_ptr<RenderingDetails> renderingDetails = nullptr;
    virtual void interruptRendering();
    void continueRendering();
    void renderRect(SkMatrix transform, int width, int height, FrameType frameType) override;
};

#endif // __NL_DEFERREDRENDERER_H