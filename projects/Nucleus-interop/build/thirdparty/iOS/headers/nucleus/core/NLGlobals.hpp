#ifndef __NL_GLOBALS_H
#define __NL_GLOBALS_H

#include <functional>
// #include <painter/IProvider.hpp>

class NLGlobals {
private:
    static std::function<float()> timeCallback;

public:
    static void setTimeCallback(std::function<float()> funcPtr);

    /////
    // static graphikos::painter::IProvider* provider;

    static float getTime();
};

#endif