/**
 * @file mathutil.h
 * @brief routines for common convertion used by shape framework
 */
#pragma once

#include <cmath>
#include <vector>

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

static float cosTan(float x, float y, float z) {
    return x * std::cos(std::atan2(z, y));
}

static float sinTan(float x, float y, float z) {
    return x * std::sin(std::atan2(z, y));
}

static std::vector<float> toCubicControlPoints(float x1, float y1, float cx1, float cy1, float x2, float y2) {
    float val1 = 0.6667, val2 = 0.3333;
    float ccx1 = (val1 * cx1 + val2 * x1), ccy1 = (val1 * cy1 + val2 * y1);
    float ccx2 = (val1 * cx1 + val2 * x2), ccy2 = (val1 * cy1 + val2 * y2);

    return std::vector<float>{ccx1, ccy1, ccx2, ccy2};
}

static float ifElse(const float& x, const float& y, const float& z) {
    if (x > 0) {
        return y;
    }
    return z;
}

// will prevent leakage of #defines
#undef kBLUR_SIGMA_SCALE
}
