#include <functional>

#include "include/patch/TextUtil.h"
#include "modules/skparagraph/src/TextLine.h"
#include "modules/skparagraph/src/ParagraphImpl.h"

using namespace skia::textlayout;

std::pair<TextLine*, size_t> TextUtil::getTextLinesFromParagraph(Paragraph* paragraph) {
    ParagraphImpl* paraImpl = static_cast<ParagraphImpl*>(paragraph);
    return std::pair<TextLine*, size_t>(paraImpl->fLines.data(), paraImpl->fLines.size());
}

