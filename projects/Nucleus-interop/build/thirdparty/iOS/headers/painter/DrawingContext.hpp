#pragma once

#include <skia-extension/GLRegion.hpp>
#include <skia-extension/Matrices.hpp>
#include <painter/ZContext.hpp>
#include <painter/RenderSettings.hpp>

#include <iostream>
#include <functional>
#include <painter/GL_Ptr.h>

class SkCanvas;
class DeferredDetails;

/**
 * @brief DrawingContext will hold 'where to draw' and 'what to draw' information
 */

enum TriggerStatus {
    START = 0,
    END = 1,
    DEFAULT = 2,
    CAPTURE_TEXT = 3,
    CAPTURE_ERROR_LINE = 4,
    CAPTURE_CELL_DETAILS = 5

};

struct CurrentShapeInfo {
    std::shared_ptr<SkRect> bound; /* contains bound of current shape to be rendered*/
    std::string shapeId;
    CurrentShapeInfo() {
        bound = std::make_shared<SkRect>();
        shapeId = "";
    }

    void addBounds(SkRect rect) {
        bound->join(rect);
    }

    SkRect getBounds() {
        return SkRect({bound->fLeft, bound->fTop, bound->fRight, bound->fBottom});
    }

    void setEmpty() {
        bound->setEmpty();
    }

    void setShapeId(std::string shapeId) {
        this->shapeId = shapeId;
    }

    std::string getShapeId() {
        return shapeId;
    }
};

struct DrawingContext;
using ShapeRenderTrigger = std::function<int(com::zoho::shapes::ShapeObject*, SkCanvas*, bool, const DrawingContext*, const std::string, TriggerStatus)>;
using GroupShapeRenderTrigger = std::function<int(com::zoho::shapes::ShapeObject*, SkCanvas*, bool, TriggerStatus, const DrawingContext*)>;
using TextBodyRenderTrigger = std::function<void(SkCanvas*, bool, const DrawingContext*, const std::string, std::string, TriggerStatus)>;

struct DrawingContext : public graphikos::painter::ZContext {
private:
    DrawingContext(const DrawingContext& og) : ZContext(og) {
        this->renderSettings = og.renderSettings;
        this->backendRenderSettings = og.backendRenderSettings;
        this->isShapeRenderTriggerEnabled = og.isShapeRenderTriggerEnabled;
        this->isGroupShapeRenderTriggerEnabled = og.isGroupShapeRenderTriggerEnabled;
        this->isTextBodyRenderTriggerEnabled = og.isTextBodyRenderTriggerEnabled;
        this->shapeRenderTriggerFn = og.shapeRenderTriggerFn;
        this->groupShapeRenderTriggerFn = og.groupShapeRenderTriggerFn;
        this->textBodyRenderTriggerFn = og.textBodyRenderTriggerFn;
        this->canvas = og.canvas;
        this->isOnlyText = og.isOnlyText;
        this->dd = og.dd;
        this->currentShapeInfo = og.currentShapeInfo;
        this->parentPaint = og.parentPaint;
    }

public:
    SkCanvas* canvas; /* The canvas we draw to */
    std::shared_ptr<CurrentShapeInfo> currentShapeInfo;
    DeferredDetails* dd = nullptr; /* contains async information */
    bool isOnlyText = true;
    bool isShapeRenderTriggerEnabled = false;
    bool isGroupShapeRenderTriggerEnabled = false;
    bool isTextBodyRenderTriggerEnabled = false;
    ShapeRenderTrigger shapeRenderTriggerFn = nullptr;
    GroupShapeRenderTrigger groupShapeRenderTriggerFn = nullptr;
    TextBodyRenderTrigger
        textBodyRenderTriggerFn = nullptr;
    const graphikos::painter::RenderSettings* renderSettings = nullptr; /* contains general and product related rendering settings for shapes */
    SkPaint parentPaint = SkPaint();                                    // in case of innerShape's fillType as GRP -> parentPaint will be considered for rendering

    std::shared_ptr<graphikos::painter::BackendRenderSettings> backendRenderSettings = std::make_shared<graphikos::painter::BackendRenderSettings>(); /* backend related settings */
    DrawingContext(SkCanvas* canvas, const graphikos::painter::RenderSettings& renderSettings, graphikos::painter::IProvider* provider = nullptr, DeferredDetails* dd = nullptr, graphikos::painter::GLRegion frame = graphikos::painter::GLRegion(), graphikos::painter::Matrices matrices = graphikos::painter::Matrices(), SkMatrix cameraMatrix = SkMatrix(), com::zoho::shapes::Transform* gTrans = nullptr)
        : ZContext(provider, frame, matrices, cameraMatrix, gTrans), canvas(canvas), dd(dd), renderSettings(&renderSettings) {
        currentShapeInfo = std::make_shared<CurrentShapeInfo>();
    }
    DrawingContext() {};
    DrawingContext clone(const graphikos::painter::RenderSettings& renderSettings) const {
        DrawingContext drawingContext(*this);
        drawingContext.renderSettings = &renderSettings;
        return drawingContext;
    }

    DrawingContext clone() const {
        return DrawingContext(*this);
    }
};
