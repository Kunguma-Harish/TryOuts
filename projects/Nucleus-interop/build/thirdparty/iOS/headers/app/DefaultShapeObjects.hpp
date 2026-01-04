#pragma once

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

class DefaultShapeObjects {
public:
    static std::map<asset::Type, std::shared_ptr<com::zoho::shapes::ShapeObject>> defaultShapesMap;
    static void initMap(asset::Type key, std::shared_ptr<com::zoho::shapes::ShapeObject> value) {
        DefaultShapeObjects::defaultShapesMap[key] = value;
    }
};