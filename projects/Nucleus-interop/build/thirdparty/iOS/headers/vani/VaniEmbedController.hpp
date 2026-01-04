#ifndef __NL_VANIEMBEDCONTROLLER_H
#define __NL_VANIEMBEDCONTROLLER_H

#include <app/controllers/NLEventController.hpp>
#include <app/controllers/NLEditorProperties.hpp>
#include <nucleus/core/layers/NLInstanceLayer.hpp>
#include <app/CustomTextEditorController.hpp>

namespace com {
namespace zoho {
namespace shapes {
class ShapeObject;
}
}
}

#define AUDIO_SEEKERRECT_SHAPE_INDEX 9
#define AUDIO_RENAME_TICK_SHAPE_INDEX 13
#define AUDIO_NAME_SHAPE_INDEX 8

class VaniEmbedController : public NLEventController {
    NLDataController* data = nullptr;
    ControllerProperties* properties;
    std::shared_ptr<NLInstanceLayer> fileHoverLayer = nullptr;
    std::shared_ptr<NLInstanceLayer> audioRenameIconLayer = nullptr;
    std::shared_ptr<NLInstanceLayer> fileNameLayer = nullptr;
    graphikos::painter::ShapeDetails hoverFileDetails;
    std::shared_ptr<CustomTextEditorController> customTextEditor;
    NLEditorProperties* editorProperties = nullptr;
    std::string dataTitleShapeID = "";
    std::string editIconAudioId = "";
    std::string hoverFileId = "";

public:
    bool enableEditing = false;
    bool enableSelection = false;
    VaniEmbedController(NLDataController* dataController, ZSelectionHandler* selectionHandler, ControllerProperties* properties, NLEditorProperties* editorProperties, std::shared_ptr<CustomTextEditorController> customTextEditor);
    void onAttach() override;
    void onDetach() override;
    void onDataChange() override;

    bool onMouseDown(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onMouseMove(const graphikos::painter::GLPoint& mouse, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onMouseUp(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onDoubleClickEnd(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onDrag(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLPoint& prevPoint, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onKeyDown(int keyCode, int modifier, bool repeat, std::string keyCharacter, const SkMatrix& matrix) override;
    bool onRightClickDown(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;

    bool renderHoverLayer(std::string shapeId, graphikos::painter::GLRect bounds = graphikos::painter::GLRect());
    void showFilePreview(com::zoho::common::Position position);
    void showFileName(graphikos::painter::ShapeDetails shapeDetails, const graphikos::painter::GLPoint& mouse);
    graphikos::painter::GLRect getFileNameRect(graphikos::painter::ShapeDetails shapeDetails);
    graphikos::painter::GLRect getAudioInnerShapeRectBasedOnIndex(graphikos::painter::ShapeDetails shapeDetails, int index);
    bool insideAudioPlayPauseBtn(graphikos::painter::ShapeDetails shapeDetails, const graphikos::painter::GLPoint& point);
    std::string getParentFrameId(graphikos::painter::ShapeDetails shapeDetails);
    void onSelectionChange();

    bool insideFilePreviewIcon(graphikos::painter::ShapeDetails shapeDetails, const graphikos::painter::GLPoint& point);
    bool insideEmbedPlayorEdit(graphikos::painter::ShapeDetails shapeDetail, bool checkForEditButton = false, graphikos::painter::GLPoint point = graphikos::painter::GLPoint(), bool triggerEvent = true);
    void initTextOnEditing(graphikos::painter::GLRect rect, com::zoho::shapes::TextBody* textBody);
    void initAudioRename(graphikos::painter::ShapeDetails shapeDetails);
    void renderDataTitle(std::string fileName, graphikos::painter::GLRect fileNameRect, com::zoho::shapes::TextBody* textBody, graphikos::painter::ShapeDetails shapeDetails);
    void renderLayerShape(com::zoho::shapes::ShapeObject* shapeObject, std::shared_ptr<NLInstanceLayer> layer);
    com::zoho::shapes::ShapeObject* getAudioRenameIconShapeObject(graphikos::painter::ShapeDetails shapeDetails);
    bool audioPlayerOnDrag(const graphikos::painter::GLPoint& end);
    void clearHoverLayers();
    void translateHoverLayer(std::string shapeId, SkMatrix matrix);
    bool audioRename(int keyCode = GL_KEY_ENTER);

    // automation API method
    std::map<std::string, graphikos::painter::GLRect> getAudioEditRects(std::string shapeID);
};

#endif