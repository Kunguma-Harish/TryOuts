#ifndef __NL_CUSTOMTEXTEDITORCONTROLLERIMPL_H
#define __NL_CUSTOMTEXTEDITORCONTROLLERIMPL_H

#include <app/CustomTextEditorController.hpp>
#include <painter/ShapeObjectPainter.hpp>
#include <painter/TextBodyPainter.hpp>
#include <sktexteditor/editor.h>
#include <app/controllers/NLEventController.hpp>
#include <nucleus/core/ZEventKeys.hpp>
#include <nucleus/core/layers/NLInstanceLayer.hpp>
#include <nucleus/core/layers/NLShapeLayer.hpp>

#define TEXT_SELECTION_COLOR \
    {0.706f, 0.706f, 0.863f, 0.5f}

namespace com {
namespace zoho {
namespace shapes {
class ShapeObject;
}
}
}

class NLRenderLayer;

class CustomTextEditorControllerImpl : public CustomTextEditorController, protected sktexteditor::Editor::Owner {
private:
    std::shared_ptr<NLInstanceLayer> textLayer = nullptr;
    std::shared_ptr<NLShapeLayer> cursorLayer = nullptr;
    bool isCustomTextEdit = false;
    sktexteditor::Editor::PaintOpts options;
    SkMatrix renderMatrix = SkMatrix();
    SkMatrix translateMatrix = SkMatrix();
    sk_sp<skia::textlayout::FontCollection> fc = nullptr;

    sktexteditor::Editor* textEditor = nullptr;
    sk_sp<SkPicture> specialDataPicture = nullptr;

    std::shared_ptr<com::zoho::shapes::TextBody> textBody = nullptr;
    graphikos::painter::GLRect rect = graphikos::painter::GLRect();
    int maxCharLimit = INT_MAX;
    bool mouseDragSupported = false;
    bool isMouseDown = false;
    bool retain_scale = false;
    bool usePxForText = true;
    graphikos::painter::GLPoint positionData = graphikos::painter::GLPoint(0, 0);
    graphikos::painter::GLPoint offset = graphikos::painter::GLPoint(0, 0);

    skia::textlayout::TextStyle getProcessedTextStyle(sktexteditor::Editor* editor, const sktexteditor::Editor::PortionStyle& portionStyle, size_t paragraphIndex) override { return portionStyle.skStyle; };
    void selectionChanged(sktexteditor::Editor* editor, sktexteditor::Editor::SelectionRange old) override;
    void willChangeTypingProperties(sktexteditor::Editor* editor, sktexteditor::Editor::TextProperties oldProps, sktexteditor::Editor::TextProperties& newProps) override;
    bool shouldReplaceText(sktexteditor::Editor* editor, sktexteditor::Editor::SelectionRange affectedRange, std::string replacementString) override;
    void textDidChange(sktexteditor::Editor* editor) override;
    void setTextParaProperties();

public:
    CustomTextEditorControllerImpl(NLDataController* dataController, ZSelectionHandler* selectionHandler, ControllerProperties* properties);
    void onAttach() override;
    void onDetach() override;

    void renderText(const SkMatrix& matrix = SkMatrix()) override;
    bool isMouseInsideTextEditor(graphikos::painter::GLPoint mouse);
    bool onMouse(graphikos::painter::GLPoint point, sktexteditor::Editor::InputState state, int modifier, SkMatrix matrix, int clickCount);
    void onLoop(SkMatrix parentMatrix) override;
    bool onTextInput(std::string inputStr, int compositionStatus, const SkMatrix& matrix) override;
    void paintCursor(graphikos::painter::GLPoint point, float scale);

#ifdef __EMSCRIPTEN__
    void enableJSTextArea(bool enable, bool isUpdate);
    void focusTextArea();
#endif

    bool onMouseDown(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onMouseUp(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onDoubleClick(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onDoubleClickEnd(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onKeyDown(int keyCode, int modifier, bool repeat, std::string keyCharacter, const SkMatrix& matrix) override;
    bool onDrag(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLPoint& prevPoint, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onMouseMove(const graphikos::painter::GLPoint& mouse, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onTripleClick(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onTripleClickEnd(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    void onViewTransformed(const ViewTransform& viewTransform, const SkMatrix& totalMatrix) override;

    void initText(graphikos::painter::GLRect rect, std::shared_ptr<com::zoho::shapes::TextBody> textBody, bool usePxForText = true) override;
    void updateTranslateMatrix(sktexteditor::Editor::SelectionRange oldSelectionRange, graphikos::painter::GLRect oldCharacterRect, std::string oldText, graphikos::painter::GLRect newCharacterRect, std::string newText, int keyCode = -1);
    void reInitCustomTextEditor(std::string text, const SkMatrix& totalMatrix, int si = 0, int ei = 0) override;
    void updateTextRect(graphikos::painter::GLRect rect, const SkMatrix& matrix = SkMatrix()) override;
    void setMaxTextLimit(int textLimit) override;
    bool getIsCustomTextEditMode() override;
    void exitText() override;
    std::string getText() override;
    void setData(bool retain_scale, graphikos::painter::GLPoint position, graphikos::painter::GLPoint offset) override;
    void enableMouseDrag() override;

    // functions related to cut, copy, paste.
    static int getTextIndex(sktexteditor::Editor* editor, sktexteditor::Editor::TextCharPosition pos);
    std::vector<int> getSiEi() const override;
    std::vector<int> getCharacterPos(int si) override;
    bool paste(std::string value, const SkMatrix& totalMatrix) override;
    std::string getSelectedText() override;
    std::string getSelectedTextByPosition(sktexteditor::Editor::TextCharPosition start, sktexteditor::Editor::TextCharPosition end);
    void cutText(const SkMatrix& totalMatrix) override;
    void addDefaultFontFamilies(std::vector<std::string> fontFamilies) override;
    sk_sp<SkPicture> generatePictureForSpecialData(const SkMatrix& matrix);
    void refreshEmojiImages(std::string imageKey, const SkMatrix& totalMatrix) override;
    void updateTextArea(const SkMatrix& totalMatrix, bool isUpdate);
};

#endif