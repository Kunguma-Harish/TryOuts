/**
 * Project Untitled
 */

#ifndef _PARAGRAPH_H
#define _PARAGRAPH_H

#include <vector>

#include <include/core/SkCanvas.h>

#include <painter/text/TextItem.h>
#include <painter/text/FontManager.h>
#include <painter/text/Shaper.h>

namespace graphikos {
namespace painter {
namespace text {
enum TextAlignment { START,
                     CENTER,
                     END,
                     JUSTIFY };
enum TextDirection { LTR,
                     RTL,
                     TTB,
                     RTTB };

struct ParagraphStyle {
    float lineHeight;
    TextAlignment textAlignment;
    TextDirection textDirection;
};
class Paragraph {
private:
    TextItems textStack;
    std::vector<Line> lines;
    std::shared_ptr<FontManager> fontMgr = nullptr;

public:
    SkPaint selectionFill;

    /**
 * @param paragraphStyle
 * @param fontMgr
 */
    Paragraph(std::shared_ptr<FontManager> fontMgr);

    /**
 * @param style
 */
    void pushStyle(TextStyle* style);

    /**
 * @param text
 */
    void pushString(std::string text);

    /**
 * @param width
 */
    void layout(float width);

    void pushString(const char* utf8, size_t utf8Size);

    /**
 * @param width
 * @param height
 * @param fromOffset
 */
    void layout(float width, float height, int fromOffset);

    /**
 * @param offset
 * @param length
 * @param utf8
 * @param utf8Size
 */
    void replaceString(int offset, int length, const char* utf8, size_t utf8Size);

    /**
 * @param offset
 * @param length
 * @param style
 */
    void replaceStyle(int offset, int length, TextStyle style);

    /**
 * @param offset
 * @param text
 */
    void insert(size_t offset, std::string text);

    /**
 * @param canvas
 * @param x
 * @param y
 */
    void paint(SkCanvas* canvas, int x, int y);
};
}
}
}
#endif //_PARAGRAPH_H