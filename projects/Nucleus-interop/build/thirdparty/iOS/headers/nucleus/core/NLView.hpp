#ifndef __NL_VIEW_H
#define __NL_VIEW_H

#include <nucleus/core/ZRenderBackend.hpp>
#include <nucleus/core/ZWindow.hpp>

class NLLayer;
struct NLLayerProperties;

class NLView {
private:
    float leftOffset = 0, topOffset = 0, rightOffset = 0, bottomOffset = 0;
    sk_sp<SkImage> viewCache = nullptr;

public:
    std::shared_ptr<NLLayerProperties> layerProperties = nullptr;
    std::shared_ptr<ZWindow> window = nullptr; // should be removed
    std::shared_ptr<NLLayer> rootLayer = nullptr;
    ZRenderBackend* backend;

    NLView(ZRenderBackend* backend, std::shared_ptr<ZWindow> window);
    void setContentOffset(float leftOffset, float topOffset, float rightOffset, float bottomOffset, graphikos::painter::GLRect viewportRect);

    void onLoop();
    void drawFrames(graphikos::painter::GLRect renderRect);

    bool translate(float valX, float valY, graphikos::painter::GLPoint mouse);
    bool magnify(float magnification, graphikos::painter::GLPoint byPoint);
    void resize(int width, int height, graphikos::painter::GLRect viewPortRect);
    bool mouseDown(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier);
    bool mouseUp(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier);
    bool doubleClickEnd(graphikos::painter::GLPoint start, graphikos::painter::GLPoint end, graphikos::painter::GLRect frame, int modifier);
    bool doubleClicked(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier);
    bool tripleClickEnd(graphikos::painter::GLPoint start, graphikos::painter::GLPoint end, graphikos::painter::GLRect frame, int modifier);
    bool tripleClick(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier);
    bool mouseMove(const graphikos::painter::GLPoint& mouse, const graphikos::painter::GLRect& frame, int modifier);
    bool drag(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLPoint& prevPoint, const graphikos::painter::GLRect& frame, int modifier);
    bool mouseHold(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLPoint& prevPoint, const graphikos::painter::GLRect& frame, int modifier);
    bool longPress(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier);
    bool keyPress(int keyCode, int modifier, std::string keyCharacter = "a");
    bool keyDown(int keyCode, int modifier, bool repeat, std::string keyCharacter = "a");
    bool keyRelease(int keyAction, int key);
    bool textInput(std::string inputStr, int compositionStatus);
    bool rightClickDown(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier);
    bool rightClickUp(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier);
    void contentScaleChange(float xScale, float yScale);
    void monitorSizeChange(int width, int height);

    ~NLView();
};

#endif
