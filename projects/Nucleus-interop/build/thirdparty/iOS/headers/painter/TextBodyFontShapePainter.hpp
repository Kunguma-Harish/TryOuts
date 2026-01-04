#ifndef __SHAPESPAINTER_TEXTBODYFONTSHAPEPAINTER_H
#define __SHAPESPAINTER_TEXTBODYFONTSHAPEPAINTER_H

#include <skia-extension/GLRect.hpp>
#include <painter/IProvider.hpp>
#include <painter/TextBodyPainter.hpp>
#include <painter/DrawingContext.hpp>

namespace com {
namespace zoho {
namespace shapes {
class TextBody;
class Transform;
class FontShape;
class Portion_CharacterBox;
class FontShape_CharacterShape;
class FontShape_CharacterShape_PathList;
}
}
}

namespace google {
namespace protobuf {
template <typename T>
class RepeatedPtrField;
}
}

class SkCanvas;

namespace graphikos {
namespace painter {
class TextBodyFontShapePainter : public TextBodyPainter {
public:
    TextBodyFontShapePainter(com::zoho::shapes::TextBody* _textBody, bool textbox);
    bool getCombinedTextPath(GLPath& result, SkCanvas* canvas, SkMatrix matrix, const com::zoho::shapes::Transform& transform, SkPaint parentPaint, IProvider* provider);
    bool draw(const DrawingContext& dc, const com::zoho::shapes::Transform& transform, std::string shapeId, std::string cellId, com::zoho::shapes::Properties* props = nullptr);
    bool drawFillPath(SkCanvas* canvas, SkMatrix matrix, const com::zoho::shapes::Transform& transform, SkPaint parentPaint, IProvider* provider);
    GLRect getTextBoxFrame(GLRect rect);
    void drawPathList(const DrawingContext& dc, const com::zoho::shapes::Portion& portion, const google::protobuf::RepeatedPtrField<com::zoho::shapes::FontShape_CharacterShape_PathList>& pathList, IProvider* provider, float ratio, const com::zoho::shapes::Portion_CharacterBox& chBox, const com::zoho::shapes::Transform& transform, SkPaint parentPaint, GLRect* bounds = nullptr);
    bool drawEmoji(const DrawingContext& dc, const com::zoho::shapes::Portion& portion, const std::string& postscriptname, const com::zoho::shapes::FontShape_CharacterShape& characterShape, IProvider* provider, float ratio, const com::zoho::shapes::Portion_CharacterBox& chBox, const com::zoho::shapes::Transform& transform, SkPaint parentPaint, GLRect* bounds = nullptr);
};
}
}
#endif
