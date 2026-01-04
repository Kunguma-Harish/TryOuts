#ifndef __NL_EDITORCONTROLLER_H
#define __NL_EDITORCONTROLLER_H

#include <app/controllers/NLScrollEventController.hpp>
#include <app/TableEditingController.hpp>
#include <app/ConnectorTextController.hpp>
#include <app/TextEditorController.hpp>
#include <app/CollabController.hpp>
#include <app/ImageCropController.hpp>
#include <app/ZEditorConfig.hpp>
#include <app/ZShapeModified.hpp>
#include <app/DrawController.hpp>
#include <app/snapper/SnappingHandler.hpp>
#include <app/CustomTextEditorController.hpp>

#include <app/TextHighlightController.hpp>
#include <app/util/ZShapeAlignUtil.hpp>
#include <app/controllers/NLEditorProperties.hpp>
#include <app/ModifiersController.hpp>
#include <painter/GifPainter.hpp>

namespace google {
namespace protobuf {
template <typename T>
class RepeatedPtrField;
}
}
namespace com {
namespace zoho {
namespace shapes {
class Table;
}
}
}

struct EditingTransform;

using CustomRTreeGenerationForSelectedLayer = std::function<void(SkMatrix, EditingLayer&)>;

class EditorController : public NLScrollEventController {
private:
    bool isSnappingEnabled = true;
    bool isParentAlreadySelected = false;
    std::shared_ptr<SnappingHandler> snappingHandler = nullptr;
    graphikos::painter::GLPoint selectedOverPoint;
    graphikos::painter::GifPainter gifpainter = graphikos::painter::GifPainter();
    bool layerTranslateEnabled = true; // translate will be done layer wise instead rendering shape;
    std::shared_ptr<NLLayer> shapeDuplicateLayer = nullptr;
    bool isShapeDuplicateLayerAttached = false;

protected:
    NLEditorProperties* editorProperties = nullptr;

    std::shared_ptr<ZBBox> bbox = nullptr;
    std::shared_ptr<NLDataController> dataLayer = nullptr;

    std::shared_ptr<NLLayer> hoverLayer = nullptr;
    std::shared_ptr<NLLayer> bboxLayer = nullptr;
    std::shared_ptr<ConnectorController> connectorController = nullptr;
    std::shared_ptr<NLInstanceLayer> lockIconLayer = nullptr;
    std::shared_ptr<NLLayer> subEditorLayer = nullptr; // for table, text , image ,modifier

    std::shared_ptr<NLShapeLayer> hoverShapeLayer = nullptr; // hover layer for shape hover

    std::shared_ptr<ModifiersController> modifiersController = nullptr;
    std::shared_ptr<ImageCropController> imageCropController = nullptr;
    std::shared_ptr<TableEditingController> tableEditor = nullptr;
    std::shared_ptr<DrawController> drawController = nullptr;

    std::shared_ptr<TextEditorController> textEditor;
    std::shared_ptr<TextHighlightController> textHighlightController;
    std::shared_ptr<CollabController> collabController = nullptr; //CollabBbox layer
    std::shared_ptr<CustomTextEditorController> customTextEditor = nullptr;

    graphikos::painter::ShapeDetails hoverShapeDetails;                // hovering shape detail
    std::vector<graphikos::painter::ShapeDetails> rangeSelectedShapes; // range selection
    SelectedShape hoverSelectedShape;                                  //hovering a selected shape
    BoxCorner editBoxCorner = BoxCorner::DEFAULT;

    bool rangeSelectShape = false;
    bool textEditingLayerAttached = false;
    bool forEdit = false;
    bool keyEdit = false;
    bool handleSelection = false;
    bool enableSODO = true;
    bool dragStart = false;
    bool isAspectRatioMaintained = false; // stores the aspectChange lock for all the selectedShapes
    bool isContinuousEditingOp = false;   // true -> when continuous editing operation from ui is performed
    std::function<void(std::vector<std::string>, std::vector<std::string>)> reRenderShapes;

