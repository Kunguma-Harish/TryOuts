#pragma once

#include <skia-extension/GLPath.hpp>
#include <skia-extension/GLRect.hpp>

namespace com {
namespace zoho {
namespace shapes {
class CustomGeometry;
class CustomGeometry_Path;
class PathObject;
class Point;
}
}
}

namespace google {
namespace protobuf {
template <typename T>
class RepeatedPtrField;
}
}

namespace graphikos {
namespace painter {
class CustomGeometryPainter {
private:
    com::zoho::shapes::CustomGeometry* customGeometry = nullptr;

public:
    CustomGeometryPainter(com::zoho::shapes::CustomGeometry* _customGeometry);
    GLPath glPathWithRadius(GLRect frame);
    GLPath glPathWithoutRadius(GLRect frame);

    void transform(GLRect rect);

    GLPath patternGlPath();
    GLPath patternGlPaths(google::protobuf::RepeatedPtrField<com::zoho::shapes::CustomGeometry_Path>* pathlist);

    GLPath glPaths(google::protobuf::RepeatedPtrField<com::zoho::shapes::CustomGeometry_Path>* pathlist);
    GLPath roundedGLPaths(google::protobuf::RepeatedPtrField<com::zoho::shapes::CustomGeometry_Path>* pathlist, GLRect frame);
    GLPath glpath(google::protobuf::RepeatedPtrField<com::zoho::shapes::CustomGeometry_Path>* pathlist, GLRect frame);

    com::zoho::shapes::CustomGeometry applying(SkMatrix matrix);

    GLPath getRawPath();
    GLPath getRawPath(google::protobuf::RepeatedPtrField<com::zoho::shapes::CustomGeometry_Path>* pathlist);
};

class PathPainter {
private:
    com::zoho::shapes::CustomGeometry_Path* _path = nullptr;

public:
    PathPainter(com::zoho::shapes::CustomGeometry_Path* customGeometryPath);
    GLPath path();
    GLPath glPath();
    GLPath* glPaths();
    GLPath patternGlPath();
};

class PointPainter {
private:
    com::zoho::shapes::Point* _point = nullptr;

public:
    PointPainter(com::zoho::shapes::Point* _point);
    GLPoint point();
    GLPoint point(float width, float height);
    GLPoint point(SkMatrix scaleMatrix) {
        if (scaleMatrix.isIdentity())
            return this->point();
        return this->point().applying(scaleMatrix);
    }
};
}
}
