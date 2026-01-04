#ifndef NWTMACWEBVIEW_HPP
#define NWTMACWEBVIEW_HPP

#include <native-window-cpp/common/view/NWTWebView.hpp>

using StringArgFn = std::function<void(const std::string&)>;
using VectorArgFn = std::function<void(const uint8_t* data, const size_t data_len)>;
using EventsArgFn = std::function<void(const std::string evName, const double x1, const double y1, const double x2, const double y2, const double x3, const double y3, const char* text, const int modifier)>;

typedef void* _WebViewHandle;

class NWTMacWebView : public NWTWebView {
private:
    _WebViewHandle webViewHandler;

public:
    NWTMacWebView(int width, int height);
    void attach(NWTWindow* window);
    void detach();
    void loadUrl(const std::string& urlString);
    void addCallbackWithString(StringArgFn cb, const std::string& name);
    void addCallbackWithVector(VectorArgFn cb, const std::string& name);
    void addCallbackWithEventsArg(EventsArgFn cb, const std::string& name);
    ~NWTMacWebView();
};

#endif