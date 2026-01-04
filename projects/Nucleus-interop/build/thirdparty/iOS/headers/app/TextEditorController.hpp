#ifndef __NL_TEXTEDITORCONTROLLER_H
#define __NL_TEXTEDITORCONTROLLER_H

#include <painter/ShapeObjectPainter.hpp>
#include <painter/TextBodyPainter.hpp>
#include <nucleus/core/ZEventKeys.hpp>
#include <skia-extension/GLPoint.hpp>
#include <app/ZSelectionHandler.hpp>
#include <app/ZShapeModified.hpp>
#include <app/controllers/NLEventController.hpp>
#include <app/controllers/NLEditorProperties.hpp>
#include <nucleus/core/layers/NLInstanceLayer.hpp>
#include <app/ZBBox.hpp>
#include <app/ConnectorController.hpp>

#include <optional>
#include <iostream>

#define TEXT_SELECTION_COLOR \
    {0.706f, 0.706f, 0.863f, 0.5f}

namespace com {
namespace zoho {
namespace shapes {
class PortionProps;
class TextBody;
class Transform;
}
}
}

namespace graphikos {
namespace painter {
namespace internal {
struct TextBulletDetails;
}
}
}

struct Modification;

class TextEditorController : public NLEventController {
public:
    std::string shapeId;
    std::string tableId = "";
    std::string connectorId = "";

    struct Color {
        float r, g, b, alpha;
    };

    struct ShapingResult {
        bool isBreakWordPresent = false;
        float height;
    };

    enum WordType {
        NORMAL,
        LINE_BREAK,
        FIELD
    };
    struct WordDetails {
        size_t startIndex;
        size_t endIndex;
        std::string word;
        size_t spaceLength = 0;
        WordType type = NORMAL;
    };

    graphikos::painter::GLRect rect;                       // rect with inset values added
    graphikos::painter::GLRect rectWithoutInsetAlteration; // rect without inset alteration
    SkMatrix matrix;                                       // textboxMatrix
    bool isTextEditMode = false;
    bool useNativeTextInput = false;
    bool mouseDownOverCheckBox = false;
    bool draggingEmptyTextShape = false;

    //cache variables that aids over hidden bullets rendering on selection and selectable bullets related specific cases
    bool containsSelectableBullet = false;

    NLEditorProperties* editorProperties = nullptr;
    std::shared_ptr<ConnectorController> connectorController;
    com::zoho::shapes::ShapeObject* modifyingConnector = nullptr;

    TextEditorController(NLDataController* dataController, ZSelectionHandler* selectionHandler, ControllerProperties* properties, NLEditorProperties* editorProperties) : NLEventController(properties, selectionHandler, dataController->getLayerProperties(), dataController->getViewPortRect()), dataLayer(dataController), editorProperties(editorProperties) {
#ifdef __EMSCRIPTEN__
        this->useNativeTextInput = true;
#else
        // Temporary setup for text input. Once our own windowing setup is ready, we can receive text input events and forward it to 'onTextInput'.
        this->useNativeTextInput = false;
#endif
    }

    static std::shared_ptr<TextEditorController> create(NLDataController* dataController, ZSelectionHandler* selectionHandler, ControllerProperties* properties, NLEditorProperties* editorProperties, std::shared_ptr<NLLayer> bboxLayer, std::shared_ptr<ZBBox> bbox);

    virtual void init(graphikos::painter::ShapeDetails shapeDetails) = 0;
    virtual bool exitTextEdit(bool triggerEvent = true) = 0;
    virtual void disableTextEdit() = 0;

    virtual float getCurrentTextHeight() = 0;
    virtual float getCurrentFontSize() const = 0;
    virtual sk_sp<SkTypeface> getCurrentTypeFace() const = 0;
    virtual graphikos::painter::GLPoint getInsetDimensons() const = 0;
    virtual graphikos::painter::GLPoint getTextDimensons() const = 0;
    virtual float getCurrLineHeightInPara() const = 0;
    virtual bool checkForSameLine() const = 0;
    virtual bool canFitInLine(float width) const = 0;
    virtual bool canFitString(std::string str, float fontScale, graphikos::painter::GLRect textContainerDim, bool isEnter) const = 0;
    virtual ShapingResult calculateTextSizeWithStr(std::string str, float origFontScale, float newFontScale, graphikos::painter::GLRect textContainerDim, bool isEnter, bool forAllParas = true) const = 0;

