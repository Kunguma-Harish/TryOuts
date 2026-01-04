#ifndef PRESET_PAINTER_HPP
#define PRESET_PAINTER_HPP

#include <string>
#include <skia-extension/GLRect.hpp>
#include <skia-extension/GLPath.hpp>
#include <painter/PathInfo.hpp>
#include <cfloat>


namespace com {
namespace zoho {
namespace shapes {
class Preset;
class Stroke;
}
}
}

namespace Show {
enum StrokeField_MarkerType : int;
enum StrokeField_Size : int;
enum StrokeField_CapType : int;
}

namespace google {
namespace protobuf {
template <typename T>
class RepeatedField;
}
}

class SkPath;

struct ZeroCheckValue {
    float width;
    float height;
    google::protobuf::RepeatedField<float>* modifiers;
};

struct PathPoint {
    char type;
    std::vector<float> points;
};

namespace graphikos {
namespace painter {
class PresetPainter {
private:
    const com::zoho::shapes::Preset* preset = nullptr;
    const com::zoho::shapes::Stroke* stroke = nullptr; // needed for draw headend/tailend arrows for connector path

public:
    PresetPainter(const com::zoho::shapes::Preset* preset);
    PresetPainter(const com::zoho::shapes::Preset* preset, const com::zoho::shapes::Stroke* stroke);

    PathInfo path(const GLRect& frame, bool withoutReduction = false);

    PathInfo foldedCorner(const GLRect& frame);
    PathInfo cube(const GLRect& frame);
    PathInfo donut(const GLRect& frame);
    PathInfo bevel(const GLRect& frame);
    PathInfo rect(const GLRect& frame, bool isCallout = false);
    PathInfo oval(const GLRect& frame);
    PathInfo pentagon(const GLRect& frame);
    PathInfo triangle(const GLRect& frame);
    PathInfo line(const GLRect& frame, bool withoutReduction = false);

    GLPath nPointStar(int n, float radius);
    PathInfo star(const GLRect& frame);
    PathInfo fivePointStar(const GLRect& frame);

    PathInfo polygon(const GLRect& frame);
    GLPath ngon(int n);

    PathInfo roundCorneredRectWith4Sides(const GLRect& frame, float topLeft = 0, float bottomLeft = 0, float topRight = 0, float bottomRight = 0); // rounded cornor rect getting path for 4 different borders

    // different types of rect rendering options.
    PathInfo roundCorneredRect(const GLRect& frame, float topLeft = 0, float bottomLeft = 0, float topRight = 0, float bottomRight = 0, bool isCallout = false);
    PathInfo angleCorneredRect(const GLRect& frame, float topLeft = 0, float bottomLeft = 0, float topRight = 0, float bottomRight = 0);
    PathInfo smoothCorneredRect(const GLRect& frame, float topLeft = 0, float bottomLeft = 0, float topRight = 0, float bottomRight = 0, float cornerSmooth = 0, float maxRadius = 0); // requires smoothness value and maxRadius value from proto.
    PathInfo insideSquareCorneredRect(const GLRect& frame, float topLeft = 0, float bottomLeft = 0, float topRight = 0, float bottomRight = 0);
    PathInfo insideArcCorneredRect(const GLRect& frame, float topLeft = 0, float bottomLeft = 0, float topRight = 0, float bottomRight = 0);

    PathInfo diamond(const GLRect& frame);
    PathInfo lshape(const GLRect& frame);
    PathInfo right_arrow(const GLRect& frame);
    PathInfo elbow_connector_2(const GLRect& frame);
    PathInfo elbow_connector_3(const GLRect& frame);
    PathInfo elbow_connector_4(const GLRect& frame);
    PathInfo elbow_connector_5(const GLRect& frame);

    PathInfo curved_connector_2(const GLRect& frame);
    PathInfo curved_connector_3(const GLRect& frame);
    PathInfo curved_connector_4(const GLRect& frame);
    PathInfo curved_connector_5(const GLRect& frame);

    std::vector<PathPoint> getPathPoints(const GLRect& frame);
    std::vector<PathPoint> line_points(const GLRect& frame);
    float differenceCalc(float point1, float point2, float cornerRadius);
    std::vector<PathPoint> elbow_connector_2_points(const GLRect& frame);
    std::vector<PathPoint> elbow_connector_4_points(const GLRect& frame);
    std::vector<PathPoint> elbow_connector_3_points(const GLRect& frame);
    std::vector<PathPoint> elbow_connector_5_points(const GLRect& frame);

    std::vector<PathPoint> curved_connector_2_points(const GLRect& frame);
    std::vector<PathPoint> curved_connector_3_points(const GLRect& frame);
    std::vector<PathPoint> curved_connector_4_points(const GLRect& frame);
    std::vector<PathPoint> curved_connector_5_points(const GLRect& frame);
    PathInfo pathPoints_to_path(const GLRect& frame, std::vector<PathPoint>& pathPoints);

