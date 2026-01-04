#ifndef _NL_LAYER_H
#define _NL_LAYER_H

#include <include/core/SkPaint.h>
#include <nucleus/nucleus_config.h>
#include <skia-extension/GLRect.hpp>
#include <nucleus/core/SODODetails.hpp>
#include <nucleus/core/NLRenderer.hpp>
#include <nucleus/core/NLDeferredDetails.hpp>

class SkCanvas;
class SkDeferredDetails;
class Looper;

struct NLLayerProperties {
private:
    float contentScale = 1;
    int width = 0;
    int height = 0;
    int fullFrameWidth = 0;
    int fullFrameHeight = 0;
    ZRenderBackend* backend = nullptr;
    Looper* looper = nullptr;

public:
    NLLayerProperties(float contentScale, int width, int height, int fullFrameWidth, int fullFrameHeight, ZRenderBackend* backend, Looper* looper);
    float getContentScale();
    void setContentScale(float contentScale);
    ZRenderBackend* getRenderBackend();
    Looper* getLooper();
    graphikos::painter::GLRect getVisibleRect();
    graphikos::painter::GLRect getFullFrameRect();
    void setVisibleRect(int width, int height);
    void setFullFrameRect(int fixedWidth, int fixedHeight);
};

struct NLClip {
public:
    enum NLClipType {
        NO_CLIP = 0,
        RECT = 1,
        PATH = 2,
        REGION = 3
    };

    NLClip();
    NLClip(graphikos::painter::GLRect rect, SkClipOp clipOp = SkClipOp::kDifference, bool antiAlias = false);
    NLClip(graphikos::painter::GLPath path, SkClipOp clipOp = SkClipOp::kDifference, bool antiAlias = false);
    NLClip(graphikos::painter::GLRegion region, SkClipOp clipOp = SkClipOp::kDifference);
    void setClipOp(SkClipOp clipOp);
    void setAntiAlias(bool antiAlias);
    void clip(SkCanvas* canvas, const SkMatrix& frameMatrix);
    graphikos::painter::GLRect getDrawableRect(graphikos::painter::GLRect viewportRect);
    bool needToDraw(graphikos::painter::GLRect renderRect, SkMatrix matrix);

private:
    NLClipType clipType = NLClipType::NO_CLIP;
    SkClipOp clipOp = SkClipOp::kDifference;
    bool antiAlias = false;

    graphikos::painter::GLRect clipRect = graphikos::painter::GLRect();
    graphikos::painter::GLPath clipPath = graphikos::painter::GLPath();
    graphikos::painter::GLRegion clipRegion = graphikos::painter::GLRegion();
};

struct NLBlur {
private:
    bool hasBlur = false;
    float blurRadius = 0.0;
    SkColor blurColor = SK_ColorTRANSPARENT;

public:
    NLBlur();
    NLBlur(float blurRadius, SkColor blurColor);
    void drawBlur(SkCanvas* canvas);
};

enum ViewTransform {
    NO_TRANSFORM = 0,
    TRANSLATE = 1,
    MAGNIFY = 2,
    TRANSFORM = 3,
    SET_MATRIX = 4
};

class NLLayer {
private:
    graphikos::painter::GLRect viewPortRect = graphikos::painter::GLRect();
    NLClip layerClip = NLClip();
    NLBlur layerBlur = NLBlur();

    float min_zoom = GRAPHICSCORE_MIN_ZOOM;
    float max_zoom = GRAPHICSCORE_MAX_ZOOM;

    SkColor layerColor = SK_ColorTRANSPARENT;

    SkMatrix viewMatrix;

    NLLayer* parent = nullptr;
    std::vector<std::shared_ptr<NLLayer>> subLayers;

    bool isDirty = false;
    graphikos::painter::GLRect dirtyRect = graphikos::painter::GLRect();

    bool shouldResize = false;
    void invalidateParentForChild(graphikos::painter::GLRect invalidateRect);

    friend class NLRenderer;
    bool isAncestor(const NLLayer* layer) const;
    bool needToDraw(graphikos::painter::GLRect renderRect, SkMatrix viewPortMatrix);

protected:
    NLLayer(NLLayerProperties* layerProperties, graphikos::painter::GLRect viewPortRect, SkColor layerColor, NLRenderer::Mode mode);
    void viewTransformed(const ViewTransform& viewTransformed, const SkMatrix& totalMatrix = SkMatrix());
    void matrixTranslate(float transX, float transY);
    void matrixScale(float magnificationX, float magnificationY, graphikos::painter::GLPoint byPoint);
    virtual void onLoop(SkMatrix parentMatrix);
    std::shared_ptr<NLRenderer> renderer;
    SODODetails sodoDetails;
    bool clipToViewPort = false;
    float alpha = 1.0;
    bool detachInNextLoop = false;
    NLLayerProperties* layerProperties = nullptr;
    bool isActive = false;

