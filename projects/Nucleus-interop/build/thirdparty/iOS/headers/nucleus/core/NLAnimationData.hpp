#ifndef __NL_ANIMATIONDATA_H
#define __NL_ANIMATIONDATA_H

#include <functional>

//#include <include/core/SkCanvas.h>
//#include <include/core/SkImage.h>
#include <skia-extension/GLRect.hpp>
#include <skia-extension/GLPoint.hpp>
#include <skia-extension/GLPath.hpp>
#include <nucleus/core/NLAnimationType.hpp>

#define POS_NULL -1
using AnimFunc = std::function<void(float)>;

namespace NLAnimation {

struct AnimationEasing {
    enum EasingBase {
        NOT_SET = 0, // Default easing of specific animation will be set.
        LINEAR = 1,  // No Easing, follows linear motion.
        EASE_IN_CUBIC = 2,
        EASE_OUT_CUBIC = 3,
        EASE_IN_OUT_CUBIC = 4,
        EASE_IN_BACK = 5,
        EASE_OUT_BACK = 6,
        EASE_IN_QUAD = 7,
        EASE_OUT_QUAD = 8,
        EASE_IN_OUT_SINE = 9,
        EASE_OUT_CIRC = 10,
        EASE_OUT_BOUNCE = 11
    };
    EasingBase base;
    bool isSet() {
        return base != NOT_SET ? true : false;
    }
};

enum AnimationDirection : int {
    NO_DIRECTION_SET = 0,
    UP = 1,
    DOWN = 2,
    LEFT = 3,
    LEFT_UP = 4,
    LEFT_DOWN = 5,
    RIGHT = 6,
    RIGHT_UP = 7,
    RIGHT_DOWN = 8,
    IN = 9,
    IN_SLIGHTLY = 10,
    IN_FROM_CENTER = 11,
    IN_TO_BOTTOM = 12,
    OUT = 13,
    OUT_SLIGHTLY = 14,
    OUT_TO_CENTER = 15,
    OUT_FROM_BOTTOM = 16,
    HORIZONTAL = 17,
    VERTICAL = 18,
    ROTATE_ALONG = 19,
    ROTATE_BACK = 20
};

enum AnimationShape : int {
    NO_SHAPE_SET = 0,
    RECT = 1,
    OVAL = 2,
    PLUS = 3,
    DIAMOND = 4
};

}

class NLAnimationData {
    NLAnimation::AnimationDirection getDirectionEnum(std::string direction);

public:
    float delayStartTime = POS_NULL;
    float animStartTime = POS_NULL;
    graphikos::painter::GLRect start = graphikos::painter::GLRect();
    graphikos::painter::GLRect end = graphikos::painter::GLRect();
    SkMatrix matrix;
    float delay = 0;
    float duration = 0;
    bool inReverse = false; //To indicate animations that are exactly a reverse of another in time [easing's similarity doesn't matter].
    float previousValue = 0;
    //std::string animOption = "";
    //std::string animSubOption = "";
    graphikos::painter::GLPoint animValues = graphikos::painter::GLPoint(0, 0); //NOTE: Might consider using Float Array instead to support more than 2 animation values in future.
    NLAnimation::AnimationEasing easing;
    NLAnimation::AnimationDirection animDirection;
    NLAnimation::AnimationDirection animSubDirection;
    NLAnimation::AnimationShape animShape;
    NLAnimation::AnimationType animType;
    SkPath animPath = SkPath();
    SkMatrix canvasTranslate = SkMatrix();
    bool animationInProgress = false;
    bool detachLayer = false;

    /*
    float previousTransX, previousTransY; //TODO: MAYBE NEEDED TO KNOW WHERE THE LAST TRANSLATED X & Y VALUES ARE FOR SAKE OF CONTINUATION. IF SO, NEED TO UPDATE THESE VALUES IN ALL ANIMATION FUNCTIONS. ELSE REMOVE.
    SkPaint canvasPaint; //TODO: Check if needed in any of the animation types, else remove.
    */

    graphikos::painter::GLRect animBounds = graphikos::painter::GLRect();
    AnimFunc animFunc = nullptr;
    std::function<void()> animationStoppedCallBack = nullptr;
    std::function<void()> startAnimationCallBack = nullptr;

    void setAnimBounds(SkRect rect);

    void setAnimDirection(std::string direction);

    void setAnimSubDirection(std::string direction);

    void setAnimShape(std::string shape);

    void setAnimFunction(AnimFunc func);

    void setAfterAnimFunction(std::function<void()> func);

    void setAnimationStartCallback(std::function<void()> func);
};

#endif
