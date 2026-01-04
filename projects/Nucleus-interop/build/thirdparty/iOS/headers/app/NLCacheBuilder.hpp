#ifndef __NL_NLCACHEBUILDER_H
#define __NL_NLCACHEBUILDER_H

#include <skia-extension/Matrices.hpp>
#include <skia-extension/GLRect.hpp>
#include <painter/RenderSettings.hpp>
#include <painter/DrawingContext.hpp>
#include <painter/PropertiesPainter.hpp>
#include <painter/ShapeObjectPainter.hpp>
#include <painter/GL_Ptr.h>
#include <nucleus/core/NLRenderTree.hpp>
#include <skia-extension/Matrices.hpp>
#include <nucleus/util/RenderTreeUtil.hpp>
namespace google {
namespace protobuf {
class Message;
}
}

typedef enum {
    SHAPEOBJECT,
    SCREENORFRAME,
    ANCHORSHAPE,
    NOTYPE
} ShapeObjectType;

//Structure to hold information on connectors to the shape
struct ConnectorsInfo {
    std::map<std::string, std::vector<std::string>> connectorsAssociatedToShape = {};
    std::map<std::string, std::vector<std::string>> shapesAssociatedToConnector = {};
    bool activeEntity = true;
};

// Structure to hold information about a shape
struct ShapeContainer {
    GL_Ptr<google::protobuf::Message> shapeObject = nullptr;
    GL_Ptr<google::protobuf::Message> screenOrFrameShape = nullptr; // to hold the temperory shapeobject of screen or frame - nneded for rendering reaction in vani
    ShapeObjectType type = SHAPEOBJECT;
    std::string drawCallParent = ""; //Holds in which its' draw calls are captured , For innerShapes, this will be their outermost parent. For other cases, will be null.
    std::string parentShapeId = "";
    graphikos::painter::Matrices currentMatrices;
    graphikos::painter::GLRect customParentBounds = graphikos::painter::GLRect::MakeNaN();
    graphikos::painter::GLRect customBounds = graphikos::painter::GLRect::MakeNaN();
    std::shared_ptr<TreeContainer> treeContainer = nullptr; // Holds the shapeId's innerShapes (only its own children)
    std::vector<std::string> innerShapeIds = {};            // shapeIds whose drawCalls are captured by the cache's shapeId
    // temporary for table
    std::vector<float> rowHeight = {}; // height cache of individual row of table
    float height = 0;                  //height of shape , needed for cell
};

enum RenderOperationType {
    NOOPTYPE = -1,
    INSERT = 0,
    DELETE = 1,
    REORDER = 2,
    UPDATE = 3,
    TEXT = 4,
};

struct ParentInfo {
    int parentIndex;
    std::vector<std::string> parentIds = {};
};

struct ComposedContent {
    RenderOperationType renderOpType = RenderOperationType::NOOPTYPE;
    int shapeIndex = -1;
    std::string shapeId = "";
    ParentInfo parentInfo;
    GL_Ptr<google::protobuf::Message> shapeObject = nullptr;
    graphikos::painter::Type shapeType;
};

// Class responsible for building and managing the render cache
class NLCacheBuilder {
private:
    bool onLoadRendering = true;
    int duplicateCount = 0;
    bool renderErrorLines = true;

    void addShapeIndexToCache(const std::string& shapeId, std::string drawCallParentId, GL_Ptr<google::protobuf::Message> shapeObj, std::string parentId, int si, int ei, int saveCount, bool isRestore, graphikos::painter::Matrices currentMatrices = graphikos::painter::Matrices(), const graphikos::painter::GLRect* customParentBounds = nullptr, const graphikos::painter::GLRect* customBounds = nullptr);
    void addTextBodyIndexToCache(const std::string& shapeId, std::string drawCallParentId, std::string parentShapeId, int txtSi, int txtEi, int errorLineSi, int errorLineEi);
    void populateChildShapeIdsToParentCache(const std::string& parentShapeId, const std::string& childShapeId, graphikos::painter::GLRect bound);
    void setAllInnerShapeIds(std::string shapeId, std::unordered_set<std::string>* shapeIdArray, std::vector<std::string>* shapeIdArrayVec);

protected:
    void populateConnectorInfo(const std::string& id, com::zoho::shapes::ShapeObject* connectorShapeObj);
    std::shared_ptr<graphikos::painter::IProvider> provider = nullptr;
    std::shared_ptr<NLRenderTree> _nlRenderTree = nullptr;
    std::unordered_map<std::string, ShapeContainer> shapeContainerMap = {};
    std::unordered_map<std::string, ConnectorsInfo> connectorInfoMap = {}; // stores the connector info

