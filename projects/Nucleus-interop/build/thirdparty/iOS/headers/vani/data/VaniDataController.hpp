#ifndef __NL_VANIDATACONTROLLER_H
#define __NL_VANIDATACONTROLLER_H

#include <app/NLDataController.hpp>
#include <app/controllers/NLEditorProperties.hpp>
#include <vani/RemoteBoardModel.hpp>
#include <painter/SelectionContext.hpp>
#include <nucleus/core/NLRenderTree.hpp>
#include <vani/VaniProvider.hpp>
#include <unordered_map>

#ifdef __EMSCRIPTEN__
extern "C" int getJSTotalHeapSize();
#endif

namespace com {
namespace zoho {
namespace shapes {
namespace build {
class SelectedTableInfo;
class SelectedShapeInfo;
class SelectedShapesInfo;
}
}
namespace remoteboard {
class Flow;
}
}
}

namespace google {
namespace protobuf {
template <typename T>
class RepeatedPtrField;
}
}

class VaniData;
namespace Performance {
struct TrackedData;
}

struct FontSizeData {
    std::string familyName;
    int fontSize;
};

struct RenderTreeData {
    int leafShapeCount;
    int groupShapeCount;
    int cacheContainerMapSize;
};

struct ProjectDataDetails {
    std::string projectName;
    std::string deserializationTime;
    int projectDataSizeKB;
    int deserializedProjectDataSize;
};

struct PerformanceStats {
    ProjectDataDetails projectDataDetails;
    RenderTreeData renderTreeData;
    std::vector<FontSizeData> fontSizeDatas;
    std::vector<Performance::TrackedData> trackedDatas;
    int totalFontSize;
    int imageDataInGPU;
#ifdef __EMSCRIPTEN__
    int jsHeapSizeMB;
#endif
};
#ifdef ENABLE_TRACKING

class VaniDataController;

PerformanceStats getPerformanceStats(VaniDataController* dataController);
void _printPerformanceStats(VaniDataController* dataController);
ProjectDataDetails _getProjectDataDetails(std::shared_ptr<RemoteBoardModel> modelUtil);
RenderTreeData _getRenderTreeData(std::shared_ptr<NLRenderTree> anchorNlRenderTree);
int _getTotalFontSize(std::unordered_map<std::string, int> fondDataMap);
std::vector<FontSizeData> _getFontSizeData(std::unordered_map<std::string, int> fondDataMap);
int _getTotalImageDataInGPU(VaniProvider* provider);
PerformanceStats _getPerformanceStats(VaniDataController* dataController);
std::vector<Performance::TrackedData> _getTrackedDataForAllMethods();
Performance::TrackedData _getTrackedDataForMethod(std::string methodName);

#endif

class VaniDataController : public NLDataController {
private:
    static std::string currentFrameId;
    NLEditorProperties* editorProperties = nullptr;
    std::shared_ptr<NLRenderTree> anchorNlRenderTree;
    std::vector<std::shared_ptr<com::zoho::shapes::ShapeObject>> frameDetailsArr = {}; // stores the shared_ptr globally thereby increasing the ref count in order to access frameDetails across web

    // contains the innerFrame that are converted as ShapeObject ptr that needs to be destroyed on out of scope of its parent. Map[parentFrameShapeObjectPtr] => vector<innerFrameShapeObjectPtr>
    std::map<com::zoho::shapes::ShapeObject*, std::vector<std::shared_ptr<com::zoho::shapes::ShapeObject>>> innerFrameShapeObjectMap = {};

public:
    std::string myZuid;
    bool enablePageCache = false;
    std::shared_ptr<VaniData> vaniData = nullptr;
    google::protobuf::RepeatedPtrField<com::zoho::shapes::build::SelectedShapesInfo>* selectedShapesAsJS = nullptr;
    google::protobuf::RepeatedPtrField<com::zoho::shapes::build::SelectedShapesInfo>* unSelectedShapesAsJS = nullptr;
    VaniDataController(ControllerProperties* properties, NLEditorProperties* editorProperties, ZSelectionHandler* selectionHandler, NLLayerProperties* layerProperties, graphikos::painter::GLRect viewPortRect, SkColor layerColor, NLRenderer::Mode mode);

    void setProjectData(std::shared_ptr<com::zoho::remoteboard::build::ProjectData> projectData);
    void onSetBytes(const uint8_t* data, const size_t data_len) override;
    void onSetCommentsBytes(const uint8_t* data, const size_t data_len, std::string docId) override;
    bool setJSONProject(std::string jsonStr) override;

