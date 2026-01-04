#ifndef __NL_CURSOR_H
#define __NL_CURSOR_H

#include <memory>
#include <nucleus/core/ZWindow.hpp>
#include <skia-extension/util/FnTypes.hpp>

class EventCallBacks;
#ifdef __EMSCRIPTEN__
#include <emscripten.h>
#include <emscripten/bind.h>
#endif

enum class Cursor {
    DEFAULT,
    CROSSHAIR,
    HAND,
    RESIZE_NESW,
    RESIZE_NWSE,
    RESIZE_NS,
    RESIZE_EW,
    ROTATE_NESW,
    ROTATE_NWSE,
    POINTER,
    PIN_ADD,
    GRAB,
    GRABBING,
    MARKING,
    PEN,
    HIGHLIGHTER,
    MOVE,
    TEXT,
    ROTATE_HANDLE,
    ROW_RESIZE,
    COL_RESIZE,
    NOT_ALLOWED
};

class NLCursor {
public:
    NLCursor(EventCallBacks* callbacks);
    void setCursor(Cursor cursor);
    void setCursorPath(unsigned char* pixels, bool onPath);
    Cursor getCurrentCursor() {
        return currentCursor;
    }

private:
    EventCallBacks* callbacks;
    Cursor currentCursor;
};

#endif
