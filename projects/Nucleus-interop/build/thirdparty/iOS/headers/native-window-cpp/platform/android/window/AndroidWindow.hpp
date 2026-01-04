
#ifndef _ANDROID_WINDOW_HPP
#define _ANDROID_WINDOW_HPP

#include <native-window-cpp/common/window/NWTWindow.hpp>
#include <EGL/egl.h>

class AndroidWindow : public NWTWindow {
    EGLDisplay eglDisplay;

public:
    AndroidWindow();
    void* onCreateNativeWindow(std::string const& title, float width, float height) override;
    void getContentScale(float* wContentScale, float* hContentScale) override;

    void onAttachToCurrentThread() override;
    bool onSwapBuffers() override;
};

#endif
