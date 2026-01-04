#ifndef NWTWINDOW_HPP
#define NWTWINDOW_HPP
#include <native-window-cpp/common/helper/nwt.h>
#include <native-window-cpp/common/context/NWTContext.hpp>

#include <string>
#include <iostream>

#if defined(NL_ENABLE_NEXUS) && defined(NL_BINDING_LANG_JAVASCRIPT)
#include <nexus_support/web_idl/nexus_support_emcc.hpp>
#endif
#if defined(NL_ENABLE_NEXUS) && defined(NL_BINDING_LANG_JAVA)
#include <nexus_support/JNI/nexus_support.hpp>
#endif

#if defined(NL_ENABLE_NEXUS)
extern NXCallBack<float> contentScaleCallback;
extern void setContentScaleCallback(NXCallBack<float> callback);
#endif

class NWTWindow {

protected:
    void* current_window;
    int window_width, window_height; // to be moved later
    std::string windowName = "";
    bool PrimaryWindowMode = false;
    bool HeadlessViewMode = false;

public:
    NWTContext* current_context = nullptr;
    //Below entities are added to run glfw based code using nwt
    /*******************************/
    bool isManualResize = false;
    int bufferIndex = 0;
    /*******************************/

    NWTWindow();
    bool createNativeWindow(std::string const& title, float width, float height, bool withoutWindow);
    virtual void* onCreateNativeWindow(std::string const& title, float width, float height) { return nullptr; }
    virtual bool isWindowAlive();
    virtual void setContext(std::string const& title, float width, float height);
    virtual NWTContext* getCurrentContext();

    virtual bool swapBuffers();
    virtual bool onSwapBuffers();

    virtual void getPhysicalSize(int* width, int* height);
    virtual void onGetPhysicalSize(int* width, int* height);

    virtual void getContentScale(float* width, float* height);
    virtual void onGetContentScale(float* width, float* height);
    virtual void setSubViewAndMakeFirstResponder(void* event);
    virtual void runApplication();

    virtual void attachToCurrentThread();
    virtual void onAttachToCurrentThread();

    virtual void detachFromCurrentThread();
    virtual void onDetachFromCurrentThread();

    virtual void destroyContext();
    virtual void onDestroyContext();

    virtual void setWindowSize(int width, int height);
    virtual void onSetWindowSize(int width, int height);

    virtual void addToWindow(void* webView);

    const char* getWindowHandle();

    bool isPrimaryWindowMode(){ return PrimaryWindowMode; }
    bool isHeadlessViewMode(){ return HeadlessViewMode; }

    void* getCurrentWindow() {
        return current_window;
    }

    virtual void* getContextDevice();
    virtual void* onGetContextDevice();

    virtual void* getContextView();
    virtual void* onGetContextView();

    virtual ~NWTWindow();
};

#endif
