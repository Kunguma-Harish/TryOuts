#ifndef __NL_NLWINDOWHANDLER_H
#define __NL_NLWINDOWHANDLER_H

#include <iostream>
#include <vector>
#include <chrono>
#include <nucleus/interface/ILoopListener.hpp>

class NLLoopHandler {
public:
    NLLoopHandler();
    void init(bool manual);
    void addLoopListener(ILoopListener* loopListener);
    std::vector<ILoopListener*> loopListeners;
    void run();
    static std::chrono::system_clock::time_point startTimeForLoopHandler;
    static float getTime();
};

#endif