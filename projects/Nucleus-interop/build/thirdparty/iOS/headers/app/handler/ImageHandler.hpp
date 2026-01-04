#ifndef __NL_IMAGEHANDLER_H
#define __NL_IMAGEHANDLER_H

class NLScrollEventController;
#include <functional>
#include <queue>

class ApplicationContext;
class ImageHandler {
private:
    ApplicationContext* app = nullptr;
    int totalSetImageArraySize = 5, noOfSetImageInProgress = 0;
    std::queue<std::function<void(void)>> setImageQueue;

public:
    ImageHandler(ApplicationContext* app);
    void setImage(std::function<void(void)> func);
    void init();
    void addNextSet();
    void clearQueue();
    NLScrollEventController* eventController = nullptr;
};

#endif