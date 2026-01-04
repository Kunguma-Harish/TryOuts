#ifndef GENERAL_UTIL_HPP
#define GENERAL_UTIL_HPP

#include <skia-extension/GLPath.hpp>
#include <painter/IProvider.hpp>
#include <painter/GL_Ptr.h>

namespace com {
namespace zoho {
namespace common {
class Tweak;
enum Tweak_TweakMode : int;
}
namespace shapes {
class Color;
class Color_HSBModel;
class Blur;
class ColorTweaks;
class RGBTweak;
class HSLTweak;
}
}
}

namespace google {
namespace protobuf {
template <typename T>
class RepeatedPtrField;

template <typename T>
class RepeatedField;
}
}

class SkPaint;
class SkImageFilter;

#define lINE_SPACING_RATIO 1.2
#define BULLET_HEIGHT 16
#define BULLET_WIDTH 16
#define SUBPORTIONRATIO 0.63

class SkCanvas;

namespace graphikos {
namespace painter {
static const double PT_TO_PX_RATIO = 1.33333;
class GeneralUtil {
public:
    static SkColor getSkColor(const com::zoho::shapes::Color* color, IProvider* provider, const com::zoho::shapes::ColorTweaks* tweaks = nullptr, const google::protobuf::RepeatedPtrField<com::zoho::shapes::ColorTweaks>* groupFillTweaks = nullptr);
    static SkPaint getSkPaint(GLPath* path, com::zoho::shapes::Fill* fill);
    static void setRGBValue(float r, float g, float b, google::protobuf::RepeatedField<int32_t>* rgb);
    static float* toRGB(google::protobuf::RepeatedField<int32_t>* rgb);
    static void scRGB(google::protobuf::RepeatedField<int32_t>* rgb, float* rgbUpdated);
    static void setTweaks(com::zoho::shapes::Color* color, google::protobuf::RepeatedField<int32_t>* rgb);
    static void setTint(google::protobuf::RepeatedField<int32_t>* rgb, float value);
    static void setShade(google::protobuf::RepeatedField<int32_t>* rgb, float value);
    static com::zoho::common::Tweak getTweak(float value, com::zoho::common::Tweak_TweakMode mode);
    static void setRGB(google::protobuf::RepeatedField<int32_t>* rgb, com::zoho::shapes::RGBTweak* rgbTweak);
    static float modifyRGBTweakValue(float value, google::protobuf::RepeatedPtrField<com::zoho::common::Tweak>* tweaks);
    static float modifyHSLTweakValue(float value, google::protobuf::RepeatedPtrField<com::zoho::common::Tweak>* tweaks);
    static void setHSL(google::protobuf::RepeatedField<int32_t>* rgb, com::zoho::shapes::HSLTweak* hsl);
    static std::vector<float> toHSL(google::protobuf::RepeatedField<int32_t>* rgb);
    static void hsl(google::protobuf::RepeatedField<int32_t>* rgb, std::vector<float> hslUpdated);
    static sk_sp<SkImageFilter> getBlurFilter(com::zoho::shapes::Blur* blur);
    static void HSBToRGB(google::protobuf::RepeatedField<int32_t>* rgb, com::zoho::shapes::Color_HSBModel* hsb);
    static std::tuple<float, float> getScaleValue(float width, float height);
    static bool ifMatricesAreSame(SkMatrix& lhs, SkMatrix& rhs, float threshold = 0.001);
    static std::shared_ptr<SkPaint> getEffectsPaint(com::zoho::shapes::Properties* props, const Matrices& matrices, IProvider* provider, bool onlyOuterEffects = false);
    static bool drawBackgroundBlur(SkCanvas* canvas, com::zoho::shapes::Blur* blur, GLPath path);
    static bool hasOnlyAlphaComponent(const SkPaint& paint);

    template <class T>
    static GL_Ptr<T> cloneProto(T& oldT) {
        GL_Ptr<T> newT = std::make_shared<T>();
        newT->CopyFrom(oldT);
        return newT;
    }
};
}
}
#endif