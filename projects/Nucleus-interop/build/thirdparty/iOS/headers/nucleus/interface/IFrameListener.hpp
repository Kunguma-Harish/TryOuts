#ifndef __NL_IFRAMELISTENER_H
#define __NL_IFRAMELISTENER_H

class IFrameListener {
    virtual void onFrameInit() = 0;
    virtual void onFrame() = 0;
};

#endif
