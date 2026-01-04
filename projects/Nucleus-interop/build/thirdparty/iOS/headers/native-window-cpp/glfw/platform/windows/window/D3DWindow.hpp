#ifndef D3D_WINDOW_HPP
#define D3D_WINDOW_HPP

#include <DXGI.h>
#include <dxgi1_4.h>
// #include <d3d11.h>
#include <d3d12.h>
#include <d3d9types.h>
#include <DXGI.h>
#include <dxgi1_4.h>
#include <memory>
#include <wrl/client.h>
#include <native-window-cpp/glfw/common/window/GLFWWindow.hpp>

class D3DWindow : public GLFWWindow {
private:
    friend class NLD3DRenderBackend;
    int index = 0;
    static const int frameCount = 2;
    HWND win32Window;
    IDXGISwapChain3* swapChain = nullptr;

public:
    D3DWindow();
    void* onCreateNativeWindow(std::string const& title, float width, float height) override;
    bool onSwapBuffers() override;
    void onGetPhysicalSize(int* width, int* height) override;
    void onGetContentScale(float* width, float* height) override;
    void setSwapChain(IDXGISwapChain3* swapChain);
    HWND getWin32Window();

    ~D3DWindow();
};

#endif
