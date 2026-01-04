#pragma once

#include <string>
#include <skia-extension/GLRect.hpp>

namespace com {
namespace zoho {
namespace shapes {
class Portion;
}
}
}

class SkCanvas;

namespace graphikos {
namespace painter {
class PortionPainter {
private:
    com::zoho::shapes::Portion* portion = nullptr;
    std::string getRawString(bool casedString);
    std::string getPortionTypeContent();
    std::string getFormattedDate();

public:
    PortionPainter(com::zoho::shapes::Portion* portion);
    std::string getZeroWidthSpaceCharacter();
    void draw(SkCanvas* canvas, GLRect frame, float lineSpace, float* xoffset,
              float* yoffset);
    //
    std::string getString();
    GLRect getBounds();
};
}
}
