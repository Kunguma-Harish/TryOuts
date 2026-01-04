#pragma once

#include <skia-extension/GLRect.hpp>

namespace com {
namespace zoho {
namespace shapes {
class Effects_Reflection;
}
}
}

class SkCanvas;

namespace graphikos {
namespace painter {
class ReflectionPainter {
private:
    com::zoho::shapes::Effects_Reflection* reflection = nullptr;

public:
    ReflectionPainter(com::zoho::shapes::Effects_Reflection* reflection);
    void draw(SkCanvas* canvas, GLRect frame, float start, float end);
};
}
}