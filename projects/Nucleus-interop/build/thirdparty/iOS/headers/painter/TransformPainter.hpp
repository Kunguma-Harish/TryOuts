#pragma once

#include <skia-extension/GLRect.hpp>
#include <skia-extension/GLPoint.hpp>
#include <skia-extension/Matrices.hpp>

namespace com {
namespace zoho {
namespace shapes {
class Transform;
}
namespace common {
class Position_AbsolutePosition;
class Dimension;
}
}
}

namespace graphikos {
namespace painter {
class GLPath;
struct GLRect;
class TransformPainter {
private:
    com::zoho::shapes::Transform* transform = nullptr;

public:
    TransformPainter(com::zoho::shapes::Transform* _transform);
    TransformPainter(const com::zoho::shapes::Transform* _transform);
    com::zoho::shapes::Transform* getTransform() {
        return transform;
    }
    GLRect getRect();
    GLRect getRect(SkMatrix matrix);
    bool isEmptyTransform();
    com::zoho::shapes::Transform getMergedTransformForAShape(Matrices parentMatrices, com::zoho::shapes::Transform* gTrans, const graphikos::painter::GLRect* customParentRect = nullptr, const graphikos::painter::GLRect* customRect = nullptr);

    GLRect getRectOrigin();
    void setRect(GLRect rect);
    void setRectOrigin(GLPoint origin);
    GLRect getchRect();
    void setchRect(GLRect rect);

    SkMatrix getChildMatrix(SkMatrix matrix);
    SkMatrix getMatrixByTransform(SkMatrix matrix, com::zoho::shapes::Transform* transform);
    SkMatrix getMatrix(SkMatrix matrix);
    Matrices getMatrix(Matrices parentMatrices, com::zoho::shapes::Transform* gTrans, const graphikos::painter::GLRect* customParentRect, const graphikos::painter::GLRect* customRect, SkMatrix scaleAndTranslate, SkMatrix flipMatrix, float editingAngle, bool flipNeeded = true);
    Matrices getMatrix(Matrices parentMatrices, com::zoho::shapes::Transform* gTrans, const graphikos::painter::GLRect* customParentRect, const graphikos::painter::GLRect* customRect, Matrices changedMatrices, float editingAngle);

    GLPath getRectPath(const Matrices& matrices = Matrices(), com::zoho::shapes::Transform* gTrans = nullptr, const graphikos::painter::GLRect* customParentRect = nullptr, const graphikos::painter::GLRect* customRect = nullptr);

    GLPoint getRotatedValue(float angle, GLPoint point, GLPoint center);
    SkMatrix getScaleTranslateMatrix(const com::zoho::shapes::Transform* gTrans, const Matrices& parentMatrices, const graphikos::painter::GLRect* customParentRect, const graphikos::painter::GLRect* customRect);
    SkMatrix getRotationFlipMatrix(GLRect rect, bool fliph, bool flipv, float rotation);
    com::zoho::shapes::Transform moveIntoGroupShape(com::zoho::shapes::Transform immediateParent, com::zoho::shapes::Transform innerShape);
    bool changeTransformForAutoLayout(const com::zoho::shapes::Transform* actualTransform, const com::zoho::shapes::Transform* gTransform);
    SkMatrix getFlipMatrix(GLPoint center, bool fliph, bool flipv);
    void updateRotationAndFlipMatrixWithShapeTransform(Matrices& matrices);

    SkMatrix getDiffMatrix(com::zoho::shapes::Transform targetTransform);
    Matrices getMatrix(const Matrices& matrices, com::zoho::shapes::Transform* gTrans, const graphikos::painter::GLRect* customParentRect, const graphikos::painter::GLRect* customRect = nullptr);
    float getAngle();
    GLRect getBounding(Matrices matrices, com::zoho::shapes::Transform* gTrans = nullptr, const graphikos::painter::GLRect* customParentRect = nullptr);
    static SkMatrix getPositionConstraintsMatrix(const com::zoho::common::Position_AbsolutePosition& abs, const com::zoho::common::Dimension& dim, const GLRect& gRect, const GLRect& rect);
    static com::zoho::shapes::Transform GetTransform(GLRect rect);
};
}
}