    NLDataController* data = nullptr;
    DrawingContext* currentDrawingContext = nullptr;
    GL_Ptr<com::zoho::shapes::ShapeObject> currentShapeObject = nullptr;

public:
    NLCacheBuilder();
    NLCacheBuilder(NLDataController* nldata, std::shared_ptr<NLRenderTree> renderTree, std::shared_ptr<graphikos::painter::IProvider> provider);
    void setRenderTree(std::shared_ptr<NLRenderTree> renderTree);
    std::shared_ptr<NLRenderTree> getRenderTree();
    void build(std::string docId);
    void clear();
    virtual void renderPlaceHolderIcon(com::zoho::shapes::ShapeObject* shapeObject, const DrawingContext& dc);
    virtual void prepareCache(std::string docId, const graphikos::painter::RenderSettings& renderSettings);
    virtual bool renderAll(const DrawingContext& dc, std::vector<std::string> selectedContainers = {});
    virtual void renderOutline(const DrawingContext& dc, SkColor screenColor, SkColor shapeColor);
    virtual std::vector<graphikos::painter::GLRect> updateTree(const std::vector<std::string>& shapeIds, const std::vector<int>& opTypes = {});
    void updateTree(std::string shapeId, graphikos::painter::ShapeDetails shapeDetails, const DrawingContext& dc, RenderOperationType opType);

    //cache releated fns
    void addToCache(const std::string& shapeId, ShapeContainer cache);
    void addToCache(const std::string& shapeId, GL_Ptr<google::protobuf::Message> shapeObject, std::shared_ptr<NLPictureRecorder> nlPicture, SkRect rect, GL_Ptr<google::protobuf::Message> screenOrFrame = nullptr, bool isGroupShape = false, bool isRestore = false, int saveCount = 0, int drawCallsCount = 0, graphikos::painter::Matrices currentMatrices = graphikos::painter::Matrices(), const graphikos::painter::GLRect* customParentBounds = nullptr, const graphikos::painter::GLRect* customBounds = nullptr, std::string parentShapeId = "", int parentContainerIndex = -1, int treeContainerIndex = -1);
    void addInnerShapeIdsToParent(const std::string& shapeId, std::vector<std::string> innerShapeIds);
    void addMatricesToCache(graphikos::painter::Matrices matrices, const std::string& shapeId);
    // Cache getters
    ShapeContainer getCacheContainer(const std::string& shapeId);
    ConnectorsInfo getConnectorCache(const std::string& shapeId);
    GL_Ptr<google::protobuf::Message> getShapeObject(const std::string& shapeId);
    virtual com::zoho::shapes::Transform* getTransform(const ShapeContainer& cacheContainer);
    std::vector<std::string> getParentIds(const std::string& shapeId);
    ShapeObjectType getShapeType(const std::string& shapeId);

    void invalidateCache(const std::string& shapeId, std::shared_ptr<NLRenderTree> renderTreeToBeConsidered = nullptr);
    void deleteElement(const std::string& shapeId, std::shared_ptr<NLRenderTree> renderTreeToBeConsidered = nullptr);
    void removeInnerShapesCache(const std::string& shapeId);
    void invalidateRHeightCacheForTable(const std::string& shapeId);

    bool isAlreadyCached(const std::string& shapeId);
    bool isConnectorInfoPopulated(const std::string& drawingPropsType, std::map<std::string, std::vector<std::string>> shapesOrConnectorsAssociated);

    // Recursive function to populate the cache
    void recursivePopulate(std::string shapeId, std::shared_ptr<TreeContainer> treeContainer);
    std::shared_ptr<NLPictureRecorder> convertShapeAsPicture(com::zoho::shapes::ShapeObject* shapeObject, const graphikos::painter::RenderSettings& renderSettings, float scaleValue = 1.0, graphikos::painter::GLRect bound = graphikos::painter::GLRect());

    void appendMaxCoverageRect(graphikos::painter::GLRect bound);
    void appendMaxCoverageRect(com::zoho::shapes::Properties* props);

