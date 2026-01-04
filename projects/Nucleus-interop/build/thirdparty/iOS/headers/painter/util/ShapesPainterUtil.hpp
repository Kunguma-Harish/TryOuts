#ifndef ShapesPainterUtil_HPP
#define ShapesPainterUtil_HPP
#include <skia-extension/GLPoint.hpp>
#include <skia-extension/GLPath.hpp>
#include <skia-extension/GLRect.hpp>

namespace com{
    namespace zoho{
        namespace shapes{
            class PathObject;
            class Point;
            class CustomGeometry;
            class Transform;
        }
        namespace common{
            class Position;
        }
    }

}

class ShapesPainterUtil {

public:
    // GLpath
    static void toPathObject(com::zoho::shapes::PathObject * pathObject, uint8_t verb, graphikos::painter::GLPoint* po, int& pos, float cornerRadius);
    static void custom(graphikos::painter::GLPath customGlPath, com::zoho::shapes::CustomGeometry* customGeom, const graphikos::painter::GLPoint& dimension, float cornerRadius);

    // GLPoint

    static graphikos::painter::GLPoint GLPointConstructFromPosition(com::zoho::common::Position* pos);
    static void GLPointSet(const graphikos::painter::GLPoint& glpoint, com::zoho::shapes::Point* point);
    static void GLPointSet(const graphikos::painter::GLPoint& glpoint, com::zoho::common::Position* pos);
    static void GLRectRectToTransform(const graphikos::painter::GLRect& rect, com::zoho::shapes::Transform* transform);

    static graphikos::painter::GLPoint getRotatedValue(float angle, graphikos::painter::GLPoint point, graphikos::painter::GLPoint center);

    static graphikos::painter::GLPoint getRotatedValue(float angle, float x, float y, float cx, float cy);

    static bool ifMatricesAreSame(SkMatrix& lhs, SkMatrix& rhs, float threshold);
};

#endif // ShapesPainterUtil_HPP