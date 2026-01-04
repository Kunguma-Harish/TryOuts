#ifndef __NL_CONNECTORUTIL_H
#define __NL_CONNECTORUTIL_H

#include <painter/ConnectorPainter.hpp>
#include <painter/util/PathGenerator.hpp>
#include <painter/util/PathUtil.hpp>
#include <app/NLDataController.hpp>
#include <app/ZBBox.hpp>
namespace com {
namespace zoho {
namespace shapes {
class NonVisualConnectorDrawingProps_Connection;
class ShapeGeometry_ConnectorPoint;
}
}
}
namespace google {
namespace protobuf {
template <typename T>
class RepeatedPtrField;
}
}

using BoxCorner = ZEditorUtil::BoxCorner;

#define ERROR_CORRECTION 1
#define MIN_DIM 0.001
#define ERROR_DISTANCE 25
#define CK 40
#define MAX_CONNECTOR_HOLD_TIME 2000

struct ZPathObj {
    float distance, angle;
    int pathListIndex;
    int edgeIndex;
};
struct ConnectorPoint {
    bool isPara = false;
    bool isRow = false;
    bool isCol = false;
    float x;
    float y;
    float angle;
    std::string shapeId = "";
    std::string connectorPointId = "";
    bool notTemporary = false;
    ConnectorPoint();
    ConnectorPoint(std::string shapeId, float x, float y, float angle, bool isPara = false, std::string connectorPointId = "", bool notTemporary = false, bool isRow = false, bool isCol = false);
};

struct ZConnectorRerouteObj {
    std::string shapeId;
    int index = -1;
    std::vector<ConnectorPoint> cpoints;
    ConnectorPoint cpoint;
};

struct ZConnectorObj {
    std::map<std::string, float> coord = {};
    float angle = 0;
    std::string boxShapeId = "";
    ConnectorPoint cpoints = ConnectorPoint();
    std::shared_ptr<com::zoho::shapes::NonVisualConnectorDrawingProps> connectorData = nullptr;
    std::string shapeId = "";
    std::string segmentConnectorId = "";
    bool isDynamic = false;
    std::string connectorPointId = "";
    int index = -1;
    std::shared_ptr<ZPathObj> pathObj = nullptr;
    std::shared_ptr<com::zoho::shapes::ShapeGeometry_ConnectorPoint> connectorPoint = nullptr;
    graphikos::painter::GLPath bboxPath = graphikos::painter::GLPath();
};

struct ZConnectorType {
    Show::GeometryField_PresetShapeGeometry connector;
    bool objectAvoidance = false;
};
struct ZConnectorFlipObj {
    int isNeg;
    bool fliph;
    bool flipv;
};

struct ZConnectorProcessData {
    graphikos::painter::GLPoint point = graphikos::painter::GLPoint();
    float angle = -1;
    std::string boxShapeId = "";
    ConnectorPoint cpoints = ConnectorPoint();
    float xOffset = 0;
    float yOffset = 0;
    std::map<std::string, float> offset = {};
    graphikos::painter::GLPoint cPoint = graphikos::painter::GLPoint(); // bx/by
    graphikos::painter::GLPoint conv = graphikos::painter::GLPoint();   // convx/convy
    graphikos::painter::GLRect rect = graphikos::painter::GLRect();
    ConnectorPoint convertedPoint = ConnectorPoint();
    bool condition = false;
};
struct ZConnectorChangeObj {
    std::shared_ptr<com::zoho::shapes::Transform> transform = nullptr;
    std::shared_ptr<com::zoho::shapes::ShapeGeometry> geom = nullptr;
    std::shared_ptr<com::zoho::shapes::NonVisualConnectorDrawingProps> nvodprops = nullptr;
    graphikos::painter::GLPoint anchor;
    //this is to store starting geom of start shape
    std::shared_ptr<com::zoho::shapes::ShapeGeometry_ConnectorPoint> initialStartConnectorPoint = nullptr;
    std::shared_ptr<com::zoho::shapes::ShapeGeometry_ConnectorPoint> startShapeConnectorPoint = nullptr;
    std::shared_ptr<com::zoho::shapes::ShapeGeometry_ConnectorPoint> endShapeConnectorPoint = nullptr;
    int isNeg = -1;
    bool autoSnapped = false;
};
enum CONNECTOR_TYPE {
    ELBOW = 0,
    CURVE = 1,
    LINE = 2
};
class ConnectorUtil {
public:
    //connector constants
    static std::map<float, std::map<std::string, bool>> defaultPos;
    static std::map<int, int> oppositeAngle;

    static std::map<int, int> rerouteAngle;

    static std::map<std::string, std::string> otherEnd;

