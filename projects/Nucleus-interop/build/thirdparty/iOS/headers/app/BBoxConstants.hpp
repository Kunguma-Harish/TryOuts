#ifndef __NL_BBOXCONSTANTS_H
#define __NL_BBOXCONSTANTS_H

#include <painter/ShapeObjectPainter.hpp>
#include <string>

namespace asset {
enum class Type;
};

namespace com {
namespace zoho {
namespace shapes {
class ShapeObject;
}
}
}

class BBoxConstants {
public:
    static std::map<asset::Type, std::shared_ptr<com::zoho::shapes::ShapeObject>> bboxMap;
    static std::shared_ptr<com::zoho::shapes::ShapeObject> getDefaultValue(asset::Type type);
    static void initMap(asset::Type key, std::shared_ptr<com::zoho::shapes::ShapeObject> value) {
        BBoxConstants::bboxMap[key] = value;
    }
};

#endif