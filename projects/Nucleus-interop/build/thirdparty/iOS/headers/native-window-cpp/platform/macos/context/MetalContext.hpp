#ifndef METALCONTEXT_HPP
#define METALCONTEXT_HPP
#include <native-window-cpp/common/context/NWTContext.hpp>

class MetalContext: public NWTContext {
    void* context = nullptr;
public:
    void* getMetalContext();
    void createMTKViewToMetalContext(float width, float height, void* handle);
    void attachMTKViewToMetalContext(float width, float height, void* handle);
    void createMetalContext();

    //metal context getters
    void* getMTKView();
    void* getMTLDevice();
    void* getCmdQueue();
    void* getMTLTexture();

    void* getNextDrawableAsTexture();
    void getContentScale(float* x, float* y) override;
    bool swapBuffers() override;
    void changeColor();
    void* drawablePtr;
    bool canFlush();

    ~MetalContext();

};

#endif