    // editor related data members.
    ZShapeAlignUtil::AlignTo alignTo = ZShapeAlignUtil::AlignTo::SHAPES;
    bool needRenderBBox = false;
    bool needRefreshLayer = false;
    bool needUpdateTextEditor = false;
    bool isAltKey = false;
    bool altKeyPressedDragStart = false; // for reseting the dependent connector to its original position.
    std::shared_ptr<EditingTransform> editingTransforms = nullptr;
    ZEditorUtil::EditingData eventData;
    std::vector<std::string> shapeIds;
    std::shared_ptr<NLShapeLayer> containerTintLayer = nullptr;
    std::map<com::zoho::shapes::ShapeNodeType, std::vector<com::zoho::shapes::ShapeNodeType>> validShapesMap; // for continuous UI editing case.
    SkMatrix temp_renderMatrix = SkMatrix();

    graphikos::painter::ShapeDetails isMousePointOnSelectableBullet(const graphikos::painter::GLPoint& mouse, const graphikos::painter::GLRect& frame, const SkMatrix& matrix, graphikos::painter::ShapeDetails shpDetails);

    virtual void shapeTranslated(const SelectedShape* selectShape, const SkMatrix& matrix, bool isAltkey);

public:
    std::string highlightedContainerId = "";
    EditorController(std::shared_ptr<NLDataController> dataController, ControllerProperties* properties, NLEditorProperties* editorProperties, ZSelectionHandler* selectionHandler);
    BoxCorner pointInBboxCorner(graphikos::painter::GLPoint mouse, graphikos::painter::GLRect frame);
    std::pair<ZEditorUtil::BoxCorner, bool> pointInBboxCornerAndIsParentLayer(graphikos::painter::GLPoint mouse, graphikos::painter::GLRect frame);

    void initEditing();
    virtual void attachProductLayer();
    virtual void detachProductLayer();

    void onAttach() override;
    void onDetach() override;
    void setLayerColor(SkColor layerColor) override;

    void refreshLayers();
    void refreshSelectedLayer(std::vector<std::string> shapeIds, bool isFontAdd = false) override;

    void setShapeModifier(std::shared_ptr<ZShapeModified> _shapeModified);
    ZShapeModified* getShapeModified();
    DrawController* getDraw();
    ImageCropController* getImageCrop();
    CustomTextEditorController* getCustomTextEditorController();
    std::shared_ptr<TextEditorController> getTextEditor();
    bool isTextEditMode();
    std::shared_ptr<TextHighlightController> getTextHighlightController();
    std::shared_ptr<CollabController> getCollabSelectionHandler();
    NLDataController* getDataLayer();
    ConnectorController* getConnectorController();
    void toggleLayerTranslate(bool layerTranslateEnabled);

    std::string getName();
    void onDataChange() override;
    void refreshControllerRect(graphikos::painter::GLRect rect, std::string imageKey, bool instantRefresh = false) override;
    std::shared_ptr<TableEditingController> getTableEditor();
    std::shared_ptr<ConnectorTextController> getConnectorTextEditor();
    std::vector<ShapeData> getUpdatedParentWithOutAShape(SelectedShape shape);
    std::vector<ShapeData> modifyTransformsOnInnerShapeDeletion(com::zoho::shapes::ShapeObject* innerShapeData, SelectedShape selectedShape);

    void fitShapes(const std::vector<std::string>& shapeIds, bool needAnimation = false, bool maintainScale = false, bool fitContainer = false, bool alwaysFit = false) override;

    // shape select apis
    void selectShape(std::string shapeId, bool triggerEvent = true, bool needToFit = true, bool needAnimation = false, bool maintainScale = false, bool alwaysFit = false) override;
    void clearSelectedShapes(bool triggerEvent, std::string shapeId = "") override;
    void onSelectionChange() override;
    void onSelectionDataChange() override;
    void addConnector(std::vector<SelectedShape>& shapes) override;

    void renderSelectionBbox();
    void renderSingleSelectionBbox();
    void drawOverBox(graphikos::painter::ShapeDetails& shapedetails, SkColor color = NUCLEUS_OVERLAY_COLOR);
    void drawLockIcon(std::vector<SelectedShape> selectedShapesInfos, std::vector<std::string> lockIconCorners);
    void clearHoverShapeLayer();
    void clearLockIconLayer();

    void onViewTransformed(const ViewTransform& viewTransform, const SkMatrix& totalMatrix) override;

