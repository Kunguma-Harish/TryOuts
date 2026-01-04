#ifndef __NL_ILOOPLISTENER_H
#define __NL_ILOOPLISTENER_H

class ILoopListener {
public:
    virtual void onLoop(float time) = 0;
    virtual bool onContinueLoop() = 0;
};

#endif