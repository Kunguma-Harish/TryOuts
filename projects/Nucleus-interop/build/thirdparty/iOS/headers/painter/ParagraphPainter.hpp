#ifndef __SHAPESPAINTER_PARAGRAPH_PAINTER
#define __SHAPESPAINTER_PARAGRAPH_PAINTER

#include <painter/IProvider.hpp>
#include <skia-extension/GLRect.hpp>

#include <painter/text/Paragraph.h>
#include <painter/DrawingContext.hpp>
#include <painter/IProvider.hpp>
#include <painter/GL_Ptr.h>

namespace com {
namespace zoho {
namespace shapes {
class Paragraph;
}
namespace common {
class Spacing_SpacingValue;
}
}
}

class SkFont;

namespace graphikos {
namespace painter {
class ParagraphPainter {
private:
    com::zoho::shapes::Paragraph* paragraph = nullptr;

    static float textOffsetx;
    static float textOffsety;
    std::string getRawString(bool casedString);
    std::string getPortionTypeContent();

public:
    ParagraphPainter(com::zoho::shapes::Paragraph* _paragraph);
    /**
     * @brief Converts com::zoho::shapes::TextBody to GLParagraph
     * @param provider
     * @param fullLayout If set to false, will layout uptill drawingContext->frame
     * @return GLParagraph
     */
    graphikos::painter::text::Paragraph getParagraph(IProvider* provider);

    SkFont getFont();
    std::shared_ptr<com::zoho::shapes::ParaStyle> getMergedParaStyle(graphikos::painter::IProvider* provider);
    void draw(GL_Ptr<DrawingContext> dc);
    float getLineSpacing(const com::zoho::common::Spacing_SpacingValue& spacingValue);
};
}
}
#endif
