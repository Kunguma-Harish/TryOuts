#ifndef PROPERTIES_PAINTER_HPP
#define PROPERTIES_PAINTER_HPP

#include <skia-extension/GLCombinedPath.hpp>
#include <skia-extension/GLPath.hpp>
#include <painter/TransformPainter.hpp>
#include <painter/IProvider.hpp>
#include <painter/FieldsHelper.hpp>
#include <painter/DrawingContext.hpp>
#include <painter/PathInfo.hpp>

namespace com {
namespace zoho {
namespace shapes {
class Stroke;
class Properties;
class SolidFill;
class Effects;
class Effects_Shadow;
class ColorTweaks;
}
}
}

namespace google {
namespace protobuf {
template <typename T>
class RepeatedPtrField;
}
}

class SkCanvas;

namespace graphikos {
namespace painter {
class PropertiesPainter {
private:
    com::zoho::shapes::Properties* properties = nullptr;
    GLPath _getShapePath(bool withRadius, IProvider* provider, const Matrices& matrices, bool considerFill);
    GLCombinedPath _getShapePathFast(bool withRadius, IProvider* provider, const Matrices& matrices, bool considerFill);
    GLPath _getFillPath(const std::vector<GLPath>& path, bool withRadius, IProvider* provider, const Matrices& matrices, bool considerFill);
    void _getFillPath(const std::vector<GLPath>& path, GLCombinedPath& fillPath, bool withRadius, IProvider* provider, const Matrices& matrices, bool considerFill);
    GLPath _getStrokePath(const google::protobuf::RepeatedPtrField<com::zoho::shapes::Stroke>& strokes, const std::vector<GLPath>& path, bool withRadius, IProvider* provider, const Matrices& matrices);
    void _getStrokePath(const google::protobuf::RepeatedPtrField<com::zoho::shapes::Stroke>& strokes, GLCombinedPath& strokePath, const std::vector<GLPath>& path, bool withRadius, IProvider* provider, const Matrices& matrices);
    GLPath _getPropsRange(IProvider* provider, const Matrices& matrices);

public:
    PropertiesPainter(com::zoho::shapes::Properties* properties);
    void draw(const DrawingContext& dc, const google::protobuf::RepeatedPtrField<com::zoho::shapes::ColorTweaks>* groupFillTweaks = nullptr);
    void drawCombinedShape(const DrawingContext& dc, GLPath combinedShapePath);
    void drawStyle(const PathInfo& path, const DrawingContext& dc, const google::protobuf::RepeatedPtrField<com::zoho::shapes::ColorTweaks>* groupFillTweaks = nullptr);
    PathInfo transformedGLPath(bool withRadius, const Matrices& matrices, bool withoutReduction = false);
    GLPath glpathWithoutRadius();
    SkScalar getMaximumStrokeWidth();
    GLPath getShapePath(bool withRadius, IProvider* provider, const Matrices& matrices, bool considerFill = false);
    GLPath getStrokePath(bool withRadius, IProvider* provider, const Matrices& matrice);
    GLCombinedPath getShapePathFast(bool withRadius, IProvider* provider, const Matrices& matrices, bool considerFill = false);
    GLPath getPropsRange(IProvider* provider, const Matrices& matrices);
    GLPath getPropsRangeWithPath(IProvider* provider, const PathInfo& pathInfo, const Matrices& matrices);
    GLRect getRectFromShadow(com::zoho::shapes::Effects_Shadow* shadow, const GLRect& rect);
    void getMergedProps(com::zoho::shapes::Properties* props, com::zoho::shapes::Properties* mergedProps);
    std::map<std::string, GLPath> getMarkerPaths(const Matrices& matrices);
    SkMatrix getMarkerMatrix(Matrices matrices, const com::zoho::shapes::Transform& transform);

    void overrideData(const com::zoho::shapes::Properties& props);
    static GLPath GetSelectorPath(GLPath path, float offset);
    float getAllStrokeWidth();
};

class SolidFillPainter {
private:
    com::zoho::shapes::SolidFill* solidFill = nullptr;

public:
    SolidFillPainter(com::zoho::shapes::SolidFill* solidFill);
    void draw(SkCanvas* canvas);
};
}
}
#endif