    void buildRenderTree(std::string docId) override;
    void build(std::string docId);
    void renderDocument(std::string docId);
    void renderFrame(std::string screenId, std::string docId);
    std::string getCurrentFrameId() { return currentFrameId; };
    void cachePagesIfNeeded();

    void setModeNew(bool isNew);
    void setMyZuid(std::string zuid) {
        myZuid = zuid;
    }
    void setEnablePageCache(bool check) {
        enablePageCache = check;
    }
    bool isPageCacheEnabled() {
        return enablePageCache;
    }
    std::string getPictureKey(const com::zoho::shapes::PictureValue& picValue) override;

    std::shared_ptr<NLRenderTree> getAnchorRenderTree() {
        return anchorNlRenderTree;
    }

    void setEditingTextBody(std::shared_ptr<com::zoho::shapes::TextBody> editingTextBody) override; // needed for textEditorController

    com::zoho::remoteboard::build::DocumentData* getCurrentDocumentData();

    void onInitRenderingStyles() override;
    SkColor getBackgroundColor(bool useDocBackground = true) override;

    std::vector<graphikos::painter::GLRect> getShapeRects(std::vector<std::string> shapeIds) override;
    void selectShapeWithNoFill(std::vector<graphikos::painter::ShapeDetails>& shapeDetailsArray, com::zoho::shapes::ShapeObject* topShape, int topShapeIndex, const graphikos::painter::GLPoint& point, const SelectionContext& sc, graphikos::painter::ShapeDetails shapeDetailsHit);
    void getInnerShapeDetailsWithReaction(std::vector<graphikos::painter::ShapeDetails>& shapeDetailsArray, const graphikos::painter::GLPoint& point, int topShapeIndex, com::zoho::shapes::ShapeObject* groupShapeObject, const SelectionContext& sc);

    //virtual functions
    std::tuple<std::vector<graphikos::painter::ShapeDetails>, std::vector<std::string>> getShapeDetails();
    std::vector<graphikos::painter::ShapeDetails> getShapeDetailsFromHitTest(graphikos::painter::GLPoint point, const SelectionContext& sc) override;
    std::vector<graphikos::painter::ShapeDetails> getShapeDetailsFromHitTest(const std::string& shapeId, graphikos::painter::GLPoint point, const SelectionContext& sc) override;
    graphikos::painter::ShapeDetails getShapeDetailsFromHitTest(graphikos::painter::GLPoint mouse, graphikos::painter::GLRect frame, bool onModifier, const SkMatrix& matrix, SelectionContext& sc) override;
    graphikos::painter::ShapeDetails getShapeDetailsFromHitTest(graphikos::painter::GLPoint mouse, graphikos::painter::GLRect frame, bool onModifier, const SkMatrix& matrix) override;
    graphikos::painter::ShapeDetails getContainerShapeDetails(graphikos::painter::GLPoint point, const SelectionContext& sc) override;
    std::vector<graphikos::painter::ShapeDetails> traverseShapes(google::protobuf::RepeatedPtrField<com::zoho::shapes::ShapeObject>* shapes, graphikos::painter::GLPoint point, const SelectionContext& sc);

    std::vector<graphikos::painter::ShapeDetails> getShapeDetailsWithinRange(graphikos::painter::GLRect range, const SelectionContext& sc, bool addToFrameDetailsArr = false) override;
    std::vector<graphikos::painter::ShapeDetails> getShapeDetailsWithinRange(graphikos::painter::GLRect range, bool addToFrameDetailsArr = false) override;
    std::vector<graphikos::painter::ShapeDetails> traverseShapesWithinRange(google::protobuf::RepeatedPtrField<com::zoho::shapes::ShapeObject>* shapes, std::vector<graphikos::painter::ShapeObjectsDetails>& parentShapeObjectDetail, graphikos::painter::GLRect range, const SelectionContext& sc, graphikos::painter::GLRect parentRect, bool addToFrameDetailsArr = false);
    bool checkForFullFit(graphikos::painter::GLRect range, graphikos::painter::GLRect shapeBound);
    std::vector<std::string> getFramesWithinRange(graphikos::painter::GLRect range);

