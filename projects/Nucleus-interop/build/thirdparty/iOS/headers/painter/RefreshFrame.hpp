#pragma once

#include <painter/TransformPainter.hpp>
#include <painter/IProvider.hpp>
#include <skia-extension/GLPath.hpp>
#include <skia-extension/GLRect.hpp>

namespace com {
namespace zoho {
namespace shapes {
class Properties;
}
}
}

class SkMatrix;

namespace graphikos {
namespace painter {
class RefreshFrame {
public:
    static GLPath getRefreshFrame(com::zoho::shapes::Properties* props, SkMatrix currentMatrix, IProvider* provider);
};
}
}