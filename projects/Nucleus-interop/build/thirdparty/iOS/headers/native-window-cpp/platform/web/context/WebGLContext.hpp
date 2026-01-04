#ifndef WEBGLCONTEXT_HPP
#define WEBGLCONTEXT_HPP
#include<native-window-cpp/common/context/NWTContext.hpp>
#include<native-window-cpp/platform/web/context/WebGLVersion.hpp>

#include <emscripten/bind.h>
#include <emscripten/html5.h>


class WebGLContext : public NWTContext {
    EMSCRIPTEN_WEBGL_CONTEXT_HANDLE ctx_handle = 0;
    WebGLVersion versionUtil;
    public:
    WebGLContext();
    void createGLContext(std::string const& title,float width, float height);
    void attachContextAsCurrent(bool attachCurrentContext) override;
    void destroyContext();
    bool swapBuffers() override;
};
#endif