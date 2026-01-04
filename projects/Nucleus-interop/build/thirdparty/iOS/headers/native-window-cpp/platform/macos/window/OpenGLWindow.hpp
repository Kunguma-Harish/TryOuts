#ifndef OPENGLWINDOW_HPP
#define OPENGLWINDOW_HPP

#include <native-window-cpp/platform/macos/window/MacWindow.hpp>
#include <native-window-cpp/platform/macos/context/OpenGLContext.hpp>
class OpenGLWindow : public MacWindow {
    // void* current_window;
public:
    OpenGLWindow();
    void setContext(std::string const& title, float width, float height) override;
    NWTContext* getCurrentContext() override;
    bool onSwapBuffers() override;
    void onAttachToCurrentThread() override;
    void onDetachFromCurrentThread() override;
    void onGetContentScale(float* width, float* height) override;
    void createOpenGLWindow();
    ~OpenGLWindow();
};

#endif