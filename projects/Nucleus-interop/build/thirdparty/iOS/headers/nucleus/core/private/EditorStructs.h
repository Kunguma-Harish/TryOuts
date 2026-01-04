#ifndef __NL_EDITORSTRUCTS_H
#define __NL_EDITORSTRUCTS_H

#include <vector>
#include <skia-extension/GLPoint.hpp>

#include <fields.pb.h>
#include <shapeobject.pb.h>
#include <offset.pb.h>
#include <transform.pb.h>

struct CompareGLPoint {
    graphikos::painter::GLPoint center;
    CompareGLPoint(graphikos::painter::GLPoint cPoint) {
        center = cPoint;
    };
    bool operator()(const graphikos::painter::GLPoint& start,
                    const graphikos::painter::GLPoint& end) {
        if (start.fX - center.fX >= 0 && end.fX - center.fX < 0) {
            return true;
        }
        if (start.fX - center.fX < 0 && end.fX - center.fX >= 0) {
            return false;
        }
        if (start.fX - center.fX == 0 && end.fX - center.fX == 0) {
            if (start.fY - center.fY >= 0 || end.fY - center.fY >= 0) {
                return start.fY > end.fY;
            }
            return end.fY > start.fY;
        }

        // compute the cross product of vectors (center -> a) x (center -> b)
        float det = (start.fX - center.fX) * (end.fY - center.fY) - (end.fX - center.fX) * (start.fY - center.fY);
        if (det < 0) {
            return true;
        }
        if (det > 0) {
            return false;
        }

        // points a and b are on the same line from the center
        // check which point is closer to the center
        float dist1 = std::sqrt(std::pow((center.fX - start.fX), 2) + std::pow((center.fY - start.fY), 2));
        float dist2 = std::sqrt(std::pow((center.fX - end.fX), 2) + std::pow((center.fY - end.fY), 2));
        return dist1 > dist2;
    };
};

struct ZShapeRecognitionData {
    bool isRecognized;
    std::vector<graphikos::painter::GLPoint> originalPathArray;
    std::vector<graphikos::painter::GLPoint> pathArray;
    com::zoho::common::Position* position;
    com::zoho::common::Dimension* dimension;
    std::vector<graphikos::painter::GLPoint> corners;
    float errorDistance;
    Show::GeometryField_PresetShapeGeometry shapeType;
    com::zoho::common::Position* newPosition;
    com::zoho::common::Dimension* newDimension;
    float rotation = 0;
    std::vector<graphikos::painter::GLPoint> bboxCorners;
    google::protobuf::RepeatedField<float>* modifiers;
};

struct ZPromisingReferData {
    int parsedIndex;
    graphikos::painter::GLPoint point;
};

struct ZShapeLine {
    float slope;
    graphikos::painter::GLPoint start;
    graphikos::painter::GLPoint end;
};

#endif
