#pragma once

#include <vector>

namespace Show {
enum GeometryField_PresetShapeGeometry : int;
}

class PresetConstants {
public:
    struct PresetDefault {
        std::vector<float> handles;
        std::vector<float> modifiers;
    };

    static PresetDefault get(Show::GeometryField_PresetShapeGeometry type);
};
