#ifndef __NL_BBOXUTILS_H
#define __NL_BBOXUTILS_H

#include <skia-extension/GLPath.hpp>
#include <include/core/SkMatrix.h>
#include <painter/ShapeObjectPainter.hpp>
#include <nucleus/core/layers/NLShapeLayer.hpp>
#include <nucleus/core/layers/NLInstanceLayer.hpp>
#include <app/ZSelectionHandler.hpp>

namespace asset {
enum class Type;
};

namespace com {
namespace zoho {
namespace shapes {
class ShapeObject;
class NonVisualConnectorDrawingProps;
}
}
}

class BBoxUtils {
public:
    static inline int width = 10;
    static inline int height = 10;
    static inline int strokeWidth = 1;
    static inline int minWidth = 27;
    static inline int minHeight = 27;
    static inline bool onlyCorners = false;
    static inline bool onlyBorder = false;
    static inline bool bunchSelect = true;
    static inline bool doNotRenderBBox = false;
    static inline bool isEditorMode = true;

    struct ZBBoxOptions {
        bool isParentShape = false;
        bool noRotation = false;
        bool onlyMove = false;
        bool isCropMode = false;
        bool flipX = false;
        bool flipY = false;

        ZBBoxOptions() {
        }

        ZBBoxOptions(bool _isParentShape, bool _noRotation, bool _onlyMove, bool _isCropMode, bool _flipX, bool _flipY) {
            isParentShape = _isParentShape;
            noRotation = _noRotation;
            onlyMove = _onlyMove;
            isCropMode = _isCropMode;
            flipX = _flipX;
            flipY = _flipY;
        }
    };

    static graphikos::painter::ShapeDetails getBBoxData(asset::Type bboxType, std::string bboxName, com::zoho::shapes::Transform bound, SkMatrix canvasMatrix, graphikos::painter::GLPoint xyPos, graphikos::painter::IProvider* provider, bool flipx = false, bool flipy = false, bool multiSelect = false, float contentScale = 1);
    static graphikos::painter::GLPoint updatePosition(com::zoho::shapes::Transform& transform, std::string type, com::zoho::shapes::Transform bound, SkMatrix canvasMatrix, graphikos::painter::GLPoint xyPos, asset::Type bboxType, bool flipx = false, bool flipy = false, float contentScale = 1);
    static com::zoho::shapes::Transform getBounding(std::vector<SelectedShape>& shapeInfo, graphikos::painter::IProvider* provider);
    static std::map<std::string, asset::Type> getBBoxes(com::zoho::shapes::Transform bound, SkMatrix canvasMatrix, ZBBoxOptions options, graphikos::painter::IProvider* provider, com::zoho::shapes::ShapeObject* shapeObject = nullptr, float scale = 1.0f, com::zoho::shapes::NonVisualConnectorDrawingProps* nvODProps = nullptr);
    static asset::Type getBBoxType(std::string bboxName, asset::Type bboxType, com::zoho::shapes::Locks* locks);
    static std::map<std::string, asset::Type> getConnectorBBoxes(com::zoho::shapes::ShapeObject* shapeObject, com::zoho::shapes::NonVisualConnectorDrawingProps* nvODProps = nullptr, bool flipX = false, bool flipY = false);
    static void transformCropBoxes(std::string bboxName, asset::Type bboxType, graphikos::painter::ShapeDetails bboxShape);
    static void drawBBoxes(std::shared_ptr<NLShapeLayer> layer, std::map<std::string, asset::Type> bboxes, com::zoho::shapes::Transform transform, const DrawingContext& dc, bool multiSelect, bool isCropFrame = false);
};

#endif
