#pragma once

#include <include/core/SkPath.h>
#include <include/pathops/SkPathOps.h>
#include <skia-extension/GLRect.hpp>

namespace com {
namespace zoho {
namespace shapes {
class PathObject;
class CustomGeometry;
}
}
}

namespace graphikos {
namespace painter {

class GLPath : public SkPath {
public:
    GLPath() {}
    using SkPath::transform;

    // void custom(com::zoho::shapes::CustomGeometry* custom, const GLPoint& dimension, float cornerRadius = 0) const;

    GLPath verticalFlip(const GLRect& frame) const;
    GLPath horizontalFlip(const GLRect& frame) const;
    GLPath rotate(float degree, const GLPoint& center) const;

    GLPath transform(const GLRect& targetRect) const;
    GLPath transform(const GLRect& targetRect, const GLRect& sourceRect) const;
    GLPath affineTransform(const GLRect& targetRect, const GLRect& sourceRect) const;

    GLRect bounds() const;
    bool intersects(const GLRect& rect) const; //this(Path) basically contains a rect....

    static GLPath combinePaths(const GLPath& path1, const GLPath& path2, SkPathOp operation);
};
}
}