    //connector editing utils
    static std::vector<ConnectorPoint> getAllCustomPointsFromData(com::zoho::shapes::ShapeObject* data, com::zoho::shapes::Transform mergedTransform, std::vector<ConnectorPoint>& presetPoints);
    static ConnectorPoint getCustomConnectorPointOnPath(ZConnectorObj& connectorObj, graphikos::painter::GLPoint currentPoint, graphikos::painter::GLPoint anchorPoint, graphikos::painter::ShapeDetails& targetShapeDetail, com::zoho::shapes::Transform mergedTransform);
    static std::vector<graphikos::painter::GLPoint> getConnectorBBoxPosition(std::vector<SelectedShape>& shapes);
    static std::vector<ZConnectorData> getConnector(std::string selectedShapeId, NLDataController* data);
    static graphikos::painter::ShapeDetails getTextBodyShapeDetails(com::zoho::shapes::ShapeObject* shapeObject, com::zoho::shapes::TextBody* textBody, graphikos::painter::Matrices matrices, com::zoho::shapes::Transform* gTrans, graphikos::painter::IProvider* provider);
    static graphikos::painter::ShapeDetails getTextBodyShapeDetails(com::zoho::shapes::ShapeObject* shapeObject, com::zoho::shapes::TextBody* textBody, graphikos::painter::IProvider* provider);
    static std::string getSegmentConnectorId(com::zoho::shapes::NonVisualConnectorDrawingProps_Connection* connection);

    static com::zoho::shapes::ShapeGeometry_ConnectorPoint* getConnectorPointDetailsByConnectorId(std::string connectorId, google::protobuf::RepeatedPtrField<com::zoho::shapes::ShapeGeometry_ConnectorPoint>* cp);
    static int getConnectorPointDetailsByConnectorId(std::string connectorId, google::protobuf::RepeatedPtrField<com::zoho::shapes::ShapeGeometry_ConnectorPoint> cp);
    static ConnectorPoint getConnectorPointFromConnectorPointDetails(std::string shapeId, com::zoho::shapes::Properties* props, com::zoho::shapes::Transform* transform, com::zoho::shapes::ShapeGeometry_ConnectorPoint* connectorPoint, std::vector<ConnectorPoint>& presetPoints);
    static ConnectorPoint getConnectorPointByConnectorId(com::zoho::shapes::ShapeObject* shapeObject, std::string connectorPointId, std::vector<ConnectorPoint>& presetPoints);
    static ConnectorPoint getConnectorPointByConnectorId(std::string shapeId, com::zoho::shapes::Properties* props, com::zoho::shapes::Transform* transform, com::zoho::shapes::ShapeGeometry_ConnectorPoint* connectorPoint, std::vector<ConnectorPoint>& presetPoints);
    static std::string getConnectorPointId(std::string id, bool isCustomPoint);
    static float getConnectorAngle(float conAngle, float boxAngle);
    static std::map<std::string, BoxCorner> getBBox(com::zoho::shapes::Transform* transform);
    static std::string terminal(BoxCorner bbox, com::zoho::shapes::Transform* transform);
    static CONNECTOR_TYPE curvedOrElbow(Show::GeometryField_PresetShapeGeometry type);
    static int getQuadrant(com::zoho::shapes::Transform* startTransform, com::zoho::shapes::Transform* endTransform, ConnectorPoint endCpoint);
    static int getQuadrant(float diagonalDiff, float rotAngle, float angleFromCenterToEndPoint);
    static bool canReroute(com::zoho::shapes::Transform* shapeTransform, ConnectorPoint startCpoint, com::zoho::shapes::Transform* endTransform, ConnectorPoint endCpoint, com::zoho::shapes::NonVisualConnectorDrawingProps_Connection* connection);
    static float findAngleForConnectorPoints(ConnectorPoint startCpoint, com::zoho::shapes::Transform* startTransform, ConnectorPoint endCpoint, com::zoho::shapes::Transform* endTransform, std::string startOrEnd);
    static ConnectorPoint rotatedValue(ConnectorPoint cpoint, com::zoho::shapes::Transform* transform);
    static bool has_fl(com::zoho::shapes::NonVisualConnectorDrawingProps* nvODProps, std::string startOrEnd, ZConnectorObj& currentPoint);
    static bool has_startOrEnd(com::zoho::shapes::NonVisualConnectorDrawingProps* nvODProps, std::string startOrEnd);
    static void rotatedPoint(ZConnectorProcessData& data, com::zoho::shapes::Transform* modifiedTransform);
    static graphikos::painter::GLRect convertTo0deg(ZConnectorProcessData pt, com::zoho::shapes::Transform* shapeTransform);
    static std::map<std::string, bool> getFlipVal(bool signX, bool signY, float startPointAngle);
    static bool XOR(bool a, bool b);
    static void update(ZConnectorProcessData& data, com::zoho::shapes::Transform* shapeTransform);
    static graphikos::painter::GLRect changeDimension(float startPointAngle, float w, float h, bool isLine);
    static ZConnectorType connectorType(ZConnectorProcessData& start, com::zoho::shapes::Transform* startModifiedTransform, ZConnectorProcessData& end, com::zoho::shapes::Transform* endModifiedTransform, float angleDiff, CONNECTOR_TYPE curvedOrElbow, bool fl);
    static bool lineMeet(ZConnectorProcessData point, com::zoho::shapes::Transform* pointTransform, ZConnectorProcessData otherpoint, com::zoho::shapes::Transform* otherPointTransform);
    static bool objectAvoidance3To5(ZConnectorProcessData start, ZConnectorProcessData end, float angleDiff);
    static ZConnectorProcessData convert4rot(ZConnectorProcessData pt, ZConnectorProcessData point, com::zoho::shapes::Transform* shapeTransform);
    static void updateConnectorTransform(com::zoho::shapes::Transform* transform);
    static void getModifiers(ZConnectorChangeObj& changeObj, Show::GeometryField_PresetShapeGeometry conType, ZConnectorProcessData start, ZConnectorProcessData end, bool objectAvoidance);
    static void threeWayModifier(ZConnectorChangeObj& changeObj, ZConnectorProcessData& start, ZConnectorProcessData& end);
    static void fourWayModifier(ZConnectorChangeObj& changeObj, ZConnectorProcessData& start, ZConnectorProcessData& end);
    static void fiveWayModifier(ZConnectorChangeObj& changeObj, ZConnectorProcessData& start, ZConnectorProcessData& end, bool objectAvoidance);
    static void route(com::zoho::shapes::ShapeObject& data, ZConnectorRerouteObj& startRerouteObj, com::zoho::shapes::Transform* startTransform, ZConnectorRerouteObj& endRerouteObj, com::zoho::shapes::Transform* endTransform, CONNECTOR_TYPE curvedOrElbow);
    static float internalDistance(ZConnectorProcessData data);
    static float shortestdistance(ZConnectorProcessData start, ZConnectorProcessData end, bool flipH, bool _bool);
    static int getOrientation(SelectedShape& selectedShape);
    static void updateShapePositionByCIndex(graphikos::painter::GLPoint endPos, com::zoho::shapes::ShapeObject* drawShapeData, graphikos::painter::GLPoint xyPos);
    static int getClosetConnectorIndex(SelectedShape& selectedShape, com::zoho::shapes::ShapeObject* drawShapeData, graphikos::painter::GLPoint& xyPos);
    static int findNearestCpIndex(ConnectorPoint oldCpPoints, std::vector<ConnectorPoint> newCpPoints);

