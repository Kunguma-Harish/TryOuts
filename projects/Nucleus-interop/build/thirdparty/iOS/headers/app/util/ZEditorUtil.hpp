#ifndef __NL_ZEDITORUTIL_H
#define __NL_ZEDITORUTIL_H
#include <iostream>
#include <map>
#include <skia-extension/GLRect.hpp>
#include <app/ZSelectionHandler.hpp>
#include <nucleus/recorder/NLPictureRecorder.hpp>
#include <nucleus/core/layers/NLRenderLayer.hpp>
#include <painter/util/mathutil.h>
#include <nucleus/core/NLCursor.hpp>
#include <nucleus/core/layers/NLShapeLayer.hpp>
#include <app/NLCacheBuilder.hpp>

namespace com {
namespace zoho {
namespace shapes {
class ShapeObject;
class NonVisualConnectorDrawingProps;
class ShapeGeometry;
class ShapeGeometry_ConnectorPoint;
class Transform;
class PictureProperties;
}
}
}

struct ModifyData {
    com::zoho::shapes::ShapeObject* shapeObject = nullptr;
    std::shared_ptr<com::zoho::shapes::ShapeObject> changedShapeObject = nullptr;
    std::string textBodyId;
    graphikos::painter::Type shapeType;
};

using CustomRenderFunction = std::function<void(DrawingContext&)>;
using CustomDrawFunction = std::function<void(DrawingContext&, com::zoho::shapes::ShapeObject*, const graphikos::painter::ShapeObjectsDetails&)>;

class ConnectorController;
class ZEditorUtil {
public:
    static bool isDevmode;

    enum EditType {
        NO_OP = 0,
        TRANSLATE = 1,
        SCALE = 2,
        ROTATE = 3
    };

    enum BoxCorner {
        DEFAULT = 0,
        LEFT_TOP = 1,
        RIGHT_TOP = 2,
        LEFT_BOTTOM = 3,
        RIGHT_BOTTOM = 4,
        LEFT = 5,
        TOP = 6,
        RIGHT = 7,
        BOTTOM = 8,
        ROTATE_HANDLE = 9,
        BORDER = 10
    };

    enum ContinuousEditType {
        NONE = 0,
        DIMENSION = 1,
        ROTANGLE = 2,
        FILL = 3,
        STROKE = 4,
        FLIP = 5,
        IMAGETRANSPARENCY = 6,
        POSITION = 7
    };

    struct ContinuousEditingData {
        std::shared_ptr<com::zoho::shapes::Properties> props = nullptr;
        std::shared_ptr<com::zoho::shapes::PictureProperties> picProps = nullptr;
        ContinuousEditType editType = ContinuousEditType::NONE;
        com::zoho::shapes::ShapeNodeType validShape;
        bool isGRPFillEnabled = false;
    };

    struct EditingData {
        bool flipX = false;
        bool flipY = false;
        float angle = 0;
        graphikos::painter::GLPoint dist;
        graphikos::painter::GLPoint anchorPoint; // starting point as this is needed in table row resize
        SkMatrix editingMatrix;
        std::shared_ptr<com::zoho::shapes::Transform> transform = nullptr; // if editing data is used please create new transform
        EditType currentEditType = EditType::NO_OP;
        BoxCorner currentCorner = BoxCorner::DEFAULT;
        SkMatrix currentEditMatrix;
        std::shared_ptr<com::zoho::shapes::ShapeGeometry> currentConnectorGeom = nullptr;
        std::shared_ptr<com::zoho::shapes::NonVisualConnectorDrawingProps> nvodprops = nullptr;

        std::map<std::string, std::shared_ptr<com::zoho::shapes::ShapeObject>>* editedConnectors = nullptr; // hold the data which generated from connector algorithm
        std::map<std::string, std::shared_ptr<com::zoho::shapes::ShapeGeometry>>* connectorDependencyShape = nullptr;
        std::shared_ptr<com::zoho::shapes::ShapeGeometry_ConnectorPoint> connectorStartConnection = nullptr;
        std::shared_ptr<com::zoho::shapes::ShapeGeometry_ConnectorPoint> connectorEndConnection = nullptr;

        std::shared_ptr<ZEditorUtil::ContinuousEditingData> continuousEditingData = nullptr; // contains the data which is required for continuous editing case from ui.
        EditingData();
    };

