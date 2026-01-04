#ifndef __NL_ZGPURENDERBACKEND_H
#define __NL_ZGPURENDERBACKEND_H
#include <nucleus/core/ZRenderBackend.hpp>
#include <nucleus/core/ZWindow.hpp>

class ZGPURenderBackend : public ZRenderBackend {
protected:
    ZWindow* window = nullptr;
    sk_sp<GrDirectContext> context;
    bool useDefaultFrameBuffer = true;
    virtual void onCreateCanvas(int width, int height, uint32_t flags = 0) override;
    virtual bool onFlush() override;

public:
    ZGPURenderBackend(ZWindow* window, SkColor clearColor = SK_ColorTRANSPARENT, ZRenderBackend* shareBackend = nullptr, bool useDefaultFrameBuffer = true);
    virtual void makeContextCurrent() override;
    virtual void onCreateSurface(int width, int height) = 0;
    virtual void onCreateDefaultFramebuffer(int width, int height) = 0;
    virtual void translate(float transX, float transY) override;
    sk_sp<SkSurface> getSurface() override;
    sk_sp<GrDirectContext> refGrDirectContext() override;
    virtual SkCanvas* getCanvas() override;
};

#endif
