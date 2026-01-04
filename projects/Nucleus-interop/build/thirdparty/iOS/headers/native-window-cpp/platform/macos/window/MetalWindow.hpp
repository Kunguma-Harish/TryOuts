#ifndef METALWINDOW_HPP
#define METALWINDOW_HPP

#include <native-window-cpp/platform/macos/window/MacWindow.hpp>
#include <native-window-cpp/platform/macos/context/MetalContext.hpp>

class MetalWindow : public MacWindow {
    void* current_webview;

public:
    MetalWindow();

    void* getNativewindow();
    bool onSwapBuffers() override;
    void* getFirstResponder();
    void setContext(std::string const& title, float width, float height) override;
    NWTContext* getCurrentContext() override;
    MetalContext* getMetalContext();
    void attachMetalContextToWindow(float width, float height);
    void createMetalContext(float width, float height);
    void onGetContentScale(float* width, float* height) override;
    void* onGetContextDevice() override ;
    void* onGetContextView() override;
    void* getEventHandlerAttachedToWindow();


    ~MetalWindow();
};

#endif
