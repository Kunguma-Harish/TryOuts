#ifndef GLFWEVENTS_HPP
#define GLFWEVENTS_HPP

#include <native-window-cpp/common/event/NWTEvents.hpp>

class GLFWwindow;

class GLFWEvents : public NWTEvents {
private:
    GLFWwindow* window;
    float xPos, yPos, startXPos, startYPos;
    void glfw_mouse_button_callback(GLFWwindow* window, int button, int action, int mods);
    void glfw_cursor_position_callback(GLFWwindow* window, double xpos, double ypos);
    void glfw_key_callback(GLFWwindow* window, int key, int scancode, int action, int mods);
    void glfw_window_resize_callback(GLFWwindow* window, int width, int height);
    void glfw_window_content_scale_callback(GLFWwindow* window, float xscale, float yscale);
    void glfw_pinchzoom_callback(GLFWwindow* window, double magnification);
    void glfw_scroll_callback(GLFWwindow* window, double xoffset, double yoffset);
    void glfw_drop_callback(GLFWwindow* window, int count, const char** paths);

public:
    void setWindowToParent(NWTWindow* handle) override;
    void initEvents(void* handle) override;
    void onWindowLoop() override;

    ~GLFWEvents();
};

#endif