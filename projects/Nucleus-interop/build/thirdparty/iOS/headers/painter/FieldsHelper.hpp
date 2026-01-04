#pragma once

#include <include/core/SkPaint.h>
#include <include/pathops/SkPathOps.h>
#include <include/core/SkBlendMode.h>

namespace Show {
enum FillField_FillRule : int;
enum ShapeField_BlendMode : int;
enum ShapeField_CombineRule : int;
enum StrokeField_CapType : int;
enum StrokeField_JoinType : int;
enum PortionField_FontWeight : int;
}

enum class SkPathFillType;
enum class SkBlendMode;
class SkPaint;
class SkPaint;

namespace graphikos {
namespace painter {
class FieldsHelper {
public:
    static SkPathFillType fillRule(Show::FillField_FillRule fillRule);
    static SkBlendMode mode(Show::ShapeField_BlendMode blendMode);
    static SkPathOp combineRule(Show::ShapeField_CombineRule combineRule);
    static SkPaint::Cap cap(Show::StrokeField_CapType cap);
    static SkPaint::Join join(Show::StrokeField_JoinType join);
    static int fontWeight(Show::PortionField_FontWeight fontWeight);
};
}
}
