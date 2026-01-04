#ifndef __NL_EDITORPROPERTIES_H
#define __NL_EDITORPROPERTIES_H
#include <app/ZShapeModified.hpp>
#include <app/NLEditingLayers.hpp>

namespace com {
namespace zoho {
namespace shapes {
class TextBody;
}
}
}

struct NLEditorProperties {
    std::shared_ptr<ZShapeModified> shapeModified = nullptr;
    std::shared_ptr<NLEditingLayers> editingLayers = nullptr;
};

#endif