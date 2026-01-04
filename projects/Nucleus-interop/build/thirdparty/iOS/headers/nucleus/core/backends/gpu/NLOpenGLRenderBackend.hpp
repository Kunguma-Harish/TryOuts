#pragma once
#include <nucleus/core/backends/ZGPURenderBackend.hpp>

class NLOpenGLRenderBackend : public ZGPURenderBackend {
public:
    NLOpenGLRenderBackend(ZWindow* window, SkColor clearColor = SK_ColorTRANSPARENT, ZRenderBackend* shareBackend = nullptr, bool useDefaultFrameBuffer = true);
    void onCreateSurface(int width, int height) override;
    void onCreateDefaultFramebuffer(int width, int height) override;
};
