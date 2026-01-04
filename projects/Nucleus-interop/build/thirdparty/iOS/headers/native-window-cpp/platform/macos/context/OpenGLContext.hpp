#ifndef OPENGLCONTEXT_HPP
#define OPENGLCONTEXT_HPP
#include <native-window-cpp/common/context/NWTContext.hpp>

class OpenGLContext : public NWTContext {
    void* context;

public:
    void createGLContext();
    void attachViewToContext(float width, float height, void* handle);
    void getContentScale(float* x, float* y) override;
    bool swapBuffers() override;
    void attachContextAsCurrent(bool attachCurrentContext) override;
    ~OpenGLContext();
};

#endif