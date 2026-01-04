#ifndef __NL_ZRENDERBACKEND_H
#define __NL_ZRENDERBACKEND_H
#include <functional>
#include <skia-extension/GLRect.hpp>
#include <skia-extension/core/types.h>
// #include <painter/BackendRenderSettings.hpp>
#include <include/core/SkRefCnt.h>
#include <include/core/SkMatrix.h>
#include <include/core/SkColorSpace.h>
#include <include/core/SkColor.h>
#include <memory>
#include <nucleus/nucleus_config.h>

class GrDirectContext;
class SkSurface;
class SkCanvas;
class SkBitmap;
class SkImage;
class SkData;

using RenderFunction = std::function<void(SkCanvas*)>;

class ZRenderBackend {
private:
    int width, height;
    std::shared_ptr<SkBitmap> bitmap;

public:
    SkColor clearColor;
    ZRenderBackend(SkColor clearColor = SK_ColorTRANSPARENT);
    // std::shared_ptr<graphikos::painter::BackendRenderSettings> backendRenderSettings = std::make_shared<graphikos::painter::BackendRenderSettings>();
    void createCanvas(int width, int height, uint32_t flags = 0);
    virtual SkCanvas* getCanvas();
    virtual sk_sp<SkData> getData();
    bool canvasInitiated();
    void renderInCanvas(RenderFunction renderFunction, bool _flush = true);
    void translateCanvas(float transX, float transY);
    void scaleCanvas(float sX, float sY, float pX, float pY);
    void resetCanvas();
    // GL_DPR("Use postTransform")
    std::shared_ptr<SkBitmap> readFrameBuffer(int srcX, int srcY);
    virtual void translate(float transX, float transY);
    void clearCanvas();
    void flush();
    virtual void makeContextCurrent() = 0;
    sk_sp<SkImage> getSnapshot(SkIRect bounds = SkIRect::MakeEmpty());
    GrDirectContext* getGrDirectContext();
    virtual sk_sp<GrDirectContext> refGrDirectContext();
    sk_sp<SkSurface> getSurface(float width, float height);
    virtual sk_sp<SkSurface> getSurface();
    virtual ~ZRenderBackend();
    void setBackgroundColor(SkColor color) {
        clearColor = color;
    }
    void setSurface(sk_sp<SkSurface> surface);

protected:
    sk_sp<SkSurface> surfaces[NL_SURFACE_COUNT];
    sk_sp<SkSurface>& surface = surfaces[0];

    virtual void onCreateCanvas(int width, int height, uint32_t flags);
    virtual bool onFlush();
};

#endif
