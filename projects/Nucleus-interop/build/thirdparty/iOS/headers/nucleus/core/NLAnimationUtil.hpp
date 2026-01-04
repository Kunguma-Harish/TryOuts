#ifndef __NL_ANIMATIONUTIL_H
#define __NL_ANIMATIONUTIL_H

#include <skia-extension/GLPath.hpp>
#include <skia-extension/GLRect.hpp>
#include <skia-extension/GLPoint.hpp>
#include <include/core/SkCanvas.h>
#include <include/core/SkImage.h>
#include <nucleus/core/NLAnimationData.hpp>

class NLAnimLayer;

class NLAnimationUtil {
private:
    static float getAnimValue(NLAnimationData* animdata, float duration, float currentAnimTime);
    static std::tuple<float, float> getTransXYvalue(NLAnimationData* animdata, float positionX, float transX, float positionY, float transY, graphikos::painter::GLRect screenRect); //calculating value to be translated for push and slide
    // static SkPaint getBackgroundPaint(graphikos::painter::GLRect cropRect, SkPaint color, bool isBlur); //for handling overlayprops
    static void applyTransform(NLAnimationData* animdata, NLAnimLayer* animLayer, SkMatrix mat, bool preConcat = true);

    // Animation Utils:
    static SkScalar getTotalLength(const SkPath& path);
    static bool getPointAngleAtLength(const SkPath& path, float distance, SkPoint* point, SkScalar* angle = nullptr);
    static graphikos::painter::GLPoint getRotatedValue(float angle, float x, float y, float cx, float cy);
    static std::map<std::string, graphikos::painter::GLPoint> getCornerPoints(
        const graphikos::painter::GLPoint pos, // {left, top}
        const graphikos::painter::GLPoint dim, // {width, height}
        float angle,
        const graphikos::painter::GLPoint* center = nullptr);
    static std::map<std::string, float> findMinMaxY(
        const graphikos::painter::GLPoint pos, // {left, top}
        const graphikos::painter::GLPoint dim, // {width, height}
        float angle,
        const graphikos::painter::GLPoint* center = nullptr);

    // Animations:
    static void transform(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationAppear(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationDisappear(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationFadeEntrance(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationFadeExit(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationFlyEntrance(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationFlyExit(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationPinWheelEntrance(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationPinWheelExit(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationBoomerangEntrance(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationBoomerangExit(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationBounceEntrance(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationBounceExit(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationDropEntrance(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationDropExit(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationFloatEntrance(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationFloatExit(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationPivotEntrance(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationPivotExit(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationCenterRevolveEntrance(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationCenterRevolveExit(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationExpand(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationContract(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationFlipEntrance(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationFlipExit(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationGrowTurn(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationShrinkTurn(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationSpinnerEntrance(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationSpinnerExit(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationSwivelEntrance(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationSwivelExit(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationZoomEntrance(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationZoomExit(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationCurvyFloatEntrance(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationCurvyFloatExit(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationCurveEntrance(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationCurveExit(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationRiseEntrance(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationSinkExit(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationOrbitalEntrance(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationOrbitalExit(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationSpiralEntrance(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationSpiralExit(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationWhipEntrance(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationWhipExit(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationCreditsEntrance(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationCreditsExit(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationFadedZoomEntrance(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationFadedZoomExit(NLAnimationData* animdata, NLAnimLayer* animLayer);

    //Masking-based animations:
    static void animationBlindsEntrance(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationBlindsExit(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationGeometricEntrance(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationGeometricExit(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationSplitEntrance(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationSplitExit(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationWipeEntrance(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationWipeExit(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationWheelEntrance(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationWheelExit(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationCheckersEntrance(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationCheckersExit(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationPeekEntrance(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationPeekExit(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationWedgeEntrance(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationWedgeExit(NLAnimationData* animdata, NLAnimLayer* animLayer);

    static void animationBounceEmphasis(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationFlashEmphasis(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationGrowEmphasis(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationPulseEmphasis(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationShakeEmphasis(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationSpinEmphasis(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationTeeterEmphasis(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationWaveEmphasis(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void animationShimmerEmphasis(NLAnimationData* animdata, NLAnimLayer* animLayer);

    static void animationPath(NLAnimationData* animdata, NLAnimLayer* animLayer);

    // Transitions:
    /*
    static void transitionPush(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void transitionFlip(NLAnimationData* animdata, NLAnimLayer* animLayer);
    static void transitionZoom(NLAnimationData* animdata, NLAnimLayer* animLayer);
    */

public:
    static void startAnimation(NLAnimationData* animdata, NLAnimLayer* animlayer);
    static void stopAnimation(NLAnimationData* animdata);
    static void animationStopped(NLAnimationData* animdata);
    static void animate(NLAnimationData* animdata, float time);
};

#endif
