#ifndef __NL_RENDERUTIL_H
#define __NL_RENDERUTIL_H
#include <skia-extension/GLRegion.hpp>
#include <skia-extension/GLRect.hpp>
#include <painter/ShapeObjectPainter.hpp>
class RenderUtil {

public:
    static void renderPathInCanvas(float contentScale, int clarityScale, SkISize dimension, graphikos::painter::ShapeDetails shapedetails, bool isAspectRatio, SkCanvas* canvas = nullptr);
    static void renderShapeInCanvas(int canvasOffsetX, int canvasOffsetY, int clarityScale, SkISize dimension, graphikos::painter::ShapeDetails shapedetails, bool isAspectRatio, graphikos::painter::IProvider* provider, SkCanvas* canvas = nullptr);
};
#endif