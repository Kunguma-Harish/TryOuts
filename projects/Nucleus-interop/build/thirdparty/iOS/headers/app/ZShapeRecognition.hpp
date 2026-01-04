#ifndef __NL_ZSHAPERECOGNITION_H
#define __NL_ZSHAPERECOGNITION_H

#include <cmath>
#include <vector>
#include <map>

#include <skia-extension/GLPoint.hpp>
#include <painter/util/mathutil.h>

namespace com {
namespace zoho {
namespace common {
class Position;
class Dimension;
}
}
}

namespace google {
namespace protobuf {
template <typename T>
class RepeatedPtrField;
template <typename T>
class RepeatedField;
}
}

struct ZShapeRecognitionData;
struct ZPromisingReferData;
struct ZShapeLine;

class ZShapeRecognition {
private:
    float errorPercent = 0.15;

public:
    ZShapeRecognition() {}
    ~ZShapeRecognition() {}
    ZShapeRecognitionData recognize(std::vector<graphikos::painter::GLPoint> originalPathArray, com::zoho::common::Position* position, com::zoho::common::Dimension* dimension);
    std::vector<graphikos::painter::GLPoint> getSparsePathArray(std::vector<graphikos::painter::GLPoint> pathArray);
    float getErrorDistance(com::zoho::common::Dimension* dimension, float errorPercent, bool ignoreMininumError);
    bool joinPath(std::vector<graphikos::painter::GLPoint>& pathArray, float errorDistance);
    std::vector<graphikos::painter::GLPoint> getCorners(std::vector<graphikos::painter::GLPoint>& pathArray, com::zoho::common::Dimension* dimension, float errorDistance);
    ZPromisingReferData getPromisingReferencePoint(std::vector<graphikos::painter::GLPoint>& pathArray, int startIndex, com::zoho::common::Dimension* dimension);
    float getMaximumOccuredNumber(std::vector<float> array);
    bool isPointOnLine(float lineSlope, graphikos::painter::GLPoint linePoint, graphikos::painter::GLPoint actualPoint, float errorDistance);
    std::map<std::string, float> getActualAndErrorAngles(float lineSlope, graphikos::painter::GLPoint linePoint, graphikos::painter::GLPoint actualPoint, float errorDistance);
    graphikos::painter::GLPoint getPerpendicularPoint(float lineSlope, graphikos::painter::GLPoint linePoint, graphikos::painter::GLPoint actualPoint);
    graphikos::painter::GLPoint getExactCorner(std::vector<graphikos::painter::GLPoint>& pathArray, int startIndex, com::zoho::common::Dimension* dimension, ZShapeLine line);
    std::vector<graphikos::painter::GLPoint> rearrangePoints(std::vector<graphikos::painter::GLPoint> points);

    bool isosceles_triangle_validate(std::vector<graphikos::painter::GLPoint> pathArray, std::vector<graphikos::painter::GLPoint> corners, float errorDistance);
    com::zoho::common::Dimension* isosceles_triangle_dimension(std::vector<graphikos::painter::GLPoint> corners);
    com::zoho::common::Position* isosceles_triangle_position(std::vector<graphikos::painter::GLPoint> corners, std::vector<graphikos::painter::GLPoint> bboxCorners, float rotation, com::zoho::common::Position* currentPosition);
    std::vector<graphikos::painter::GLPoint> isosceles_triangle_bboxCorners(std::vector<graphikos::painter::GLPoint> corners);
    float isosceles_triangle_rotation(std::vector<graphikos::painter::GLPoint> corners);
    google::protobuf::RepeatedField<float>* isosceles_triangle_modifiers(std::vector<graphikos::painter::GLPoint> corners, com::zoho::common::Dimension* dimension);

    bool line_validate(std::vector<graphikos::painter::GLPoint> pathArray, std::vector<graphikos::painter::GLPoint> corners, float errorDistance);
    float line_rotation(std::vector<graphikos::painter::GLPoint> corners, com::zoho::common::Position* pos, com::zoho::common::Dimension* dim);
    google::protobuf::RepeatedField<float>* line_modifiers(std::vector<graphikos::painter::GLPoint> corners, com::zoho::common::Dimension* dimension);

