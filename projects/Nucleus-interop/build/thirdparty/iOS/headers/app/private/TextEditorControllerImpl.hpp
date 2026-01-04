#ifndef __NL_TEXTEDITORCONTROLLERIMPL_H
#define __NL_TEXTEDITORCONTROLLERIMPL_H

#include <app/TextEditorController.hpp>
#include <sktexteditor/editor.h>

class TextEditorControllerImpl : public TextEditorController, protected sktexteditor::Editor::Owner {
protected:
    graphikos::painter::ShapeDetails shapeDetails;
    graphikos::painter::Matrices matrices; // shape matrices needed check when point is inside the rect

private:
    friend class EditorTextBodyParserHandler;

    std::unique_ptr<std::vector<std::unique_ptr<graphikos::painter::internal::TextBulletDetails>>> bulletDetails; // Using unique ptr since only one copy of the object is going to be required.

    bool renderOnly = false; // only text rendered no editingops will be handled , cursor and selection will be hidden , currently used for table

    int fPos = 0;
    bool refreshLayer = false;
    float heightBeforeEditing = 0;
    float maxParaWidthBeforeEditing = 0;

    bool userSuggestionPopoverStatus = false;

    bool autoFitGenerated = false;

    bool textDeleted = false;
    std::vector<Modification>* modifications;
    std::vector<Modification> partialModificationsOfAutoCap;
    const com::zoho::shapes::TextBody* currentlyPastingTextBody = nullptr;
    std::unique_ptr<std::vector<std::unique_ptr<graphikos::painter::internal::TextBulletDetails>>> currentlyPastingBulletDetails;
    std::string changedTypingPropertiesValue;
    // Will hold portion props of removed text for future text insertion at the same place.
    // Will be set to nullptr inside willChangeTypingAttriubutes.
    std::shared_ptr<com::zoho::shapes::PortionProps> futurePortionPropsUpdate = nullptr;
    // When text is removed, this will be set.
    // When text is inserted along with removal, this will be set back to nullptr after updating portion props delta.
    // If text is not inserted along with removal, this value will be passed on to futurePortionPropsUpdate inside textDidChange.
    std::shared_ptr<com::zoho::shapes::PortionProps> currentPortionPropsUpdate = nullptr;

    std::shared_ptr<NLRenderLayer> textLayer;
    std::shared_ptr<NLLayer> caretLayer;

    bool mouseDownOverBullet = false;
    bool isMouseDown = false;
    bool currentlyPasting = false;
    bool _isEditable = false;
    bool isCommenter = false;
    bool displayCursorForCommenter = false;

    sktexteditor::Editor::TextCharPosition userMentionStartPosition;

    std::string insertingZuid = "";
    sk_sp<SkPicture> specialDataPicture = nullptr;
    bool addSubLayerToParent = true;
    bool dragHandled = false;
    sktexteditor::Editor::TextCharPosition markedTextStart;
    sktexteditor::Editor::PaintOpts cursorOptions;

    sk_sp<SkPicture> generatePictureForSpecialData(const SkMatrix& matrix, bool renderBullets = true, bool renderEmojis = false);
    void drawUnderLine(SkCanvas* canvas);
    void drawErrorLine(SkCanvas* canvas);
    void drawHighlight(SkCanvas* canvas);
    void performOnMatchingProps(SkCanvas* canvas, bool shouldSkipSpace, std::function<bool(sktexteditor::Editor::StyleSpan)> isValidPropPresent, std::function<graphikos::painter::TextBodyPainter::TextBlock(sktexteditor::Editor::StyleSpan, skia::textlayout::TextStyle, size_t)> constructTextBlock, std::function<void(graphikos::painter::TextBodyPainter::TextBlock&, std::vector<size_t>&, std::vector<skia::textlayout::LineMetrics>&, std::vector<skia::textlayout::TextBox>&, SkMatrix, SkCanvas*)> drawProp);
    skia::textlayout::TextStyle processedTextStyle(sktexteditor::Editor* editor, const sktexteditor::Editor::PortionStyle& style, size_t paragraphIndex) const;

