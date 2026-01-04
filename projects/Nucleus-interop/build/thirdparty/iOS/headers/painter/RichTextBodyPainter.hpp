#pragma once

#include <painter/DrawingContext.hpp>
#include <painter/GL_Ptr.h>

namespace com {
namespace zoho {
namespace shapes {
class TextBody;
}
}
}

class RichTextBodyPainter {
private:
    com::zoho::shapes::TextBody* textBody = nullptr;

public:
    RichTextBodyPainter(com::zoho::shapes::TextBody* textbody, bool textbox);
    bool draw(GL_Ptr<DrawingContext> dc, com::zoho::shapes::Transform* transform, SkMatrix matrixWithoutScale);
};