#ifndef __NL_TEXTHIGHILIGHTCONTROLLER_H
#define __NL_TEXTHIGHILIGHTCONTROLLER_H

#include <app/TextEditorController.hpp>
#include <app/ZBBox.hpp>
#include <nucleus/core/layers/NLInstanceLayer.hpp>
class TextHighlightController : public NLEventController {
private:
    NLEditorProperties* editorProperties = nullptr;
    struct TextCollabMemberDetails; // Implementation is provided in TextHighlightController.cpp since it requires text editor position types.

    struct TextCollabDetails {
        std::vector<TextCollabMemberDetails> textCollabMemberDetails;
    };

    std::shared_ptr<NLRenderTree> nlrenderTree;
    graphikos::painter::GLRect selectionRect;

    std::map<std::string, std::vector<std::string>> tableCellIds;
    std::map<std::string, std::vector<std::string>> connectorTextIds;
    std::vector<std::string> deletedShapeIds;

    std::shared_ptr<ZBBox> bbox = nullptr;
    NLDataController* dataLayer;
    std::shared_ptr<NLRenderLayer> textLayer;

    std::shared_ptr<TextEditorController> textEditorController;

public:
    std::map<std::string, TextCollabDetails> textCollabMap;
    TextHighlightController(NLDataController* dataController, ZSelectionHandler* selectionHandler, ControllerProperties* properties, NLEditorProperties* editorProperties, std::shared_ptr<ZBBox> bbox);
    void onAttach() override;
    void onDetach() override;
    void attachTextSelectionToLayer(std::shared_ptr<NLPictureRecorder> nlPicture, std::string shapeId);
    void removeFromLayer(const std::string& shapeId);

    void setDeletedShapeIds(std::vector<std::string> deletdShapeIds);
    void dataUpdated(bool needRender = false, std::vector<std::string> shapeIds = {}) override;

    void addTextCollabDetails(std::string shapeId, std::string zuid, int si, int ei, TextEditorController::Color color, std::string cellId = "", std::string textBodyId = "");
    void reRenderTextHightlightforShape(std::string shapeId, std::string cellId = "", std::string textBodyId = "");
    //zuid will be empty in case if shape is deleted
    void deleteTextCollabDetails(std::string shapeId, std::string zuid = "", std::string cellId = "", std::string textBodyId = "");
    void clearTextCollabDetails();

    void renderCollabDetails(std::string shapeId, std::string zuid, int si, int ei, TextEditorController::Color color, graphikos::painter::ShapeDetails& shapeDetails);
    bool deleteCollabDetails(std::string shapeId, std::string zuid = "", bool needToDeleteData = true);

    void removeTextHighlightBeforeEditing(std::vector<std::string> shapeIds);
    void removeInnerShapeHighlight(com::zoho::shapes::ShapeObject* groupShape);
    void clearTextHightlightforShape(com::zoho::shapes::ShapeObject* shapeObject);

    std::shared_ptr<NLPictureRecorder> getTextCollabSelectionAsPicture(TextCollabMemberDetails collabMemberDetail, TextCollabDetails collabDetail);

    virtual ~TextHighlightController();
};

#endif
