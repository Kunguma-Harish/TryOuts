#ifndef __NL_ZEVENTS_H
#define __NL_ZEVENTS_H

#include <skia-extension/GLPoint.hpp>
#include <nucleus/core/NLCursor.hpp>
#include <nucleus/core/layers/NLScrollLayer.hpp>

#include <nucleus/core/NLView.hpp>
#include <nucleus/interface/IWindowLoopListener.hpp>
#include <skia-extension/util/FnTypes.hpp>
// #include <nucleus/nucleus_config.h>
#include <filesystem>
#include <nucleus/wasm/EventCallBacks.hpp>
class NWTEvents;
/**
 * Captures system events and passes it to ZEventHandler
 * Responsible for attaching and detaching events as applicable
 */

class ZEvents : public IWindowLoopListener {
    friend class SWBindings;

private:
    NLCursor* cursor = nullptr;
    ZWindow* zWindow = nullptr;
    std::shared_ptr<WindowConfig> windowConfig = nullptr;
    // ZView* view = nullptr;
    NLView* nlView = nullptr;
    std::shared_ptr<EventCallBacks> eventCallBacks = nullptr;
    NLScrollLayer* tempRootLayer = nullptr; // added temperarily for scroll zoom through

    float scrollSpeed = NUCLEUS_SCROLLSPEED;
    float zoomSpeed = NUCLEUS_ZOOMSPEED;
    NWTEvents* events_adapter = nullptr;

    /// @todo managing this, should be the responsibility of ZEventBinder.
    // std::shared_ptr<ZEventHandler::EventHandlerProperties> properties = nullptr;
    void window_resize(int width, int height);

protected:
    void cursor_position_callback(void* event, float xpos, float ypos, int keyModifier);
    void mouse_drag_callback(void* event, float startX, float startY, float currentX, float currentY, float previousX, float previousY, int keyModifier);
    void mouse_hold_callback(void* event, float startX, float startY, float currentX, float currentY, float previousX, float previousY, int keyModifier);
    bool key_callback(void* event, int key, int action, int keyModifier, const char* input = "a");
    bool key_up_callback(void* event, int key, int action, int keyModifier, const char* input = "a");
    bool key_down_callback(void* event, int key, int action, int keyModifier, const char* input = "a");
    void text_input_callback(void* event, char* input, int compositionStatus);
    void window_resize_callback(void* event, int width, int height);
    void window_resize_end_callback(void* event, int width, int height);
    void window_content_scale_callback(void* event, float xScale, float yScale);
    void monitor_resize_callback(void* event, int width, int height);
    bool pinchzoom_callback(void* event, double magnification, float xpos, float ypos);
    bool scroll_callback(void* event, float xoffset, float yoffset, float x, float y, int keyModifier);

    void single_click_start_callback(void* event, float x, float y, int keyModifier);
    void single_click_end_callback(void* event, float startX, float startY, float endX, float endY, int keyModifier);

    void double_click_start_callback(void* event, float x, float y, int keyModifier);
    void double_click_end_callback(void* event, float startX, float startY, float endX, float endY, int keyModifier);

    void triple_click_start_callback(void* event, float x, float y, int keyModifier);
    void triple_click_end_callback(void* event, float startX, float startY, float endX, float endY, int keyModifier);

    void right_mouse_down_callback(void* event, float x, float y, int keyModifier);
    void right_mouse_up_callback(void* event, float startX, float startY, float endX, float endY, int keyModifier);

    void long_press_callback(void* event, float x, float y, int keyModifier);

    void scroll_end_callback(void* event, float x, float y);
    void zoom_end_callback(void* event);
#ifdef NL_ENABLE_FILESYSTEM_API
    void drop_callback(std::vector<std::filesystem::path> files);
#endif

public:
    ZEvents(ZWindow* window);
    void setNLView(NLView* nlView);
    void setCursor(NLCursor* cursor);

    std::shared_ptr<EventCallBacks> getEventCallBacks();
    NWTEvents* getEventsAdapter();

    virtual void init();

    void windowLoopInit() override;
    void windowLoop() override;
    void setTempRootLayer(NLScrollLayer* tempRootLayer);
    void onLoop();
    bool onContinueLoop();
    virtual void onWindowLoop();
    void setScrollSpeed(float _scrollSpeed);
    float getScrollSpeed();
    void setZoomSpeed(float _zoomSpeed);
    float getZoomSpeed();
    void setZoom(double zoomRange, graphikos::painter::GLPoint pivot = graphikos::painter::GLPoint(), bool needAnimation = false);
    bool handleZoom(float magnification, float x, float y);
    void handleZoomByPoint(float magnification, float x, float y);
    virtual void removeRegisteredEvents();

    void assignMouseWheelOverride(bool assignMouseOverride);
    void forceHorizontalScrollOnShift(bool enable);

    virtual ~ZEvents();
};

#endif
