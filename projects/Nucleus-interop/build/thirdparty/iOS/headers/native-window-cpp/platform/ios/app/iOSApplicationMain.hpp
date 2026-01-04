#ifndef iOSAPPLICATION_MAIN_HPP
#define iOSAPPLICATION_MAIN_HPP

#include <native-window-cpp/common/app/NWTApplicationMain.hpp>

class iOSApplicationMain : public NWTApplicationMain {

private:
    void* application = nullptr;

public:
    iOSApplicationMain();

    void onApplicationMainInitialize() override;
    void onApplicationMainConfigureRunLoop(std::function<void(bool)> mainLoop, bool runLooppNeeded) override;
};
#endif
