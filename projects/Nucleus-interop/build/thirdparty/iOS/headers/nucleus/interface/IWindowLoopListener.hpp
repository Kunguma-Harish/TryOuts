#ifndef __NL_IWINDOWLOOPLISTENER_H
#define __NL_IWINDOWLOOPLISTENER_H

class IWindowLoopListener {
public:
    /**
     * @brief Called when loop is started
     */
    virtual void windowLoopInit() = 0;

    /**
     * @brief Called for every loop
     */
    virtual void windowLoop() = 0;
};

#endif