    struct MinMax {
        float width;
        float height;
        bool minWidthReached = false;
        bool minHeightReached = false;

        bool maxWidthReached = false;
        bool maxHeightReached = false;
        bool minOrMaxReached = false;
    };

    struct ZResizeBBox {
        std::string p1;
        std::string p2;
        std::string p3;
        std::string p4;
        std::string anchor;
        int signX;
        int signY;
        int isNeg;
        BoxCorner flipx;
        BoxCorner flipy;
        BoxCorner flipxy;
        std::string constant = "";
    };
    static std::map<ZEditorUtil::BoxCorner, ZResizeBBox> bbox;
    static std::map<ZEditorUtil::BoxCorner, std::map<std::string, graphikos::painter::GLPoint>> tangentialAnchorMap;

    static SkMatrix getScaleMatrix(graphikos::painter::GLRect rect, graphikos::painter::GLPoint dist, BoxCorner corner);
    static SkMatrix resizeMatrix(com::zoho::shapes::Transform& transform, graphikos::painter::GLPoint start, graphikos::painter::GLPoint end, BoxCorner corner, graphikos::painter::GLRect frame, EditingData& eventData, float angleDiff, bool aspectChange = false, const std::vector<SelectedShape>& selectedShapes = {});
    static graphikos::painter::GLPoint getAnchorPoint(com::zoho::shapes::Transform& transform, BoxCorner corner);
    static int isGivenCornerNegative(BoxCorner finalbbox, bool flipX, bool flipY);
    static graphikos::painter::GLPoint getTangentialAnchor(float angle, BoxCorner corner, graphikos::painter::GLPoint anchor, float diffWidth, float diffHeight);
    static std::string getQuadrant(float angle);
    static std::pair<std::shared_ptr<com::zoho::shapes::Transform>, graphikos::painter::Matrices> getChangedMatrixAndGtrans(com::zoho::shapes::Transform& editingTransform, EditingData& eventData, SelectedShape shape, bool isMultiSelect);

    static com::zoho::shapes::Transform getChangedMergedTransform(const SelectedShape* shape, com::zoho::shapes::Transform& editingTransform, EditingData& eventData, bool multiSelect = false);
    static bool modifyTransformData(com::zoho::shapes::Transform* transform, com::zoho::shapes::Transform mergeTransform, const SelectedShape* shape, std::vector<ModifyData>* dataModifiedArray, EditingData eventData, graphikos::painter::IProvider* provider = nullptr, bool includeParentALCalculation = false);
    static void modifyTransformRespectToText(com::zoho::shapes::ShapeObject* shapeObject, ZEditorUtil::EditType currentEditType, com::zoho::shapes::Transform& modifiedShapeTransform, graphikos::painter::IProvider* provider);
    static void modifyTransformForGivenHeight(com::zoho::shapes::Transform& modifiedShapeTransform, float height, BoxCorner align = RIGHT_BOTTOM);
    static com::zoho::shapes::Transform getUpdatedShapeTransform(SelectedShape& selectedShape, com::zoho::shapes::Transform* editingTransform, ZEditorUtil::EditingData& eventData, bool multiSelect, bool isAltKey = false, bool includeParentALCalculation = false);
    static com::zoho::shapes::Transform updateParentTransformsWithGivenChild(std::string childId, const SelectedShape* selectedShape, com::zoho::shapes::Transform updatedChildTransform, size_t parentIndex, size_t parentStartIndex, std::vector<ModifyData>* dataModifiedArray, EditingData* eventData = nullptr, ConnectorController* connectorController = nullptr, graphikos::painter::GLRect* offset = nullptr, bool considerShapeDimScale = false);
    static com::zoho::shapes::Transform updateParentTransforms(const SelectedShape* selectedShape, com::zoho::shapes::Transform updatedChildTransform, size_t parentIndex, std::vector<ModifyData>* dataModifiedArray, EditingData* eventData = nullptr, ConnectorController* connectorController = nullptr, graphikos::painter::GLRect* offset = nullptr, bool considerShapeDimScale = false);
    static std::pair<com::zoho::shapes::Transform, bool> getChangedOriginalTransform(com::zoho::shapes::Transform transform, const SelectedShape* selectedShape, bool includeParentALCalculation = false);

    static com::zoho::shapes::Transform getTransformFromEditingData(com::zoho::shapes::Transform* editingTransform, EditingData eventData, SkMatrix scaleMatrix, graphikos::painter::Matrices currentMatrices, com::zoho::shapes::Transform* gTrans);