    // Recording functions
    void renderAndAddCache(GL_Ptr<com::zoho::shapes::ShapeObject> shapeObject, const DrawingContext& dc, SkRect offset = SkRect{0, 0, 0, 0}, std::string parentShapeId = "", int parentContainerIndex = -1, int treeContainerIndex = -1, std::string modifiedShapeId = "");
    bool renderShapeWithFallback(const std::string shapeId, GL_Ptr<com::zoho::shapes::ShapeObject>, DrawingContext dc);

    void updateImmediateParentBound(const std::string& parentShapeId, const std::string& childShapeId, SkRect bound);                                                 // Appends the bound to its immediate parent
    void updateParentsBound(const std::string& parentShapeId, const std::string& childShapeId, SkRect bound, std::shared_ptr<TreeContainer> treeContainer = nullptr); // Recursively appends the respective bound to the tree (hierarchy) of parents

    int getPredecessorIndex(GL_Ptr<com::zoho::shapes::ShapeObject> parentShapeObject, int index);
    int getIndexToInsert(std::shared_ptr<TreeContainer> treeContainer, int index);
    virtual int getElementOrderTreeIndex(const std::string& shapeId = "");

    virtual void renderEmbedAddons(com::zoho::shapes::ShapeObject* shapeObject, const DrawingContext& dc);

    std::shared_ptr<NLRenderTree> constructRenderCache(std::vector<std::string> shapeIds, std::vector<std::string> idsToSkip = {}, std::shared_ptr<NLRenderTree> resultantRenderTree = nullptr, std::shared_ptr<NLRenderTree> renderTreeToBeConsidered = nullptr, bool traverseInnerShapes = true, bool excludeTextDrawCalls = false);
    std::shared_ptr<NLRenderTree> constructSelectiveRenderCache(std::string shapeId, bool excludeTextDrawCalls = false, std::shared_ptr<NLRenderTree> renderTree = nullptr, bool excludeFromParent = true);
    void addInnerShapesToRenderCache(const std::string shapeId, std::shared_ptr<NLRenderTree> renderTree);

    bool hasModifiedTextDrawCalls(std::string shapeId, CacheContainer oldCache); // determines if the number of draw calls have been modifies for the shapeId passed
    std::shared_ptr<NLRenderTree> getNLRenderTreeForId(std::string id);

    std::map<std::string, std::vector<std::string>> getConnectorsAssociatedToShape(const std::string& shapeId);
    std::map<std::string, std::vector<std::string>> getShapesAssociatedToConnector(const std::string& shapeId);
    void accumulateConnectorInfoRecursively(const std::string& shapeId, ConnectorsInfo& connectorInfo, bool accumulateRecursivelyForInnerShapes = false);
    void activateConnectorCache(const std::string& shapeId);
    void removeInactiveConnectorCache();
    void removeConnectorCache(const std::string& connectorId, bool forceDelete);

    std::vector<float> getTableRowHeights(const std::string& shapeId);
    void setTableRowHeights(std::string& tableId, std::vector<float>& rowheights);
    void setShapeHeight(std::string& shapeId, std::string& tableId, float height);

    int getShapeCount(std::string shapeId);
    void dumpCacheInfo(const std::string& shapeId);
    void setAllInnerShapeIds(std::string shapeId, std::vector<std::string>& shapeIdArray);
    void setAllInnerShapeIds(std::string shapeId, std::unordered_set<std::string>& shapeIdArray);

    virtual int getShapeIndex(const std::string& shapeId);
    virtual graphikos::painter::ShapeDetails constructShapeDetailsFromCache(const std::string& shapeId, bool addToFrameDetailsArr = false);

    std::string lookupKeyBySuffix(const std::string& searchKey);
    void setErrorLinesRenderingStatus(bool status);
    bool getErrorLinesRenderingStatus();

    std::shared_ptr<NLCache> getCache(std::string shapeId);
    DrawingContext* getCurrentDrawingContext();
    GL_Ptr<com::zoho::shapes::ShapeObject> getCurrentShapeObject();

    virtual std::vector<graphikos::painter::ShapeDetails> getShapeDetailsFromHitTest(const graphikos::painter::GLPoint point, SkScalar selectionOffset);
    virtual std::vector<graphikos::painter::ShapeDetails> getShapeDetailsFromHitTest(const std::string& shapeId, const graphikos::painter::GLPoint point, SkScalar selectionOffset = 0);
};

#endif
