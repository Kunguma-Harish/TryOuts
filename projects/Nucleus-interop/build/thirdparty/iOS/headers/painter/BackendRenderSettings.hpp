#pragma once

#include <painter/RenderSettings.hpp>

namespace graphikos {
namespace painter {
struct BackendRenderSettings {
    /* merge shaders before painting */
    bool enableShaderMerge = true;
};
}
}