    bool rect_validate(std::vector<graphikos::painter::GLPoint> pathArray, std::vector<graphikos::painter::GLPoint> corners, float errorDistance);
    com::zoho::common::Dimension* rect_dimension(std::vector<graphikos::painter::GLPoint> corners);
    com::zoho::common::Position* rect_position(std::vector<graphikos::painter::GLPoint> corners, std::vector<graphikos::painter::GLPoint> bboxCorners, float rotation, com::zoho::common::Position* currentPosition);
    std::vector<graphikos::painter::GLPoint> rect_bboxCorners(std::vector<graphikos::painter::GLPoint> corners);
    float rect_rotation(std::vector<graphikos::painter::GLPoint> corners);

    bool parallelogram_validate(std::vector<graphikos::painter::GLPoint> pathArray, std::vector<graphikos::painter::GLPoint> corners, float errorDistance);
    com::zoho::common::Dimension* parallelogram_dimension(std::vector<graphikos::painter::GLPoint> corners);
    com::zoho::common::Position* parallelogram_position(std::vector<graphikos::painter::GLPoint> corners, std::vector<graphikos::painter::GLPoint> bboxCorners, float rotation, com::zoho::common::Position* currentPosition);
    std::vector<graphikos::painter::GLPoint> parallelogram_bboxCorners(std::vector<graphikos::painter::GLPoint> corners);
    float parallelogram_rotation(std::vector<graphikos::painter::GLPoint> corners);
    google::protobuf::RepeatedField<float>* parallelogram_modifiers(std::vector<graphikos::painter::GLPoint> corners, com::zoho::common::Dimension* dimension);

    bool trapezoid_validate(std::vector<graphikos::painter::GLPoint> pathArray, std::vector<graphikos::painter::GLPoint> corners, float errorDistance);
    com::zoho::common::Dimension* trapezoid_dimension(std::vector<graphikos::painter::GLPoint> corners);
    com::zoho::common::Position* trapezoid_position(std::vector<graphikos::painter::GLPoint> corners, std::vector<graphikos::painter::GLPoint> bboxCorners, float rotation, com::zoho::common::Position* currentPosition);
    std::vector<graphikos::painter::GLPoint> trapezoid_bboxCorners(std::vector<graphikos::painter::GLPoint> corners);
    float trapezoid_rotation(std::vector<graphikos::painter::GLPoint> corners);
    google::protobuf::RepeatedField<float>* trapezoid_modifiers(std::vector<graphikos::painter::GLPoint> corners, com::zoho::common::Dimension* dimension);

    bool oval_validate(std::vector<graphikos::painter::GLPoint> pathArray, std::vector<graphikos::painter::GLPoint> corners, float errorDistance);
    float oval_rotation(std::vector<graphikos::painter::GLPoint> corners);
    com::zoho::common::Dimension* oval_dimension(std::vector<graphikos::painter::GLPoint> corners);
    com::zoho::common::Position* oval_position(std::vector<graphikos::painter::GLPoint> corners, std::vector<graphikos::painter::GLPoint> bboxCorners, float rotation, com::zoho::common::Position* currentPosition);

    bool isPolygon(float polygonAngle, std::vector<graphikos::painter::GLPoint> corners, float errorDistance, bool checkRegular);
    std::vector<float> getErrorAngles(std::vector<graphikos::painter::GLPoint> corners, float errorDistance);
    std::vector<float> getCornerDistances(std::vector<graphikos::painter::GLPoint> corners);
    std::vector<graphikos::painter::GLPoint> getEllipseCorners(std::vector<graphikos::painter::GLPoint> pathArray);
    float getMinimumDistancePoints(std::vector<graphikos::painter::GLPoint> points, graphikos::painter::GLPoint referencePoint);
    std::map<std::string, graphikos::painter::GLPoint> getMaximumDistancePoints(std::vector<graphikos::painter::GLPoint> pathArray);
    std::map<std::string, graphikos::painter::GLPoint> getSemiMinorAxisCoordinates(std::map<std::string, graphikos::painter::GLPoint> semiMajorAxisCoordinates, float semiMajorAxis, float semiMinorAxis, graphikos::painter::GLPoint center);

