#ifndef FILL_UTIL_HPP
#define FILL_UTIL_HPP

#include <skia-extension/GLRect.hpp>
#include <painter/FieldsHelper.hpp>
#include <painter/IProvider.hpp>

namespace com {
namespace zoho {
namespace shapes {
class Fill;
class Transform;
class GradientFill;
class ColorTweaks;
class PictureProperties;
class PictureFill_PictureFillType;
}
}
}

namespace google {
namespace protobuf {
template <typename T>
class RepeatedPtrField;
}
}

class SkPaint;
class SkImage;
class SkMatrix;

namespace graphikos {
namespace painter {
class FillUtil {
private:
    /// Use the same paint object
    static std::shared_ptr<SkPaint> TRANSPARENT_PAINT;

public:
    static std::shared_ptr<SkPaint> getPaint(const google::protobuf::RepeatedPtrField<com::zoho::shapes::Fill>* fills, Show::ShapeField_BlendMode blendMode, const com::zoho::shapes::Transform* transform, const SkMatrix& matrix, const SkPaint& parentPaint, IProvider* provider, bool forRendering = false, std::string shapeId = "", const com::zoho::shapes::ColorTweaks* tweaks = nullptr, com::zoho::shapes::Properties* props = nullptr, const google::protobuf::RepeatedPtrField<com::zoho::shapes::ColorTweaks>* groupFillTweaks = nullptr);
    static SkPaint getPaint(const com::zoho::shapes::Fill* fill, const com::zoho::shapes::Transform* transform, const SkMatrix& matrix, const SkPaint& parentPaint, IProvider* provider, bool forRendering = false, const com::zoho::shapes::ColorTweaks* tweaks = nullptr, com::zoho::shapes::Properties* props = nullptr, const google::protobuf::RepeatedPtrField<com::zoho::shapes::ColorTweaks>* groupFillTweaks = nullptr);
    /**
     * Same as getPaint but doesn't use SkShader internally
     */

    static sk_sp<SkShader> getSkShader(const google::protobuf::RepeatedPtrField<com::zoho::shapes::Fill>* fills, Show::ShapeField_BlendMode blendMode, const com::zoho::shapes::Transform* t, const SkMatrix& matrix, const SkPaint& parentPaint, IProvider* provider, com::zoho::shapes::Properties* props = nullptr, bool forRendering = false, std::string shapeId = "", const com::zoho::shapes::ColorTweaks* tweaks = nullptr, const google::protobuf::RepeatedPtrField<com::zoho::shapes::ColorTweaks>* groupFillTweaks = nullptr);
    static sk_sp<SkShader> getSkShader(const com::zoho::shapes::Fill* fill, const com::zoho::shapes::Transform* transform, const SkMatrix& matrix, const SkPaint& parentPaint, IProvider* provider, com::zoho::shapes::Properties* props = nullptr, bool forRendering = false, std::string shaped = "", const com::zoho::shapes::ColorTweaks* tweaks = nullptr, const google::protobuf::RepeatedPtrField<com::zoho::shapes::ColorTweaks>* groupFillTweaks = nullptr);

    static sk_sp<SkShader> getPatternFill(const com::zoho::shapes::Fill* fill, const com::zoho::shapes::Transform* transform, const SkMatrix& matrix, const SkPaint& parentPaint, IProvider* provider, const com::zoho::shapes::ColorTweaks* tweaks = nullptr, const google::protobuf::RepeatedPtrField<com::zoho::shapes::ColorTweaks>* groupFillTweaks = nullptr);

    static sk_sp<SkShader> getPictureAsShader(sk_sp<SkImage> image, const GLRect& rect, const SkMatrix& matrix, const com::zoho::shapes::PictureFill_PictureFillType* picFillType);
    static sk_sp<SkShader> getGradientAsShader(const com::zoho::shapes::GradientFill* gradientFill, const GLRect& transformRect, const SkMatrix& matrix, const SkPaint& parentPaint, IProvider* provider, const com::zoho::shapes::ColorTweaks* tweaks = nullptr, const google::protobuf::RepeatedPtrField<com::zoho::shapes::ColorTweaks>* groupFillTweaks = nullptr);
    static sk_sp<SkShader> getImageShaderInFrame(sk_sp<SkImage> image, const GLRect& rect, const SkMatrix& matrix);

    static sk_sp<SkColorFilter> getPictureProperties(const com::zoho::shapes::PictureProperties* picProps);

    static void setLinearFillParams(const com::zoho::shapes::GradientFill* gradient, const GLRect& rect, GLPoint& startPoint, GLPoint& endPoint, SkMatrix& gradientMatrix);

    static sk_sp<SkImage> getPlaceHolderImage();
};
}
}
#endif