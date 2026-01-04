#ifndef __NL_CONNECTORCONTROLLER_H
#define __NL_CONNECTORCONTROLLER_H

#include <app/controllers/NLEventController.hpp>
#include <app/controllers/NLEditorProperties.hpp>
#include <nucleus/core/layers/NLInstanceLayer.hpp>
#include <app/util/ZEditorUtil.hpp>
#include <app/ConnectorTextController.hpp>
#include <app/util/ConnectorUtil.hpp>
#include <chrono>

namespace com {
namespace zoho {
namespace shapes {
class NonVisualConnectorProps;
class Connection_ConnectionBehaviour;
class ShapeGeometry_ConnectorPoint;
class NonVisualConnectorDrawingProps_Connection;
}
}
}

class NLDataController;
class ConnectorTextController;
struct ShapeData;
struct DrawData;

#define CONNECTORCORNERRADIUS 36
struct ZModifiedConnectedShape {
    std::string shapeId = "";
    //Dont use this shapeObject unnecessarily it will be used only for the case where the shape data will not available from the cache.
    std::shared_ptr<com::zoho::shapes::ShapeObject> clonedShapeObject = nullptr;
    std::shared_ptr<com::zoho::shapes::Transform> changedTransform = nullptr;
    std::shared_ptr<com::zoho::shapes::TextBody> changedTextBody = nullptr;
    std::shared_ptr<com::zoho::shapes::Properties> changedProps = nullptr;
    //this is for table row col height
    std::unordered_map<std::string, float> tableMeasurements = {};
    //this is for handling reroute of connectors
    bool reRouted = false;
};

struct ZNearestConnectorPointsObj {
    int nearestConnectorIndex = -1;
    std::string nearestSegmentConnectorId = "";
    ConnectorPoint customConnectorPoint = ConnectorPoint();
};

struct ZConnectorCDP {
    int index;
    std::string id;
    std::string paraId;
    graphikos::painter::GLPoint point;
};
struct ConnectorPointIcons {
    std::shared_ptr<NLInstanceLayer> wOConnection = nullptr;
    std::shared_ptr<NLInstanceLayer> wConnection = nullptr;
    std::shared_ptr<NLInstanceLayer> pConnection = nullptr; //previous connection
    std::shared_ptr<NLInstanceLayer> paraConnection = nullptr;
};

class ConnectorController : public NLEventController {
public:
    void _editingDependency(std::vector<ZConnectorData>& connectors, bool updateShape = true);
    std::map<std::string, ZModifiedConnectedShape> modifiedConnectedShapes;
    void connectToNearestIndex(com::zoho::shapes::ShapeObject* newshapeData, std::string oldShapeId, com::zoho::shapes::ShapeObject* connectorShapeObject);
    void changeShape(com::zoho::shapes::ShapeObject* oldShapeObject, com::zoho::shapes::ShapeObject* newShapeObject);

private:
    std::shared_ptr<ConnectorTextController> textBoxController;
    std::shared_ptr<NLLayer> bboxLayer;
    NLEditorProperties* editorProperties = nullptr;
    NLDataController* data = nullptr;
    // cloned connector data will be store in the editedConnectors variable while "connector & connected shape editing"..Have to be cleared once the connector data
    std::vector<std::string> connectorDependencyIds;
    ZEditorUtil::EditingData* eventData = nullptr;
    graphikos::painter::GLPath hoveredShapePath;
    SkMatrix scaleMatrix;
    graphikos::painter::ShapeDetails drawConnectorDetails;
    std::string currentConnector = "CURVEDELBOW";
    ZEditorUtil::EditingData drawEventData;
    //config
    bool isShapeMove = false;
    bool isConnectorDraw = false;
    bool supportCustomConnectorPoint = true;
    //connector points mode
    bool connectorPointsMode = false;
    //connector points mode end
    bool gsConnector = true;                 // TODO - CONFIG
    bool rerouteConnectorOnShapeMove = true; // TODO - CONFIG
    bool connectToNearest = true;

    // move to resize -  end
    ZNearestConnectorPointsObj nearestConnectorPointObj = ZNearestConnectorPointsObj();
    bool shapeDrawn = false;
    bool dragStart = false;
    int currentHoveredCDP = -1;
    std::shared_ptr<ZConnectorChangeObj> createShapeChangeObj = nullptr;

    //connector timer config
    std::chrono::system_clock::time_point cursorTimeInShape{};
    bool forceDisableConnectorSnap = false;

