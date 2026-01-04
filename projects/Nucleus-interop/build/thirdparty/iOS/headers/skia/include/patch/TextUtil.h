#ifndef TextUtil_DEFINED
#define TextUtil_DEFINED




namespace skia {
namespace textlayout {
    class TextLine;
    class Paragraph;
}
}


class TextUtil {
public:
    static std::pair<skia::textlayout::TextLine*, size_t> getTextLinesFromParagraph(skia::textlayout::Paragraph* paragraph);
};

#endif