    float correctRotation(float angle);
    std::vector<float> getCornerAngles(std::vector<graphikos::painter::GLPoint> corners);
    bool checkIsLine(std::vector<graphikos::painter::GLPoint> corners, float errorDistance);
    ZShapeRecognitionData getRecognizedShapeProps(ZShapeRecognitionData data);
    graphikos::painter::GLPoint getIntersectPoint(ZShapeLine line1, ZShapeLine line2);
    com::zoho::common::Position* getPosition(std::vector<graphikos::painter::GLPoint> bboxCorners, graphikos::painter::GLPoint finalPosition, float rotation, com::zoho::common::Position* currentPosition);
    bool isPointOnLineSegment(graphikos::painter::GLPoint A, graphikos::painter::GLPoint B, graphikos::painter::GLPoint C);
    float roundOffToEven(float val);
    graphikos::painter::GLPoint getCentroid(std::vector<graphikos::painter::GLPoint> points);
    float getAngle(graphikos::painter::GLPoint firstPoint, graphikos::painter::GLPoint secondPoint, graphikos::painter::GLPoint thirdPoint);
    std::map<std::string, float> correctCircle(float semiMajorAxis, float semiMinorAxis);
    std::vector<graphikos::painter::GLPoint> rearrangeEllipseCorners(std::vector<graphikos::painter::GLPoint> corners);
    float getRotation(graphikos::painter::GLPoint baseStartPoint, graphikos::painter::GLPoint baseEndPoint);
    float solveEllipse(graphikos::painter::GLPoint center, float semiMajorAxis, float semiMinorAxis, float angle, graphikos::painter::GLPoint point);
    graphikos::painter::GLPoint getRotatedValue(float angle, graphikos::painter::GLPoint point, graphikos::painter::GLPoint center);
    float correctModifier(float modifier);
    bool isClockwise(std::vector<graphikos::painter::GLPoint> points);
    float getAngle(graphikos::painter::GLPoint A, graphikos::painter::GLPoint B, graphikos::painter::GLPoint C, bool clockwise);

    graphikos::painter::GLPoint differenceOfPoints(graphikos::painter::GLPoint start, graphikos::painter::GLPoint end) {
        return graphikos::painter::GLPoint(start.fX - end.fX, start.fY - end.fY);
    };

    graphikos::painter::GLPoint sumOfPoints(graphikos::painter::GLPoint start, graphikos::painter::GLPoint end) {
        return graphikos::painter::GLPoint(start.fX + end.fX, start.fY + end.fY);
    };

    graphikos::painter::GLPoint midPoint(graphikos::painter::GLPoint start, graphikos::painter::GLPoint end) {
        return graphikos::painter::GLPoint((start.fX + end.fX) / 2, (start.fY + end.fY) / 2);
    };

    bool isSamePoint(graphikos::painter::GLPoint start, graphikos::painter::GLPoint end) {
        return (start.fX == end.fX && start.fY == end.fY);
    };

    float getTangentAngle(float oppositeSide, float adjacentSide) {
        return std::atan(oppositeSide / adjacentSide) * (180 / MATH_UTIL_PI);
    };
    float getCosineAngle(float adjacent, float hypotenuse) {
        return std::acos(adjacent / hypotenuse) * (180 / MATH_UTIL_PI);
    };

    float getYValueFromLineEquation(float slope, graphikos::painter::GLPoint point, float xValue) {
        return std::isfinite(slope) ? ((slope * xValue) - (slope * point.fX) + point.fY) : xValue;
    };

    float getXValueFromLineEquation(float slope, graphikos::painter::GLPoint point, float yValue) {
        return (slope != 0) ? ((yValue / slope) - (point.fY / slope) + point.fX) : yValue;
    };

    float getSlope(graphikos::painter::GLPoint startPoint, graphikos::painter::GLPoint endPoint) {
        return (endPoint.fY - startPoint.fY) / (endPoint.fX - startPoint.fX);
    };

    float getDistance(graphikos::painter::GLPoint startPoint, graphikos::painter::GLPoint endPoint) {
        return std::sqrt(std::pow((endPoint.fX - startPoint.fX), 2) + std::pow((endPoint.fY - startPoint.fY), 2));
    };

    float getSlopeAngle(graphikos::painter::GLPoint startPoint, graphikos::painter::GLPoint endPoint) {
        return std::atan((endPoint.fY - startPoint.fY) / (endPoint.fX - startPoint.fX)) * (180 / MATH_UTIL_PI);
    };
};

#endif
