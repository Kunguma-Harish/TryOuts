#pragma once
#include <nucleus/core/backends/ZGPURenderBackend.hpp>
#include <include/gpu/graphite/Context.h>

class NLMetalRenderBackend : public ZGPURenderBackend {
private:
    std::unique_ptr<skgpu::graphite::Context> graphiteContext;
    std::unique_ptr<skgpu::graphite::Recorder> graphiteRecorder;

public:
    NLMetalRenderBackend(ZWindow* window, SkColor clearColor = SK_ColorTRANSPARENT, ZRenderBackend* shareBackend = nullptr, bool useDefaultFrameBuffer = true);
    void onCreateSurface(int width, int height) override;
    void onCreateDefaultFramebuffer(int width, int height) override;
    void setSurface(sk_sp<SkSurface> surface);

    bool onFlush() override;
};
