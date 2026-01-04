#ifndef Z_PRESET_SHAPES_HPP
#define Z_PRESET_SHAPES_HPP

#include <map>
#include <vector>

namespace com {
namespace zoho {
namespace shapes {
namespace build {
class PresetShape;
}
}
}
}

namespace Show {
enum GeometryField_PresetShapeGeometry : int;
}

// #define PRESET_SHAPES_SIZE 201 //  GeometryField_PresetShapeGeometry total size

class ZPresetShapes {
public:
    static com::zoho::shapes::build::PresetShape& getPresetDefault(Show::GeometryField_PresetShapeGeometry type);
    static void addPresetShape(const com::zoho::shapes::build::PresetShape& presetShape, const Show::GeometryField_PresetShapeGeometry& type);

private:
    static com::zoho::shapes::build::PresetShape presetShapes[];
    static void setModifier(com::zoho::shapes::build::PresetShape& shape, std::vector<float> modifierValues);
    static void allocateHandles(com::zoho::shapes::build::PresetShape& shape, int handles, int handleValues);
};
#endif