    static std::vector<ConnectorPoint> getHandles(com::zoho::shapes::Transform* transform);
    static std::vector<ConnectorPoint> getParaHandles(std::string shapeId, std::string paraCdpId, com::zoho::shapes::Transform& transform, std::vector<ConnectorPoint>& presetPoints);
    static bool canCreateCDP(com::zoho::shapes::ShapeObject* shapeObject);
    static graphikos::painter::GLPoint getHandlePoints(int index, bool isParaConnector = false);
    static bool checkIfAllRowOrColIdsPresent(com::zoho::shapes::ShapeObject* shapeObject);
    static int findClosetConnectorIndex(graphikos::painter::GLPoint point, std::vector<ConnectorPoint> connectorPoints, com::zoho::shapes::Transform mergedTransform, float angle = -1);

    //connector text
    static com::zoho::shapes::PointOnPath getPointOnPath(graphikos::painter::GLPoint point, com::zoho::shapes::Transform mergedTransform, com::zoho::shapes::ShapeObject* shapeObject, graphikos::painter::GLPoint* intersectPoint = nullptr, float* angle = nullptr, bool getAngleFromPath = false);
    static bool updateIntersectedIndeces(com::zoho::shapes::ShapeObject* shapeObject, std::vector<graphikos::painter::GLPath>& paths, graphikos::painter::GLPoint& point, graphikos::painter::GLPoint* intersectPoint, int& pathListIndex, int& edgeIndex, double& timeT);
    static void intersectPath(graphikos::painter::GLPath::Verb verb, graphikos::painter::GLPoint pts[], SkIntersections& intersections, SkDLine line, float conicWeight);
    static float getAngleOfConnector(std::vector<graphikos::painter::GLPath> paths, com::zoho::shapes::PointOnPath pointOnPath, graphikos::painter::GLPoint point, com::zoho::shapes::Transform transform, com::zoho::shapes::Properties& properties, bool getAngleFromPath = false);
    static float getConnectorAngle(float angle, graphikos::painter::GLPoint& currentPoint, graphikos::painter::GLPoint& anchorPoint, com::zoho::shapes::Transform& mergedTransform);
    static std::vector<SkDLine> getRectLines(graphikos::painter::GLPoint point, float maxLength);
    static float connectorSnapDistance(com::zoho::shapes::ShapeObject* shapeObject);
    static com::zoho::shapes::TextBody getTextBodyById(google::protobuf::RepeatedPtrField<com::zoho::shapes::TextBody>* textBodies, std::string textBodyId);

    static float getErrorCorrection();
    static float getErrorDistance();
    static float getMinDim();
    static float getCK();
    static float getMaxConnectorHoldTime();
};

#endif
