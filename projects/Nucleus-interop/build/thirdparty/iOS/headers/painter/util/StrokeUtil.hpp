#ifndef STROKE_UTIL_HPP
#define STROKE_UTIL_HPP

#include <string>
#include <skia-extension/GLPath.hpp>
#include <painter/BackendRenderSettings.hpp>
#include <painter/IProvider.hpp>

namespace Show {
enum StrokeField_MarkerType : int;
enum StrokeField_CapType : int;
enum StrokeField_Size : int;
}
namespace com {
namespace zoho {
namespace shapes {
class Stroke;
}
}
}

namespace google {
namespace protobuf {
template <typename T>
class RepeatedPtrField;
}
}

class SkCanvas;
class SkPaint;
class SkPathEffect;

namespace graphikos {
namespace painter {
class StrokeUtil {
public:
    static bool isStrokesAreOuter(const google::protobuf::RepeatedPtrField<com::zoho::shapes::Stroke>& strokes);
    static SkPaint getPaint(const com::zoho::shapes::Stroke* stroke, const com::zoho::shapes::Transform* transform, SkMatrix matrix, SkPaint parentPaint, IProvider* provider);
    static SkPaint getPaint(google::protobuf::RepeatedPtrField<com::zoho::shapes::Stroke>* stroke, const com::zoho::shapes::Transform* transform, SkMatrix matrix, SkPaint parentPaint);
    static SkPaint getStrokedPaint(SkPaint paint, const com::zoho::shapes::Stroke* stroke);
    static void drawStroke(SkCanvas* canvas, com::zoho::shapes::Stroke* stroke, GLPath path, SkPaint paint);
    static sk_sp<SkPathEffect> getPathEffect(const com::zoho::shapes::Stroke* stroke);
};
}
}
#endif