    std::string paraCdpId = "";
    std::string previousConnectorPointId = "";
    //Connector points on layer
    void createConnectorPoints();
    void addConnectorPoints();

    //core editing util methods
    ConnectorPoint getConnectorPointByConnectorId(std::string shapeId, std::string connectorPointId);
    ConnectorPoint getConnectorPointWithAngle(const com::zoho::shapes::NonVisualConnectorDrawingProps_Connection* nvodprops);
    std::vector<ConnectorPoint> getConnectorPointPositions(std::string shapeId, std::string segmentConnectorId, bool customPoint = false);
    std::map<std::string, std::vector<ConnectorPoint>> getAllConnectorPointPositions(std::string shapeId);
    std::map<std::string, std::vector<ConnectorPoint>> getAllConnectorPointPositions(com::zoho::shapes::ShapeObject* data, com::zoho::shapes::Transform mergedTransform, com::zoho::shapes::TextBody* mergedTextBody = nullptr, com::zoho::shapes::Properties* shapeProps = nullptr);
    std::map<std::string, std::vector<ConnectorPoint>> getAllParaConnectorPoints(std::string shapeId, com::zoho::shapes::TextBody* tb, bool isTextBox, com::zoho::shapes::Transform mergedTransform, graphikos::painter::GLRect cTextBox, com::zoho::shapes::Transform parentTransform);
    std::map<std::string, std::vector<ConnectorPoint>> getAllTableConnectorPoints(com::zoho::shapes::ShapeObject* shapeObject, com::zoho::shapes::Transform& mergedTransform);
    int getClosestConnectorPointIndex(std::string& shapeId, ZConnectorObj& connectorObj, com::zoho::shapes::Transform& mergedTransform, std::string& startOrEnd, std::vector<ConnectorPoint>& connectorPoints, com::zoho::shapes::NonVisualConnectorDrawingProps* originalProps, graphikos::painter::GLPoint& anchor, graphikos::painter::GLPoint& point);

    //editing util methods
    graphikos::painter::GLRect getTableRect(std::string& colOrRowId, int& index, com::zoho::shapes::ShapeObject* shapeObject, com::zoho::shapes::Transform& mergedTransform);
    std::shared_ptr<NLInstanceLayer> getConnectorPointInstance(bool connected = false, bool previous = false, bool para = false);
    void addModifiedShape(std::string shapeId, bool cloneShapeObject = false);
    void setRerouteConnector(std::string shapeId, bool reRouted);
    com::zoho::shapes::TextBody* getModifiedShapeTextBody(std::string shapeId);
    com::zoho::shapes::ShapeObject* getModifiedShapeObject(std::string shapeId);
    float getModifiedTableMeasurement(std::string shapeId, std::string rowOrColId);
    float getParaHeightFromId(std::string shapeId, std::string paraId);

    //for dynamic_connector start
    std::shared_ptr<com::zoho::shapes::ShapeGeometry> getConnectorPointsModifiedData(std::string shapeId, com::zoho::shapes::ShapeGeometry_ConnectorPoint* connectorPoint);
    void getConnectorPointsModifiedData(com::zoho::shapes::ShapeGeometry* geom, com::zoho::shapes::ShapeGeometry_ConnectorPoint* connectorPoint);
    void addConnectorDependencyShapeData(com::zoho::shapes::ShapeGeometry* shapeGeom, com::zoho::shapes::ShapeObject* shapeObject, std::vector<ShapeData>& dataTobeModified);
    void addOverlayPath(ZConnectorObj& obj, graphikos::painter::ShapeDetails shapeDetails);
    void clearOverlayPath();
    //for dynamic_connector_end

