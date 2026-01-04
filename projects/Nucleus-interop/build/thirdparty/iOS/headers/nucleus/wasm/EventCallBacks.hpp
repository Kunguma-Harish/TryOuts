#ifndef __NL_EVENTCALLBACKS_H
#define __NL_EVENTCALLBACKS_H
#include <iostream>
#include <skia-extension/util/FnTypes.hpp>
#include <skia-extension/GLPoint.hpp>
enum class Cursor;
class EventCallBacks {
public:
#if defined(NL_ENABLE_NEXUS)
    CREATE_CALLBACK_NEXUS(ZoomCallBack, void, double);
    CREATE_CALLBACK_NEXUS(ZoomEndCallBack, void, double);
    CREATE_CALLBACK_NEXUS(ScrollCallBack, void, graphikos::painter::GLPoint);
    CREATE_CALLBACK_NEXUS(ScrollEndCallBack, void, graphikos::painter::GLPoint);
    CREATE_CALLBACK_NEXUS(MouseUpCallBack, void, graphikos::painter::GLPoint);
    CREATE_CALLBACK_NEXUS(DragCallBack, void, float, float, float, float, float, float, int);

    //cursor
    CREATE_CALLBACK_NEXUS(CursorCallBack, void, Cursor);
#else
    //ZEvents
    CREATE_CALLBACK(ZoomCallBack, void(double));
    CREATE_CALLBACK(ZoomEndCallBack, void(double));
    CREATE_CALLBACK(ScrollCallBack, void(graphikos::painter::GLPoint));
    CREATE_CALLBACK(ScrollEndCallBack, void(graphikos::painter::GLPoint));
    CREATE_CALLBACK(MouseUpCallBack, void(graphikos::painter::GLPoint));
    CREATE_CALLBACK(DragCallBack, void(float, float, float, float, float, float, int));

    //cursor
    CREATE_CALLBACK(CursorCallBack, void(Cursor)); // as this is in nucleus repo , this will be made as lib and be overrided and run time
#endif
};
#endif