    static void updateGroupShapeTransform(com::zoho::shapes::ShapeObject* groupShapeDetails, com::zoho::shapes::Transform* transform, float rx, float ry, std::map<std::string, com::zoho::shapes::Transform>& modifiedChildTransforms, bool considerInnerShapeDimScale);
    static void updateChData(com::zoho::shapes::Transform* transform, graphikos::painter::GLRect updatedRect, float cdx, float cdy, float grx, float gry);

    static ZEditorUtil::BoxCorner flipV(BoxCorner corner);
    static ZEditorUtil::BoxCorner flipH(BoxCorner corner);
    static ZEditorUtil::BoxCorner getBoxCornerByName(std::string bboxType);
    static Cursor getCursor(ZEditorUtil::BoxCorner corner, float angle = 0.0f);

    static bool isShapeTypeValidForEditing(com::zoho::shapes::ShapeObject* shapeObject);
    static bool selectable(com::zoho::shapes::Locks* lock);
    static bool editable(com::zoho::shapes::Locks* lock);
    static bool resizable(com::zoho::shapes::Locks* lock);
    static bool rotatable(com::zoho::shapes::Locks* lock);
    static bool movable(com::zoho::shapes::Locks* lock);
    static bool noShapePropsModifySansTextOp(com::zoho::shapes::Locks* lock);
    static bool noBbox(com::zoho::shapes::Locks* lock);
    static bool isShapeEditable(SelectedShape& shape, ZEditorUtil::EditType currentEditType, bool isMultiSelect = false);
    static bool isShapeEditable(const SelectedShape* shape, ZEditorUtil::EditType currentEditType, bool isMultiSelect = false);
    static bool isShapeNotEditable(SelectedShape& shape, ZEditorUtil::EditType currentEditType, graphikos::painter::IProvider* provider, bool isMultiSelect = false);       // including product based check for audio and embed
    static bool isShapeNotEditable(const SelectedShape* shape, ZEditorUtil::EditType currentEditType, graphikos::painter::IProvider* provider, bool isMultiSelect = false); // including product based check for audio and embed
    static bool canTranslateShape(com::zoho::shapes::ShapeObject* shapeObject);

    static bool noShapePropsModify(com::zoho::shapes::Locks* lock);
    static bool handleEscapeOnShape(ZSelectionHandler* selectionHandler);

    static bool isStickyNote(com::zoho::shapes::ShapeObject* groupShapeDetails);
    static std::string getEditableInnerShapeId(com::zoho::shapes::ShapeObject* groupShapeDetails);
    static std::vector<std::string> getEditableInnerShapeIds(com::zoho::shapes::ShapeObject* groupShapeDetails, std::vector<std::string>& shapeIds);
    static bool isInnerShapeSelectable(com::zoho::shapes::Locks* lock, bool canEditText = false);
    static bool isNavigationKey(int key);
    static graphikos::painter::ShapeDetails getSelectableParent(SelectedShape shape);
    static graphikos::painter::ShapeDetails getSelectableParent(graphikos::painter::ShapeDetails shape);
    static graphikos::painter::ShapeDetails getSelectableParent(std::vector<graphikos::painter::ShapeObjectsDetails> parentShapeDetails);
    static bool isModifier(int key);
    static void addToOnDataChange(std::string shapeId, graphikos::painter::GLRect totalBounds, std::shared_ptr<NLPictureRecorder> nlPicture, std::shared_ptr<NLRenderLayer> layer);
    static void addToOnDataChange(std::string shapeId, graphikos::painter::GLRect totalBounds, std::shared_ptr<NLPictureRecorder> nlPicture, std::shared_ptr<NLRenderTree> renderTree, std::shared_ptr<NLRenderLayer> layer = nullptr);
    static void addToOnDataChange(std::shared_ptr<NLRenderLayer> layer, std::shared_ptr<NLRenderTree> nlrenderTree);
    static void changePictureInTree(std::string shapeId, graphikos::painter::GLRect totalBounds, std::shared_ptr<NLPictureRecorder> nlPicture, std::shared_ptr<NLRenderTree> renderTree);
    static void appendRenderTreeToLayer(std::string shapeId, graphikos::painter::GLRect totalBounds, std::shared_ptr<NLPictureRecorder> nlPicture, std::shared_ptr<NLRenderTree> renderTreeToAppend, std::shared_ptr<NLRenderLayer> layer);
    static void drawDraggingBox(std::shared_ptr<NLShapeLayer> hoverShapeLayer, const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, const SkMatrix& matrix);