    struct ParaInsertDeleteData {
        struct Insert {
            // Index where text insertion starts. Bullets will be inserted starting from paragraph after this index.
            // For example, if 'insertParaIndex' is 6 then new bullets will be inserted from index 7.
            sktexteditor::Editor::TextCharPosition insertPos;
            size_t newParaCount;
            // If newBulletDetails is set, it will be used for the newly inserted bullets.
            // If it is not set, then existing bullet details of insertParaIndex will be duplicated.
            // Count of newBulletDetails must be equal to the number of inserted paras or one more than that.
            // If the count is equal to the number of new paragraphs, then existing bullet details at insertParaIndex will be retained.
            // If the count is one higher, then bullet at insertParaIndex will be replaced with the first value.
            std::unique_ptr<std::vector<std::unique_ptr<graphikos::painter::internal::TextBulletDetails>>> newBulletDetails;
        };
        struct Delete {
            size_t startParaIndex;
            size_t endParaIndex;
            bool bulletDeleteFromStart;
        };
        std::optional<Insert> insertData;
        std::optional<Delete> deleteData;
    };
    static std::vector<Modification> changesForTextReplace(sktexteditor::Editor* editor, sktexteditor::Editor::SelectionRange affectedRange, std::string replacementString, ParaInsertDeleteData& paraInsertDeleteData, std::string& changedTypingPropertiesValue, std::shared_ptr<com::zoho::shapes::PortionProps>& updateFullPortionProps, const std::string& insertingZuid, const std::pair<std::string, std::string>& paraIdAndStyle);
    static std::vector<Modification> changesForTextRemove(sktexteditor::Editor* editor, sktexteditor::Editor::SelectionRange affectedRange, ParaInsertDeleteData& paraInsertDeleteData, const std::pair<std::string, std::string>& paraIdAndStyle);
    static std::vector<Modification> replaceUserMention(sktexteditor::Editor* editor, sktexteditor::Editor::TextCharPosition pos1, sktexteditor::Editor::TextCharPosition pos2);
    void throwChanges(std::vector<Modification> modifications, bool isImmediateOp = false);
    void throwTextListener();
    void enableNativeTextInput(bool enable, bool isUpdate);
    void focusTextArea();

    ParaInsertDeleteData paraInsertDeleteData;
    void updateBulletDetailsFromAffectedIndex(size_t affectedStartIndex);
    void reloadBulletDetails();
    void handleCheckBoxForMouseEvents(graphikos::painter::GLPoint point, sktexteditor::Editor::InputState state);
    bool checkGivenParaHasBullet(size_t paraIndex);
    bool checkCursorNextToBullet();
    virtual void setMarginAndIndentOnBulletRemoval(com::zoho::shapes::ParaStyle* paraStyle);
    void updateModificationsForBulletRemoval(size_t paraIndex);
    void convertCurrentParaToBullet();
    std::tuple<sktexteditor::Editor::TextCharPosition, int> getLineLastIndex(sktexteditor::Editor::TextCharPosition targetPos) const;
    void getCurrentParaId(std::string& paraId);
    void setParaConnectorId(bool setEmpty, bool checkForShapeConnectors = false, const graphikos::painter::GLPoint& mouse = graphikos::painter::GLPoint(), const SkMatrix& matrix = SkMatrix());
    bool canAutoCapitalize();
    void doAutoCapitalize(bool revert = false);
    static size_t getIncrementedIndexForPlaceholderData(const sktexteditor::StringSlice& text, const std::vector<sktexteditor::Editor::StyleSpan>& styles, size_t index);
    graphikos::painter::GLRect getBoundingRectForTextBody();

    SkPoint getInsetTranslate();
    SkScalar getVAlignOffset();

    bool enableTextEdit(graphikos::painter::ShapeDetails shapeDetails = graphikos::painter::ShapeDetails());
    void resizeTextEditor();

    graphikos::painter::ShapeDetails getShapeDetailsFromPointForHyperlink(const graphikos::painter::GLPoint& point, graphikos::painter::ShapeDetails shpDetails);
    bool isLastParaBullet = false;

