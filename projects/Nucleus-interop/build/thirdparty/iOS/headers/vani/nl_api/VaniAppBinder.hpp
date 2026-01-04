#ifndef __NL_VANIAPPBINDER_H
#define __NL_VANIAPPBINDER_H

#include <app/nl_api/AppBinder.hpp>
#include <vani/Vani.hpp>
#include <vani/data/VaniDataController.hpp>
#include <app/util/ZShapeAlignUtil.hpp>
#include <app/CollabController.hpp>
#include <vani/nl_api/VaniCallBacks.hpp>
#include <nucleus/core/layers/NLScrollLayer.hpp>
#include <vani/VaniCommentHandler.hpp>

class ProtoBuilder;

namespace com {
namespace zoho {
namespace collaboration {
class DocumentContentOperation;
class DocumentContentOperation_Component;
class DocumentContentOperation_Component_Text;
}
namespace shapes {
namespace build {
class SelectedShapeConnectInfo;
};
}
}
}

class VaniAppBinder : public AppBinder {
private:
    TextEditorController* getTextEditor();

public:
    struct TextCursorDetails {
        int cursorIndex;
        graphikos::painter::GLRect cursorRect;
        std::vector<float> colorArr;
    };
    VaniAppBinder();
    com::zoho::remoteboard::build::ProjectData* getProjectData();
    com::zoho::remoteboard::Project* getProject();
    com::zoho::remoteboard::Project* getClonedProject();

    void setDocumentIds(std::vector<std::string> documentIds);
    std::string getProjectId();
    std::string getProjectTitle();
    com::zoho::remoteboard::build::DocumentData* getDocumentData(std::string docId);
    com::zoho::remoteboard::build::DocumentData* getClonedDocumentData(const std::string& docId);
    com::zoho::remoteboard::Document* getDocument(std::string docId);
    com::zoho::remoteboard::Frame* getFrameById(std::string frameId, std::string docId);
    int getFrameIndexById(std::string frameId, std::string docId);
    std::tuple<std::vector<graphikos::painter::ShapeDetails>, std::vector<std::string>> getShapeDetails();
    google::protobuf::RepeatedPtrField<std::string> getDocumentIds();
    google::protobuf::RepeatedPtrField<std::string> getDocumentTitles();

    com::zoho::comment::build::DocumentCommentData* getDocumentComments(std::string docId);
    com::zoho::comment::build::DocumentCommentData* getClonedDocumentComments(std::string docId);
    com::zoho::comment::build::DocumentCommentData* getDocCommentDataByDocCommentId(std::string docCommentId);
    com::zoho::common::DocBaseMeta* getCommentBaseMeta(std::string docId);
    std::string getDocIdByDocCommentId(std::string commentId);
    void setMode(Vani::VaniMode mode);
    void setDevMode(bool isDevmode = false);
    Vani::VaniMode getModeFromString(std::string modeName);
    google::protobuf::RepeatedPtrField<com::zoho::shapes::build::SelectedShapesInfo>* getSelectedShapesInfo(std::vector<SelectedShape> selectedShapesSoFar = {});

    void renderDocument(std::string docId) override;
    void setMyZuid(std::string zuid);

    void cropImage();
    void resetCrop();
    bool isCropState();
    void setCrop();
    graphikos::painter::GLPoint getRemoveIconPosition();

    bool isTextEditMode() override;
    bool isCustomTextEditMode();
    void reInitCustomTextEditor(std::string text, int si = 0, int ei = 0);
    void textEditorInsertUserMention(std::string zuid);
    void goToTextEditMode(int rowIndex, int colIndex, std::string textBodyId, int fromIndex, int toIndex, bool selectAll);
    void exitTextEdit();
    void setTextEditorUserSuggestionPopoverStatus(bool status);

    void updateSnappingState(bool snappingState);
    bool getSnappingState();
    VaniAppBinder::TextCursorDetails getCursorDetails();
    graphikos::painter::GLRect getDenseRegion(float width, float height);

