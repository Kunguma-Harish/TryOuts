#pragma once

#include <include/effects/SkColorMatrix.h>

typedef uint32_t SkColor;

class GLColorMatrix : public SkColorMatrix {
private:
    GLColorMatrix(std::array<float, 20>& cMatrix);

public:
    GLColorMatrix();
    static GLColorMatrix makeBrightness(float val);
    static GLColorMatrix makeContrast(float val);
    static GLColorMatrix makeHue(float val);
    static GLColorMatrix makeAlpha(float scale, float trans);
    static GLColorMatrix makeWithColorTrans(SkColor color);

    void setAlphaf(float scale, float trans);
    void setAlpha(int value, float trans);
};