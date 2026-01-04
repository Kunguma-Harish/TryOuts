#ifndef __NL_VANIFLOWCONTROLLER_H
#define __NL_VANIFLOWCONTROLLER_H

#include <app/controllers/NLScrollEventController.hpp>
#include <app/ZBBox.hpp>
#include <app/NLDataController.hpp>
#include <vani/data/VaniDataController.hpp>
#include <vani/VaniEmbedController.hpp>
#include <vani/VaniReactionController.hpp>
#include <app/TextEditorController.hpp>
#include <nucleus/util/FitToScreenUtil.hpp>
#include <nucleus/core/layers/NLAnimLayer.hpp>
#include <vani/vani_config.h>
#include <painter/GifPainter.hpp>
#include <vani/VaniCommonUtil.hpp>

enum Flowtype {
    STATIC = 0,
    MOTION = 1

};

class VaniFlowController : public NLScrollEventController, public VaniCommonUtil {
private:
    graphikos::painter::GifPainter gifpainter = graphikos::painter::GifPainter();
public:
    std::shared_ptr<com::zoho::remoteboard::Frame> currentFrame = nullptr;
    std::shared_ptr<NLDataController> dataLayer = nullptr;
    VaniDataController* vaniDataController = nullptr;
    std::shared_ptr<ZBBox> bbox = nullptr;

    std::shared_ptr<NLLayer> currentFrameRenderLayer = nullptr;
    std::shared_ptr<NLShapeLayer> hoverShapeLayer = nullptr;
    std::shared_ptr<NLLayer> bboxLayer = nullptr;
    std::shared_ptr<NLLayer> containerLayer = nullptr;
    std::shared_ptr<NLAnimLayer> frameChangeAnimLayer = nullptr;
    std::shared_ptr<NLRenderLayer> anchorLayer = nullptr;
    std::shared_ptr<VaniEmbedController> embedController = nullptr;
    std::shared_ptr<TextEditorController> textEditor = nullptr;
    NLEditorProperties* editorProperties = nullptr;

    std::shared_ptr<NLLayer> flowUILayer = nullptr;
    std::shared_ptr<NLInstanceLayer> addToFlowLayer = nullptr;
    std::shared_ptr<NLInstanceLayer> plusIconLayer = nullptr;
    std::shared_ptr<NLInstanceLayer> fileHoverLayer = nullptr;
    std::shared_ptr<NLAnimLayer> addFrameAnimLayer = nullptr;
    std::map<std::string, std::vector<std::shared_ptr<NLInstanceLayer>>> frameIndexMap;
    std::map<std::string, std::shared_ptr<NLInstanceLayer>> moreFrameIndexMap;

    float zoomEventTime = 0;
    float currentScale = 0;

    bool selectFrameState = true;
    int currentFrameIndex = -1;
    int currentFlowIndex = -1;
    int maxStatesCount = -1;
    std::string currentHoverFrameId = "";
    int currentPreviewFlowIndex;
    bool animationInProgress = false; // need this to skip animation when the user has given two inputs within the duration of animation.

    graphikos::painter::ShapeDetails hoverShapeDetails;
    std::vector<std::function<void()>> interruptCallbacks;
    SkMatrix oldMatrix = SkMatrix(); // need this for persisting matrix value from the previous eventController.

    std::vector<NLAnimationData> animDataArray;
    void slideEnded();
    void motionEnded();

public:
    Flowtype flowtype;
    VaniFlowController(std::shared_ptr<NLDataController> dataController, ZSelectionHandler* selectionHandler, ControllerProperties* properties, NLEditorProperties* editorProperties);

    void fitShapes(const std::vector<std::string>& shapeIds, bool needAnimation = false, bool maintainScale = false, bool fitContainer = false, bool alwaysFit = false) override;

    void attachLayers();
    void detachLayers();
    void onAttach() override;
    void onDetach() override;
    void onDataChange() override;
    void clearHoverShapeLayer();

    // regenerates currentFrameRenderLayer for audio shape in  slide animation
    void refreshData(std::vector<std::string> shapeIds);
    void refreshControllerRect(graphikos::painter::GLRect rect, std::string imageKey, bool instantRefresh = false) override;

    bool onMouseDown(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onMouseUp(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onMouseMove(const graphikos::painter::GLPoint& mouse, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onDrag(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLPoint& prevPoint, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onRightClickDown(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onResize(const graphikos::painter::GLRect viewPortRect, const SkMatrix& matrix) override;
    void onViewTransformed(const ViewTransform& viewTransform, const SkMatrix& totalMatrix) override;
    void onLoop(SkMatrix parentMatrix) override;

    // Flow mode methods.
    void initFlow(int flowIndex);
    void deInitFlow();
    void moveToFrame(int index);
    int getCurrentFrameIndex();
    std::tuple<std::shared_ptr<NLLayer>, std::shared_ptr<com::zoho::remoteboard::Frame>> getLayerForFlowState(int flowIndex, int stateIndex);
    void animateViewChange(SkMatrix fitMatrix) override;
    void animateFlow(std::tuple<std::shared_ptr<NLLayer>, std::shared_ptr<com::zoho::remoteboard::Frame>> layerFrameDetails);
    void slideAnimate(std::tuple<std::shared_ptr<NLLayer>, std::shared_ptr<com::zoho::remoteboard::Frame>> layerFrameDetails, NLAnimationData animdata);
    void attachFrameAndProductLayers();
    void detachFrameAndProductLayers();

    void renderAddToFlowLayer(int flowIndex);
    void renderFlowUILayer(int flowIndex);
    void removeFlowUILayer();
    void generateAddFlowButtonPicture();
    void renderHoverLayer(graphikos::painter::GLRect frameRect);
    void renderFrameAdded(graphikos::painter::GLRect frameRect);

    SkMatrix getMatrix() { return oldMatrix; }
    void setMatrix(SkMatrix matrix) { oldMatrix = matrix; }
};

#endif
