#ifndef __NL_FITTOSCREENUTIL_H
#define __NL_FITTOSCREENUTIL_H

#include <vector>
#include <include/core/SkMatrix.h>
#include <skia-extension/GLRect.hpp>
namespace graphikos {
namespace common {
class FitToScreenUtil {
public:
    enum FitType {
        DEFAULT_100_FIT = 0, // 100% display.
        CANVAS_FIT = 1,      // fits into canvas with ratio of 0.95.
        CANVAS_FULL_FIT = 2, // fits into canvas with ratio of 1.
        SCALE_FIT = 3,       // fits by using scale value in view->customScale.
        FILL_FIT = 4,        // fits by filling the content.
        CUSTOM_FIT = 5,      // fits by ratio given in view->customRatio=0.8.
        WIDTH_FIT = 6,       // fits to the width of sourceRect
        TOP_LEFT_FIT = 7     // fits the given rect to the top left of viewport
    };

    SkMatrix getFitToScreenMatrix(graphikos::painter::GLRect sourceRect, FitType fitType, graphikos::painter::GLRect visibleRect = graphikos::painter::GLRect(), float customScale = 1, float fitRatio = 0);
};
};
};
#endif