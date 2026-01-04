#ifndef NWTAPPLICATION_MAIN_HPP
#define NWTAPPLICATION_MAIN_HPP
#include <iostream>
#include <functional>
using MainLoopFunc = std::function<void(bool)>;
using SetupDataFunc = std::function<void()>;


class NWTApplicationMain {
public:
    static bool isMainLoopSet;

    NWTApplicationMain();
    void NWTApplicationMainInitialize();
    virtual void onApplicationMainInitialize();

    void NWTApplicationMainConfigureRunLoop(std::function<void(bool)> mainLoop, bool runLooppNeeded);
    virtual void onApplicationMainConfigureRunLoop(std::function<void(bool)> mainLoop, bool runLooppNeeded);
    virtual ~NWTApplicationMain();
};
#endif
