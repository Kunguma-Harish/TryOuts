#ifndef __NL_VANIEDITORCONTROLLER_H
#define __NL_VANIEDITORCONTROLLER_H
#include <app/EditorController.hpp>
#include <vani/VaniAnchorController.hpp>
#include <vani/VaniEmbedController.hpp>
#include <vani/VaniReactionController.hpp>
#include <vani/VaniCommonUtil.hpp>

class VaniCollabController;

namespace com {
namespace zoho {
namespace remoteboard {
class Frame;
}
}
}
class VaniEditorController : public EditorController, public VaniCommonUtil {
private:
    std::shared_ptr<NLLayer> productLayer = nullptr;
    std::shared_ptr<VaniAnchorController> anchorController = nullptr;
    std::shared_ptr<VaniEmbedController> embedController = nullptr;
    bool dragHandled = false;
    std::shared_ptr<VaniCollabController> vaniCollabController = nullptr;
    std::shared_ptr<NLInstanceLayer> AIPreviewLayer = nullptr;

public:
    VaniEditorController(std::shared_ptr<NLDataController> dataController, ZSelectionHandler* selectionHandler, ControllerProperties* properties, NLEditorProperties* editorProperties);
    void onDataChange() override;

    void attachProductLayer() override;
    void detachProductLayer() override;
    bool getEditingLayerStatus();
    graphikos::painter::GLPoint getRemoveIconPosition();
    void dataUpdated(bool needRender = false, std::vector<std::string> shapeIds = {}) override;
    void updateSelectedShapeData(std::vector<std::string>& selectedShapes, const std::vector<std::string>& containerModifiedShapes = {}) override;
    void refreshSelectedLayer(std::vector<std::string> shapeIds, bool isFontAdd = false) override;
    void onSelectionChange() override;
    void saveContainerName();

    VaniAnchorController* getAnchorController();
    VaniEmbedController* getEmbedController();
    std::shared_ptr<VaniCommentHandler> getCommentHandler();

    void createEditingLayers() override;
    graphikos::painter::GLRect reRenderSelectedShapeWithMatrix(std::shared_ptr<NLRenderTree> nlrenderTree, const SelectedShape* selectedShape, graphikos::painter::Matrices matrices = graphikos::painter::Matrices(), bool createBulletForEmptyLines = false, com::zoho::shapes::Transform* gTrans = nullptr, const std::vector<std::pair<std::string, bool>>& idsToDraw = {}, com::zoho::shapes::ShapeObject* changedShapeObject = nullptr) override;
    void renderContainerNameUsingMatrix(std::string& shapeId, const std::string& name, com::zoho::shapes::Transform* transform, const graphikos::painter::Matrices& changedMatrices, const graphikos::painter::Matrices& originalMatrices);
    void translateGifButton(com::zoho::shapes::ShapeObject* shape, SkMatrix matrix);
    void translateContainerName(std::string& shapeId, SkMatrix matrix);
    void updateContinuousEditingData(std::string value, com::zoho::shapes::ShapeNodeType validShape, ZEditorUtil::ContinuousEditType type, bool isMouseDown = true, bool isGRPFillEnabled = false) override;
    void addContainerNameOverlay(std::string containerId) override;
    void clearContainerNameOverlay(std::string containerId) override;
    void showAIPreviewForFrame(com::zoho::remoteboard::Frame* frame);
    void showAIPreviewForShape(com::zoho::shapes::ShapeObject* shapeObject);
    void removeAIPreview();

    // product specific overriden functions
    graphikos::painter::ShapeDetails getShapeDetails(graphikos::painter::GLPoint mouse, graphikos::painter::GLRect frame, bool onModifier, const SkMatrix& matrix) override;
    bool _onMouseMove(const graphikos::painter::GLPoint& mouse, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix, graphikos::painter::ShapeDetails shapeDetails) override;
    bool _onMouseDown(const graphikos::painter::GLPoint& mouse, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix, graphikos::painter::ShapeDetails shapeDetails) override;
    bool _onKeyDown(int keyCode, int modifier, bool repeat, std::string keyCharacter, const SkMatrix& matrix) override;
    bool _onMouseHold(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLPoint& prevPoint, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool _onDrag(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLPoint& prevPoint, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool _onDoubleClickEnd(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix, graphikos::painter::ShapeDetails shapeDetails) override;
    bool _onMouseUp(const graphikos::painter::GLPoint start, const graphikos::painter::GLPoint end, int modifier, graphikos::painter::ShapeDetails shapeDetails, const graphikos::painter::GLRect& frame, const SkMatrix& matrix) override;
    bool _onRightClickDown(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix, graphikos::painter::ShapeDetails shapeDetails) override;
    bool _onRightClickUp(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix);
    void onViewTransformed(const ViewTransform& viewTransform, const SkMatrix& totalMatrix) override;
    void shapeTranslated(const SelectedShape* selectShape, const SkMatrix& matrix, bool isAltkey) override;
};
#endif
