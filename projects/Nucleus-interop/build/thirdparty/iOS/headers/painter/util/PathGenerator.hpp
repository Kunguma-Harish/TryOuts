#pragma once

#include <vector>
#include <memory>

#include <skia-extension/GLRect.hpp>
#include <cfloat>

namespace com {
namespace zoho {
namespace shapes {
class Properties;
class Preset;
}
}
}

namespace google {
namespace protobuf {
template <typename T>
class RepeatedField;
}
}

namespace graphikos {
namespace painter {

struct ZPathObject {
    GLRect textbox;
    std::vector<std::vector<float>> connector;
    std::vector<std::vector<float>> handle;
};

class PathGenerator {
public:
    static float getCoordinates(float val, float maxX, float maxY, float maxPercent = 0.5, char maxType = 'n');
    static GLPoint getRectCoordinates(float modifier0, float modifier1, float maxX, float maxY);
    static std::vector<float> computeCurvedArrowValues(google::protobuf::RepeatedField<float>* modifiers, float maxX, float maxY, bool yVal = false, int selectedHandle = -1);
    static std::vector<float> computeCurvedArrowValues(const com::zoho::shapes::Preset* preset, float maxX, float maxY, bool yVal = false, int selectedHandle = -1);
    static GLRect getEllipseCoordinates(float angle1, float angle2, float rx, float ry, float midX = 0, float midY = 0);
    static graphikos::painter::GLPoint computeEllipticCoords(float rx, float ry, float startX, float startY, double startAngle, double sweepAngle);
    static std::vector<float> computeArrowValues(float width, float height, const com::zoho::shapes::Preset* preset);
    static std::vector<float> computeArrowValues(float width, float height, google::protobuf::RepeatedField<float>* modifiers, int selectedHandle = -1);
    static std::vector<float> computeArrowCalloutValues(float width, float height, const com::zoho::shapes::Preset* preset, bool isY = false, bool isLeftOrTop = false, bool isLeftRight = false, int selectedHandle = -1);
    static std::vector<float> computeArrowCalloutValues(float width, float height, google::protobuf::RepeatedField<float>* modifiers, bool isY = false, bool isLeftOrTop = false, bool isLeftRight = false, int selectedHandle = -1);
    static void computeCallout(float width, float height, const google::protobuf::RepeatedField<float>& modifiers, graphikos::painter::GLRect& textbox, std::vector<std::vector<float>>& handle, std::vector<std::vector<float>>& connector, int callNum);

    static std::vector<float> bentArrow(google::protobuf::RepeatedField<float>* modifiersData, float maxX, float maxY, int selectedHandle = -1);
    static std::vector<float> uTurnArrow(google::protobuf::RepeatedField<float>* modifiersData, float maxX, float maxY, int selectedHandle = -1);
    static std::vector<float> leftUpArrow(google::protobuf::RepeatedField<float>* modifiersData, float maxX, float maxY, int selectedHandle = -1);
    static std::vector<float> bentUpArrow(google::protobuf::RepeatedField<float>* modifiersData, float maxX, float maxY, int selectedHandle = -1);
    static std::vector<float> quadArrowCallout(google::protobuf::RepeatedField<float>* modifiersData, float maxX, float maxY, int selectedHandle = -1);
    static std::vector<float> divide(google::protobuf::RepeatedField<float>* modifiersData, float maxX, float maxY, int selectedHandle = -1);
    static std::vector<float> equal(google::protobuf::RepeatedField<float>* modifiersData, float maxX, float maxY, int selectedHandle = -1);
    static std::vector<float> notEqual(google::protobuf::RepeatedField<float>* modifiersData, float maxX, float maxY, int selectedHandle = -1);
    static std::vector<float> halfFrame(google::protobuf::RepeatedField<float>* modifiersData, float maxX, float maxY, int selectedHandle = -1);
    static std::vector<float> curvedUpRibbon(google::protobuf::RepeatedField<float>* modifiersData, float maxX, float maxY, int selectedHandle = -1);
    static std::vector<float> curvedDownRibbon(google::protobuf::RepeatedField<float>* modifiersData, float maxX, float maxY, int selectedHandle = -1);

    const static google::protobuf::RepeatedField<float>& getModifiers(const com::zoho::shapes::Preset* preset);
    static std::unique_ptr<ZPathObject> getPresetPathObject(float width, float height, com::zoho::shapes::Preset* preset);
    static std::unique_ptr<ZPathObject> getPathObject(com::zoho::shapes::Properties* props, GLRect mergedTransformRect = GLRect());
};
}
}
