#ifndef __NL_ZBBOX_H
#define __NL_ZBBOX_H

#include <skia-extension/GLPath.hpp>
#include <include/core/SkMatrix.h>
#include <painter/ShapeObjectPainter.hpp>
#include <nucleus/core/layers/NLShapeLayer.hpp>
#include <nucleus/core/layers/NLInstanceLayer.hpp>
#include <app/BBoxConstants.hpp>
#include <app/util/BBoxUtils.hpp>
#include <app/util/ZEditorUtil.hpp>

struct SelectedShape;
struct BPath;

class ZBBox {
    std::shared_ptr<NLLayer> shapeLayersHolder = nullptr;        // for holding shapeSubLayer and shapeLayer in order
    std::shared_ptr<NLShapeLayer> shapeLayer = nullptr;          // for selected shape  max coverage for multiselection
    std::shared_ptr<NLShapeLayer> shapeSubLayer = nullptr;       // for parent shape , individual shape for multiselection
    std::shared_ptr<NLInstanceLayer> rotateIconLayer = nullptr;  // for rotate icon since its a group shape
    std::shared_ptr<NLInstanceLayer> resizerIconLayer = nullptr; // for rendering   table resizer box icon
    bool shapeSubLayerAttached = false;
    bool rotateIconLayerAttached = false;
    bool resizerIconLayerAttached = false;

    std::map<std::string, asset::Type> bboxes;

public:
    bool shapeLayerAttached = false;
    ZBBox();
    void setBBoxLayer(std::shared_ptr<NLLayer> shapeLayersHolder);
    void create(std::vector<SelectedShape>& selectedShapesInfos, ZEditorUtil::EditingData& eventData, NLDataController* dataHandler, bool isAltKey = false, com::zoho::shapes::Transform* _childTransform = nullptr);
    void refresh();
    void remove();
    std::shared_ptr<NLLayer> getBBoxShapeLayersHolder();
    void emptyBBoxShapeLayers();
    std::pair<ZEditorUtil::BoxCorner, bool> getBBoxCorner(const graphikos::painter::GLPoint& point, const SkMatrix& matrix);

    void applyEditValuesInBBoxBound(com::zoho::shapes::Transform& totalBounds, std::vector<SelectedShape>& selectedShapesInfos, ZEditorUtil::EditingData& eventData, graphikos::painter::IProvider* provider, bool multiSelect = false, BBoxUtils::ZBBoxOptions* bboxOptions = nullptr, bool isAltKey = false);

    std::map<std::string, asset::Type> getBBoxes(com::zoho::shapes::Transform bound, SkMatrix canvasMatrix, ZEditorUtil::EditingData& eventData, std::vector<SelectedShape>& selectedShapesInfos, graphikos::painter::IProvider* provider, bool isParentShape = false, BBoxUtils::ZBBoxOptions bboxOptions = BBoxUtils::ZBBoxOptions());

    void drawBBoxes(std::map<std::string, asset::Type> bboxes, com::zoho::shapes::Transform bound, const DrawingContext& dc, bool multiSelect = false, bool forSubLayer = false);
    void drawInnerShapeBbox(std::vector<SelectedShape>& selectedShapesInfos, ZEditorUtil::EditingData& eventData, const DrawingContext& dc);

    std::map<std::string, graphikos::painter::GLPoint> getBBoxPoints();

private:
    static std::string getCursor(std::string bboxName, float angle);
};

#endif