    void resetTextEditor();
    std::optional<com::zoho::common::HorizontalAlignType> getHAlignFromSkParagraph(sktexteditor::Editor::TextParagraph& para, float* firstLinePos);

public:
    std::shared_ptr<ZBBox> bbox = nullptr;
    std::shared_ptr<NLLayer> bboxLayer = nullptr;
    bool autoCapitalize = true;
    bool combineAutoCapitalizeDelta = false;
    bool unCapitalize = false;

    sktexteditor::Editor::PaintOpts options;
    graphikos::painter::GLRect transformRect;
    sktexteditor::Editor* textEditor = nullptr;
    bool isDataUpdated = false;
    std::string currentCompositionString;

    // Editor Owner
    skia::textlayout::TextStyle getProcessedTextStyle(sktexteditor::Editor* editor, const sktexteditor::Editor::PortionStyle& style, size_t paragraphIndex) override;
    void selectionChanged(sktexteditor::Editor* editor, sktexteditor::Editor::SelectionRange old) override;
    void willChangeTypingProperties(sktexteditor::Editor* editor, sktexteditor::Editor::TextProperties oldProps, sktexteditor::Editor::TextProperties& newProps) override;
    bool shouldReplaceText(sktexteditor::Editor* editor, sktexteditor::Editor::SelectionRange affectedRange, std::string replacementString) override;
    bool handleDeleteAction(sktexteditor::Editor* editor) override;
    bool shouldReplaceText(sktexteditor::Editor* editor, sktexteditor::Editor::SelectionRange affectedRange, std::vector<sktexteditor::Editor::TextParagraph> replacementParas, bool overridesFirstParaParaStyle) override;
    void textDidChange(sktexteditor::Editor* editor) override;

    int getTextBodyPortionIndex(sktexteditor::Editor::TextCharPosition textEditorPos) const;
    std::string getSelectedTextByPosition(sktexteditor::Editor::TextCharPosition start, sktexteditor::Editor::TextCharPosition end);

    TextEditorControllerImpl(NLDataController* dataController, ZSelectionHandler* selectionHandler, ControllerProperties* properties, NLEditorProperties* editorProperties, std::shared_ptr<NLLayer> bboxLayer, std::shared_ptr<ZBBox> bbox);

    void onAttach() override;
    void onDetach() override;

    bool clearMainUserData();
    void clearSelection();
    bool assignTextBody(com::zoho::shapes::TextBody* textBody);
    virtual void setEditingCloneTextBody(std::shared_ptr<com::zoho::shapes::TextBody> textBody);
    virtual std::shared_ptr<com::zoho::shapes::TextBody> getEditingTextBody() const;

    std::string getShapeId();
    //This function only inits the shape Data and will not enables/disables the text input field text area
    void initWithShapeDetails(graphikos::painter::ShapeDetails shapeDetails, bool moveCursor = true);
    void reInit(graphikos::painter::ShapeDetails shapeDetails);

    virtual void renderText() {}
    std::shared_ptr<NLPictureRecorder> getTextBodyAsPicture();

    virtual void onExit();

    bool onMouse(graphikos::painter::GLPoint point, sktexteditor::Editor::InputState state, int modifiers, int clickCount);

    void TextSelectionAndCursorThrow();
    bool isUserSuggestionPopoverActive() { return userSuggestionPopoverStatus; }
    void setUserSuggestionPopoverStatus(bool status);
    void insertUserMention(std::string zuid);

    bool isBreakWordPresent();
    static bool isBreakWordPresent(sktexteditor::Editor* textEditor);
    void changeFontScale(float fontScale);
    void changeLineSpaceScale(float diffInlineSpace);
    void updateCacheData(graphikos::painter::ShapeDetails shapeDetails);
    void setCurrentFontSize(float fontSize);
    void changeErrorLines(int si, int ei, bool addLine) override;
    bool isMisspellWordSelected() override;

    static int getTextIndex(sktexteditor::Editor* editor, sktexteditor::Editor::TextCharPosition pos);
    sktexteditor::Editor::TextCharPosition getTextCharPosition(int index) const;

