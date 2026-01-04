#ifndef __NL_CONNECTORTEXTCONTROLLER_H
#define __NL_CONNECTORTEXTCONTROLLER_H

#include <app/controllers/NLEventController.hpp>
#include <app/controllers/NLEditorProperties.hpp>
#include <nucleus/core/layers/NLInstanceLayer.hpp>
#include <app/util/ZEditorUtil.hpp>
#include <app/TextEditorController.hpp>
#include <include/core/SkPathMeasure.h>
#include <app/CollabController.hpp>

namespace com {
namespace zoho {
namespace shapes {
class Connector;
class PointOnPath;
}
}
}
class NLDataController;
struct ShapeData;
struct DrawData;
class TextEditorController;
class CollabController;
class SkIntersections;

class ConnectorTextController : public NLEventController {
private:
    NLEditorProperties* editorProperties = nullptr;
    std::shared_ptr<TextEditorController> textEditor = nullptr; // create when needed
    NLDataController* data = nullptr;
    std::string selectedTextBodyId = "";
    com::zoho::shapes::ShapeObject* modifyingConnector = nullptr;
    bool textBodyShapeDragged = false;
    bool textEditMode = false;
    bool textLayerAttached = false;
    bool isCommenter = false;
    CollabController* collabController = nullptr;
    bool dragStart = false;

    bool exitTextEditor();

public:
    std::shared_ptr<NLShapeLayer> textBoxOverLay = nullptr;
    ConnectorTextController(NLDataController* dataController, ZSelectionHandler* selectionHandler, ControllerProperties* properties, NLEditorProperties* editorProperties);

    void onAttach() override;
    void onDetach() override;
    void reset();
    bool onMouseDown(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onMouseMove(const graphikos::painter::GLPoint& mouse, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onMouseUp(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onDoubleClickEnd(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onKeyDown(int keyCode, int modifier, bool repeat, std::string keyCharacter, const SkMatrix& matrix) override;
    bool onDrag(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLPoint& prevPoint, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    void dataUpdated(bool needRender = false, std::vector<std::string> shapeIds = {}) override;
    // int ConnectorTextController::getTextBodyIndex(const google::protobuf::RepeatedPtrField<com::zoho::shapes::TextBody> textBodies, std::string id);
    void attachTextAndSelectTextLayer(SelectedShape selectedShape);
    void attachTextLayer(SelectedShape selectedShape, std::string textBodyId);
    static float getPathLength(const SkPath& path);
    static float getTotalLength(std::vector<graphikos::painter::GLPath> paths);
    float getCurrentPointLength(std::vector<graphikos::painter::GLPath> paths, const com::zoho::shapes::PointOnPath pointOnPath);
    void updateApproximateTBoxPosition(com::zoho::shapes::ShapeObject* shapeObject, com::zoho::shapes::PointOnPath& pointOnPath);
    void updatePointAtDistance(std::vector<graphikos::painter::GLPath> paths, float distance, com::zoho::shapes::PointOnPath* pointOnPath);
    std::vector<float> getAllPositionInPercentageOfTBoxes(std::vector<graphikos::painter::GLPath> paths, google::protobuf::RepeatedPtrField<com::zoho::shapes::TextBody> textBodies, float totalLength, bool doNotAddStartAndEnd);
    void renderModifiedConnectors(EditingLayer& layer, std::string connectorId, bool fromText);
    void renderTextBodySelection(graphikos::painter::ShapeDetails connectorShapeDetail, com::zoho::shapes::TextBody textBody, bool mergeTextBody = true);
    void renderModifiedConnectorAndRenderTextSelection(graphikos::painter::ShapeDetails connectorShapeDetail, com::zoho::shapes::TextBody* textBody, bool mergedTextBody = true, bool textRender = false);
    void getMergedTextTransform(com::zoho::shapes::ShapeObject* textBodyShapeObject, graphikos::painter::ShapeDetails connectorShapeDetail);
    void resetTextSelection();
    float getSegmentLength(graphikos::painter::GLPath::Verb verb, graphikos::painter::GLPoint pts[], float conicWeight);
    void move_textbody(graphikos::painter::GLPoint midPoint);
    bool initTextEditor(graphikos::painter::ShapeDetails shapeDetail);
    void updateTextEditor(graphikos::painter::ShapeDetails shapeDetail);
    void updateModifyingConnector(graphikos::painter::ShapeDetails shapeDetails);
    com::zoho::shapes::PointOnPath addTextBox(std::string shapeId);
    com::zoho::shapes::PointOnPath addTextBoxData(com::zoho::shapes::ShapeObject* shapeObject);
    virtual void clearSelection();

    void onShapeDataChange(std::vector<std::string> shapeIds);
    void updateSelectedData(bool forceUpdate = false);
    bool goToTextEdit(std::string textBodyId, int fromIndex, int toIndex, bool selectAll);
    void setSelectedTextBodyId(std::string textBodyId);
    std::string getSelectedTextBodyId();
    bool isTextEditMode();
    void setIsCommenter(bool isCommenter);
    std::shared_ptr<TextEditorController> getTextEditor();

    void reRenderModifyingConnector(com::zoho::shapes::TextBody* clonedTextBody, bool textRender = false);
    void setCollabController(CollabController* collab);
    ~ConnectorTextController();
};

#endif
