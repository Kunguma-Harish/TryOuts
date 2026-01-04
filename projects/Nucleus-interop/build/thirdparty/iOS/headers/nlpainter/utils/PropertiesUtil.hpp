#ifndef __NL_PROPERTIESUTIL_H
#define __NL_PROPERTIESUTIL_H

#include <skia-extension/GLPath.hpp>
#include <skia-extension/GLRect.hpp>
#include <skia-extension/Matrices.hpp>

#include <painter/PathInfo.hpp>

#include <include/core/SkPaint.h>
#include <include/core/SkPicture.h>

namespace Show {
enum StrokeField_StrokePosition : int;

}

namespace com {
namespace zoho {
namespace shapes {
class Properties;
class Stroke_StrokeGrid;
}
}
}

namespace graphikos {
namespace painter {
class IProvider;
}
}

class PropertiesUtil {
public:
    struct DrawPathRec {
        graphikos::painter::GLPath path;
        SkPaint paint;
    };

    struct StrokeInfo {
        std::optional<DrawPathRec> headEnd;
        std::optional<DrawPathRec> tailEnd;
        Show::StrokeField_StrokePosition position;
        SkPaint strokePaint;
        bool isHidden = false;
        const com::zoho::shapes::Stroke_StrokeGrid* strokeGrid = nullptr;
    };

    struct PropertiesInfo {
        std::optional<SkPaint> effectsPaint;
        graphikos::painter::GLRect bounds;
        std::optional<SkPaint> innerEffectsPaint;
        sk_sp<SkPicture> backgroundBlur;
        std::vector<SkPaint> fillPaints;
        std::vector<StrokeInfo> strokesInfo;
        PathInfo pathInfo;
    };

    static PropertiesInfo getPropertiesInfo(com::zoho::shapes::Properties* properties, graphikos::painter::IProvider* provider, graphikos::painter::Matrices matrices);
    static std::vector<SkPaint> getFillsPaint(com::zoho::shapes::Properties* properties, const std::vector<graphikos::painter::GLPath>& paths, graphikos::painter::IProvider* provider, const SkMatrix& matrix);
    static std::vector<StrokeInfo> getStrokesInfo(com::zoho::shapes::Properties* properties, graphikos::painter::IProvider* provider, const graphikos::painter::Matrices& matrices);
};

#endif // __NL_PROPERTIESUTIL