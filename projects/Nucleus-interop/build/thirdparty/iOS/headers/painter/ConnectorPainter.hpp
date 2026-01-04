#pragma once

#include <painter/ShapeObjectPainter.hpp>
#include <painter/TransformPainter.hpp>
#include <painter/IProvider.hpp>
#include <painter/DrawingContext.hpp>
#include <src/pathops/SkIntersections.h>

namespace com {
namespace zoho {
namespace shapes {
class Connector;
class TextBody;
class PointOnPath;
class Transform;
class Properties;
}
namespace common {
class Dimension;
}
}
}

namespace graphikos {
namespace painter {
class ConnectorPainter {
private:
    com::zoho::shapes::Connector* connector = nullptr;

public:
    ConnectorPainter(com::zoho::shapes::Connector* connector);
    void draw(const DrawingContext& dc);
    graphikos::painter::GLPath getConnectorPath(Matrices currentMatrices, IProvider* provider);
    static graphikos::painter::GLPoint getPointForPointOnPath(const com::zoho::shapes::PointOnPath& pointOnPath, const com::zoho::shapes::Transform& mergedTransform, const com::zoho::shapes::Properties& props);

    static GLPoint getFlippedRotatedPoint(GLPoint point, const com::zoho::shapes::Transform& shapeTransform);
    std::pair<com::zoho::shapes::Transform, GLPoint> getTransformForCustomTextBox(const com::zoho::shapes::TextBody& textBody, const com::zoho::common::Dimension& shapeSize);
    std::pair<com::zoho::shapes::Transform, GLPoint> getTransformForCustomTextBox(const com::zoho::shapes::TextBody& textBody, const com::zoho::common::Dimension& shapeDim, const com::zoho::shapes::Transform& mergedTransform);
    static std::shared_ptr<com::zoho::shapes::ShapeObject> getTextBodyAsShape(com::zoho::shapes::Transform& transform, com::zoho::shapes::TextBody& textBody);
    std::shared_ptr<com::zoho::shapes::ShapeObject> getTextBodyAsShape(com::zoho::shapes::TextBody& textBody, graphikos::painter::IProvider* provider);
    ShapeObjectsDetails getTextBodyInPoint(com::zoho::shapes::ShapeObject* connectorShapeObject, graphikos::painter::GLPoint point, const SelectionContext& sc);
};
}
}
