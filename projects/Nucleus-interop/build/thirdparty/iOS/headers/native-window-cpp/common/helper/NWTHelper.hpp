#ifndef NWT_HELPER_HPP
#define NWT_HELPER_HPP
#include <native-window-cpp/common/helper/nwt.h>
#include <native-window-cpp/common/window/NWTWindow.hpp>
#include <native-window-cpp/common/event/NWTEvents.hpp>
#include <native-window-cpp/common/view/NWTWebView.hpp>
#include <native-window-cpp/common/app/NWTApplicationMain.hpp>

#include <map>
#include <memory>

class NWTHelper {
public:
    static NWTWindow* createWindow(NWTBackend arch);
    static NWTEvents* createEvent(NWTPlatform arch);
    static NWTWebView* CreateWebView(NWTPlatform arch, int width, int height);
    static std::unique_ptr<NWTApplicationMain> createApplicationMain(NWTPlatform arch);
};

#endif