#ifndef __NL_ZWINDOW_H
#define __NL_ZWINDOW_H

#include <iostream>
#include <memory>

#include <nucleus/Looper.hpp>
#include <nucleus/interface/IWindowLoopListener.hpp>
#include <nucleus/interface/IWindowEventsListener.hpp>
#include <nucleus/interface/OnSwapBufferListener.hpp>
#include <nucleus/core/WindowConfig.hpp>
#include <nucleus/nucleus_export.h>
#include <skia-extension/util/FnTypes.hpp>
class NWTWindow;
class SkMatrix;

class NUCLEUS_EXPORT ZWindow {

public:
    bool enable_graphite = false;
    // Only to be used with ZRenderBackend and it's derivatives
    ZWindow();
    NWTWindow* window_adapter = nullptr;
    virtual ~ZWindow();
    std::shared_ptr<WindowConfig> windowConfig = std::make_shared<WindowConfig>();
    IWindowLoopListener* windowLoopListener = nullptr;
    IWindowEventsListener* windowEventsListener = nullptr;
    OnSwapBufferListener* onSwapBufferListener = nullptr;

    /*
     * ZWindow of the current context of the `main` thread
     * will be available in attachedWindow
     * @note Calling destroyContext will make `attachedWindow` nullptr,
     * if it succeeds
     * @todo Use std::map<thread_id, ZWindow*> for better management of contexts
     * between threads
     */
    static std::atomic<ZWindow*> attachedWindow;

    Looper looper;
    bool createWindow(int width, int height, std::string title, ZWindow* share = nullptr, bool attachWindowToThread = true, bool isHidden = false, bool withoutWindow = false);
    virtual bool onCreateWindow(int width, int height, std::string title, ZWindow* share = nullptr, bool attachWindowToThread = true, bool isHidden = false);

    bool isAttachedWindow();

    /**
   * @brief Get the Main Looper object
   * @return Looper*
   */
    Looper* getLooper();

    void setWindowConfig(std::shared_ptr<WindowConfig> windowConfig);
    std::shared_ptr<WindowConfig> getWindowConfig();

    /**
     * @brief Should not be used normally
     * @param windowConfig Useful in threadhandler where we need windowConfig to be same for both windows
     */
    void overrideWindowConfig(std::shared_ptr<WindowConfig> windowConfig);

    virtual void spinLoop();

    void setWindowLoopListener(IWindowLoopListener* windowLoopListener);
    void windowSize();
    void setVisibleOffset(int left, int top);

    /**
     * @brief Should be called when the client is ready to display a 'interactive window'.
     * @param if manual is true, run is expected to be called multiple times
     * else run blocks the call.
     */

    virtual void getPhysicalSize(int* width, int* height);
    virtual void getContentScale(float* wContentScale, float* hContentScale);
    virtual void attachToCurrentThread();
    virtual void detachFromCurrentThread();
    virtual bool swapBuffers();
    virtual void setWindowSize(int width, int height);
    virtual int on_run();

    void destroyContext();
    virtual void onDestroyContext();

    virtual void* getNativeWindow();
    std::string getWindowName();

    /*
     * Retuns the currently active gpu buffer object that is active
     * For D3D it returns the index of D3DBuffer set in swapchain
     * For Metal it returns the TODO research
     */
    virtual int getBufferIndex();
};

#endif
