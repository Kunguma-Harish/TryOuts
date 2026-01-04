#pragma once

#include <include/utils/SkTextUtils.h>
#include <string>

namespace graphikos {
namespace painter {
class ParaStyleHelper {
public:
    ParaStyleHelper();
    SkTextUtils::Align getAlignment();
    std::string getFontId();
};
}
}