    /** 
     * returns the matrix in which the layer will be rendered (finds and concats all parent matrices)
    */
    SkMatrix getRenderMatrix() const;

    /** 
     * returns the matrix in which the layer will be rendered given parentMatrix
     * @param concated matrix of parentlayers of all levels
    */
    SkMatrix getRenderMatrix(const SkMatrix& parentMatrix) const;

public:
    NLLayer();
    NLLayer(NLLayerProperties* layerProperties, graphikos::painter::GLRect viewPortRect, SkColor layerColor = SK_ColorTRANSPARENT);

    SkMatrix getInvMatrix(SkMatrix matrix);

    void initialise(bool isDataChanged = true);

    NLLayerProperties* getLayerProperties();

    /** 
     * Adds dirty region to be refreshed in the next draw, should be called only when required
        @param dirtyRect 
    */
    void addDirtyRect(graphikos::painter::GLRect dirtyRect);
    graphikos::painter::GLRect getDirtyRect();
    const std::vector<std::shared_ptr<NLLayer>>& getSubLayers();
    std::shared_ptr<NLLayer> getSubLayerByIndex(int index);
    graphikos::painter::GLRect getVisibleRect() const;
    graphikos::painter::GLRect getFullFrameRect() const;
    graphikos::painter::GLRect getViewPortRect() const;
    graphikos::painter::GLRect getAbsoluteViewPortRect();
    void setViewPortRect(graphikos::painter::GLRect viewportRect);
    void setLayerClip(NLClip clip);
    NLClip getLayerClip();
    void setLayerBlur(NLBlur blur);
    NLBlur getLayerBlur();
    float getContentScale();
    SkColor getLayerColor();
    float getAlpha();
    void setAlpha(float alpha);
    void setShouldResize(bool shouldResize);
    bool getShouldResize();

    void setClipToViewport(bool clipToViewPort);
    bool getClipToViewport();

    SkMatrix getParentMatrix(SkMatrix renderMatrix);
    SkMatrix getTotalMatrix() const;
    SkMatrix getInvTotalMatrix() const;
    SkMatrix getViewPortTranslate() const;

    void applyZoomLimit(SkMatrix* viewMatrix);
    virtual void updateViewMatrix(SkMatrix viewMatrix);
    virtual void setLayerColor(SkColor layerColor);
    void setCustomZoomRange(float min, float max);
    std::pair<float, float> getCustomZoomRange();
    virtual float getCurrentScale();
    virtual graphikos::painter::GLPoint getCurrentTranslate();

    virtual void onDataChange();

    virtual void addSublayer(std::shared_ptr<NLLayer> sublayer);
    virtual void willRemoveFromParent();
    virtual void removeFromParent();
    void moveSublayersTo(NLLayer*);
    virtual void onAttach();
    virtual void onDetach();
    void clearParent() {
        parent = nullptr;
        onDetach();
    }

    void loop(SkMatrix parentMatrix = SkMatrix());
    virtual graphikos::painter::GLRect getDirtyRectFromData(const SkMatrix& totalMatrix);
    graphikos::painter::GLRect getSelectiveRenderRect(const graphikos::painter::GLRect& parentViewport, SkMatrix parentMatrix);
    virtual bool needToRefresh();

    void refreshRect(graphikos::painter::GLRect rect, bool instantRefresh = false);
    void changeRendererMode(NLRenderer::Mode mode, int fullFrameTileCount);

    bool cacheSODODetails(const graphikos::painter::GLRect& frame, const graphikos::painter::GLPoint& end, const SkMatrix& matrix);
    virtual int getWeightedDrawCallCount(const SkRect& queryRect, const SkMatrix& matrix, const int& uLimit);
    virtual graphikos::painter::GLRect getCoverageRect();
    virtual void updateCoverageRect();
    virtual bool hasData();

    //draw code
    virtual bool onDraw(SkCanvas* canvas, NLDeferredDetails* dd, SkMatrix totalMatrix = SkMatrix(), bool applyContentScale = true);
    void draw(SkCanvas* canvas, SkMatrix parentMatrix = SkMatrix());
    void detachChildBeforeLoop();

