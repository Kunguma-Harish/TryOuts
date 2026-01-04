#pragma once
#include <string>
#include <include/core/SkPaint.h>
#include <include/core/SkPoint.h>

namespace graphikos {
namespace painter {
namespace text {
struct Shadow {
    bool isOuter;
    SkPaint shadowPaint;
    float radius;
    float blur;
    SkPoint offset;
};

struct TextStyle {
    std::string fontName;
    int fontWeight;
    float fontSize;
    bool underline;
    bool strikethrough;
    float baseline;
    SkPaint fillPaint;
    SkPaint strokePaint;
    Shadow shadow;
};
}
}
}