    static void updateNewPictureInLayer(CustomRenderFunction renderFunction, graphikos::painter::IProvider* provider, std::shared_ptr<NLRenderLayer> renderLayer);
    static bool isConnectorConnected(com::zoho::shapes::ShapeObject* shapeObject);
    static bool nonModifyableInnerShape(const SelectedShape& selectedShapesInfo);
    static bool nonModifyableInnerShape(graphikos::painter::ShapeDetails& shape);

    static std::shared_ptr<NLPictureRecorder> drawShapeObjectInAPicture(CustomDrawFunction& renderFunction, com::zoho::shapes::ShapeObject* shapeObject, DrawingContext* dc, const graphikos::painter::ShapeObjectsDetails& originalShapeDetail);
    static graphikos::painter::GLRect updatePictureToRTree(std::shared_ptr<NLRenderTree> renderTree, const SelectedShape* selectedShape, com::zoho::shapes::ShapeObject* clonedShapeObject, const std::vector<std::pair<std::string, bool>>& idsToDraw, DrawingContext& dc, bool drawOriginal = false, std::string textEditingShapeId = "");
    static int isConnectorDependency(std::vector<SelectedShape>& selectedShapes, com::zoho::shapes::ShapeObject* _shape, SkCanvas* canvas = nullptr);
    static MinMax calculateAspectChange(const SelectedShape* selectedShape, ZEditorUtil::EditingData eventData, graphikos::painter::GLRect& rectToBeModified);

    // Selection code
    static bool selectContainer(graphikos::painter::ShapeDetails& shapeDetails, ZSelectionHandler* selectionHandler, bool onModifier, NLDataController* data);
    static void selectShapeOnMouseDown(graphikos::painter::ShapeDetails& shpDetails, int modifier, ZSelectionHandler* selectionHandler, NLDataController* data);
    static void selectInnerShapeOnMouseUp(graphikos::painter::ShapeDetails& shapeDetails, int modifier, ZSelectionHandler* selectionHandler, NLDataController* data, const graphikos::painter::GLPoint& end, SelectionContext& sc, bool isParentAlreadySelected);

    static MinMax changeTransformForMinMax(graphikos::painter::GLRect& rectToBeModified, com::zoho::shapes::Transform& mergedTransform);
    static MinMax changeTransformForMinMax(com::zoho::shapes::Transform& parentTransform, com::zoho::shapes::Transform& childTransform);
    static MinMax minMaxreached(com::zoho::shapes::Transform& transform);
    static float getCurrentRowHeight(NLCacheBuilder* cacheBuilder, const SelectedShape* selectedShape, graphikos::painter::IProvider* provider, float currentTextHeight, float rowIndex, int cellIndex);
    static float getCurrentRowHeight(NLCacheBuilder* cacheBuilder, com::zoho::shapes::ShapeObject* shapeObject, graphikos::painter::IProvider* provider, float currentTextHeight, int rowIndex, int cellIndex);
    static bool checkIfInnerShapeIsToBeSelected(const google::protobuf::RepeatedPtrField<com::zoho::shapes::ShapeObject>& innerShapes, std::string selectedShapeId, NLDataController* dataController);
    static bool checkIfParentFrameIsToBeSelected(std::vector<graphikos::painter::ShapeObjectsDetails>& parentShapeDetails, std::string currentShapeId);
    static bool isShapeUnderSelectableParent(graphikos::painter::ShapeDetails shapeDetails);
    static bool isShapeUnderSelectableParent(SelectedShape shape);
    static bool isShapeUnderSelectableParent(std::vector<graphikos::painter::ShapeObjectsDetails> parentShapeDetails);
    static std::string getEditableComponentInnerShapeId(NLDataController* dataController, com::zoho::shapes::ShapeObject* groupShapeDetails);
    static bool canApplyContainerTransform(com::zoho::shapes::Transform* transform);
    static graphikos::painter::Matrices getContainerMatrices(com::zoho::shapes::Transform* transform, graphikos::painter::GLRect parentRect, graphikos::painter::GLRect modifiedParentRect = graphikos::painter::GLRect());
};
#endif
