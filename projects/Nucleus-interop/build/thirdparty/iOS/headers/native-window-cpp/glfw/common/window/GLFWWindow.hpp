#ifndef GLFWWINDOW_HPP
#define GLFWWINDOW_HPP

#include <native-window-cpp/common/window/NWTWindow.hpp>
class GLFWwindow;

class GLFWWindow : public NWTWindow {
private:
    GLFWwindow* window = nullptr;

public:
    GLFWWindow();
    ~GLFWWindow();
    bool createGLFWWindow(int width, int height, std::string title, NWTWindow* share = nullptr, bool attachWindowToThread = true, bool isHidden = false);
    virtual void* onCreateNativeWindow(std::string const& title, float width, float height) override;

    GLFWwindow* getGLFWwindow();
    

    virtual void onAttachToCurrentThread() override;
    virtual void onDetachFromCurrentThread() override;

    bool swapBuffers() override;
    virtual bool onSwapBuffers() override;

    virtual void onSetWindowSize(int width, int height) override;
    void getContentScale(float* width, float* height) override;
    virtual void onGetContentScale(float* wContentScale, float* hContentScale) override;
    void getPhysicalSize(int* width, int* height) override;
    virtual void onGetPhysicalSize(int* width, int* height) override;
    bool isWindowAlive() override;
    // void* getNativeWindow() override;
};

#endif
