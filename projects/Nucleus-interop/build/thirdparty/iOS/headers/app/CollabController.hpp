#ifndef __NL_COLLABCONTROLLER_H
#define __NL_COLLABCONTROLLER_H

#include <app/controllers/NLEventController.hpp>
#include <nucleus/core/layers/NLInstanceLayer.hpp>
#include <app/ConnectorController.hpp>
#include <app/util/ZEditorUtil.hpp>

class NLDataController;
class TextHighlightController;
class ConnectorController;
class CollabController : public NLEventController {

public:
    struct CollabDetail {
        std::string zuid;
        std::string name;
        SkColor color;
        std::shared_ptr<NLInstanceLayer> iconLayer = nullptr;
    };
    struct NotificationInstanceHandler {
        std::vector<CollabDetail> collabDetail;
        std::shared_ptr<NLInstanceLayer> borderLayer = nullptr;
        std::shared_ptr<NLInstanceLayer> userNameLayer = nullptr;
    };

    std::vector<std::string> deletedShapeIds;

    CollabController(NLDataController* dataController, ZSelectionHandler* selectionHandler, ControllerProperties* properties);
    void onAttach() override;
    void onDetach() override;
    std::string lastSelectedTableId = "";

    void selectCollabShape(std::string shapeId, CollabDetail collabDetail);
    void unSelectShape(std::string shapeId, std::string zuid);
    void clearShapes();
    void clearCollabShapeId(std::string shapeId, bool onlyRemoveLayer = false);
    void addOffsetCollabIcon();

    virtual void renderBboxWithProfile(std::string shapeId, com::zoho::shapes::Transform* shapeBound = nullptr);
    virtual void renderBboxWithProfile(com::zoho::shapes::ShapeObject* shapeObject, com::zoho::shapes::Transform* shapeBound = nullptr);
    virtual void clearCollabHoverLayer(std::string shapeId);
    void renderCollaBbox(std::vector<SelectedShape>& selectedShapesInfos, ZEditorUtil::EditingData& eventData, std::shared_ptr<ConnectorController> conectorController);
    void onBeforeRerenderRegion(std::vector<std::string>& shapeIds, std::vector<int>& opTypes);
    void onShapeDataChange(std::vector<std::string> shapeIds);
    void reDrawInnerBbox(com::zoho::shapes::ShapeObject* shapeObject, com::zoho::shapes::Transform* shapeBound);
    void removeInstanceLayer(std::shared_ptr<NLInstanceLayer>& layer);
    int getTableCollabIconOffset() {
        return this->tableCollabIconOffset;
    };
    void setTextHighlighter(std::shared_ptr<TextHighlightController> textHightlighter);
    ~CollabController();

protected:
    int tableCollabIconOffset = 40;
    NLDataController* data = nullptr;
    std::shared_ptr<TextHighlightController> textHightController;
    std::map<std::string, NotificationInstanceHandler> collabMap;
};
#endif
