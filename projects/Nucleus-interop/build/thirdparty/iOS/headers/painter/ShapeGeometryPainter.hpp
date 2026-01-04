#ifndef SHAPE_GEOMETRY_PAINTER_HPP
#define SHAPE_GEOMETRY_PAINTER_HPP

#include <skia-extension/GLPath.hpp>
#include <painter/PathInfo.hpp>

namespace com {
namespace zoho {
namespace shapes {
class ShapeGeometry;
class Stroke;
}
}
}

namespace graphikos {
namespace painter {
class ShapeGeometryPainter {
private:
    com::zoho::shapes::ShapeGeometry* shapeGeometry = nullptr;
    com::zoho::shapes::Stroke* stroke = nullptr; // needed for draw headend/tailend arrows for connector path

public:
    ShapeGeometryPainter(com::zoho::shapes::ShapeGeometry* _shapeGeometry);
    ShapeGeometryPainter(com::zoho::shapes::ShapeGeometry* _shapeGeometry, com::zoho::shapes::Stroke* stroke);
    PathInfo shapePath(const GLRect& frame, bool withRadius, bool isPattern = false, bool withoutReduction = false);
    GLPath getGLPathWithoutRadius();
};
}
}
#endif