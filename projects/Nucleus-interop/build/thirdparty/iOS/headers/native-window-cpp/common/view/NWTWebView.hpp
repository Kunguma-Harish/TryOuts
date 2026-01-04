#ifndef NWTWEBVIEW_HPP
#define NWTWEBVIEW_HPP

#include <native-window-cpp/common/window/NWTWindow.hpp>
#include <functional>

using StringArgFn = std::function<void(const std::string&)>;
using VectorArgFn = std::function<void(const uint8_t* data, const size_t data_len)>;
using EventsArgFn = std::function<void(const std::string evName, const double x1, const double y1, const double x2, const double y2, const double x3, const double y3, const char* text, const int modifier)>;

class NWTWebView {
protected:
    int width, height;

public:
    NWTWebView(int width, int height);
    virtual void attach(NWTWindow* window) = 0;
    virtual void detach() = 0;
    virtual void loadUrl(const std::string& urlString) = 0;
    virtual void addCallbackWithString(StringArgFn cb, const std::string& name) = 0;
    virtual void addCallbackWithVector(VectorArgFn cb, const std::string& name) = 0;
    virtual void addCallbackWithEventsArg(EventsArgFn cb, const std::string& name) = 0;
};

#endif