    //layer accessors and populators
    void clearTextLayer();
    void refreshTextBodyLayer(); // populates the shape to selected-shp-layer (implemented for an edge case)

    void updateTextData();
    void dataUpdated(bool needRender = false, std::vector<std::string> shapeIds = {}) override;

    graphikos::painter::ShapeDetails getShapeDetails(graphikos::painter::GLPoint mouse, graphikos::painter::GLRect frame, bool onModifier);

    //overriden events
    bool onMouseDown(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onMouseUp(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onMouseMove(const graphikos::painter::GLPoint& mouse, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onDoubleClick(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onDoubleClickEnd(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onTripleClick(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onTripleClickEnd(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onRightClickDown(const graphikos::painter::GLPoint& mouse, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onRightClickUp(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onKeyPress(int keycode, int modifier, std::string keyCharacter, const SkMatrix& matrix) override;
    bool onKeyDown(int keyCode, int modifier, bool repeat, std::string keyCharacter, const SkMatrix& matrix) override;
    bool onTextInput(std::string inputStr, int compositionStatus, const SkMatrix& matrix) override;
    bool onDrag(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLPoint& prevPoint, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onMouseHold(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLPoint& prevPoint, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    void onLoop(SkMatrix parentMatrix) override;
    void onViewTransformed(const ViewTransform& viewTransform, const SkMatrix& totalMatrix) override;

    std::shared_ptr<NLRenderTree> getRenderTreeWithoutText();

    void handleTextSelectionByBullet(const graphikos::painter::GLPoint& point, sktexteditor::Editor::InputState state);

    static TextEditorControllerImpl* getTextEditorControllerImpl(TextEditorController* textEditorController) {
        return static_cast<TextEditorControllerImpl*>(textEditorController);
    }

    ~TextEditorControllerImpl();

    // TextEditorController
    //this function will init the shapeDetails and also enables/disables the text input field text area
    void init(graphikos::painter::ShapeDetails shapeDetails) override;
    bool exitTextEdit(bool triggerEvent = true) override;
    void disableTextEdit() override;

    float getCurrentTextHeight() override;
    float getCurrentFontSize() const override;
    sk_sp<SkTypeface> getCurrentTypeFace() const override;
    graphikos::painter::GLPoint getInsetDimensons() const override;
    graphikos::painter::GLPoint getTextDimensons() const override;
    float getCurrLineHeightInPara() const override;
    bool checkForSameLine() const override;
    bool canFitInLine(float width) const override;
    bool canFitString(std::string str, float fontScale, graphikos::painter::GLRect textContainerDim, bool isEnter) const override;
    ShapingResult calculateTextSizeWithStr(std::string str, float origFontScale, float newFontScale, graphikos::painter::GLRect textContainerDim, bool isEnter, bool forAllParas = true) const override;

    bool isEditable() override { return _isEditable; }
    void setIsEditable(bool editable) override;
    bool isRenderOnly() override;
    void enableRenderOnly() override;
    void disableRenderOnly(bool enableEditing = false) override;
    void setIsCommenter(bool commenter) override;
    void setDisplayCursorForCommenter(bool value) override;
    void setTableId(std::string id) override;
    void setConnectorId(std::string id) override;
    SkMatrix renderMatrix(bool withInsetTranslate = true) override;
    void shapeSelected(SelectedShape shape, graphikos::painter::GLPoint selectedPoint = graphikos::painter::GLPoint()) override;
    bool isHoveredOverBullet(graphikos::painter::GLPoint point, bool onlyCheckBox = false) override;
    bool refreshNeighboursForCurrentShape() override; //determines if current shapeId is an inner shape
    void onShapeDataChange(std::vector<std::string> shapeIds, bool isFontAdd) override;
    bool mouseInsideEditor(graphikos::painter::GLPoint mouse, bool considerOnlyShape = false) override;
    bool mouseInsideText(graphikos::painter::GLPoint mouse) override;
    bool mouseInsideAnotherShape(graphikos::painter::GLPoint mouse, graphikos::painter::GLRect frame, bool onModifier, const SkMatrix& matrix);

    void clearCache() override;
    void invalidateLayout(size_t startPara, size_t endPara) override;
    void addDefaultFontFamilies(std::vector<std::string> fontFamilies) override;

    bool onChar(int key, int modifier, std::string keyCharacter) override;

    void selectAll() override;

    void attachTextLayer(bool onTop = false) override;
    void attachTextBodyToLayer() override;         // populates live text editing and its components to a sublayer
    void attachShapeWithoutTextToLayer() override; // populates shape without textbody to selected-shp-layer
    bool needToRefreshLayer() override;
    void refreshEmojiImages(std::string imageKey) override;

    void setConnectorController(std::shared_ptr<ConnectorController> _connectorController) override;

    bool insideHyperLink(const graphikos::painter::GLPoint& point, graphikos::painter::ShapeDetails shpDetails, bool needToTrigger = true) override;

    void setSelectionForSiEi(int si, int ei) override;
    std::vector<graphikos::painter::GLRect> getBulletRect(int paraIndex = -1) override;

    std::vector<int> getSiEi() const override;
    std::vector<int> getSiEiForPropertyUpdates() override;   // si ,ei , fromindex , to index , ops
    std::vector<int> getCharacterPos(int si) const override; // paranum , portion num
    std::string getSelectedText() override;
    std::string getTextBySiEi(int si, int ei) override;

    bool changeTypingProperties(com::zoho::shapes::PortionProps* fullProps, std::string changedValue) override;
    bool paste(std::string value) override;
    void triggerParaDelete(size_t paraIndexForRemove) override;
    void textEditorInsertUserMention(std::string zuid) override;
    void setTextEditorUserSuggestionPopoverStatus(bool status) override;
    bool goToTextEdit(int fromIndex = -1, int toIndex = -1, bool selectAll = false) override;
    void goToTextEdit(graphikos::painter::ShapeDetails shapeDetails, int fromIndex = -1, int toIndex = -1, bool selectAll = false) override;
    void goToTextEdit(graphikos::painter::ShapeDetails shapeDetails, const graphikos::painter::GLPoint& point);
    void pasteTextBodyJSON(std::string textBodyJSON, bool withStyle) override;
    bool pasteTextBody(com::zoho::shapes::TextBody textBody, bool withStyle) override;
    std::vector<ShapeData> textDependencyChanges(com::zoho::shapes::TextBody* textBody) override;
    SelectedShape getFirstSelected();

    //apis for automation
    void selectTextByParaIndex(size_t fromIndex, size_t toIndex) override; //indices to fPara - index
    void setCursorAtParaIndex(int paraIndex) override;                     //fPara - index

    void enableEditorMouseDrag() override;
    void disableEditorMouseDrag() override;

    std::vector<TextEditorController::WordDetails> getWordsInPara(size_t paraIndex, size_t startChar, size_t endChar);
    std::vector<TextEditorController::WordDetails> getWords(size_t startIndex, size_t endIndex) override;
    size_t getNextWordEnd(int startIndex) override;
    TextEditorController::WordDetails getWord(int startIndex) override;
    void renderSelectionBox(com::zoho::shapes::Transform changedTransform);
    graphikos::painter::GLRect getSelectionRect(int si, int ei) override;
    graphikos::painter::GLRect getSelectionRect(sktexteditor::Editor::TextCharPosition startPos, sktexteditor::Editor::TextCharPosition endPos);
    std::optional<TextEditorController::CursorDetails> getCurrentCursorDetails() override;
    void updateTextArea(bool isUpdate);

    void updateWordDetails(TextEditorController::WordDetails& wordDetail, std::string& lineString, sktexteditor::StringSlice& stringSlice, std::vector<std::pair<size_t, bool>>& wordBreaks);
    static TextEditorController::WordDetails parseTextBodyNonTextEditMode(graphikos::painter::ShapeDetails shapeDetails, int index, NLDataController* dataLayer, ZSelectionHandler* selectionHandler);
};

#endif
