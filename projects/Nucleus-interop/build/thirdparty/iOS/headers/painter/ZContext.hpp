#pragma once

#include <skia-extension/GLRegion.hpp>
#include <skia-extension/Matrices.hpp>
#include <painter/IProvider.hpp>
#include <painter/BackendRenderSettings.hpp>

#include <include/core/SkPaint.h>

namespace com {
namespace zoho {
namespace shapes {
class Transform;
}
}
}

/// @todo revise the struct once

/**
 * @brief DrawingContext will hold 'where to draw' information
 */
namespace graphikos {
namespace painter {
struct ZContext {
protected:
    ZContext(const ZContext& og) {
        this->provider = og.provider;
        this->frame = og.frame;
        this->parentPaint = og.parentPaint;
        this->matrices = og.matrices;
        this->cameraMatrix = og.cameraMatrix;
        this->gTrans = og.gTrans;
        this->contaninerTransformOverriden = og.contaninerTransformOverriden;
        this->customParentBounds = og.customParentBounds;
        this->customBounds = og.customBounds;
    }

public:
    IProvider* provider = nullptr;                  /* provider dependeing on product */
    GLRegion frame = GLRegion();                    /* Region of the canvas we draw to (Matrix not multiplied) */
    SkPaint parentPaint = SkPaint();                /**/
    Matrices matrices;                              /* Group matrices */
    SkMatrix cameraMatrix;                          /* World camera coordinates */
    com::zoho::shapes::Transform* gTrans = nullptr; /* parents transform */
    bool contaninerTransformOverriden = false;
    const GLRect* customParentBounds = nullptr; /* Amount of parentBounds available for child */
    const GLRect* customBounds = nullptr;       /* CustomBounds for child */

    ZContext() {}
    ZContext(GLRegion frame, Matrices matrices, SkMatrix cameraMatrix) : frame(frame), matrices(matrices), cameraMatrix(cameraMatrix) {}

    ZContext(IProvider* provider, GLRegion frame = GLRegion(), Matrices matrices = Matrices(), SkMatrix cameraMatrix = SkMatrix(), com::zoho::shapes::Transform* gTrans = nullptr)
        : provider(provider), frame(frame), matrices(matrices), cameraMatrix(cameraMatrix), gTrans(gTrans) {}

    /**
     * @brief Returns the frame multiplied with cameraMatrix and groupMatrix
     * @return GLRect The final rect in scene
     */
    GLRegion getFinalRect();

    /**
     * @brief Get the Final Matrix object
     * 
     * @return SkMatrix 
     */
    SkMatrix getFinalMatrix();

    SkMatrix getFinalMatrixWithoutScale();

    SkMatrix getInvCameraMat();
};
}
}
