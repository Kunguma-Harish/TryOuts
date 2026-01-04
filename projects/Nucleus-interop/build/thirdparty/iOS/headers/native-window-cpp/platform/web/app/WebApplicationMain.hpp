#ifndef WEBAPPLICATION_MAIN_HPP
#define WEBAPPLICATION_MAIN_HPP
#include <iostream>
#include <functional>
#include <native-window-cpp/common/app/NWTApplicationMain.hpp>
#include <emscripten/emscripten.h>

extern "C" {
    typedef void (*MainLoopTransmitter)(void);

    void gc_configure_loop(MainLoopFunc mainLoop);
    bool gc_platform_supports_offscreen();
    void mainLoopWrapper();
    extern MainLoopFunc globalMainLoop;
}

class WebApplicationMain : public NWTApplicationMain{
public:
    WebApplicationMain();
    virtual void onApplicationMainInitialize();
    virtual void onApplicationMainConfigureRunLoop(std::function<void(bool)> mainLoop, bool runLooppNeeded);
    virtual ~WebApplicationMain();
};
#endif
