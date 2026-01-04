#ifndef __NL_IWINDOWEVENTSLISTENER_H
#define __NL_IWINDOWEVENTSLISTENER_H

class IWindowEventsListener {
public:
    virtual void onWindowContextLost() = 0;
    virtual void onWindowContextRestored() = 0;
};

#endif