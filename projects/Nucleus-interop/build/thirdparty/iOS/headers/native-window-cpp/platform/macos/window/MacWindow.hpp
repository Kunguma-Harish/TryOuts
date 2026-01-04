#ifndef MACWINDOW_HPP
#define MACWINDOW_HPP

#include <native-window-cpp/common/window/NWTWindow.hpp>

class MacWindow : public NWTWindow {
public:
    MacWindow();
    void* onCreateNativeWindow(std::string const& title, float width, float height) override;
    void runApplication() override;
    bool isWindowAlive() override;
    void setSubViewAndMakeFirstResponder(void* event) override;
    void onGetPhysicalSize(int* width, int* height) override;
    void addToWindow(void* webView) override;
    NWTContext* getCurrentContext() override;
};

#endif