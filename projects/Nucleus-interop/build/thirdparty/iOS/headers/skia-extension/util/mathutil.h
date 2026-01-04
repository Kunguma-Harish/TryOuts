/**
 * @file mathutil.h
 * @brief routines for common convertion used by shape framework
 */
#pragma once

#include <cmath>

namespace mathutil {

#define kBLUR_SIGMA_SCALE 0.57735f
#define MATH_UTIL_PI 3.14159265358979323846f

static constexpr float radiusToSigma(float radius) {
    return radius > 0 ? kBLUR_SIGMA_SCALE * radius + 0.5f : 0.0f;
}

static constexpr float degreesToRadians(float angle) {
    return (angle * MATH_UTIL_PI) / 180.0f;
}

static constexpr float absAngle(float angle) {
    int t = angle / 360;
    angle -= 360 * t;
    if (angle < 0)
        angle += 360;
    return angle;
}

static constexpr float radiansToDegrees(float radian) {
    return absAngle(radian * (180 / MATH_UTIL_PI));
}

static float angleOfLine(float x0, float y0, float x1, float y1) {
    double degree = atan2(y1 - y0, x1 - x0);
    return radiansToDegrees(degree);
}

static float getPositiveAngle(float value) { //fmod is a non-constexpr fn , cannot be used under constexpr expression
    value = fmod(value, 360);
    if (value < 0)
        value += 360;
    return value;
}

static constexpr float min(float num1, float num2) {
    if (num1 < num2) {
        return num1;
    } else {
        return num2;
    }
}

static void swap(float& a, float& b) {
    float temp = a;
    a = b;
    b = temp;
}

static float roundOff(float value, int decimal) {
    float pow_10 = pow(10.0f, (float)decimal);
    return round(value * pow_10) / pow_10;
}

// will prevent leakage of #defines
#undef kBLUR_SIGMA_SCALE
}
