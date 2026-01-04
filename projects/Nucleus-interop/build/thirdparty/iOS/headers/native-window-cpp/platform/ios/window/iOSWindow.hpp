#ifndef IOSWINDOW_HPP
#define IOSWINDOW_HPP

#include <string>
#include <native-window-cpp/common/window/NWTWindow.hpp>
#include <native-window-cpp/platform/ios/context/MetalContext.hpp>

class iOSWindow : public NWTWindow {
public:
    iOSWindow();
    ~iOSWindow();
    void* onCreateNativeWindow(std::string const& title, float width, float height) override;
    void runApplication() override;
    bool isWindowAlive() override;
    void onGetPhysicalSize(int* width, int* height) override;
    void setContext(std::string const& title, float width, float height) override;
    void setSubViewAndMakeFirstResponder(void* event) override;
    NWTContext* getCurrentContext() override;
    MetalContext* getMetalContext();
    void attachMetalContextToWindow(float width, float height);
    void createMetalContext(float width, float height);
    bool onSwapBuffers() override;
    void onGetContentScale(float* x, float* y) override;
    void* onGetContextDevice() override;
    void* onGetContextView() override;
};

#endif // METALWINDOW_HPP
