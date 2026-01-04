#pragma once

#include <skia-extension/GLPath.hpp>
#include <painter/IProvider.hpp>
#include <include/core/SkBlendMode.h>

namespace com {
namespace zoho {
namespace shapes {
class Effects;
}
}
}

class SkCanvas;
class SkImageFilter;

namespace graphikos {
namespace painter {
class EffectsPainter {
private:
    com::zoho::shapes::Effects* effects = nullptr;

public:
    EffectsPainter(com::zoho::shapes::Effects* _effects);
    void preDraw(SkCanvas* canvas, GLPath path, bool isFill, IProvider* provider);
    void postDraw(SkCanvas* canvas, GLPath path, bool isFill, IProvider* provider);

    sk_sp<SkImageFilter> getEffectsAsFilter(IProvider* provider, com::zoho::shapes::Properties* props, const Matrices& matrices, GLRect rect = {}, bool outerShadow = true, bool innerShadow = true);
    sk_sp<SkImageFilter> getInnerShadowsAsFilter(IProvider* provider, com::zoho::shapes::Properties* props, const Matrices& matrices, GLRect rect = {});
    sk_sp<SkImageFilter> getOuterShadowsAsFilter(IProvider* provider, com::zoho::shapes::Properties* props, const Matrices& matrices, GLRect rect = {});

    static bool hasInnerEffects(const com::zoho::shapes::Effects& effects);
};
}
}