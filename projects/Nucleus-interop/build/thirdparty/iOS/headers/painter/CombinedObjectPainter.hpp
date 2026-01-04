#pragma once

#include <string>

#include <skia-extension/GLPath.hpp>
#include <painter/ShapeObjectPainter.hpp>

namespace com {
namespace zoho {
namespace shapes {
class ShapeObject_CombinedObject;
}
}
}

namespace graphikos {
namespace painter {
class CombinedObjectPainter {
private:
    com::zoho::shapes::ShapeObject_CombinedObject* combinedObject = nullptr;

public:
    CombinedObjectPainter(com::zoho::shapes::ShapeObject_CombinedObject* combinedObject);
    void draw(const DrawingContext& dc);
    GLPath combinePaths(GLPath path1, GLPath path2, SkPathOp operation);
    GLPath getCombinedPath(SkMatrix matrix);
    void setCombinedPath(SkMatrix matrix);

    std::vector<ShapeDetails> traverseCombinedObject(GLPoint point, const SelectionContext& sc);
    ShapeDetails traverseCombinedObjectById(std::string shapeId, const SelectionContext& sc);
    std::vector<ShapeDetails> traverseCombinedObjectByName(std::string shapeName, const SelectionContext& sc);
    GLPath getCombinedPath(const DrawingContext& dc,com::zoho::shapes::ShapeObject_CombinedObject* combinedObject);
};
} // namespace nila

} // namespace graphikos
