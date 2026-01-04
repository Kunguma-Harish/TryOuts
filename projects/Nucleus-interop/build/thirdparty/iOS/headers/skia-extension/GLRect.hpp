#pragma once

#include <cmath>
#include <map>
#include <sstream>

#include <skia-extension/GLPoint.hpp>
#include <skia-extension/Matrices.hpp>

#include <include/core/SkRect.h>

namespace com {
namespace zoho {
namespace shapes {
class Transform;
}
}
}

namespace graphikos {
namespace painter {
class GLPath;
struct GLRect : public SkRect {
public:
    GLRect();
    GLRect(SkRect rect);
    GLRect(SkScalar left, SkScalar top, SkScalar right, SkScalar bottom);

    GLPoint getCenter() const;
    float getArea() const;
    bool isLine() const;
    bool isNaN() const;
    bool hasNonZeroDimension() const;
    GLPoint getUpperLeft() const;

    SkMatrix getDiffMatrix(const GLRect& targetRect) const;
    SkMatrix confineWithinRect(const GLPoint& point, const SkMatrix& matrix = SkMatrix()) const;
    SkMatrix confineWithinRect(const GLRect& rect, const SkMatrix& matrix = SkMatrix()) const;
    SkMatrix getFitToRectMatrix(const GLRect& fitRect, float ratio, bool maintainScale = false) const;
    GLRect scaleToHoldRect(const GLRect& rect) const;
    void forceJoin(const GLRect& rect);

    GLRect applying(const SkMatrix& matrix) const;
    GLRect applying(const Matrices& matrices) const;

    // void rectToTransform(com::zoho::shapes::Transform* trans) const;
    void apply(const SkMatrix& matrix);

    GLRect rotateAtCenter(SkScalar degree);
    GLRect rotate(SkScalar degree, const GLPoint& anchor);
    GLRect& enlargeBy(SkScalar dx, SkScalar dy);

    SkIRect toInt() const;
    GLRect toGLInt() const;
    std::string toString() const;

    static GLRect MakeNaN();

    /// @todo-refactor these functions
    static SkMatrix getAdaptiveTransformMatrix(GLRect targetRect, GLRect sourceRect, float ratio = 1.0);
    std::map<std::string, GLPoint> getCorners(float rotate);
};
}
}
