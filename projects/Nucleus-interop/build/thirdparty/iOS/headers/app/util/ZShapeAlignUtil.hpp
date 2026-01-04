#ifndef __NL_ZSHAPEALIGNUTIL_H
#define __NL_ZSHAPEALIGNUTIL_H

#include <iostream>
#include <skia-extension/GLPoint.hpp>
#include <app/ZSelectionHandler.hpp>

namespace com {
namespace zoho {
namespace common {
class Dimension;
}
}
}
struct SortedPoints {
    float small;
    float big;
    std::string shapeId;
};

class ZShapeAlignUtil {
public:
    enum AlignType {
        NONE = 0,
        LEFT = 1,
        RIGHT = 2,
        TOP = 3,
        BOTTOM = 4,
        MIDDLE = 5,
        CENTER = 6,
        HORIZONTAL = 7,
        VERTICAL = 8
    };

    enum AlignTo {
        SHAPES = 0,
        SLIDES = 1
    };

    static float left(float pos, float left);
    static float right(float pos, float left, float w);
    static float top(float pos, float top);
    static float bottom(float pos, float top, float h);
    static float center(float pos, float left, float w, com::zoho::common::Dimension* dim);
    static float middle(float pos, float top, float h, com::zoho::common::Dimension* dim);

    static graphikos::painter::GLPoint alignProps(AlignType alignType, AlignTo alignTo, std::vector<SelectedShape>& shapes, graphikos::painter::IProvider* provider);
    static graphikos::painter::GLPoint alignShapeProps(AlignType alignType, std::vector<SelectedShape> shapes, graphikos::painter::IProvider* provider);
    static float position(const SelectedShape* shape, AlignType alignType, bool flag, graphikos::painter::IProvider* provider);
    static std::string positionId(const SelectedShape* shape, AlignType alignType);
    static std::pair<float, float> getParentContainerDim(SelectedShape shape);
    static std::vector<SortedPoints> sortedPosition(AlignType alignType, std::vector<SelectedShape> shapes, graphikos::painter::IProvider* provider);

    static bool compareByType(const SortedPoints& a, const SortedPoints& b) {
        return (a.small < b.small);
    };
};

#endif