    graphikos::painter::ShapeDetails getDetailsWithRect(com::zoho::shapes::ShapeObject* shapeobject, graphikos::painter::GLRect range, const SelectionContext& sc) override;
    graphikos::painter::ShapeDetails getShapeDetailsById(std::string shapeId, bool includeFrames = true, bool checkInnerShape = false, bool addToFrameDetailsArr = false) override;
    graphikos::painter::ShapeDetails getShapeDetailsById(std::vector<std::string> ids, bool includeScreens) override;
    graphikos::painter::ShapeDetails getShapeDetailsById(std::string shapeId, std::string docId, bool includeScreens = true, bool checkInnerShape = false, bool fromClonedData = false, bool addToFrameDetailsArr = false) override;
    graphikos::painter::ShapeDetails constructTextBodyShape(std::string parentShapeId, std::string textBodyId);
    graphikos::painter::ShapeDetails getAnchorShapeDetails(graphikos::painter::GLPoint point, graphikos::painter::GLRect frame, bool modifier);
    graphikos::painter::ShapeDetails traverseShapesById(google::protobuf::RepeatedPtrField<com::zoho::shapes::ShapeObject>* shapes, std::string shapeId, const SelectionContext& sc);
    graphikos::painter::ShapeDetails getShapeDetailsFromClone(std::string shapeId, std::string docId = "", bool addToFrameDetailsArr = false);
    float getShapeCountRatio(std::vector<int> rootLevelElemIndices) override;

    void getDefaultFrame(com::zoho::shapes::ShapeObject* shapeObject, bool addEffects = true);

    google::protobuf::RepeatedPtrField<com::zoho::shapes::ShapeObject>* getContainerShapes(GL_Ptr<google::protobuf::Message> screenOrShapeObject) override;
    std::shared_ptr<com::zoho::shapes::ShapeObject> convertContainerAsShapeObject(GL_Ptr<google::protobuf::Message> screenOrShapeObject, const graphikos::painter::RenderSettings& renderSettings) override;
    std::shared_ptr<com::zoho::shapes::ShapeObject> getContainerNameShapeObject(std::string frameName, graphikos::painter::GLRect& frameRect, std::string frameId, float scale = 1.0f);
    std::unique_ptr<skia::textlayout::Paragraph> buildFrameNameParagraph(std::string frameId, std::string frameName, float scale, std::vector<std::string>& frameNameEmojiList, bool needHover = false);
    std::shared_ptr<com::zoho::shapes::ShapeObject> convertFrameAsShapeObject(com::zoho::remoteboard::Frame* frame, const graphikos::painter::RenderSettings& renderSettings);
    std::vector<std::string> getAllShapeIdsByType(com::zoho::shapes::ShapeNodeType type) override;
    std::vector<std::string> traverseShapesByType(google::protobuf::RepeatedPtrField<com::zoho::shapes::ShapeObject>* shapes, com::zoho::shapes::ShapeNodeType type);
    graphikos::painter::GLRect getWholeRegionOfContainerShapes(SelectedShape selectedShape) override;
    void getFrameAsShapeObject(com::zoho::remoteboard::Frame* frame, std::vector<std::shared_ptr<com::zoho::shapes::ShapeObject>>& innerFrameShapeObjectsList, com::zoho::shapes::ShapeObject* shapeObject = nullptr);
    com::zoho::shapes::ShapeObject* getContainerShapeObject(std::string frameId) override;
    void releaseFrameAndShapes(com::zoho::shapes::ShapeObject* shapeObject);
    graphikos::painter::ShapeObjectsDetails getFrameAsShape(com::zoho::remoteboard::Frame* frame, bool populateMatricesFromCache = true);
    com::zoho::remoteboard::Frame* getFrameFromId(std::string screenId, std::string docId = "");
    void unSelectFrameOrShape(std::string shapeId, bool triggerEvent);
    void overOnShape(std::string shapeId);
    std::string getFrameName(std::string screenId);

    std::multimap<std::string, com::zoho::shapes::Transform> getContainerNameAndTransform() override;
    com::zoho::shapes::Transform* getContainerTransform(std::string id) override;
    graphikos::painter::GLPath getEmbedTitleRegion(com::zoho::shapes::ShapeObject* shapeObject, graphikos::painter::Matrices matrices) override;
    bool getReactionDetails(std::vector<graphikos::painter::ShapeDetails>* shapedetailsArray, graphikos::painter::GLPoint point, com::zoho::shapes::ShapeObject* shape, const SelectionContext& sc);
    void updateContainer(std::vector<std::string> shapeIds) override;

    com::zoho::shapes::Locks* getContainerLocks(ShapeContainer& shape) override; // specially for container