    //composer
    void handleDelta(std::string deltaString, std::string docId);
    google::protobuf::Message* Compose(google::protobuf::RepeatedPtrField<com::zoho::collaboration::DocumentContentOperation_Component>* contentOps, ProtoBuilder* builder);
    google::protobuf::Message* Compose(com::zoho::collaboration::DocumentContentOperation* docContentOp, ProtoBuilder* builder);
    ProtoBuilder* toBuilder(google::protobuf::Message* message, bool omitRootField, bool releaseForDelete = false, bool createOperations = true);
    ProtoBuilder* newBuilder(google::protobuf::Message* message, bool omitRootField, bool releaseForDelete = false, bool createOperations = true);

    std::vector<graphikos::painter::GLPoint> getConnectorBBoxPosition();
    void changeConnectorType(CONNECTOR_TYPE curvedOrElbow, float cornerRadius = 0);
    void setCurrentConnector(std::string connectorType);
    std::vector<ShapeData> addShapeAndConnect(bool isStartPoint, DrawData appData, bool updateTextTransformCallBack, com::zoho::shapes::ShapeObject* drawShapeData = nullptr);
    com::zoho::shapes::ShapeObject getShapeByReferenceShape(DrawData appData, std::string anotherShapeId, std::string oppositeParaId = "", bool updateTextTransformCallBack = false);
    std::vector<ShapeData> shortestPath(com::zoho::shapes::ShapeObject* connectorShape, com::zoho::shapes::ShapeObject* startData, com::zoho::shapes::ShapeObject* endData, int startIndex, int endIndex);
    void enableConnectorPointsMode();
    float getMarkerOrientation(com::zoho::shapes::ShapeObject* connectorShape, com::zoho::shapes::Transform* mergedTransform, bool isStartingPoint);
    com::zoho::shapes::PointOnPath addTextBox(std::string shapeId);
    com::zoho::shapes::PointOnPath addTextBoxData(com::zoho::shapes::ShapeObject* shapeObject);
    std::vector<ShapeData> updateDependencyTextBodyData(com::zoho::shapes::ShapeObject* connectorShape);
    std::vector<ShapeData> changeShapeRoute();
    std::vector<ShapeData> getUpdatedTableModifyData(com::zoho::shapes::ShapeObject* shapeObject, bool needGroupShapeModify);

    void setDistribute(ZShapeAlignUtil::AlignType alignType);
    void setAlign(ZShapeAlignUtil::AlignType alignType);
    void setAlignType(ZShapeAlignUtil::AlignTo align);
    bool getEditingLayerStatus();

    void clearTableSelection();

    void switchToEditAnchor(std::string anchorId);
    void switchToNonEditAnchor(com::zoho::shapes::ShapeObject* anchorShapeObject, bool isEscapeKey = false);

    void setContinuousDrawing(bool isContinuousDraw);
    void clearDrawMode();
    void setDrawObject(const DrawData& drawData);
    bool isDrawMode();

    void updateCSRect(graphikos::painter::GLRect rect);
    graphikos::painter::GLRect getCSRect();
    void enableCS();
    void disableCS();

    std::map<std::string, graphikos::painter::GLPoint> getBBoxPoints();
    graphikos::painter::GLPoint getRotateOffset();
    std::vector<graphikos::painter::GLPoint> getModifierPoints();

