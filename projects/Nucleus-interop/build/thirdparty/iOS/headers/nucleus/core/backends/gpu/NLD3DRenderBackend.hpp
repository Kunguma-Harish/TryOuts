#ifndef __NLD3DRENDERBACKEND_H
#define __NLD3DRENDERBACKEND_H

#include <nucleus/core/backends/ZGPURenderBackend.hpp>

#ifdef _WIN32

class IDXGISwapChain3;
class ID3D12Fence;
class ID3D12Device;
class ID3D12CommandQueue;
class HWND;
struct GrD3DBackendContext;
class NUCLEUS_EXPORT NLD3DRenderBackend : public ZGPURenderBackend {
private:
    void* adapter = nullptr;
    gr_cp<ID3D12Device> device;
    gr_cp<ID3D12CommandQueue> queue;
    IDXGISwapChain3* swapChain = nullptr;
    sk_sp<SkSurface> surface2 = nullptr;
    std::shared_ptr<GrD3DBackendContext> ctx;
    static const int frameCount = NL_SURFACE_COUNT;
    ID3D12Fence* fFence = nullptr;
    /// @todo should be frameCount
    uint64_t fFenceValues[frameCount];

public:
    NLD3DRenderBackend(ZWindow* window, void* adapter, void* device, void* queue, void* swapChain, SkColor clearColor = SK_ColorTRANSPARENT, ZRenderBackend* shareBackend = nullptr, bool useDefaultFrameBuffer = true);
    NLD3DRenderBackend(ZWindow* window, SkColor clearColor = SK_ColorTRANSPARENT, ZRenderBackend* shareBackend = nullptr, bool useDefaultFrameBuffer = true);
    void onCreateSurface(int width, int height) override;
    void onCreateDefaultFramebuffer(int width, int height) override;
    bool onFlush() override;

    bool CreateD3DBackendContext(std::shared_ptr<GrD3DBackendContext> ctx, bool isProtected);
    bool initializeContext(HWND hwnd);
};
#endif
#endif