    void triggerEmbedRendered(com::zoho::shapes::ShapeObject* shapeObject);
    void triggerPictureRendered(com::zoho::shapes::Picture* picture);
    //shape framework removal fns
    google::protobuf::RepeatedPtrField<com::zoho::shapes::build::SelectedShapesInfo>* getSelectedAsJS(std::vector<SelectedShape> selectedShapesSoFar);
    void convertSelectedDataAsJS(std::vector<SelectedShape>& shapes, google::protobuf::RepeatedPtrField<com::zoho::shapes::build::SelectedShapesInfo>* convertedShapes, bool forUnselectedShape = false);
    void populateSelectedData() override;
    void getSelectedShapeData(com::zoho::shapes::ShapeObject* shapeObject, com::zoho::shapes::build::SelectedShapeInfo* selectedData, bool isContainer = false, bool textEditableShape = true, bool forUnselectedShape = false);
    void getInnerSelectedShapeData(com::zoho::shapes::ShapeObject* shapeObject, google::protobuf::RepeatedPtrField<com::zoho::shapes::build::SelectedShapeInfo>* selectedShapes, bool isContainer = false, bool forUnselectedShape = false);
    void getSelectedShapeTextData(SelectedShape Shape, com::zoho::shapes::build::SelectedShapesInfo* selectedShape, bool textEditableShape = true, bool forUnselectedShape = false);
    void getTableSelection(com::zoho::shapes::build::SelectedTableInfo* table);
    bool isShapeInRange(graphikos::painter::GLRect range, std::string shapeId) override;
    bool isInnerShapeIterable(com::zoho::shapes::ShapeObject* shapeObject);
    bool isInnerShapePresent(google::protobuf::RepeatedPtrField<com::zoho::shapes::ShapeObject>* shapes, std::string shapeId);
    bool removeStickyNoteTextEditingData(google::protobuf::RepeatedPtrField<com::zoho::shapes::build::SelectedShapeInfo>* shapes, bool isEditingTextBodyNull);
    // void clearSelectedShapes(bool triggerEvent, std::string shapeId = "") override;
    com::zoho::shapes::ShapeObject* getDefaultNonEditAnchor(float left, float top, std::string id);
    com::zoho::shapes::ShapeObject* getDefaultEditAnchor(float left, float top, std::string id);
    void setAnchorValues(com::zoho::shapes::ShapeObject* shapeObject, std::string anchorId, std::string anchorTitle);
    com::zoho::remoteboard::Flow* getFlowFromIndex(int index);
    std::vector<std::shared_ptr<com::zoho::shapes::ShapeObject>>& getFrameDetailsArr();
    graphikos::painter::GLRect getMaxCoverageRectGivenshapeIds(std::vector<std::string> shapeIds);
    bool allowOverFlowForBestFit(com::zoho::shapes::ShapeObject* shapeObject) override;

    std::string getRootFieldID(std::string shapeId);

    void regenerateAndRenderFullDocument(const std::string& docId) override;

#ifdef ENABLE_TRACKING

    friend void _printPerformanceStats(VaniDataController* dataController);
    friend ProjectDataDetails _getProjectDataDetails(std::shared_ptr<RemoteBoardModel> modelUtil);
    friend RenderTreeData _getRenderTreeData(std::shared_ptr<NLRenderTree> anchorNlRenderTree);
    friend int _getTotalFontSize(std::unordered_map<std::string, int> fondDataMap);
    friend std::vector<FontSizeData> _getFontSizeData(std::unordered_map<std::string, int> fondDataMap);
    friend int _getTotalImageDataInGPU(VaniProvider* provider);
    friend PerformanceStats _getPerformanceStats(VaniDataController* dataController);
    friend std::vector<Performance::TrackedData> _getTrackedDataForAllMethods();
    friend Performance::TrackedData _getTrackedDataForMethod(std::string methodName);

#endif

    bool isPageFrame(std::string shapeId) override;
    bool isPageFrameShape(std::string shapeId) override;

    int getIndex(graphikos::painter::ShapeObjectsDetails shape) override;
    google::protobuf::RepeatedPtrField<std::string> getChildContainerIds(std::string containerId);
    int getChildContainerIndex(std::string containerId);
#ifdef __EMSCRIPTEN__
    void triggerDrawObjectCallback(std::shared_ptr<CallBacks> callback, DrawData drawObject) override;
#endif
    ~VaniDataController();
};

#endif
