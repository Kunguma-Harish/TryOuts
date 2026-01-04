#pragma once
#ifndef ContainerUtil_HPP
#define ContainerUtil_HPP

#include <skia-extension/GLPoint.hpp>
#include <include/core/SkMatrix.h>
class ContainerUtil {

public:
    static graphikos::painter::GLPoint getRotatedValue(float angle, graphikos::painter::GLPoint point, graphikos::painter::GLPoint center);
    static graphikos::painter::GLPoint getRotatedValue(float angle, float x, float y, float cx, float cy);
    static bool ifMatricesAreSame(const SkMatrix& lhs, const SkMatrix& rhs, float threshold = 0.001);
    static bool isMatrixAlmostIdentity(const SkMatrix& matrix, float threshold = 1e-6); // 1e-3 will be causing some failure in checks similarly 1e-12 will get into some unwanted small values which can cause issue. A tolerance of 1e-6 is small enough that it won’t significantly affect most practical use cases.
};

#endif // ContainerUtil_HPP