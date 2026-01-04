#ifndef __NL_GROUPSHAPEUTIL_H
#define __NL_GROUPSHAPEUTIL_H

#include <skia-extension/GLPath.hpp>
#include <skia-extension/GLRect.hpp>
#include <skia-extension/Matrices.hpp>

#include <include/core/SkPicture.h>
#include <include/core/SkPaint.h>

#include <vector>

namespace graphikos {
namespace painter {
class IProvider;
class RenderSettings;
}
}

namespace com {
namespace zoho {
namespace shapes {
class ShapeObject;
class ShapeObject_GroupShape;
class Transform;
}
}
}

class GroupShapeUtil {
public:
    struct GroupShapeInfo {
        sk_sp<SkPicture> backgroundBlur;
        std::optional<SkPaint> effectsPaint;
        graphikos::painter::GLRect bounds;
        graphikos::painter::GLPath maskPath;
    };

    struct SmartShapeFollowerInfo {
        std::shared_ptr<com::zoho::shapes::ShapeObject> mergedLeader;
        graphikos::painter::Matrices matrices;
        com::zoho::shapes::Transform* gTrans;
        std::vector<com::zoho::shapes::ShapeObject*> shapesBeneath;
        std::vector<com::zoho::shapes::ShapeObject*> shapesOnTop;
    };

    static GroupShapeInfo getGroupShapeInfo(com::zoho::shapes::ShapeObject_GroupShape* groupShape, graphikos::painter::IProvider* provider, const graphikos::painter::RenderSettings* renderSettings, graphikos::painter::Matrices matrices, com::zoho::shapes::Transform* gTrans);
    static SmartShapeFollowerInfo getSmartShapeInfo(com::zoho::shapes::ShapeObject_GroupShape* groupShape, graphikos::painter::IProvider* provider, graphikos::painter::Matrices matrices, com::zoho::shapes::Transform* gTrans);
};

#endif //__NL_GROUPSHAPEUTIL_H
