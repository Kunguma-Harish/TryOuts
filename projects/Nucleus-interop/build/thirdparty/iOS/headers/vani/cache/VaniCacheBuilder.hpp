#ifndef __NL_VANICAHEBUILDER_H
#define __NL_VANICAHEBUILDER_H

#include <app/NLCacheBuilder.hpp>
#include <include/core/SkPicture.h>
#include <vani/data/VaniDataController.hpp>
#include <nucleus/core/NLRenderTree.hpp>

namespace com {
namespace zoho {
namespace remoteboard {
class Document;
class Frame;
class FrameOrShape;
namespace build {
class DocumentData;
}
}
}
}

class VaniCacheBuilder : public NLCacheBuilder {
protected:
    void constructShapeDetailsFromCache(const std::string& shapeId, graphikos::painter::ShapeDetails& shapeDetails, bool constructParentDetails = false, bool addToFrameDetailsArr = false);
    void getShapeDetailsFromHitTest(const std::string& shapeId, const graphikos::painter::GLPoint point, SkScalar offset, std::vector<graphikos::painter::ShapeDetails>* shpDetailsArray);

public:
    std::shared_ptr<TreeContainer> framesTreeContainer = nullptr;
    std::shared_ptr<TreeContainer> elementOrderTreeContainer = nullptr;
    std::shared_ptr<TreeContainer> anchorTreeContainer = nullptr;
    //TODO Must make use of a single treeContainer as vani renders as per element order.
    graphikos::painter::GLPath docShapesPath = graphikos::painter::GLPath();

    VaniCacheBuilder();
    VaniCacheBuilder(VaniDataController* data, std::shared_ptr<NLRenderTree> renderTree, std::shared_ptr<graphikos::painter::IProvider> vaniProvider);
    void prepareCache(std::string docId, const graphikos::painter::RenderSettings& renderSettings) override;
    std::vector<std::string> getOrderedFrameIds();
    void setDocShapesPath(com::zoho::shapes::ShapeObject* shapeObject);
    graphikos::painter::GLPath getDocShapesPath();
    // com::zoho::shapes::Transform* getTransform(const CacheContainer& cacheContainer) override;

    // void prepareCache(std::string docId, const graphikos::painter::RenderSettings& renderSettings) override;
    void prepareCache(com::zoho::remoteboard::build::DocumentData* docData, const graphikos::painter::RenderSettings& renderSettings);
    void prepareAnchorCache(com::zoho::remoteboard::build::DocumentData* docData, const graphikos::painter::RenderSettings& renderSettings);

    void renderDocShape(GL_Ptr<com::zoho::shapes::ShapeObject> shapeObject, const DrawingContext& dc, SkRect offset = SkRect{0, 0, 0, 0});
    void renderFrameShapesAndAddCache(google::protobuf::RepeatedPtrField<com::zoho::shapes::ShapeObject>* shapes, const DrawingContext& dc, int& index, SkRect offset = SkRect{0, 0, 0, 0}, std::string frameId = "");
    void renderFrameAndAddCache(const DrawingContext& dc, GL_Ptr<com::zoho::shapes::ShapeObject> shapeObject, GL_Ptr<google::protobuf::Message> frame, std::string frameId, SkRect offset = SkRect{0, 0, 0, 0}, int index = -1, int parentIndex = -1, std::string parentShapeId = "");
    void renderFrameShapes(google::protobuf::RepeatedPtrField<com::zoho::shapes::ShapeObject>* shapes, const DrawingContext& dc, SkRect offset = SkRect{0, 0, 0, 0}, std::string frameId = "");
    void renderFrameAndShapes(com::zoho::remoteboard::Frame* frame, const DrawingContext& dc, int& index, int& framesTreeIndex, bool doNotRenderShapes = false, int parentIndex = -1, std::string parentShapeId = "");
    void renderAndUpdateFrameCache(const DrawingContext& dc, GL_Ptr<com::zoho::shapes::ShapeObject> shapeObject, GL_Ptr<google::protobuf::Message> frame, std::string frameId, SkRect offset = SkRect{0, 0, 0, 0});
    bool renderFrameAndShapesWithoutCache(const DrawingContext& dc, std::vector<std::string> selectedContainers);
    void renderPhAndEmbed(const DrawingContext& dc, GL_Ptr<com::zoho::shapes::ShapeObject> shapeObject, com::zoho::shapes::ShapeObject* embedShape, std::string frameId = "", int treeContainerIndex = -1, int parentContainerIndex = -1);
    void renderAnchorAndAddCacheWithoutTrigger(DrawingContext& dc, std::shared_ptr<com::zoho::shapes::ShapeObject> shapeObject);

    bool renderAll(const DrawingContext& dc, std::vector<std::string> selectedContainers = {}) override;
    std::vector<graphikos::painter::GLRect> updateTree(const std::vector<std::string>& shapeIds, const std::vector<int>& opTypes = {}) override;
    void updateTree(std::string shapeId, const DrawingContext& dc, RenderOperationType opType);
    void updateTree(std::string shapeId, graphikos::painter::ShapeDetails shapeDetails, const DrawingContext& dc, RenderOperationType opType, int elementIndex);
    void deleteTree(std::string shapeId);

    com::zoho::shapes::Transform* getTransform(const ShapeContainer& cacheContainer) override;
    void renderPlaceHolderIcon(com::zoho::shapes::ShapeObject* shapeObject, const DrawingContext& dc) override;
    void renderEmbedAddons(com::zoho::shapes::ShapeObject* shapeObject, const DrawingContext& dc) override;

    int getSuccessorFrameIndex(int elementOrderIndex);
    int getElementOrderTreeIndex(const std::string& shapeId = "") override;
    int getShapeIndex(const std::string& shapeId) override;
    void constructParentShapeDetailsFromCache(const std::string& parentShapeId, graphikos::painter::ShapeDetails& shapeDetails, bool addToFrameDetailsArr = false);
    graphikos::painter::ShapeDetails constructShapeDetailsFromCache(const std::string& shapeId, bool addToFrameDetailsArr = false) override;
    graphikos::painter::GLRect getMaxCoverageRectGivenshapeIds(std::vector<std::string> shapeIds);

    std::vector<graphikos::painter::ShapeDetails> getShapeDetailsFromHitTest(const graphikos::painter::GLPoint point, SkScalar selectionOffset) override;
    std::vector<graphikos::painter::ShapeDetails> getShapeDetailsFromHitTest(const std::string& shapeId, const graphikos::painter::GLPoint point, SkScalar selectionOffset = 0) override;
};

#endif