    void regenerateAndRenderFullDocument(const std::string& docId);
    void dataUpdated(bool needRender = false, std::vector<std::string> shapeIds = {});
    void clearClonedData();
    void clearClonedCommentsData();
    void setRowColIndex(int rowIndex, int cellIndex);
    void changeContinousProps(std::string value, com::zoho::shapes::ShapeNodeType validShape, ZEditorUtil::ContinuousEditType type, bool isMouseDown = true, bool isGRPFillEnabled = false);
    void audioPlayerAction(bool playingState, float playerCurrentTime, std::string resetAudioPlayerId);
    void renderFlowUILayer(int flowIndex);
    void removeFlowUILayer();
    void initFlow(int flowIndex);
    void deInitFlow();
    void moveToFrame(int index);
    int getCurrentFlowIndex();
    com::zoho::remoteboard::Details getFrameDetailsById(std::string id, std::string docId);
    void setDocumentComment(std::string docId, com::zoho::comment::DocumentComment* documentComment);
    void setClonedCommentsData(std::string docId);
    void setDocument(std::string docId, com::zoho::remoteboard::Document* document);
    // void setDocumentData(std::string docId, com::zoho::remoteboard::build::DocumentData* documentData);
    void setFrame(std::string docId, com::zoho::remoteboard::Frame* screen);
    void setProject(com::zoho::remoteboard::build::ProjectData* data);
    void removeDocumentData(std::string docId);
    void removeFrame(std::string docId, com::zoho::remoteboard::Frame* screen);
    void removeDocumentCommentData(std::string docId);
    std::string getSelectedText();
    std::string getTextBySiEi(int si, int ei);

    std::vector<graphikos::painter::GLPoint> getCDPpoints(bool considerOffset = false);
    std::vector<graphikos::painter::GLPoint> getConnectingPoints();
    std::map<std::string, graphikos::painter::GLPoint> getCropFramePoints();
    std::map<std::string, graphikos::painter::GLPoint> getCropImagePoints();
    graphikos::painter::GLPoint getFrameNamePoint(std::string frameId);
    std::string getFrameName(std::string frameId);
    graphikos::painter::GLPoint getAnchorNonEditPoint(std::string anchorId);
    graphikos::painter::GLPoint getAnchorEditPoint(std::string anchorId, std::string action);
    std::string getEditingAnchorId();
    void selectTextByParaIndex(size_t fromIndex, size_t toIndex);
    void setCursorAtParaIndex(int paraIndex);
    std::string getHighlightedContainerId();

    std::vector<int> getCharacterPosition(int index);
    bool changeTypingProperties(com::zoho::shapes::PortionProps* props, std::string changedValue);
    void setCursorIndex(int si, int ei);
    bool pasteText(std::string value);
    void cutText();
    graphikos::painter::GLRect getSelectionTotalBound();
    graphikos::painter::GLRect getOriginalBoundGivenShapeIds(std::vector<std::string> shapeIds);
    graphikos::painter::GLRect getAnchorBound(std::string anchorId);
    std::vector<int> getStartIndexEndIndex(bool forPropertyUpdates = false);
    void reRenderRegion(std::vector<std::string> shapeIds, std::vector<int> opTypes) override;
    std::vector<ShapeData> connectToNearestIndex(com::zoho::shapes::ShapeObject newshapeObject, std::string OldShapeId, std::vector<com::zoho::shapes::ShapeObject> connectorObject);

    void refreshEditingLayers();
    void toggleLayerTranslate(bool enableLayerTranslate);
    void updateCellIndex(int rowIndex, int cellIndex);
    void refreshSelectedLayer(std::vector<std::string> shapeIds);
    graphikos::painter::ShapeDetails getShapeDetailsFromClone(std::string shapeId, std::string docId);
    std::vector<std::string> getParentIds(std::string shapeId, bool fromCache = false);
    std::vector<ShapeData> refreshParaConnector(com::zoho::shapes::TextBody* textBody);
    std::vector<ShapeData> textDependencyChanges(com::zoho::shapes::TextBody* textBody);
    std::vector<ShapeData> textDependencyChanges(std::string shapeId, com::zoho::shapes::Properties* props, bool isTextBox, com::zoho::shapes::TextBody* textBody, bool doNotAutofit);

