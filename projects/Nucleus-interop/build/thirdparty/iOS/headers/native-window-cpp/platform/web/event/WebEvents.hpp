#ifndef WEBGL_EVENTS_HPP
#define WEBGL_EVENTS_HPP
#include <native-window-cpp/common/event/NWTEvents.hpp>

extern "C" {
extern void initEventListener(NWT_HANDLE handle, void* window);
// extern void htmlSetMouseButtonCallback(void* window, HTMLmousebuttonfun callback);
extern void htmlSetSingleClickStartCallback(void* window, NWTmousebuttonfun callback);
extern void htmlSetSingleClickEndCallback(void* window, NWTmouseendfun callback);

extern void htmlSetDoubleClickStartCallback(void* window, NWTmousebuttonfun callback);
extern void htmlSetDoubleClickEndCallback(void* window, NWTmouseendfun callback);

extern void htmlSetTripleClickStartCallback(void* window, NWTmousebuttonfun callback);
extern void htmlSetTripleClickEndCallback(void* window, NWTmouseendfun callback);

extern void htmlSetRightMouseDownCallback(void* window, NWTmousebuttonfun callback);
extern void htmlSetRightMouseUpCallback(void* window, NWTmouseendfun callback);

extern void htmlSetLongPressCallback(void* window, NWTmousebuttonfun callback);

extern void htmlSetMouseHoldCallback(void* window, NWTmouseholdfun callback);

extern void htmlSetKeyUpCallback(void* window, NWTkeyfun callback);
extern void htmlSetKeyDownCallback(void* window, NWTkeyfun callback);
extern void htmlSetTextInputCallback(void* window, NWTtextinputfun callback);

extern void htmlSetCursorPosCallback(void* window, NWTcursorposfun callback);
extern void htmlDragCallback(void* window, NWTmousedragfun callback);
extern void htmlSetPinchZoomCallback(void* window, NWTpinchzoomfun callback);
extern void htmlSetScrollCallback(void* window, NWTscrollfun callback);
extern void htmlSetKeyCallback(void* window, NWTkeyfun callback);
extern void htmlSetFramebufferResizeCallback(void* window, NWTframebuffersizefun callback);
extern void htmlSetFramebufferResizeEndCallback(void* window, NWTframebufferresizefun callback);
extern void htmlSetMonitorResizeCallback(void* window, NWTmonitorresizedfun callback);
extern void htmlSetContentScaleCallback(void* window, NWTwindowcontentscalefun callback);
extern void htmlSetScrollEndCallback(void* window, NWTscrollendfun callback);
extern void htmlSetPinchZoomEndCallback(void* window, NWTeventendfun callback);
extern void htmlSetWindowUserPointer(void* window, void* pointer);
extern void* htmlGetWindowUserPointer(void* window);
extern void setOnWindowChange(void* window, NWTWindowchangefun callback);
extern void htmlRemoveRegisteredEvents(void* window);
extern float getCurrentTime();
extern void htmlBindEventListeners(void* window);
extern void htmlOverrideMouseWheelBehaviour(bool assignMouseOverride);
extern void htmlSetEventQueueListener(void* window, NWTeventfun populateCustomEvents);
extern void htmlClearEventQueueListener(void* window, NWTeventendfun clearCustomEvents);
}

class WebEvents : public NWTEvents {
public:
    void initEvents(void* window) override;
    void onSetExtendedUsers(void* userWindow) override;
    void removeRegisteredEvents() override;
    void assignMouseWheelOverride(bool assignMouseOverride) override;

    ~WebEvents();
};

#endif
