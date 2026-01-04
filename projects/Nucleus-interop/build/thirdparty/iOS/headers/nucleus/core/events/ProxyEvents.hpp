#ifndef __NL_PROXYEVENTS_H
#define __NL_PROXYEVENTS_H

#include <nucleus/core/ZEvents.hpp>
#include <nucleus/core/ZWindow.hpp>
// #include <app/ZView.hpp>

class ProxyEvents : public ZEvents {
public:
    void proxy_mouse_button_callback(int button, int action, int mods);
    void proxy_drag_callback(double xpos, double ypos);
    bool proxy_key_callback(int key, int scancode, int action, int mods);
    void proxy_window_resize_callback(int width, int height);
    void proxy_cursor_position_callback(double xpos, double ypos);
    void proxy_pinchzoom_callback(double magnification);
    void proxy_scroll_callback(double xoffset, double yoffset, int keyModifier);
    void proxy_window_contentscale_callback(float scale);

public:
    ProxyEvents(ZWindow* window);
    void onWindowLoop() override;

    ~ProxyEvents();
};

#endif
