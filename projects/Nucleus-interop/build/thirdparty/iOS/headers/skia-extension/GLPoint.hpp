#pragma once

#include <iostream>
#include <include/core/SkPoint.h>

namespace com {
namespace zoho {
namespace shapes {
	class ShapeObject;
	class PathObject;
	class Point;
}
namespace common {
	class Position;
}
}
}

class SkMatrix;

namespace graphikos {
namespace painter {

struct GLPoint : public SkPoint {
    GLPoint(float p1, float p2);
    GLPoint();
    // GLPoint(com::zoho::common::Position* pos);
    // void set(com::zoho::shapes::Point* point) const;
    // void set(com::zoho::common::Position* pos) const;
    GLPoint rotate(const GLPoint& point, float degree) const;
    GLPoint mirror(const GLPoint& midPoint) const;
    float distance(const GLPoint& point) const;
    GLPoint applying(const SkMatrix& matrix) const;
    bool isNull() const;
	float getAngle() const;
    float getAngle(const GLPoint& point) const;
    GLPoint pointOnArc(float angle, float radius) const;
};

struct LineSegment {
    GLPoint start;
    GLPoint end;
    LineSegment();
    LineSegment(const GLPoint& start, const GLPoint& end);
    GLPoint length() const;
    float lineLength() const;

    float hLength() const;
    float vLength() const;
    GLPoint midPoint() const;
    GLPoint point(float t) const;
    float getAngle() const;
};

struct SmartLine {
    LineSegment line;
    bool dashed;
    int num = 0;
};
}
}