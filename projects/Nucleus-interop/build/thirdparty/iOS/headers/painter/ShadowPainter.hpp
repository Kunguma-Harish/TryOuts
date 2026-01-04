#ifndef __SHAPAESPAINTER_SHADOWPAINTER
#define __SHAPAESPAINTER_SHADOWPAINTER

#include <painter/util/mathutil.h>
#include <skia-extension/GLPoint.hpp>
#include <skia-extension/GLRect.hpp>
#include <painter/util/GeneralUtil.hpp>
#include <include/core/SkBlurTypes.h>
#include <include/core/SkColorFilter.h>


namespace com {
namespace zoho {
namespace shapes {
class Effects_Shadow;
}
}
}

class SkCanvas;

namespace graphikos {
namespace painter {
class ShadowPainter {
private:
    com::zoho::shapes::Effects_Shadow* shadow = nullptr;

public:
    ShadowPainter(com::zoho::shapes::Effects_Shadow* _shadow);
    GLPath getOuter(GLPath path);
    GLPath getInner(GLPath path);
    GLPoint getOuterOffset();
    GLPoint getInnerOffset();
    void draw(SkCanvas* canvas, GLPath path, bool isFill, IProvider* provider);

    sk_sp<SkImageFilter> getShadowAsFilter(IProvider* provider, com::zoho::shapes::Properties* props, const Matrices& matrices);
    GLRect getOuterRect(GLRect rect);
};
}
}
#endif
