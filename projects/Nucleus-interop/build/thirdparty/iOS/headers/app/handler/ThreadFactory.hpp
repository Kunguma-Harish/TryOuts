#ifndef __NL_THREADFACTORY_H
#define __NL_THREADFACTORY_H
#include <iostream>
#include <queue>
#include <functional>
#include <thread>
#include <mutex>
#include <atomic>
#include <nucleus/Looper.hpp>
#ifdef __EMSCRIPTEN__
#include <emscripten/emscripten.h>
#include <emscripten/bind.h>
#include <emscripten/val.h>
#endif
enum ThreadMode {
    SINGLETHREAD,
    WITHSHAREDARRAY,
    WITHOUTSHAREDARRAY
};

struct GLThread {
    std::thread thread;
    Looper looper;
    bool breakLoop;

    static void spinLoop(void* args) {
        struct GLThread* threadStruct = (struct GLThread*)args;
        threadStruct->looper.execute();

        if (threadStruct->breakLoop) {
#ifdef __EMSCRIPTEN__
            emscripten_cancel_main_loop();
#endif
        }
    }

    static void* setToMainLoop(void* args) {
        struct GLThread* threadStruct = (struct GLThread*)args;
        threadStruct->looper.setThreadId(std::this_thread::get_id());
#ifdef __EMSCRIPTEN__
        emscripten_set_main_loop_arg(&spinLoop, args, 0, 0);
#else
        while (true) {
            spinLoop(args);
            if (threadStruct->breakLoop) {
                break;
            }
        }
        // logger::loginfo << "printing in second loop" << logger::end;

#endif
        return nullptr;
    }
};

class ThreadFactory {

public:
    static ThreadMode threadMode;
    static std::vector<GLThread*> arrayOfThread;
    bool createThread();
    ///@todo need to delete the struct and clear from respective handlers ,asset a
    bool deleteThread(GLThread* thread);
    bool deleteAllThread();
};

#endif