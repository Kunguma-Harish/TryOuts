#ifndef __NL_SIMPLERENDERER_H
#define __NL_SIMPLERENDERER_H

#include <include/core/SkMatrix.h>
#include <nucleus/core/NLRenderTree.hpp>
#include <skia-extension/GLRegion.hpp>

class NLLayer;
class NLRenderer;

class NLSimpleRenderer {
    graphikos::painter::GLRect cachedVisibleRect = graphikos::painter::GLRect();

protected:
    enum FrameType {
        CURRENT_FRAME = 1,
        FULL_FRAME = 2,
        ALL_FRAMES = 3
    };

    enum class Requirement {
        NOT_REQUIRED,
        OPTIONAL,
        MANDATORY
    };

    NLRenderer* renderer = nullptr;
    NLLayer* renderLayer = nullptr;
    float matrixChangeCalledTime = 0;
    float resizeCalledTime = 0;
    sk_sp<SkImage> image = nullptr;
    SkMatrix matrixCache;
    bool freshRender = true;
    bool isDataChanged = true;

    Requirement isCurrFrameRequired(SkMatrix renderMatrix);
    void updateFrame(sk_sp<SkImage> image);
    void adjustMatrix(SkMatrix currentMatrix = SkMatrix());
    void checkForRefreshRect(const SkMatrix& renderMatrix);
    virtual void renderRect(SkMatrix transform, int width, int height, FrameType frameType);
    virtual void refreshRect(sk_sp<SkImage> image, SkMatrix transform, FrameType frameType);
    virtual void immediateRender(SkMatrix renderMatrix);

    graphikos::painter::GLRect getCachedVisibleRect();
    virtual graphikos::painter::GLRect getCachedRect();

    void setCachedVisibleRect(graphikos::painter::GLRect cachedVisibleRect);

    SkMatrix getDirtyMatrix(SkMatrix renderMatrix);
    SkMatrix getInvMatrixCache();

public:
    NLSimpleRenderer(NLRenderer* renderer);
    virtual void init(bool isDataChanged);
    virtual void onLoop(SkMatrix renderMatrix);
    virtual void startMatrixChangedTime();
    virtual void startResizeTimer();
    virtual void fullFrameResize();
    virtual void draw(SkCanvas* canvas, SkMatrix renderMatrix);

    void setRenderLayer(NLLayer* renderLayer);

    /// @todo move to protected later
    virtual void render(SkMatrix renderMatrix);
    virtual ~NLSimpleRenderer() {};

    graphikos::painter::GLRect temp_getTilesRegion() {
        return getCachedVisibleRect().applying(getInvMatrixCache());
    }

    
    
};

#endif // __NL_SIMPLERENDERER_H