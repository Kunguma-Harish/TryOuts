#ifndef __NL_VANICOMMENTCONTROLLER_H
#define __NL_VANICOMMENTCONTROLLER_H

#include <app/ZBBox.hpp>
#include <app/NLDataController.hpp>
#include <app/controllers/NLScrollEventController.hpp>
#include <app/TableController.hpp>
#include <app/TextHighlightController.hpp>
#include <app/CollabController.hpp>
#include <vani/VaniEmbedController.hpp>
#include <vani/VaniReactionController.hpp>
#include <painter/GifPainter.hpp>
#include <vani/VaniCommonUtil.hpp>

class NLEditorProperties;

class VaniCommentController : public NLScrollEventController, public VaniCommonUtil {
    std::shared_ptr<NLDataController> dataLayer = nullptr;
    std::shared_ptr<ZBBox> bbox = nullptr;

    std::shared_ptr<NLShapeLayer> hoverShapeLayer = nullptr;
    std::shared_ptr<NLLayer> bboxLayer = nullptr;
    std::shared_ptr<TextHighlightController> textHighlightController = nullptr;
    std::shared_ptr<TableController> tableEditor = nullptr;
    std::shared_ptr<TextEditorController> textEditor = nullptr;
    std::shared_ptr<CollabController> collabController = nullptr;
    std::shared_ptr<ConnectorTextController> connectorTextController = nullptr;
    std::shared_ptr<NLRenderLayer> anchorLayer = nullptr;
    std::shared_ptr<NLInstanceLayer> containerNameLayer = nullptr;
    std::shared_ptr<VaniEmbedController> embedController = nullptr;

    graphikos::painter::ShapeDetails hoverShapeDetails;
    bool bboxRendered = false;
    bool textEditingLayerAttached = false;
    bool selectInnerShape = false;
    bool isParentAlreadySelected = false;
    NLEditorProperties* editorProperties = nullptr;
    graphikos::painter::GifPainter gifpainter = graphikos::painter::GifPainter();
    bool rangeSelectShape = false;
    std::vector<graphikos::painter::ShapeDetails> rangeSelectedShapes; // range selection

public:
    VaniCommentController(std::shared_ptr<NLDataController> dataController, ZSelectionHandler* selectionHandler, ControllerProperties* properties, NLEditorProperties* editorProperties);
    void onAttach() override;
    void onDetach() override;
    bool getEditingLayerStatus();
    void onDataChange() override;
    graphikos::painter::ShapeDetails getShapeDetails(graphikos::painter::GLPoint mouse, graphikos::painter::GLRect frame, bool onModifier, const SkMatrix& matrix);
    void setLayerColor(SkColor layerColor) override;
    bool onMouseDown(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onMouseUp(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onRightClickDown(const graphikos::painter::GLPoint& mouse, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onRightClickUp(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onMouseMove(const graphikos::painter::GLPoint& mouse, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onDoubleClick(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onDoubleClickEnd(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onDrag(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLPoint& prevPoint, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    void onViewTransformed(const ViewTransform& viewTransform, const SkMatrix& totalMatrix) override;
    void drawOverBox(graphikos::painter::ShapeDetails shapedetails, SkColor color = NUCLEUS_OVERLAY_COLOR);
    void renderSelectionBbox();
    void clearHoverShapeLayer();
    void dataUpdated(bool needRender = false, std::vector<std::string> shapeIds = {}) override;
    void onLoop(SkMatrix parentMatrix) override;

    std::shared_ptr<TextHighlightController> getTextHighlightController();
    std::shared_ptr<VaniCommentHandler> getCommentHandler();
    std::shared_ptr<TextEditorController> getTextEditor();
    std::shared_ptr<CollabController> getCollabSelectionHandler();
    VaniEmbedController* getEmbedController();
    std::shared_ptr<TableController> getTableEditor();
    void refreshSelectedLayer(std::vector<std::string> shapeIds, bool isFontAdd = false) override;

    void fitShapes(const std::vector<std::string>& shapeIds, bool needAnimation = false, bool maintainScale = false, bool fitContainer = false, bool alwaysFit = false) override;

    // shape select apis
    void selectShape(std::string shapeId, bool triggerEvent = true, bool needToFit = true, bool needAnimation = false, bool maintainScale = false, bool alwaysFit = false) override;
    void clearSelectedShapes(bool triggerEvent, std::string shapeId = "") override;
    void onSelectionChange() override;

    void addContainerNameOverlay(std::string containerId);
    void clearContainerNameOverlay(std::string containerId);
    void detachTableEditingLayer();
    std::shared_ptr<ConnectorTextController> getConnectorTextEditor();

    std::map<std::string, graphikos::painter::GLPoint> getBBoxPoints();
};

#endif