    bool composeTextInTextBody(google::protobuf::RepeatedPtrField<com::zoho::collaboration::DocumentContentOperation_Component_Text>* text, com::zoho::shapes::TextBody* textBody);
    bool pasteTextBody(std::string textBodyJSON, bool withStyle);
    std::vector<ShapeData> getUpdatedParentWithOutAShape();
    std::vector<ShapeData> modifyTransformsOnInnerShapeDeletion(com::zoho::shapes::ShapeObject* innerShapeData);
    google::protobuf::RepeatedPtrField<com::zoho::remoteboard::Frame>* getClonedFrames(std::string docId);
    com::zoho::remoteboard::Frame* getClonedFrame(const std::string& frameId);
    TextEditorController::WordDetails getWord(size_t startIndex);
    TextEditorController::WordDetails getWordNonTextEditMode(std::string shapeId, int startIndex);
    std::vector<TextEditorController::WordDetails> getAllWords(size_t startIndex, size_t endIndex);
    void selectTextBody(std::string shapeId, std::string textBodyId);

    std::vector<std::string> getFramesWithinRange(graphikos::painter::GLRect range);
    void setRowColResizeGap(int gap);
    void updateProject(com::zoho::remoteboard::build::ProjectData* data);
    void clearCollabShapeId(std::string shapeId);
    void unSelectCollabShape(std::string shapeId, std::string zuid);
    void selectCollabShape(std::string shapeId, CollabController::CollabDetail collabDetail);
    void addTextCollabDetails(std::string shapeId, std::string zuid, int si, int ei, TextEditorController::Color color, std::string cellId = "", std::string textBodyId = "");
    void deleteTextCollabDetails(std::string shapeId, std::string zuid = "", std::string cellId = "", std::string textBodyId = "");
    std::string isAnchorClicked(graphikos::painter::GLPoint mouse);
    void playOrEditEmbed(std::string shapeId, bool editButton = false);

    void renderGifButton(std::string clientKey, std::string shapeId, bool isRemove);
    void clearAllGifButton();
    graphikos::painter::GLRect getRefreshRectForFrame(com::zoho::remoteboard::Frame frame);

    //QA testing
    std::vector<graphikos::painter::GLRect> getBulletRect(int paraIndex);
    std::vector<graphikos::painter::GLRect> getBulletRect();
    void textMoveLineEnd();

    graphikos::painter::GLRect getParaRemoveIcon();

    //finitezone
    void viewShape(std::string id, NLScrollLayer::NLPivot pivot);
    void exitViewingShape();

    //tableController
    bool setDynamicHeight(bool value);
    void selectRowOrCol(bool isRow, int startIndex, int endIndex = -1);
    graphikos::painter::GLRect getTableLabelIconRect(bool isRow);

    std::string getRootFieldID(std::string shapeId);

    void onRegisterWebViewCallbacks() override;
    std::vector<ShapeData> getDependencyForModifiedShapes(std::vector<com::zoho::shapes::build::SelectedShapeConnectInfo> selectedshapeInfoConnectors, std::vector<com::zoho::shapes::ShapeObject> modifieddata);
    VaniCallBacks* getVaniCallBackClass();
    void toggleErrorLineRendering(bool status);
    void changeErrorLines(int si, int ei, bool addLine);
    bool isMisspellWordSelected();
    int getNextWordEnd(int startIndex);
    std::vector<std::string> getInnerFrameIds(std::string frameId);
    std::vector<std::string> getOrderedFrameIds(); // returns framesTreeContainer shapeIds

    void showAIPreviewForFrame(com::zoho::remoteboard::Frame* frame);
    void showAIPreviewForShape(com::zoho::shapes::ShapeObject* shapeObject);
    void removeAIPreview();

    void scrollToAnchor(std::string anchorId, graphikos::painter::GLRect viewPort = graphikos::painter::GLRect(), bool needAnimation = false, bool maintainScale = false, bool alwaysFit = false);
    void navigateToShape(std::vector<std::string> shapeIds, graphikos::painter::GLRect viewPort = graphikos::painter::GLRect(), bool needAnimation = false, bool maintainScale = false, bool alwaysFit = false);
    void refreshFrameShapeObject(std::string frameId);
    void fitTemplates(bool needAnimation, bool maintainScale, bool fitContainer, bool alwaysFit, float fitRatio = 0.0, graphikos::painter::GLRect customRect = graphikos::painter::GLRect());

