
#pragma once
#include <app/util/ZEditorUtil.hpp>
#include <app/ZSelectionHandler.hpp>
#include <nucleus/core/layers/NLShapeLayer.hpp>
#include <nucleus/core/layers/NLTextLayer.hpp>

#include <app/util/ZEditorUtil.hpp>
#include <app/NLCacheBuilder.hpp>

class ObjectSnapper;
class RectInPoints;
enum SnapperHandle : int;

class SnappingHandler {
private:
    enum SnappingThreshold {
        LOW,
        MEDIUM,
        HIGH
    };
    double getSnappingRange(const SnappingThreshold SnappingThreshold);
    void drawXAtPoint(const SkPoint& point, const SkPaint& paint);
    void insertSnappingData(std::shared_ptr<ObjectSnapper> objectSnapper, const std::vector<SelectedShape>& selectedShapes, const graphikos::painter::GLRect& viewArea, NLCacheBuilder* cacheBuilder, bool considerSelectedShape = false);
    void insertSnappingDataWithoutConstraints(std::shared_ptr<ObjectSnapper> objectSnapper, const std::vector<SelectedShape>& selectedShapes, const graphikos::painter::GLRect& viewArea, NLCacheBuilder* cacheBuilder, bool considerSelectedShape = false);
    SnapperHandle getHandleFromCorner(const ZEditorUtil::BoxCorner corner);
    std::pair<double, double> getHeightWidth(const std::string heightWidthString);
    void drawRect(double x, double y, std::string heightWidthString);
    std::string getParentShapeId(std::string shapeId, NLCacheBuilder* cacheBuilder);
    RectInPoints getModifiedRect(graphikos::painter::GLRect& rect, const double angle, const com::zoho::shapes::Properties* props);

public:
    enum SnappingType {
        ONETOONE, // center point snaps with center points similarly for corner points
        ONETOMANY // center point and corner points snaps with each other
    };
    std::shared_ptr<ObjectSnapper> objectSnapper = nullptr;
    std::shared_ptr<ObjectSnapper> objectSnapperCenter = nullptr;
    std::shared_ptr<ObjectSnapper> objectSnapperCorner = nullptr;
    std::shared_ptr<NLLayer> snappingLayer = nullptr;
    std::shared_ptr<NLShapeLayer> snappingShapeLayer = nullptr;
    std::shared_ptr<NLTextLayer> snappingTextLayer = nullptr;
    SnappingType snappingType;
    bool isLayerAttached;

    SnappingHandler(bool includePosSnap, bool includeDimensionSnap, bool includeEquidistantSnap, bool includeVectorSnap, double magnification, SnappingType snappingType, std::shared_ptr<NLLayer> snappingLayer);
    void insertLineData(const com::zoho::shapes::Transform& transform, const SkMatrix& matrix, const graphikos::painter::GLRect& viewPort, const ZEditorUtil::EditType editType);
    graphikos::painter::GLPoint getSnappedPoint(const std::vector<SelectedShape>& selectedShapes, NLCacheBuilder* nlRenderTree, const com::zoho::shapes::Transform& transform, const graphikos::painter::GLPoint& startPoint, const graphikos::painter::GLPoint& endPoint, const graphikos::painter::GLRect& viewArea, float magnification, bool considerSelectedShape = false);
    graphikos::painter::GLPoint getSnappedPointForResize(const std::vector<SelectedShape>& selectedShapes, NLCacheBuilder* nlRenderTree, const com::zoho::shapes::Transform& transform, const ZEditorUtil::BoxCorner corner, const bool isFlipX, const bool isFlipY, const graphikos::painter::GLPoint& startPoint, const graphikos::painter::GLPoint& endPoint, const graphikos::painter::GLRect& viewArea, float magnification);
    void drawLines();
    void drawLine(const ObjectSnapper& objectSnapper);
    void drawDistantLine(const ObjectSnapper& objectSnapper);
    void drawDashedLine(const ObjectSnapper& objectSnapper);
    void attachToParent(NLLayer* parent);
    void removeLineData();
};