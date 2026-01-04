#ifndef MACAPPLICATION_MAIN_HPP
#define MACAPPLICATION_MAIN_HPP

#include <native-window-cpp/common/app/NWTApplicationMain.hpp>

class MacApplicationMain : public NWTApplicationMain {

private:
    void* application = nullptr;

public:
    MacApplicationMain();
    // void initializeApplication();
    // void initializeRunLoop(std::function<void(bool)> mainLoop);

    void onApplicationMainInitialize() override;
    void onApplicationMainConfigureRunLoop(std::function<void(bool)> mainLoop, bool runLooppNeeded) override;
};
#endif