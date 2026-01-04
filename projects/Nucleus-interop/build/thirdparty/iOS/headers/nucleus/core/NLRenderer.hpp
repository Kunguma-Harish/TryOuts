#ifndef __NL_RENDERER_H
#define __NL_RENDERER_H

#include <include/core/SkMatrix.h>
#include <skia-extension/GLRect.hpp>
#include <skia-extension/GLRegion.hpp>
#include <deque>
#include <vector>
#include <functional>
#include <include/core/SkImage.h>

#include <nucleus/interface/IRenderListener.hpp>


class NLLayer;
struct NLLayerProperties;
class NLSimpleRenderer;
class NLRenderTree;
class ZRenderBackend;
class SkCanvas;
class NLDeferredDetails;

class NLRenderer {
    struct RefreshRectReq {
        graphikos::painter::GLRect refreshRect;
        bool instantRefresh;
    };

    std::shared_ptr<NLSimpleRenderer> rendererDelegate;
    NLLayer* renderLayer = nullptr;

    sk_sp<SkImage> fullFrame;
    graphikos::painter::GLRect currMaxCoverageRect;
    std::deque<RefreshRectReq> refreshRects;
    bool enableFullFrame;

    void renderFullFrame();
    void drawFullFrame(SkCanvas* canvas, SkMatrix renderMatrix);
    SkMatrix getFullFrameMatrix();
    void interruptRendering();

    // experiment
    int fullFrameTileCount = 1;
    std::vector<std::vector<sk_sp<SkImage>>> fullFrameTiles;
    std::vector<std::vector<std::function<void()>>> fullFrameContinueRendering;
    void renderFullFrameTile(int row, int col);
    void renderFullFrameTiles();
    void drawFullFrameTiles(SkCanvas* canvas, SkMatrix renderMatrix);

public:
    static bool disableDownSampling;
    static int WeightedDrawCallULimit;
    // to render tiles in tilerenderer when scaling (for experimental purpose)
    static bool renderTilesOnScale;
    static float cachedVisibleRectRelOutset;

    enum Mode {
        NONE,     // nothing will be cached
        DEFERRED, // caches a single image and uses deferred playback
        TILED,    // caches tiles of images and renders in between events
        SIMPLE,   // caches a single image (temporary)
        AUTO      // automatically select the mode
    };
    NLRenderer::Mode mode;

    NLRenderer(Mode mode);
    void init(bool isDataChanged);
    void initRenderer(Mode mode, int fullFrameTilesSize);
    void onLoop(SkMatrix renderMatrix);
    void startMatrixChangedTime();
    void startResizeTimer();
    void fullFrameResize();
    void draw(SkCanvas* canvas, SkMatrix renderMatrix);
    bool onDraw(SkCanvas* canvas, NLDeferredDetails* dd, SkMatrix totalMatrix = SkMatrix(), bool applyContentScale = true, bool isViewPortTransformed = false);
    void refreshRect(graphikos::painter::GLRect reqRect, bool instantRefresh);

    void setRenderLayer(NLLayer* renderLayer);
    graphikos::painter::GLRect getViewPortRect();

    void changeRendererMode(NLRenderer::Mode mode, int fullFrameTilesSize);


    // temp functions
    SkMatrix temp_getMatrixCache();
    void temp_renderFullFrame();
    void temp_ReRender(std::function<void()> temp_renderFunction);
    ZRenderBackend* temp_getRenderBackend();
    void temp_AdjustMatrix(SkMatrix matrix);
    sk_sp<SkImage>& temp_getLayerFullFrame();

    friend class NLSimpleRenderer;
    friend class NLDeferredRenderer;
    friend class NLTileRenderer;

    //for viewport manager
    std::vector<IRenderListener*> receivers;
    void addRenderListener(IRenderListener* dataReceivable) {
        receivers.push_back(dataReceivable);
    }
    void firePreRenderListeners(graphikos::painter::GLRect query){
        for (auto dataReceivable : receivers) {
            dataReceivable->onViewPortChange(query);
        }
    }
};

#endif // __NL_RENDERER_H
