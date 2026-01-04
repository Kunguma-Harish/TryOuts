#ifndef NL_APPLICATION_MAIN_HPP
#define NL_APPLICATION_MAIN_HPP

#include <nucleus/core/ZEvents.hpp>
#include <nucleus/core/ZWindow.hpp>

#include <memory>
class NWTApplicationMain;
class AppBinder;
using AddViewData = std::function<void()>;
using AddViewDataForInput = std::function<void(std::string)>;

class NLApplicationMain { //aka the ultimate martyr

    std::unique_ptr<NWTApplicationMain> app;

protected:
public:
    static std::vector<NLApplicationMain*> nlApplications;
    std::shared_ptr<ZWindow> window;
    std::shared_ptr<ZEvents> events;
    std::shared_ptr<ZRenderBackend> renderBackend;
    std::shared_ptr<NLView> nlView;
    std::shared_ptr<AppBinder> appBinder;
    std::shared_ptr<NLCursor> cursor;
    int argCount;
    char** argVec;
    int windowWidth, windowHeight;
    std::string windowName;
    bool isRunLoopNeeded;
    bool withoutAppMain;
    bool withoutWindow;

    AddViewData loadDataOnViewLoad;
    AddViewDataForInput loadInputDataOnViewLoad;

    NLApplicationMain();
    NLApplicationMain(int argc, char** argv, std::string windowName, int width, int height, bool runLooppNeeded);
    void init(int argc, char** argv, std::string windowName, int width, int height, bool runLoppNeeded, bool withoutAppMain = false, bool withoutWindow = false);
    void executeMainLoop(bool loopNeeded);

    void configureApplication();
    void runApplication(bool runLooppNeeded);
    void configureAndRunApp(std::string windowName, int width, int heigh, bool runLooppNeeded, bool withoutAppMain, bool withoutWindow);
    void* setupAppComponents(std::string windowName, int width, int height, bool withoutAppMain, bool withoutWindow);
    void setUpCallBacks();
    ~NLApplicationMain();
};

#endif // NUCLEUS_DELEGATE_HPP
