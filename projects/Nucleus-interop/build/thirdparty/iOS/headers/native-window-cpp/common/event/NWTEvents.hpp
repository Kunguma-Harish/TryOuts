#ifndef NWT_EVENTS_HPP
#define NWT_EVENTS_HPP
#include <native-window-cpp/common/window/NWTWindow.hpp>
#include <native-window-cpp/common/helper/nwt.h>
#include <vector>

class NWTEvents {
private:
    NWTWindow* window = nullptr;
    void* extendedUserHandle; // marks to the class used by user inherited from NativeEvents
    void* extendedUserWindow;

    struct CallBacks {
        NWTmousefun _onStartSingleClick = nullptr;
        NWTmousefun _onStartDoubleClick = nullptr;
        NWTmousefun _onStartTripleClick = nullptr;

        NWTmouseendfun _onEndSingleClick = nullptr;
        NWTmouseendfun _onEndDoubleClick = nullptr;
        NWTmouseendfun _onEndTripleClick = nullptr;

        NWTkeyfun _onKeyUp = nullptr;
        NWTkeyfun _onKeyDown = nullptr;
        NWTkeyfun _onKey = nullptr;
        NWTtextinputfun _onTextInputFunc = nullptr;

        NWTmousebuttonfun _onMouseMove = nullptr;
        NWTmousedragfun _onMouseDrag = nullptr;
        NWTmouseholdfun _onMouseHold = nullptr;

        NWTmouseendfun _onRightMouseUp = nullptr;
        NWTmousebuttonfun _onRightMouseDown = nullptr;

        NWTmousebuttonfun _onLongPress = nullptr;

        NWTpinchzoomfun _onPinchZoom = nullptr;
        NWTscrollfun _onScroll = nullptr;
        NWTframebuffersizefun _onFrameBufferResize = nullptr;
        NWTframebufferresizefun _onFrameBufferResizeEnd = nullptr;
        NWTwindowcontentscalefun _onWindowContentScaleChange = nullptr;
        NWTmonitorresizedfun _onMonitorResize = nullptr;
        NWTcursorposfun _onCursorPosChange = nullptr;

        NWTeventendfun _onZoomEnd = nullptr;
        NWTscrollendfun _onScrollEnd = nullptr;

    } callbacks;

    bool forcesHorizontalScrollOnShift;

public:
    NWTEvents();
    NWTEvents(NWTWindow* window);
    virtual void initEvents(void* window);

    /*************************************************************************
        * Native Window Callbacks to events and window
    *************************************************************************/

    virtual void setWindowToParent(NWTWindow* window);
    void* getWindowAttached();
    void setExtendedUsers(void* userHandle, void* userWindow);
    virtual void onSetExtendedUsers(void* userWindow);
    virtual void assignMouseWheelOverride(bool assignMouseOverride) {}

    void* getExtendedUserEvent();
    void* getExtendedUserWindow();
    NWTWindow* getNativeWindow();
    virtual void removeRegisteredEvents();

    virtual void onWindowLoop();

    void onStartSingleClick(void* userhandle, int x, int y, int button);
    void onStartDoubleClick(void* userhandle, int x, int y, int button);
    void onStartTripleClick(void* userhandle, int x, int y, int button);

    void onEndSingleClick(void* userhandle, int startX, int startY, int endX, int endY, int button);
    void onEndDoubleClick(void* userhandle, int startX, int startY, int endX, int endY, int button);
    void onEndTripleClick(void* userhandle, int startX, int startY, int endX, int endY, int button);

    bool onKeyUp(void* userhandle, int key, int scancode, int action, char* chars);
    bool onKeyDown(void* userhandle, int key, int scancode, int action, char* chars);
    bool onKey(void* userhandle, int key, int scancode, int action, char* chars);
    void onTextInput(void* userhandle, char* text, int length);
    void onMouseMove(void* userhandle, int x, int y, int button);
    void onMouseDrag(void* userhandle, int startx, int starty, int currentx, int currenty, int prevx, int prevy, int button);
    void onMouseHold(void* userhandle, int startx, int starty, int currentx, int currenty, int prevx, int prevy, int button);
    void onRightMouseUp(void* userhandle, int startX, int startY, int endX, int endY, int button);
    void onRightMouseDown(void* userhandle, int x, int y, int button);
    void onLongPress(void* userhandle, int x, int y, int button);
    bool onPinchZoom(void* userhandle, double magnification, int xpos, int ypos);
    bool onScroll(void* userhandle, double xOffset, double yOffset, int xpos, int ypos, int button);
    void onFrameBufferResize(void* userhandle, int width, int height);
    void onFrameBufferResizeEnd(void* userhandle, int width, int height);
    void onMonitorResize(void* userhandle, int width, int height);
    void onWindowContentScaleChange(void* userhandle, float xScale, float yScale);
    void onCursorPosChange(void* userhandle, int xPos, int yPos, int button);
    void onZoomEnd(void* userhandle);
    void onScrollEnd(void* userhandle, float x, float y);

    void NWTSingleClickStartCallback(NWTmousefun cbfun);
    void NWTDoubleClickStartCallback(NWTmousefun cbfun);
    void NWTTripleClickStartCallback(NWTmousefun cbfun);

    void NWTSingleClickEndCallback(NWTmouseendfun cbfun);
    void NWTDoubleClickEndCallback(NWTmouseendfun cbfun);
    void NWTTripleClickEndCallback(NWTmouseendfun cbfun);

    void NWTSetKeyUpCallback(NWTkeyfun cbfun);
    void NWTSetKeyDownCallback(NWTkeyfun cbfun);
    void NWTSetKeyInputCallback(NWTtextinputfun cbfun);

    void NWTSetKeyCallback(NWTkeyfun cbfun);

    void NWTSetPinchZoomCallback(NWTpinchzoomfun cbfun);
    void NWTScrollCallback(NWTscrollfun cbfun);
    void NWTFrameBufferResizeCallback(NWTframebuffersizefun cbfun);
    void NWTFrameBufferResizeEndCallback(NWTframebufferresizefun cbfun);
    void NWTWindowContentScaleCallback(NWTwindowcontentscalefun cbfun);
    void NWTMonitorResizedCallback(NWTmonitorresizedfun cbfun);
    void NWTWindowCursorPosChangeeCallback(NWTwindowcontentscalefun cbfun);

    void NWTCursorPosChangeCallback(NWTcursorposfun cbfun);
    void NWTMouseDragCallback(NWTmousedragfun cbfun);
    void NWTMouseHoldCallback(NWTmouseholdfun cbfun);

    void NWTLongPressCallback(NWTmousebuttonfun cbfun);

    void NWTRightMouseUpCallback(NWTmouseendfun cbfun);
    void NWTRightMouseDownCallback(NWTmousebuttonfun cbfun);

    void NWTZoomEndCallback(NWTeventendfun cbfun);
    void NWTScrollEndCallback(NWTscrollendfun cbfun);

    void forceHorizontalScrollOnShift(bool enable);

    // Custom Event Propogators
    struct Event {
        void* context;
        int functionId;
        std::vector<int> args;
    };
    
    std::vector<Event> eventQueue;

    void populateCustomEvents(void* userhandle, int functionId, int startx, int starty, int currentx, int currenty, int prevx, int prevy, int button);
    void callFunction(void* context, int functionId, int* args, int argCount );
    void clearCustomEvents(void* userhandle);
    void fireCustomEventsQueued();

    virtual ~NWTEvents();
};

#endif
