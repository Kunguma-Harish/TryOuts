#pragma once
#ifndef __NL_TEXTLAYERIMPL_H
#define __NL_TEXTLAYERIMPL_H
#include <nucleus/core/layers/NLTextLayer.hpp>
#include <sktexteditor/editor.h>

class NLTextLayerImpl : public NLTextLayer, public sktexteditor::Editor::Owner {
private:
    sktexteditor::Editor::PaintOpts options;
    std::shared_ptr<NLRenderLayer> textEditorLayer = nullptr;
    std::shared_ptr<NLRenderLayer> caretLayer = nullptr;
    void updateCaretLayer();      //move
    void updateTextEditorLayer(); //move

    bool _onMouseUp(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix);
    bool _onMouseDown(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix);
    bool onMouse(graphikos::painter::GLPoint point, sktexteditor::Editor::InputState state, int modifiers, int clickCount);

public:
    NLTextLayerImpl(bool setAsEditable, NLLayerProperties* properties, graphikos::painter::GLRect viewPortRect, SkColor layerColor = SK_ColorTRANSPARENT);
    sktexteditor::Editor editor; //move

    void initiateTextEdit(int editorWidth, NLLayerProperties* properties, graphikos::painter::GLRect viewPortRect, SkColor layerColor = SK_ColorTRANSPARENT, graphikos::painter::GLPoint point = graphikos::painter::GLPoint(0, 0));

    //Functions that facilitates Editing.
    graphikos::painter::GLPoint renderPoint = graphikos::painter::GLPoint(); //marks to the point where the text is to be renered.
    void onAttach() override;

    bool mouseInsideEditor(graphikos::painter::GLPoint mouse);

    void onLoop(SkMatrix parentMatrix) override;
    bool onMouseDown(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onMouseUp(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onDrag(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLPoint& prevPoint, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onDoubleClick(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onDoubleClickEnd(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onTripleClick(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onTripleClickEnd(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onKeyDown(int keyCode, int modifier, bool repeat, std::string keyCharacter, const SkMatrix& matrix) override;
    bool onTextInput(std::string inputStr, int compositionStatus, const SkMatrix& matrix) override;
    void setEditorState(int textIndex);
    void resetEditorState(int textIndex);

    std::string getTextContent();

    void populateTextContent(const std::string& data);
    void appendTextContent(std::string str);
    graphikos::painter::GLRect getBoundingRectForTextEditor() override;
};

#endif