    //editing methods
    void change(ZConnectorChangeObj& changeObj, com::zoho::shapes::ShapeObject& connectorShape, std::string strtOrEnd, BoxCorner bbox, com::zoho::shapes::Transform* connectorTransform, ZConnectorObj currentPoint, com::zoho::shapes::NonVisualConnectorDrawingProps* actualProps, graphikos::painter::GLPoint anchor);
    void smartReroutePath(com::zoho::shapes::ShapeObject& connectorShape);
    void _shortestPath(com::zoho::shapes::ShapeObject& connectorShape, std::vector<ShapeData>* dependencyShapeData, ZConnectorRerouteObj& startRerouteObj, ZConnectorRerouteObj& endRerouteObj);
    void _shortestPath(com::zoho::shapes::ShapeObject& connectorShape, std::vector<ShapeData>* dependencyShapeData, int startIndex = -1, int endIndex = -1);
    std::map<std::string, ZConnectorProcessData> getConnectorData(ZConnectorChangeObj& changeObj, std::string startOrEnd, ZConnectorObj& currentPoint, com::zoho::shapes::NonVisualConnectorDrawingProps* nvODProps, graphikos::painter::GLPoint anchor, bool isInnerShape);
    void route(com::zoho::shapes::ShapeObject& data, ZConnectorRerouteObj& startRerouteObj, ZConnectorRerouteObj& endRerouteObj, CONNECTOR_TYPE curvedOrElbow, std::vector<ShapeData>* dependencyShapeData);
    void coordinates(ZConnectorObj& obj, std::string strtOrEnd, graphikos::painter::GLPoint start, graphikos::painter::GLPoint end);
    graphikos::painter::GLRect renderSelectedConnector(SkCanvas* canvas);
    void renderModifiedConnectors(EditingLayer& layer, std::string connectorId);
    void resetCursorInShapeTimer();
    void setCursorInShapeTimer(std::chrono::system_clock::time_point time);
    std::chrono::system_clock::time_point getCursorInShapeTimer();

public:
    ConnectorController(NLDataController* dataController, ZSelectionHandler* selectionHandler, std::shared_ptr<NLLayer> bboxLayer, ControllerProperties* properties, NLEditorProperties* editorProperties);
    ConnectorPointIcons* connectorIcons = nullptr;
    std::shared_ptr<NLShapeLayer> connectionStrokeOverlay = nullptr;
    std::shared_ptr<NLShapeLayer> connectedShapeOverlayLayer = nullptr;
    std::vector<std::shared_ptr<NLInstanceLayer>> cdpIcons = {};
    std::vector<std::shared_ptr<NLInstanceLayer>> paraCdpIcons = {};
    std::map<std::string, std::shared_ptr<com::zoho::shapes::ShapeObject>> editedConnectors; //need to verify this one
    std::shared_ptr<NLRenderLayer> drawNLRLayer;

