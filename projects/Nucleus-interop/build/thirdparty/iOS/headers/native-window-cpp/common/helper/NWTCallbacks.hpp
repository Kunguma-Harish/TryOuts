#ifndef CALLBACKS_HPP
#define CALLBACKS_HPP

#include <functional>
#include <memory>
#include <string>

class NWTCallbacks {
public:
    using ApplicationCallback = std::function<void()>;
    using ApplicationCallbackForInputStr = std::function<void(std::string)>;
    using InitApplicationCallback = std::function<void*()>;

    static NWTCallbacks& getInstance();

    void setInitApplicationCallback(InitApplicationCallback callback);
    void setRunApplicationCallback(ApplicationCallback callback);
    void setConfigureApplicationDataCallback(ApplicationCallback callback);
    void setConfigureApplicationCallbackForInputStr(ApplicationCallbackForInputStr callback);

    void* fireInitApplicationCallback();
    void fireRunApplicationCallback();
    void fireConfigureApplicationCallback(std::string inputPath = "");


private:
    NWTCallbacks() = default;

    InitApplicationCallback initApplicationCallback;
    ApplicationCallback runApplicationCallback;
    ApplicationCallback configureApplicationDataCallback;
    ApplicationCallbackForInputStr configureApplicationCallbackForInputStr;
};

#endif 
