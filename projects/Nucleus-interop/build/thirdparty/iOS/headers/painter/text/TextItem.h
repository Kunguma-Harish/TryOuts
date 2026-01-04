#pragma once

#include <painter/text/TextStyle.h>
#include <vector>

namespace graphikos {
namespace painter {
namespace text {
struct TextItem {
    TextStyle* textStyle = nullptr;
    const char* utf8;
    size_t utf8Size;

    TextItem(TextStyle* textStyle) : textStyle(textStyle) {}
    TextItem(const char* utf8, size_t utf8Size) : utf8(utf8), utf8Size(utf8Size) {}
};
using TextItems = std::vector<TextItem*>;
}
}
}
