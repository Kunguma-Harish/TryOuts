#pragma once

#include <include/core/SkRegion.h>
#include <skia-extension/GLRect.hpp>
#include <skia-extension/GLPath.hpp>
#include <skia-extension/Matrices.hpp>

class SkMatrix;

namespace graphikos {
namespace painter {
struct GLRegion : public SkRegion {

public:
    GLRegion();
    GLRegion(const GLRect& rect);
    GLRegion applying(const SkMatrix& matrix) const;
    GLRegion applying(const Matrices& matrices) const;
    std::string toString() const;
};
}
}