    //COMMENT API'S
    void addComment(std::string listId, std::vector<std::string> shapeIds, std::vector<std::string> paraIds, std::string type);
    void addDraftComment(graphikos::painter::GLPoint position = graphikos::painter::GLPoint());
    void removeComment(std::string listId, std::string shapeId);
    void removeDraftComment();
    void addPinComment(std::string listId, graphikos::painter::GLPoint position, std::string type);
    void removeAllComments();
    void updateCommentType(std::string listId, std::string type);
    void addHighlightComment(std::vector<std::string> shapeIds, std::vector<std::string> paraIds);
    void removeHighlightComment(std::vector<std::string> shapeIds, std::vector<std::string> paraIds);
    graphikos::painter::GLRect getCommentIconRect(std::string shapeId, std::string listId);
    graphikos::painter::GLRect getGroupCommentIconRect(std::string shapeId, std::string listId);
    graphikos::painter::GLRect getRenderedParahighlight(std::string shapeId, std::vector<std::string> paraIds);
    int getSpotWidth();
    //COMMENT API'S END

    void createIndicatorForRowOrCol(bool isCol, bool towardsLeft);
    void clearTableIndicators();
    graphikos::painter::GLRect getTextSelectionRange(int si, int ei);

    std::vector<float> getHeightForText(com::zoho::shapes::ShapeObject* shapeObject);
    com::zoho::common::Dimension calculateTextSize(com::zoho::shapes::ShapeObject* shapeObject);
    bool nonModifyableInnerShape(SelectedShape selectedShape);
    graphikos::painter::ShapeDetails getEditableParent(SelectedShape selectedShape);

// Performance Stats API
#ifdef ENABLE_TRACKING
    PerformanceStats getPerformanceStats();
    void printPerformanceStats();

    ProjectDataDetails getProjectDataDetails();
    RenderTreeData getRenderTreeData();
    int getTotalFontSize();
    std::vector<FontSizeData> getFontSizeData();
    int getTotalImageDataInGPU();

    std::vector<Performance::TrackedData> getTrackedDataForAllMethods();
    Performance::TrackedData getTrackedDataForMethod(std::string methodName);
#endif

    // automation API method
    std::map<std::string, graphikos::painter::GLRect> getAudioEditRects(std::string shapeID);
    graphikos::painter::GLRect getReactionStatusRect(std::string shapeID, std::string reactionStatus);

    void applyDelta(std::string documentDelta);

// only for wasm
#if defined(NL_ENABLE_NEXUS)
    NXByteMemoryView getDownloadAsset(std::vector<std::string> shapeIds, ExportDetails exportDetails, int extraSpace);
    NXByteMemoryView getDownloadAssetForGivenRect(graphikos::painter::GLRect rect, ExportDetails exportDetails, int extraSpace);
    NXByteMemoryView exportAsMultiplePagedPDF(std::vector<std::string> shapeIds);
    NXByteMemoryView exportFlowAsPDF(std::vector<std::string> shapeIds);
    NXByteMemoryView getFullDocAsImage(int width, int height, graphikos::painter::GLRect clipRect = graphikos::painter::GLRect());
    NXByteMemoryView getFullDocAsImage(std::string docId, int width, int height, graphikos::painter::GLRect clipRect = graphikos::painter::GLRect());
    NXByteMemoryView getFrameAsImage(std::string frameId, float scale);
#else
    std::vector<uint8_t> getFullDocAsImage(int width, int height, graphikos::painter::GLRect clipRect = graphikos::painter::GLRect());
#endif
};

VaniAppBinder* createNLObject();
bool isTrackingEnabled();
#endif
