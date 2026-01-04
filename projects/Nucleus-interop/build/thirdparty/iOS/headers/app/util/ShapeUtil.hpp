#ifndef __NL_SHAPEUTIL_H
#define __NL_SHAPEUTIL_H

#include <app/ZSelectionHandler.hpp>
#include <skia-extension/GLPath.hpp>

namespace com {
namespace zoho {
namespace shapes {
class ShapeObject;
class Transform;
}
}
}

class ShapeUtil {

public:
    static float degree44;
    static float degree45;
    static float degree134;
    static float degree224;
    static float degree314;
    static float degree135;
    static float degree225;
    static float degree315;
    struct PathDetails {
        graphikos::painter::GLPath path;
        SkPaint paint;
        //  PathDetails(GLPath path, SkPaint paint);
    };
    static graphikos::painter::GLPoint positionShape(float angle, graphikos::painter::GLRect rect, int isNegative);
    static com::zoho::shapes::Transform getTotalBoundingTransform(std::vector<SelectedShape>& selectedShapes);
    static com::zoho::shapes::Transform getMergedEditingTransform(std::vector<SelectedShape>& selectedShapes, graphikos::painter::IProvider* provider);
    static std::vector<PathDetails> getPathFromShapeObject(com::zoho::shapes::ShapeObject* shapeObject, graphikos::painter::IProvider* provider);
    static std::string getUUID();

    static bool isGroupShapeAuto(com::zoho::shapes::ShapeObject* groupShapeDetails);
    static bool isGroupShapeHeightAuto(com::zoho::shapes::Transform* groupTrans);
    static bool isGroupShapeWidthAuto(com::zoho::shapes::Transform* groupTrans);
};
#endif