    void getReducedPath(std::vector<PathPoint>& pathPoints);

    PathInfo rounded_rectangular_callout(const GLRect& frame);
    PathInfo lock_symbol(const GLRect& frame);
    PathInfo frame(const GLRect& frame);

    void getCurve(float startX, float startY, float endX, float endY, bool anticlockwise, bool largearc, GLPath& path);

    GLPath getPathWithRadius(const GLRect& frame, const GLPath& path, float cornerRadius);

    ZeroCheckValue zeroCheck(google::protobuf::RepeatedField<float>* modifiers, float maxX, float maxY);

    GLPath getMarker(const com::zoho::shapes::Stroke* stroke, GLRect rect, bool isHeadEnd, std::vector<PathPoint>& pathPoints);

    GLPath getMarkerPath(Show::StrokeField_MarkerType markerType, float width, float height, float miterLength, bool isHeadEnd, GLRect rect, float orientation, std::map<std::string, float> reduction);
    float getMarkerClippedPath(int marker, float reduction, std::vector<PathPoint>& pathArr);
    float getMarkerArrowSize(Show::StrokeField_Size arrowSize);
    float getMiterLength(float mw, float mh);
    std::map<std::string, float> getReduction(Show::StrokeField_MarkerType markerType, float strokeWidth, float width, float height, float miterLength, bool isHeadEnd, Show::StrokeField_CapType capType);

    void drawBracket(GLPath& path, float left, float top, float x1, float x2, float y0, float y1, float y2, float y3);
    void drawBrace(GLPath& path, float left, float top, float x0, float x1, float x2, float y0, float y1, float y2, float y3, float y4, float y5, float y);
    PathInfo computeCallout(const GLRect& frame, int callNum, bool accent, bool hasBorder = false);

