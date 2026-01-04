#pragma once

#include <string>

#include <skia-extension/GLRegion.hpp>
#include <painter/TransformPainter.hpp>
#include <painter/ShapeObjectPainter.hpp>
#include <skia-extension/DeferredDetails.hpp>

namespace com {
namespace zoho {
namespace shapes {
class ShapeObject;
class ShapeObject_GroupShape;
class ModifiedFollower;
}
}
}

namespace graphikos {
namespace painter {
class GroupShapePainter {
private:
    com::zoho::shapes::ShapeObject_GroupShape* groupShape = nullptr;

public:
    GroupShapePainter(com::zoho::shapes::ShapeObject_GroupShape* groupShape);
    bool draw(const DrawingContext& dc);
    bool drawShapes(const DrawingContext& dc);
    std::vector<ShapeDetails> traverseGroupShape(GLPoint point, const SelectionContext& sc);
    ShapeDetails traverseGroupShapeById(std::string shapeId, const SelectionContext& sc);
    GLPath getBoundingPathFromShape(std::map<std::string, com::zoho::shapes::Transform>& modifiedChildTransforms, bool considerInnerShapeDimScale);
    std::vector<ShapeDetails> traverseGroupShapeByName(std::string shapeName, const SelectionContext& sc);
    bool renderSmartObject(const DrawingContext& dc);
    std::vector<ShapeDetails> getSmartShapeDetails(GLPoint point, const SelectionContext& sc);
    ShapeDetails getSmartShapeDetailsById(std::string shapeId, const SelectionContext& sc);
    std::vector<ShapeDetails> getSmartShapeDetailsByName(std::string shapeName, const SelectionContext& sc);

    ShapeObjectsDetails getMergedLeader(const ZContext& zc, com::zoho::shapes::ShapeObject* leaderShape);
    bool isTemplate();

    GLRect getCoverageRectForChilds(ShapeDetails shapedetails);
    ShapeDetails getMaskShapeDetails(ShapeDetails shapedetails);
    GLPath computeMaskShapePath(GLPath path, const DrawingContext& dc);
    void calculateAutoLayoutAndVisit(const com::zoho::shapes::Transform& transform, const Matrices& matrices, com::zoho::shapes::Transform* gTrans, std::function<void(ShapeObjectPainter& shape, const graphikos::painter::GLRect& dimRect, const graphikos::painter::GLRect& rect, int index)> visitorFn, std::function<com::zoho::shapes::Transform(com::zoho::shapes::ShapeObject*)>* getOverridenTransform = nullptr);
    bool hasNaturalPosition();
    static void computePathForAllChildren(com::zoho::shapes::ShapeObject* shapeObject, graphikos::painter::GLPath& path, const DrawingContext& dc, bool needRefreshFrame);
};
}
}
