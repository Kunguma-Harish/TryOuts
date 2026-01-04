#ifndef __NL_ZTEXTEDITORUTIL_H
#define __NL_ZTEXTEDITORUTIL_H

#include <painter/IProvider.hpp>

namespace com {
namespace zoho {
namespace shapes {
class TextBody;
}
}
}

class ZTextEditorUtil {
public:
    static float calculateTextHeight(com::zoho::shapes::TextBody* textBody, com::zoho::shapes::Transform* transform, graphikos::painter::IProvider* provider);
};
#endif
