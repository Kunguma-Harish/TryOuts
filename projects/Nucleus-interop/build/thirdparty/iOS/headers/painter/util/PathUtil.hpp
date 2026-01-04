#pragma once

#include <string>
#include <skia-extension/GLPath.hpp>

#include <tuple>

namespace com {
namespace zoho {
namespace shapes {
class PathObject;
}
namespace common {
class Dimension;
class Position;
}
}
}

namespace google {
namespace protobuf {
template <typename T>
class RepeatedPtrField;
}
}

namespace graphikos {
namespace painter {
class PathUtil {
public:
    struct RoundedCornerDetails {
        GLPoint centerPoint;
        float startAngle;
        float endAngle;
        bool isClockwise;
        GLPoint startPoint;
        GLPoint endPoint;
        float radius;
        // func startAndEndPoint(cornerRadius: CGFloat) -> (startPoint: CGPoint, endPoint: CGPoint) {
        // 	let s_x = self.centerPoint.x + cornerRadius * cos(self.startAngle * CGFloat(Double.pi))
        // 	let s_y = self.centerPoint.y + cornerRadius * sin(self.startAngle * CGFloat(Double.pi))
        // 	let e_x = self.centerPoint.x + cornerRadius * cos(self.endAngle * CGFloat(Double.pi))
        // 	let e_y = self.centerPoint.y + cornerRadius * sin(self.endAngle * CGFloat(Double.pi))
        // 	return (startPoint: CGPoint(x: s_x, y: s_y), endPoint: CGPoint(x: e_x, y: e_y))
        // }
    };
    static RoundedCornerDetails RoundedCorner(GLPoint fromPoint, GLPoint viaPoint, GLPoint toPoint, float cornerRadius);
    static GLPath getLinePath(SkScalar x1, SkScalar y1, SkScalar x2, SkScalar y2);
    static GLPath getGLPath(google::protobuf::RepeatedPtrField<com::zoho::shapes::PathObject>* pathObjects, SkMatrix scaleMatrix);
    static GLPath customPath(google::protobuf::RepeatedPtrField<com::zoho::shapes::PathObject>* pathObjects, SkMatrix scaleMatrix);
    static GLPath GetRoundedGLPath(google::protobuf::RepeatedPtrField<com::zoho::shapes::PathObject>* pathObject);
    static std::tuple<GLPoint, GLPoint> ControlPointsForCubicCurveRepresentationOfCircleQuadrant(GLPoint startPoint, GLPoint endPoint, GLPoint center);

    static float maximumCornerRadius(GLPoint fromPoint, GLPoint viaPoint, GLPoint toPoint, bool prevNodeHasRadius, bool nextNodeHasRadius, bool prevNodeSelected, bool nextNodeSelected);
    static bool checkNodePresent(com::zoho::shapes::PathObject* node, google::protobuf::RepeatedPtrField<com::zoho::shapes::PathObject>* pathObjects, int lastIndex);
    static GLPoint getRotatedValue(float angle, GLPoint point, GLPoint center);
    static GLPoint getRotatedValue(float angle, float x, float y, float cx, float cy);
    static std::map<std::string, GLPoint> getCornerPoints(com::zoho::common::Position* pos, com::zoho::common::Dimension* dim, float angle);
    static std::map<std::string, GLPoint> getCornerPoints(com::zoho::common::Position* pos, com::zoho::common::Dimension* dim, float angle, float cx, float cy);

    static float getMaximumSmoothingPercent(float maxRadius, float appliedRadius);
    static GLPoint getNodePointForSquircle(GLPoint point1, GLPoint point2, float ratio1, float ratio2);
    static GLPoint getControlPointForSquircle(GLPoint point1, GLPoint point2, float ratio1, float ratio2);
    /**
     * @brief Get the Zig Zag Path always starts from left 0 
     * 
     * @param width 
     * @param height 
     * @param baseLine 
     * @return GLPath 
     */
    static GLPath getZigZagPath(float width, float height, float baseLine);

    // Angle for a point in an ellipse. Considers the ellipse to have wR and hR as its mid point.
    // Angle starts at (maxX, midY) as 0 and moves clockwise , 90 -> (midX , maxY) ,
    // 180 -> (0, midY) , 270 -> (midX, 0) and ends in the same place as
    // 360 degree, Manipulations are done here to accomplish that.
    // x,y = point in an ellipse
    // wR - x Radius, hR - y radius.
    // Uses the formula x = midx + a * cos(theta) , y = midy + b * sin(theta) , divide both to get tan(theta)
    static float getAngle(float x, float y, float wR, float hR) {
        return PathUtil::getAngle(x, y, wR, hR, wR, hR);
    };
    static float getAngle(float x, float y, float wR, float hR, float midX, float midY);

    static float getLength(float x1, float y1, float x2, float y2) {
        return std::sqrt(std::pow((x2 - x1), 2) + std::pow((y2 - y1), 2));
    };

    static float limit(float val, float min, float max) {
        float a = std::min(val, max);
        return std::max(a, min);
    };
    /**
 * @brief perpendicular distance between a point and line 
 * 
 * @param val1 
 * @param val2 
 * @param diffX 
 * @param diffY 
 * @param isY 
 * @return float 
 */
    static float distanceOf(GLPoint val1, GLPoint val2, float diffX, float diffY, bool isY = false) {
        float a = val2.fY - val1.fY;
        if (isY) {
            a *= -1;
        }
        float b = val1.fX - val2.fX;
        if (isY) {
            b *= -1;
        }
        float c = (((-1) * b) * val1.fY) - a * val1.fX;
        float denominator = (std::sqrt(std::pow(a, 2) + std::pow(b, 2)));
        return (denominator != 0) ? ((a * diffX + b * diffY + c) / denominator) : 0;
    };
};
}
}