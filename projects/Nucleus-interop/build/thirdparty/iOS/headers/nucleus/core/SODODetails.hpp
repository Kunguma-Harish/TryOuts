#ifndef SCROLL_ON_DRAG_OVERFLOW_HPP
#define SCROLL_ON_DRAG_OVERFLOW_HPP
#include <include/core/SkMatrix.h>

#define SODO_EDGE 25
#define SODO_MAX_SPEED 5
#define SODO_MIN_SPEED 0.1

struct SODODetails { //Scroll On Drag Overflow Details
    SkMatrix matrix;
    SkMatrix prevViewMatrix;
    SkMatrix prevPointMatrix;
    float transX = 0;
    float transY = 0;
    float calculateSpeed(float distance) {
        if (distance >= SODO_EDGE) {
            return SODO_MIN_SPEED;
        } else if (distance <= 0) {
            return SODO_MAX_SPEED;
        } else {
            return SODO_MAX_SPEED - (SODO_MAX_SPEED - SODO_MIN_SPEED) * (distance / SODO_EDGE);
        }
    }
    void clear() {
        this->matrix.reset();
        this->prevViewMatrix.reset();
        this->prevPointMatrix.reset();
        this->transX = 0;
        this->transY = 0;
    }
};

#endif