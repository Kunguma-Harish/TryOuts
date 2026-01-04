/**
 * Project Untitled
 */

#ifndef _SHAPER_H
#define _SHAPER_H

#include <vector>
#include <painter/text/TextItem.h>
#include <include/core/SkTextBlob.h>

namespace graphikos {
namespace painter {
namespace text {
struct Span {
    TextStyle* textStyle = nullptr;
    std::string text;
};

struct Line {
    std::vector<Span> spans;
    sk_sp<SkTextBlob> textBlob;
};

class Shaper {
private:
    float width;

public:
    /**
 * @param stack
 */
    std::vector<Line> shape(TextItems stack);
    void setWidth(float width);
};
}
}
}

#endif //_SHAPER_H