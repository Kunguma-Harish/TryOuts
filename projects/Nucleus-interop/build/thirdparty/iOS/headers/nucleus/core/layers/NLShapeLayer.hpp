#ifndef __NL_SHAPELAYER_H
#define __NL_SHAPELAYER_H

#include <nucleus/core/layers/NLLayer.hpp>
#include <skia-extension/GLPath.hpp>
#include <skia-extension/GLRect.hpp>

struct ShapeProperties {
    std::string shapeId = "";
    bool retain_scale = false;
    bool retain_strokeWidth = false;
    SkPaint paint;
    graphikos::painter::GLPath path;
    graphikos::painter::GLPoint offset;
    graphikos::painter::GLRect restrictorRect = graphikos::painter::GLRect();
    graphikos::painter::GLRect cullRect = graphikos::painter::GLRect();
    float selectionOffset = 0;
    ShapeProperties(graphikos::painter::GLPath path, SkPaint paint, bool retain_scale = false, bool retain_strokeWidth = false, graphikos::painter::GLPoint offset = graphikos::painter::GLPoint(0, 0), std::string shapeId = "", graphikos::painter::GLRect restrictorRect = graphikos::painter::GLRect(), graphikos::painter::GLRect cullRect = graphikos::painter::GLRect(), float selectionOffset = 0);
};

class NLShapeLayer : public NLLayer {
private:
    std::vector<ShapeProperties> dirtyShapes;
    std::vector<ShapeProperties> shapes;
    void applyMatrixOnShape(ShapeProperties* shape, const SkMatrix& totalMatrix);
    graphikos::painter::GLRect getDirtyRectFromData(const SkMatrix& parentMatrix) override;

public:
    NLShapeLayer(NLLayerProperties* properties, graphikos::painter::GLRect viewPortRect, SkColor layerColor = SK_ColorTRANSPARENT);

    void onDataChange() override;
    bool onDraw(SkCanvas* canvas, NLDeferredDetails* dd, SkMatrix totalMatrix = SkMatrix(), bool applyContentScale = true) override;

    void addShapeProperties(ShapeProperties shape);
    bool deleteShapeProperty(size_t index);
    void emptyShapeProperties();
    int getShapeIndexFromId(std::string shapeId);
    std::string getShapeIdForPoint(const graphikos::painter::GLPoint& point, const SkMatrix& matrix); // returns shapeid of the shape the point is on , follows revrese draw order
    std::vector<ShapeProperties> getShapes();
    bool shouldPreventShapeRender(ShapeProperties shape, const SkMatrix& matrix);
    void updateShapePropertyByIndex(ShapeProperties shapeProp, size_t index);
};

#endif