    //events
    void onAttach() override;
    void onDetach() override;
    bool onMouseDown(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onMouseUp(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onMouseHold(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLPoint& prevPoint, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onDrag(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLPoint& prevPoint, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onMouseMove(const graphikos::painter::GLPoint& mouse, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onRightClickDown(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onRightClickUp(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onKeyDown(int keyCode, int modifier, bool repeat, std::string keyCharacter, const SkMatrix& matrix) override;
    void dataUpdated(bool needRender = false, std::vector<std::string> shapeIds = {}) override;

    //data provider and setter
    graphikos::painter::ShapeDetails getTargetShapeDetails(graphikos::painter::GLPoint mouse, graphikos::painter::GLRect frame, graphikos::painter::ShapeDetails& connectorShapeDetails, bool onModifier);
    void updateModifiedConnectorData();
    void updateModifiedShape(std::string shapeId, com::zoho::shapes::Transform* transform = nullptr, com::zoho::shapes::TextBody* textBody = nullptr, com::zoho::shapes::Properties* props = nullptr, com::zoho::shapes::ShapeObject* clonedShapeObject = nullptr);
    void updateModifiedShapeProps(std::string shapeId, com::zoho::shapes::Properties* shapeProps);
    void updateModifiedTableMeasurements(std::string& shapeId, std::string& colOrRowId, float changedValue);
    void setAllRowOrColIds(com::zoho::shapes::ShapeObject* shapeObject);
    com::zoho::shapes::Properties* getModifiedShapeProps(std::string shapeId);
    void updateAllTableMeasurements(com::zoho::shapes::ShapeObject* shapeObject);
    void updateAllTableMeasurements(com::zoho::shapes::ShapeObject* shapeObject, std::vector<float>& rowHeight, std::vector<float>& colWidths);
    void setEditedConnector(std::string connectorId, com::zoho::shapes::ShapeObject* connectorShape, com::zoho::shapes::Transform* mergedTransform = nullptr, com::zoho::shapes::NonVisualConnectorProps* nvoProps = nullptr);
    std::map<std::string, std::shared_ptr<com::zoho::shapes::ShapeObject>>* getEditedConnectors();
    std::map<std::string, ZModifiedConnectedShape> getModifiedShapes();
    void setParaConnectorId(std::string paraId);
    void deleteEditedConnectors();
    void setEditingData(ZEditorUtil::EditingData* eventData);
    ZEditorUtil::EditingData* getEditingData();
    com::zoho::shapes::ShapeObject* setDrawObject(const DrawData& drawObject, graphikos::painter::GLPoint position = graphikos::painter::GLPoint());
    void setCurrentConnector(std::string connectorType);
    std::shared_ptr<com::zoho::shapes::ShapeObject> getShapeByReferenceShape(DrawData appData, std::string anotherShapeId, std::string oppositeParaId = "", bool updateTextTransformCallBack = false);
    com::zoho::shapes::Transform* getModifiedShapeTransform(std::string shapeId);

    //editing methods
    void setShapeMove(bool isShapeMove);
    //erd shapes
    bool updateAssociatedCardinality(com::zoho::shapes::ShapeObject* connectorObject, const com::zoho::shapes::Stroke& stroke);
    bool updateAssociatedCardinality(std::string& startShapeId, std::string& endShapeId, com::zoho::shapes::ShapeObject* connectorObject, const com::zoho::shapes::Stroke& stroke);
    bool updateAssociatedCardinality(com::zoho::shapes::ShapeObject* startShapeObject, com::zoho::shapes::ShapeObject* endShapeObject, com::zoho::shapes::ShapeObject* connectorObject, const com::zoho::shapes::Stroke& stroke);

    void updateConnectorPointDetails(int index, com::zoho::shapes::ShapeGeometry_ConnectorPoint& connectorPoint, ZPathObj* pathObj = nullptr);
    void updateConnectorPointDetails(int index, com::zoho::shapes::ShapeGeometry_ConnectorPoint& connectorPoint, std::string connectorPointId, ZPathObj* pathObj = nullptr);

    void editingDependency(bool isShapeMove = false);
    void editingDependency(std::vector<ZConnectorData>& dependencyConnector, bool isShapeMove = false);

    void dragConnector(graphikos::painter::ShapeDetails& connectorShapeDetails, graphikos::painter::GLPoint start, graphikos::painter::GLPoint end, graphikos::painter::GLRect frame, int modifier, com::zoho::shapes::Transform& editingTransform, bool onMouseUp = false);
    float getOpenEndAngle(graphikos::painter::GLPoint& anchor, graphikos::painter::GLPoint& currentEnd, std::string startOrEnd, com::zoho::shapes::NonVisualConnectorDrawingProps* nvODProps, float startAngle);
    void changeType(CONNECTOR_TYPE curvedOrElbow, float cornerRadius = 0);
    void resetConnectionPoint(graphikos::painter::GLPoint point, std::string startOrEnd, com::zoho::shapes::NonVisualConnectorDrawingProps* originalProps);
    void fitInExistingConnectorPoint(ZConnectorObj& connectorObj, graphikos::painter::ShapeDetails& shape, com::zoho::shapes::Transform& mergedTransform, ConnectorPoint& customPoint, ConnectorPoint& connectedPoint, std::map<std::string, std::vector<ConnectorPoint>>& connectorPoints, bool onMouseUp, graphikos::painter::GLPoint& point);
    void pointInConnectorBBox(ZConnectorObj& connectorObj, graphikos::painter::ShapeDetails& connectorShapeDetail, graphikos::painter::ShapeDetails& targetShapeDetail, graphikos::painter::GLPoint mouse, graphikos::painter::GLRect frame, bool onMouseUp, graphikos::painter::GLPoint anchor, com::zoho::shapes::NonVisualConnectorDrawingProps* originalProps, std::string startOrEnd, bool isAltKeyPressed);
    ZConnectorObj findClosestConnectorPoint(graphikos::painter::GLPoint pos);
    std::vector<ShapeData> updateDependencyTextBodyData(com::zoho::shapes::ShapeObject* connectorShape);
    void updateDependencyTextBodyData(com::zoho::shapes::ShapeObject* oldShapeObject, com::zoho::shapes::ShapeObject* newShapeObject);
    std::vector<ShapeData> refreshConnectorPath(com::zoho::shapes::ShapeObject* shapeObject, com::zoho::shapes::NonVisualConnectorProps* connectionData);
    std::vector<ShapeData> refreshParaConnector(com::zoho::shapes::TextBody* textBody, bool needUpdateTransform = true, com::zoho::shapes::Transform* newTransform = nullptr);
    void removeRelatedConnectorPoint(ZEditorUtil::EditingData& eventData, com::zoho::shapes::NonVisualConnectorDrawingProps* originalProps, com::zoho::shapes::NonVisualConnectorDrawingProps* changedProps, std::vector<ShapeData>& editedShapeData);
    void updateConnectorDependencyShapeData(ZEditorUtil::EditingData& eventData, std::vector<ShapeData>& dependencyShapeData);
    bool isHoveredInParaCDP(const graphikos::painter::GLPoint& point, const SkMatrix& matrix);
    bool createCustomConnectorPoint(const graphikos::painter::GLPoint& end);
    static ZConnectorFlipObj changeFlipVal(float w, float h, BoxCorner bbox, com::zoho::shapes::Transform* transform, float startPointAngle);
    void reset();
    bool clearDrawMode();
    void exitConnectorPointsMode();

    //cdp methods
    ZConnectorCDP cdp;
    void setZConnectorCDP(std::string Id, std::string paraId, int Index, graphikos::painter::GLPoint point);
    ZConnectorCDP getZConnectorCDP();
    void renderPoint(com::zoho::shapes::Transform& totalBounds, com::zoho::shapes::Transform& mergedTransform, int index, std::string segmentConnectorId, ConnectorPoint& connectPoint, bool isCustomPoint, bool connected, bool previousPoint);
    void renderConnectorBBox(graphikos::painter::ShapeDetails shape);
    void showCDP(bool isParaCDP = false, com::zoho::shapes::Transform* transform = nullptr);
    void showAllCDP();
    void drawCDPIcon(int index, bool isParaCDP, ConnectorPoint handle, com::zoho::shapes::Transform transform, bool needHover = false);
    int getCDPIndex(const graphikos::painter::GLPoint& point, const SkMatrix& matrix, bool checkForParaCDP = false);
    void resetCDPInstances();
    void resetConnectorPoints();

    //editing utils
    SkMatrix getScaleMatrix();
    std::vector<graphikos::painter::GLPoint> getCDPpoints(bool considerOffset = false, float scale = 1.0f);
    std::shared_ptr<ConnectorTextController> getTextController();
    std::vector<graphikos::painter::GLPoint> getConnectingPoints();

    //config
    bool isSupportCustomConnectorPoint(com::zoho::shapes::ShapeObject* shapeObject);
    bool canSnapConnectorToClosestPoint(com::zoho::shapes::ShapeObject* shapeObject);
    bool isSupportCustomConnectorPoint();
    bool isSupportGroupShapeConnector();
    bool isSupportRerouteOnShapeMove();
    bool isConnectorPointsMode();
    bool canConnectorToNearestPoint();
    bool isDrawMode();
    void setDrawMode(bool isDrawMode);
    bool getShapeMove();
    void enableConnectorPointsMode();

    //shapeData formation methods
    void addModifiedConnectorDatas(std::vector<ModifyData>& modifiedConnectorData, bool isScaleEditType = false, bool updateTextBox = true, std::vector<ShapeData>* dependencyData = nullptr, ZEditorUtil::EditingData* editingData = nullptr);
    void updateConnectorModifiedData(com::zoho::shapes::ShapeObject* connector, std::vector<ModifyData>& modifiedConnectorData, bool updateTextBox, std::vector<ShapeData>* dependencyData, ZEditorUtil::EditingData* editingData, std::map<std::string, std::shared_ptr<com::zoho::shapes::ShapeObject>>& parentGS);
    void updateParentDependencyConnector(std::map<std::string, std::shared_ptr<com::zoho::shapes::ShapeObject>>& parentGS, std::vector<ModifyData>& modifiedConnectorData, bool updateTextBox, std::vector<ShapeData>* dependencyData, ZEditorUtil::EditingData* editingData);
    com::zoho::shapes::Transform getParentModifiedData(graphikos::painter::ShapeDetails& shapeDetails, com::zoho::shapes::Transform modifiedChildTransform, std::map<std::string, std::shared_ptr<com::zoho::shapes::ShapeObject>>& parentGS, std::vector<ShapeData>* dependencyData, ZEditorUtil::EditingData* editingData);
    void addModifiedShapeDatas(std::vector<ShapeData>& dependencyData);
    std::vector<ShapeData> refreshDependentConnector(com::zoho::shapes::Transform modifiedTransform, int selectedShapeIndex, std::vector<ModifyData>* modifiedData = nullptr);
    std::vector<ShapeData> addShapeAndConnect(bool isStartPoint, DrawData appData, bool updateTextTransformCallBack, com::zoho::shapes::ShapeObject* drawShapeData);
    std::vector<ShapeData> shortestPath(com::zoho::shapes::ShapeObject& connectorShape, com::zoho::shapes::ShapeObject* startData, com::zoho::shapes::ShapeObject* endData, int startIndex = -1, int endIndex = -1);

    ~ConnectorController();
};

#endif
