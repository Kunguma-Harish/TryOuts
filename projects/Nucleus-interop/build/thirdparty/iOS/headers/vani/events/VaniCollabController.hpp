#ifndef __NL_ZVANICOLLABCONTROLLER_H
#define __NL_ZVANICOLLABCONTROLLER_H

#include <app/controllers/NLController.hpp>
#include <nucleus/core/layers/NLInstanceLayer.hpp>
#include <app/ZBBox.hpp>
#include <app/ZShapeModified.hpp>
#include <app/CollabController.hpp>



namespace com {
namespace zoho {
namespace shapes {
class Transform;
}
}
}

class NLDataController;
class ZData;

class VaniCollabController : public CollabController {

public:
    VaniCollabController(NLDataController* dataController, ZSelectionHandler* selectionHandler, ControllerProperties* properties);

    void onAttach() override;
    void onDetach() override;

    bool onMouseDown(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onMouseMove(const graphikos::painter::GLPoint& mouse, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;

    void updateBboxValues(com::zoho::shapes::ShapeObject* shapeobject, std::string shapeId);
    void updateBboxValues(com::zoho::shapes::ShapeObject* shapeobject, SkColor color);
    void updateShapeFill(com::zoho::shapes::Fill* fill, SkColor color);
    void renderBboxWithProfile(std::string shapeId, com::zoho::shapes::Transform* shapeBound = nullptr) override;
    void renderBboxWithProfile(com::zoho::shapes::ShapeObject* shapeObject, com::zoho::shapes::Transform* shapeBound = nullptr) override;
    void renderShapeInLayer(com::zoho::shapes::ShapeObject* previewShape, std::shared_ptr<NLInstanceLayer>& layer);
    void clearCollabHoverLayer(std::string shapeId) override;
    CollabDetail getActiveUser(std::string shapeId);
    std::shared_ptr<com::zoho::shapes::ShapeObject> getPreviewShape(std::string shapeId, int hoverIndex = -1, com::zoho::shapes::Transform* shapeBound = nullptr);
    std::shared_ptr<com::zoho::shapes::ShapeObject> getPreviewShape(com::zoho::shapes::ShapeObject* shapeObject, int hoverIndex = -1, com::zoho::shapes::Transform* shapeBound = nullptr, float offset = 0);
    void redrawHoveredLayer(int profileIndex = -1);

    ~VaniCollabController();

private:
    com::zoho::shapes::ShapeObject* collabUsersPreview = nullptr;

    int maxProfileVisble = 4;
    std::string currentShapeId = "";

    std::shared_ptr<NLInstanceLayer> hoverIconLayer = nullptr;
    std::string hoverShapeId = "";
};
#endif
