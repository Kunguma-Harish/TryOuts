#ifndef HTMLWINDOW_HPP
#define HTMLWINDOW_HPP

#include <native-window-cpp/common/window/NWTWindow.hpp>
#include <native-window-cpp/platform/web/context/WebGLContext.hpp>
#include <emscripten/html5.h>

class WebGLWindow : public NWTWindow {

public:
    WebGLWindow();
    void* onCreateNativeWindow(std::string const& title, float width, float height) override;

    void setContext(std::string const& title, float width, float height) override;
    NWTContext* getCurrentContext() override;
    void onAttachToCurrentThread() override;
    void onDetachFromCurrentThread() override;
    bool onSwapBuffers() override;
    void onDestroyContext() override;

    void onSetWindowSize(int width, int height) override;
    void onGetContentScale(float* wContentScale, float* hContentScale) override;
    void onGetPhysicalSize(int* width, int* height) override;
};

#endif