    PathInfo parallelogram(const GLRect& frame);
    PathInfo ovalCallout(const GLRect& frame);
    PathInfo sevenPointStar(const GLRect& frame);
    PathInfo eightPointStar(const GLRect& frame);
    PathInfo wave(const GLRect& frame);
    PathInfo flowChartDocument(const GLRect& frame);
    PathInfo data(const GLRect& frame);
    PathInfo terminator(const GLRect& frame);
    PathInfo preparation(const GLRect& frame);
    PathInfo manualInput(const GLRect& frame);
    PathInfo offPageConnector(const GLRect& frame);
    PathInfo delay(const GLRect& frame);
    PathInfo sequentialAccessStorage(const GLRect& frame);
    PathInfo display(const GLRect& frame);
    PathInfo bentArrow(const GLRect& frame);
    PathInfo uTurnArrow(const GLRect& frame);
    PathInfo leftUpArrow(const GLRect& frame);
    PathInfo bentUpArrow(const GLRect& frame);
    PathInfo curvedRightArrow(const GLRect& frame);
    PathInfo notchedRightArrow(const GLRect& frame);
    PathInfo pentagonArrow(const GLRect& frame);
    PathInfo chevron(const GLRect& frame);
    PathInfo punchedCard(const GLRect& frame);
    PathInfo magneticDisk(const GLRect& frame);
    PathInfo snipSameSideRect(const GLRect& frame);
    PathInfo snipDiagonalRect(const GLRect& frame);
    PathInfo roundDiagonalRect(const GLRect& frame);
    PathInfo trapezoid(const GLRect& frame);
    PathInfo hexagon(const GLRect& frame);
    PathInfo pie(const GLRect& frame);
    PathInfo tearDrop(const GLRect& frame);
    PathInfo heart(const GLRect& frame);
    PathInfo Or(const GLRect& frame);
    PathInfo octagon(const GLRect& frame);
    PathInfo punchedTape(const GLRect& frame);
    PathInfo snipSingleRect(const GLRect& frame);
    PathInfo snipRoundSingleRect(const GLRect& frame);
    PathInfo roundSingleRect(const GLRect& frame);
    PathInfo roundSameSideRect(const GLRect& frame);
    PathInfo rightTriangle(const GLRect& frame);
    PathInfo heptagon(const GLRect& frame);
    PathInfo decagon(const GLRect& frame);
    PathInfo chord(const GLRect& frame);
    PathInfo halfFrame(const GLRect& frame);
    PathInfo diagonalStripe(const GLRect& frame);
    PathInfo cross(const GLRect& frame);
    PathInfo plaque(const GLRect& frame);
    PathInfo can(const GLRect& frame);
    PathInfo noSymbol(const GLRect& frame);
    PathInfo blockArc(const GLRect& frame);
    PathInfo smiley(const GLRect& frame);
    PathInfo lightningBolt(const GLRect& frame);
    PathInfo sun(const GLRect& frame);
    PathInfo moon(const GLRect& frame);
    PathInfo cloud(const GLRect& frame);
    PathInfo arc(const GLRect& frame);
    PathInfo doubleBracket(const GLRect& frame);
    PathInfo doubleBrace(const GLRect& frame);
    PathInfo leftBracket(const GLRect& frame);
    PathInfo rightBracket(const GLRect& frame);
    PathInfo leftBrace(const GLRect& frame);
    PathInfo rightBrace(const GLRect& frame);
    PathInfo clock(const GLRect& frame);
    PathInfo upDownArrow(const GLRect& frame);
    PathInfo leftRightArrow(const GLRect& frame);
    PathInfo quadArrow(const GLRect& frame);
    PathInfo leftArrow(const GLRect& frame);
    PathInfo upArrow(const GLRect& frame);
    PathInfo downArrow(const GLRect& frame);
    PathInfo leftRightUpArrow(const GLRect& frame);
    PathInfo curvedLeftArrow(const GLRect& frame);
    PathInfo curvedUpArrow(const GLRect& frame);
    PathInfo curvedDownArrow(const GLRect& frame);
    PathInfo stripedRightArrow(const GLRect& frame);
    PathInfo rightArrowCallout(const GLRect& frame);
    PathInfo leftArrowCallout(const GLRect& frame);
    PathInfo upArrowCallout(const GLRect& frame);
    PathInfo downArrowCallout(const GLRect& frame);
    PathInfo leftRightArrowCallout(const GLRect& frame);
    PathInfo quadArrowCallout(const GLRect& frame);
    PathInfo preDefinedProcess(const GLRect& frame);
    PathInfo internalStorage(const GLRect& frame);
    PathInfo multiDocument(const GLRect& frame);
    PathInfo manualOperation(const GLRect& frame);
    PathInfo summingJunction(const GLRect& frame);
    PathInfo collate(const GLRect& frame);
    PathInfo sort(const GLRect& frame);
    PathInfo extract(const GLRect& frame);
    PathInfo merge(const GLRect& frame);
    PathInfo storedData(const GLRect& frame);
    PathInfo directAccessStorage(const GLRect& frame);
    PathInfo plus(const GLRect& frame);
    PathInfo minus(const GLRect& frame);
    PathInfo multiply(const GLRect& frame);
    PathInfo divide(const GLRect& frame);
    PathInfo equal(const GLRect& frame);
    PathInfo notEqual(const GLRect& frame);
    PathInfo explosion1(const GLRect& frame);
    PathInfo explosion2(const GLRect& frame);
    PathInfo fourPointStar(const GLRect& frame);
    PathInfo sixPointStar(const GLRect& frame);
    PathInfo tenPointStar(const GLRect& frame);
    PathInfo twelvePointStar(const GLRect& frame);
    PathInfo sixteenPointStar(const GLRect& frame);
    PathInfo twentyFourPointStar(const GLRect& frame);
    PathInfo thirtyTwoPointStar(const GLRect& frame);
    PathInfo upRibbon(const GLRect& frame);
    PathInfo downRibbon(const GLRect& frame);
    PathInfo curvedUpRibbon(const GLRect& frame);
    PathInfo curvedDownRibbon(const GLRect& frame);
    PathInfo verticalScroll(const GLRect& frame);
    PathInfo horizontalScroll(const GLRect& frame);
    PathInfo doubleWave(const GLRect& frame);
    PathInfo borderCallout1(const GLRect& frame);
    PathInfo borderCallout2(const GLRect& frame);
    PathInfo borderCallout3(const GLRect& frame);
    PathInfo rectangularCallout(const GLRect& frame);
    PathInfo cloudCallout(const GLRect& frame);
    PathInfo accentCallout1(const GLRect& frame);
    PathInfo accentCallout2(const GLRect& frame);
    PathInfo accentCallout3(const GLRect& frame);
    PathInfo callout1(const GLRect& frame);
    PathInfo callout2(const GLRect& frame);
    PathInfo callout3(const GLRect& frame);
    PathInfo accentBorderCallout1(const GLRect& frame);
    PathInfo accentBorderCallout2(const GLRect& frame);
    PathInfo accentBorderCallout3(const GLRect& frame);
    PathInfo actionPrevious(const GLRect& frame);
    PathInfo actionNext(const GLRect& frame);
    PathInfo actionBegin(const GLRect& frame);
    PathInfo actionEnd(const GLRect& frame);
    PathInfo actionHome(const GLRect& frame);
    PathInfo actionInformation(const GLRect& frame);
    PathInfo actionReturn(const GLRect& frame);
    PathInfo actionMovie(const GLRect& frame);
    PathInfo actionDocument(const GLRect& frame);
    PathInfo actionSound(const GLRect& frame);
    PathInfo actionHelp(const GLRect& frame);
    PathInfo actionCustom(const GLRect& frame);
    PathInfo roundDiamond(const GLRect& frame);
    PathInfo dfdExternalEntity1(const GLRect& frame);
    PathInfo erdAssociativeEntity(const GLRect& frame);
};
}
}
#endif