    virtual bool isEditable() = 0;
    virtual void setIsEditable(bool editable) = 0;
    virtual bool isRenderOnly() = 0;
    virtual void enableRenderOnly() = 0;
    virtual void disableRenderOnly(bool enableEditing = false) = 0;
    virtual void setIsCommenter(bool commenter) = 0;
    virtual void setDisplayCursorForCommenter(bool value) = 0;
    virtual void setTableId(std::string id) = 0;
    virtual void setConnectorId(std::string id) = 0;
    virtual SkMatrix renderMatrix(bool withInsetTranslate = true) = 0;
    virtual void shapeSelected(SelectedShape shape, graphikos::painter::GLPoint selectedPoint = graphikos::painter::GLPoint()) = 0;
    virtual bool isHoveredOverBullet(graphikos::painter::GLPoint point, bool onlyCheckBox = false) = 0;
    virtual bool refreshNeighboursForCurrentShape() = 0; //determines if current shapeId is an inner shape
    virtual void onShapeDataChange(std::vector<std::string> shapeIds, bool isFontAdd) = 0;
    virtual bool mouseInsideEditor(graphikos::painter::GLPoint mouse, bool considerOnlyShape = false) = 0;
    virtual bool mouseInsideText(graphikos::painter::GLPoint mouse) = 0;

    virtual void clearCache() = 0;
    virtual void invalidateLayout(size_t startPara, size_t endPara) = 0;
    virtual void addDefaultFontFamilies(std::vector<std::string> fontFamilies) = 0;

    virtual bool onChar(int key, int modifier, std::string keyCharacter) = 0;

    virtual void selectAll() = 0;

    virtual void attachTextLayer(bool onTop = false) = 0;
    virtual void attachTextBodyToLayer() = 0;         // populates live text editing and its components to a sublayer
    virtual void attachShapeWithoutTextToLayer() = 0; // populates shape without textbody to selected-shp-layer
    virtual bool needToRefreshLayer() = 0;
    virtual void refreshEmojiImages(std::string imageKey) = 0;

    virtual void setConnectorController(std::shared_ptr<ConnectorController> _connectorController) = 0;

    virtual bool insideHyperLink(const graphikos::painter::GLPoint& point, graphikos::painter::ShapeDetails shpDetails, bool needToTrigger = true) = 0;

    // Binding functions
    virtual void setSelectionForSiEi(int si, int ei) = 0;
    virtual std::vector<graphikos::painter::GLRect> getBulletRect(int paraIndex = -1) = 0;
    virtual std::vector<int> getSiEi() const = 0;
    virtual std::vector<int> getSiEiForPropertyUpdates() = 0;   // si ,ei , fromindex , to index , ops
    virtual std::vector<int> getCharacterPos(int si) const = 0; // paranum , portion num
    virtual std::string getSelectedText() = 0;
    virtual std::string getTextBySiEi(int si, int ei) = 0;

    virtual bool changeTypingProperties(com::zoho::shapes::PortionProps* fullProps, std::string changedValue) = 0;
    virtual bool paste(std::string value) = 0;
    virtual void triggerParaDelete(size_t paraIndexForRemove) = 0;
    virtual void textEditorInsertUserMention(std::string zuid) = 0;
    virtual void setTextEditorUserSuggestionPopoverStatus(bool status) = 0;
    virtual bool goToTextEdit(int fromIndex = -1, int toIndex = -1, bool selectAll = false) = 0;
    virtual void goToTextEdit(graphikos::painter::ShapeDetails shapeDetails, int fromIndex = -1, int toIndex = -1, bool selectAll = false) = 0;
    virtual void pasteTextBodyJSON(std::string textBodyJSON, bool withStyle) = 0;
    virtual bool pasteTextBody(com::zoho::shapes::TextBody textBody, bool withStyle) = 0;
    virtual std::vector<ShapeData> textDependencyChanges(com::zoho::shapes::TextBody* textBody) = 0;
    virtual void changeErrorLines(int si, int ei, bool addLine) = 0;
    virtual bool isMisspellWordSelected() = 0;

    //apis for automation
    virtual void selectTextByParaIndex(size_t fromIndex, size_t toIndex) = 0; //indices to fPara - index
    virtual void setCursorAtParaIndex(int paraIndex) = 0;                     //fPara - index

    virtual void enableEditorMouseDrag() = 0;
    virtual void disableEditorMouseDrag() = 0;

    virtual std::vector<WordDetails> getWords(size_t startIndex, size_t endIndex) = 0;
    virtual size_t getNextWordEnd(int startIndex) = 0;
    virtual TextEditorController::WordDetails getWord(int startIndex) = 0;
    virtual graphikos::painter::GLRect getSelectionRect(int si, int ei) = 0;
    struct CursorDetails {
        int index;
        graphikos::painter::GLRect rect;
        SkColor color;
    };
    virtual std::optional<CursorDetails> getCurrentCursorDetails() = 0;

    ~TextEditorController() {};

protected:
    bool editorMouseDrag = false;
    NLDataController* dataLayer;
};

#endif