    // events
    bool translate(float valX, float valY, graphikos::painter::GLPoint byPoint, SkMatrix parentMatrix = SkMatrix());
    bool magnify(float magnification, graphikos::painter::GLPoint byPoint, SkMatrix parentMatrix = SkMatrix());
    bool transform(SkMatrix matrix, bool preConcat);
    bool resize(graphikos::painter::GLRect viewPortRect, SkMatrix parentMatrix = SkMatrix());
    void canvasResize();
    bool monitorResize();

    bool mouseDown(const graphikos::painter::GLPoint& point, int modifier, const SkMatrix& matrix);
    bool mouseUp(const graphikos::painter::GLPoint& point, const graphikos::painter::GLPoint& end, int modifier, const SkMatrix& matrix);
    bool doubleClickEnd(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, int modifier, const SkMatrix& matrix);
    bool tripleClickEnd(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, int modifier, const SkMatrix& matrix);
    bool mouseMove(const graphikos::painter::GLPoint& point, int modifier, const SkMatrix& matrix);
    bool internalDrag(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLPoint& prevPoint, int modifier, const SkMatrix& matrix);
    bool drag(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLPoint& prevPoint, int modifier, const SkMatrix& matrix);
    bool mouseHold(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLPoint& prevPoint, int modifier, const SkMatrix& matrix);
    bool longPress(const graphikos::painter::GLPoint& point, int modifier, const SkMatrix& matrix);
    bool keyPress(int keyCode, int modifier, std::string keyCharacter, const SkMatrix& matrix);
    bool keyDown(int keyCode, int modifier, bool repeat, std::string keyCharacter, const SkMatrix& matrix);
    bool keyRelease(int keyAction, int key, const SkMatrix& matrix);
    bool textInput(std::string inputStr, int compositionStatus, const SkMatrix& matrix);
    bool doubleClick(const graphikos::painter::GLPoint& point, int modifier, const SkMatrix& matrix);
    bool tripleClick(const graphikos::painter::GLPoint& point, int modifier, const SkMatrix& matrix);
    bool rightClickDown(const graphikos::painter::GLPoint& point, int modifier, const SkMatrix& matrix);
    bool rightClickUp(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, int modifier, const SkMatrix& matrix);

    virtual bool onTranslate(float transX, float transY);
    virtual bool onMagnify(float magnification, graphikos::painter::GLPoint byPoint);
    virtual bool onTransform(const SkMatrix& matrix, bool preConcat);
    virtual bool onResize(const graphikos::painter::GLRect viewPortRect, const SkMatrix& matrix);
    virtual bool onMouseDown(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix);
    virtual bool onDoubleClickEnd(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix);
    virtual bool onDoubleClick(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix);
    virtual bool onTripleClickEnd(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix);
    virtual bool onTripleClick(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix);
    virtual bool onMouseMove(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix);
    virtual bool onDrag(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLPoint& prevPoint, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix);
    virtual bool onMouseHold(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLPoint& prevPoint, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix);
    virtual bool onLongPress(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix);
    virtual bool onKeyPress(int keyCode, int modifier, std::string keyCharacter, const SkMatrix& matrix);
    virtual bool onKeyDown(int keyCode, int modifier, bool repeat, std::string keyCharacter, const SkMatrix& matrix);
    virtual bool onKeyRelease(int keyAction, int key, const SkMatrix& matrix);
    virtual bool onMouseUp(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix);
    virtual bool onTextInput(std::string inputStr, int compositionStatus, const SkMatrix& matrix);
    virtual bool onRightClickDown(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix);
    virtual bool onRightClickUp(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix);
    virtual void onViewTransformed(const ViewTransform& viewTransform, const SkMatrix& totalMatrix);

    // Coordinates
    graphikos::painter::GLPoint convertPointFrom(const graphikos::painter::GLPoint& point, const NLLayer* fromLayer) const;
    graphikos::painter::GLPoint convertPointTo(const graphikos::painter::GLPoint& point, const NLLayer* toLayer) const;

    virtual ~NLLayer();
    void temp_traverse(std::function<void(NLLayer*)> func);
    std::string layerName = "layerName";

    //temp functions : to fetch and store current viewPort in tile mode.
    graphikos::painter::GLRect temp_viewPortRect;
    graphikos::painter::GLRect temp_maxCoveragerect;
    std::shared_ptr<NLRenderer> getRenderer() {
        return renderer;
    }

//hotfix for layer order change in onloop
    bool temp_skipDraw = false;
    bool temp_shouldSkipDraw();
};

#endif