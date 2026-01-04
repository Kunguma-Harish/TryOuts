#ifndef NWTCONTEXT_HPP
#define NWTCONTEXT_HPP
#include <native-window-cpp/common/helper/nwt.h>

#include <string>

class NWTContext {

public:
    virtual bool swapBuffers();
    virtual void setContext(std::string const& title, float width, float height);

    virtual void getContentScale(float* xscale, float* yscale);
    virtual void attachContextAsCurrent(bool attachCurrentContext);
    virtual ~NWTContext();
};

#endif