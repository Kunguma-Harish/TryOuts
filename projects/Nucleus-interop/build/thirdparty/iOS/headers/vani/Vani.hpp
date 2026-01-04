#ifndef __NL_VANI_H
#define __NL_VANI_H

#include <app/Nucleus.hpp>
#include <app/controllers/NLController.hpp>
#include <app/CustomSelectionController.hpp>
#include <app/TextHighlightController.hpp>
#include <vani/VaniCommentHandler.hpp>
#include <vani/events/VaniFlowController.hpp>
#include <vani/events/VaniCollabController.hpp>
#include <app/TableEditingController.hpp>
#include <painter/TablePainter.hpp>
#include <vani/RemoteBoardModel.hpp>
#include <nucleus/core/ZEvents.hpp>

class VaniCollabHandler;
class EditorController;
class VaniDataController;
class VaniCollabHandler;
class Vani : public Nucleus {
public:
    enum VaniMode {
        DEFAULT_MODE = 0,
        COMMENT = 1,
        EDITOR = 2,
        FLOW = 3,
        FINITE = 4
    };
    Vani();
    void setController(VaniMode mode = VaniMode::EDITOR);
    VaniMode getMode(std::string);
    void setBackgroundColor(SkColor backgroundColor) override;
    std::shared_ptr<EditorController> getEditorController(std::shared_ptr<NLDataController> dataController);
    // void setController(Mode mode);
    void setDisplayType(graphikos::common::FitToScreenUtil::FitType fitType, SkMatrix cacheMatrix = SkMatrix());
    void renderDocument(std::string docId);
    void renderFrame(const std::string& frameId, const std::string& docId);
    VaniMode getCurrentMode();
    void fitSelectedShapesOnCustomRect(graphikos::painter::GLRect bound, graphikos::painter::GLRect viewPort, bool needAnimation, bool maintainScale, bool alwaysFit, graphikos::common::FitToScreenUtil::FitType fitType, float fitRatio = 0);

    //customSelection code
    std::shared_ptr<CustomSelectionController> getCustomSelection();
    void enableCustomSelection();
    void disableCustomSelection();

    //FlowMode
    VaniFlowController* getVaniFlowController();

    void createCallBackClass() override;
    void selectTextBody(std::string shapeId, std::string textBodyId);
    graphikos::painter::GLRect getSelectionTotalBound();
    std::vector<int> getStartIndexEndIndex(bool forPropertyUpdates = false);
    std::shared_ptr<TextEditorController> getTextEditor();
    std::vector<int> getCharacterPosition(int index);
    bool changeTypingProperties(com::zoho::shapes::PortionProps* props, std::string changedValue);
    void setCursorIndex(int si, int ei);
    bool pasteText(std::string value);
    std::shared_ptr<TableController> getTableEditor();
    void clearTableSelection();
    std::shared_ptr<TextHighlightController> getTextHighlightController();
    std::shared_ptr<VaniCommentHandler> getCommentHandler();
    CollabController* getCollabSelectionHandler();
    graphikos::painter::GLPoint getAnchorEditPoint(std::string anchorId, std::string action);
    graphikos::painter::GLPoint getAnchorNonEditPoint(std::string anchorId);
    graphikos::painter::GLPoint getFrameNamePoint(std::string frameId);
    std::string getFrameName(std::string frameId);
    graphikos::painter::GLRect getAnchorBound(std::string anchorId);
    void regenerateAndRenderFullDocument(const std::string& docId);
    std::shared_ptr<Asset> getFrameAsImage(std::string frameId, float scale);
    std::string getProductName() override;
    void renderErrorLines(bool status);
    void scrollToAnchor(std::string anchorId, graphikos::painter::GLRect viewPort = graphikos::painter::GLRect(), bool needAnimation = false, bool maintainScale = false, bool alwaysFit = false);
    void navigateToShape(std::vector<std::string> shapeIds, graphikos::painter::GLRect viewPort = graphikos::painter::GLRect(), bool needAnimation = false, bool maintainScale = false, bool alwaysFit = false);
    std::shared_ptr<VaniCollabHandler> collabHandler = nullptr;
    void setCollabHandler();

    // C  P  P    D  E  L  T  A    C  O  M  P  O  S  E  R     F  A  C  I  L  I  T  A  T  O  R  S
    std::vector<graphikos::painter::GLRect> updateCache(const std::vector<ComposedContent>& composedContents) override;
    void refreshRect(std::vector<graphikos::painter::GLRect> rects) override;
    void preRender(const std::vector<ComposedContent>& composedContents) override;
    void postRender(const std::vector<ComposedContent>& composedContents) override;

    ~Vani();

private:
    VaniMode currentMode;
    std::shared_ptr<CustomSelectionController> customSelection = nullptr;

    void onInitApplication(std::shared_ptr<ZWindow> window, bool withoutAppMain = false, std::shared_ptr<ZRenderBackend> renderBackend = nullptr) override;
    std::vector<std::string> eventControllerNames;
    std::map<VaniMode, std::shared_ptr<NLScrollEventController>> eventControllers;
};
#endif