    virtual graphikos::painter::ShapeDetails getShapeDetails(graphikos::painter::GLPoint mouse, graphikos::painter::GLRect frame, bool onModifier, const SkMatrix& matrix);

    bool onMouseDown(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onMouseUp(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onDoubleClick(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onDoubleClickEnd(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onTripleClickEnd(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onMouseMove(const graphikos::painter::GLPoint& mouse, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onDrag(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLPoint& prevPoint, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onMouseHold(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLPoint& prevPoint, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onKeyDown(int keyCode, int modifier, bool repeat, std::string keyCharacter, const SkMatrix& matrix) override;
    bool onKeyRelease(int keyAction, int key, const SkMatrix& matrix) override;
    bool onRightClickDown(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onRightClickUp(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;

    //overrides for proct based operations
    virtual bool _onMouseMove(const graphikos::painter::GLPoint& mouse, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix, graphikos::painter::ShapeDetails shapeDetails);
    virtual bool _onMouseDown(const graphikos::painter::GLPoint& mouse, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix, graphikos::painter::ShapeDetails shapeDetails);
    virtual bool _onMouseHold(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLPoint& prevPoint, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix);
    virtual bool _onDrag(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLPoint& prevPoint, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix);
    virtual bool _onKeyDown(int keyCode, int modifier, bool repeat, std::string keyCharacter, const SkMatrix& matrix);
    virtual bool _onDoubleClickEnd(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix, graphikos::painter::ShapeDetails shapeDetails);
    virtual bool _onMouseUp(const graphikos::painter::GLPoint start, const graphikos::painter::GLPoint end, int modifier, graphikos::painter::ShapeDetails shapeDetails, const graphikos::painter::GLRect& frame, const SkMatrix& matrix);
    virtual bool _onRightClickDown(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix, graphikos::painter::ShapeDetails shapeDetails);
    virtual bool _onRightClickUp(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix);
    void onLoop(SkMatrix parentMatrix) override;

    void setDrawObject(const DrawData& drawData);
    void setCrop();
    void cropImage();
    void resetCrop();

    virtual void updateContinuousEditingData(std::string value, com::zoho::shapes::ShapeNodeType validShape, ZEditorUtil::ContinuousEditType type, bool isMouseDown = true, bool isGRPFillEnabled = false);

    void dataUpdated(bool needRender = false, std::vector<std::string> shapeIds = {}) override; // call it after composing..
    void updateSelectedData(std::vector<std::string> shapeIds);
    virtual void updateSelectedShapeData(std::vector<std::string>& selectedShapes, const std::vector<std::string>& containerModifiedShapes = {});
    void refreshSelectedShapes();
    bool selectInnerShapeAndGoToTextEdit(SelectedShape shape); // selecting sticky note inner shape
    void exitTextEdit();
    graphikos::painter::GLPoint getRotateOffset();

    std::map<std::string, graphikos::painter::GLPoint> getBBoxPoints();
    std::vector<graphikos::painter::GLPoint> getModifierPoints();
    std::vector<graphikos::painter::GLPoint> getSelectedShapesCenter();

    // editing related functions.
    void refreshEditingLayer();
    virtual void createEditingLayers();
    com::zoho::shapes::Transform& getEditingTransform();
    com::zoho::shapes::Transform getSelectedShapeRect();
    NLEditorProperties* getEditorProperties();
    ZEditorUtil::EditingData& getEventData();
    SkMatrix getCurrentEditMatrix();
    void setCurrentEditMatrix(SkMatrix matrix);
    void setAlignType(ZShapeAlignUtil::AlignTo align);
    void resetEventData();
    void updateEditingTransform(std::vector<SelectedShape>& selectedShape);
    std::shared_ptr<com::zoho::shapes::Transform> updateModifiedTransform(const SelectedShape* selectedShape);

    void translate(graphikos::painter::GLPoint start, graphikos::painter::GLPoint end);
    void scale(graphikos::painter::GLPoint start, graphikos::painter::GLPoint end, ZEditorUtil::BoxCorner corner, graphikos::painter::GLRect frame, int modifier, float rotate = 0);
    void rotate(graphikos::painter::GLPoint start, graphikos::painter::GLPoint end, ZEditorUtil::BoxCorner corner);
    void align(ZShapeAlignUtil::AlignType alignType);
    void distribute(ZShapeAlignUtil::AlignType alignType);

    void setMatrixAndRerenderer(SkMatrix matrix = SkMatrix(), CustomRTreeGenerationForSelectedLayer customRtreeGen = nullptr, bool isClickEnd = false);
    std::vector<ZConnectorData> getDisconnectedConnectors();
    void renderSelectedLayer(SkMatrix matrix, CustomRTreeGenerationForSelectedLayer customRtreeGen);
    bool setConnectedShapeDetails(const SelectedShape* selected, std::string shapeId);
    void constructContainerTintLayer(graphikos::painter::GLPath& path);
    void reRenderSelectedShape(std::shared_ptr<NLRenderTree> nlrenderTree, std::vector<const SelectedShape*>& selectedShapes, SkMatrix _matrix, const std::vector<std::pair<std::string, bool>>& idsToDraw = {});
    graphikos::painter::GLRect renderContainerAloneUsingMatrix(std::string& shapeId, std::shared_ptr<NLRenderTree> nlrenderTree, DrawingContext& dc, const graphikos::painter::ShapeObjectsDetails& originalShapeDetail, com::zoho::shapes::ShapeObject* changedShapeObject = nullptr);
    virtual graphikos::painter::GLRect reRenderSelectedShapeWithMatrix(std::shared_ptr<NLRenderTree> nlrenderTree, const SelectedShape* selectedShape, graphikos::painter::Matrices matrices = graphikos::painter::Matrices(), bool createBulletForEmptyLines = false, com::zoho::shapes::Transform* gTrans = nullptr, const std::vector<std::pair<std::string, bool>>& idsToDraw = {}, com::zoho::shapes::ShapeObject* changedShapeObject = nullptr);
    void renderDocShapeObjects(com::zoho::shapes::ShapeObject* shapeObject, const DrawingContext& dc, SkMatrix matrix);
    void updateShapeObjectData(const SelectedShape* selectedShape, com::zoho::shapes::ShapeObject* selectedShapeObject, graphikos::painter::Matrices& matrices); // case - continuous editing from ui
    void updateEditingData(SelectedShape shape, com::zoho::shapes::ShapeObject* clonedShapeObject, bool isUpdateData = false, std::vector<ModifyData>* dataToBeModified = nullptr);
    void updateContainerInnerShapesDependency(SelectedShape& shapeObject, com::zoho::shapes::Transform* updatedTransform, ZEditorUtil::EditingData& eventData, std::vector<ModifyData>& dataToBeModified);
    void updateData(std::vector<SelectedShape>& selectedShapes, graphikos::painter::GLPoint start, graphikos::painter::GLPoint end, bool isExternalShape = false, bool shapesDuplicated = false);
    void updateData(std::vector<SelectedShape>& selectedShapes, ZEditorUtil::EditingData eventData, graphikos::painter::GLPoint mousePoint = graphikos::painter::GLPoint(), bool isExternalShape = false, bool shapesDuplicated = false, bool fromUI = false);
    void updateRowAndColumnDim(std::string& tableId, com::zoho::shapes::Table* table, graphikos::painter::GLPoint dist, graphikos::painter::GLPath& path, com::zoho::shapes::Table* updatedTable, com::zoho::shapes::Transform* tableTransform);
    void setTempRenderMatrix(SkMatrix matrix); // temporary purpose. should be removed

    bool isDataThrown(); // for text edit delay case
    void dataReceived(); // for text edit delay - reset
    void setIsSnappingEnabled(bool isSnappingEnabled);
    bool getIsSnappingEnabled();

    void reRenderSelection(com::zoho::shapes::ShapeObject* orgShapeObject, graphikos::painter::ShapeDetails updatedShapeDetails, com::zoho::shapes::TextBody* editedTextBody);
    void detachTableEditingLayer();

    virtual void addContainerNameOverlay(std::string containerId) {};
    virtual void clearContainerNameOverlay(std::string containerId) {};

    void onShapeEditStarted(std::vector<std::string> shapeIds);

    ~EditorController();
};

#endif
