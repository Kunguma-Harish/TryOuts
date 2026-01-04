#ifndef __NL_DATACONTROLLER_H
#define __NL_DATACONTROLLER_H
#include <nucleus/core/layers/NLRenderLayer.hpp>
#include <app/controllers/NLController.hpp>
#include <filesystem>
#include <memory>

#include <nucleus/interface/IDataListener.hpp>
#include <nucleus/interface/IFontShapeListener.hpp>
#include <app/structs/SelectionStructs.hpp>
#include <nucleus/core/NLRenderTree.hpp>
#include <app/NLCacheBuilder.hpp>
#include <nucleus/core/layers/NLRenderLayer.hpp>
#include <app/ApplicationContext.hpp>
#include <app/ZSelectionHandler.hpp>
#include <app/ZShapeModified.hpp>

namespace graphikos {
namespace painter {
class ResourceHandler;
struct ShapeDetails;
}
}

namespace com {
namespace zoho {
namespace startwith {
namespace build {
class FontShapeData;
}
}
namespace shapes {
class FontShape;
class ShapeObject;
class Properties;
class Transform;
class TextBody;
}
}
}
class NLDataController : public NLController, public NLRenderLayer {
private:
    GL_Ptr<void> renderData = nullptr; //for test rendering

    std::string _documentId;
    ///   @d-todo can data hold either FontShapeData/FontShape
    std::shared_ptr<com::zoho::startwith::build::FontShapeData> fontShapeData = nullptr;
    google::protobuf::RepeatedPtrField<com::zoho::shapes::FontShape>* fontShapes = nullptr;

    graphikos::painter::ResourceHandler* resourceHandler = nullptr;
    std::shared_ptr<graphikos::nucleus::IFontShapeListener> fontShapesListener;
    ZSelectionHandler* selectionHandler = nullptr;

protected:
    std::shared_ptr<NLRenderTree> nlRenderTree;
    std::shared_ptr<NLCacheBuilder> cacheBuilder;
    std::shared_ptr<graphikos::painter::IProvider> provider;

    std::shared_ptr<com::zoho::shapes::TextBody> editingTextBody = nullptr; // needed for textEditorController

public:
    SelectedCellDetails selectedCellDetails;
    bool selectInnerShapeOnMouseUp = false;

    NLDataController();
    NLDataController(ControllerProperties* properties, ZSelectionHandler* selectionHandler, NLLayerProperties* layerProperties, graphikos::painter::GLRect viewPortRect, SkColor layerColor, NLRenderer::Mode mode);
    void onDetach() override;

    void onDataChange(std::shared_ptr<NLRenderTree> picture) override;

    virtual void setEditingTextBody(std::shared_ptr<com::zoho::shapes::TextBody> editingTextBody); // needed for textEditorController
    std::shared_ptr<com::zoho::shapes::TextBody> getEditingTextBody();                             // needed for textEditorController

    std::shared_ptr<NLRenderTree> getRenderTree();
    std::shared_ptr<graphikos::painter::IProvider> getProvider();
    graphikos::painter::ResourceHandler* getResourceHandler();
    std::shared_ptr<NLCacheBuilder> getCacheBuilder();
    void setCacheBuilder(std::shared_ptr<NLCacheBuilder> cacheBuilderToBeSet);
    void setRenderTree(std::shared_ptr<NLRenderTree> renderTreeToBeSet);
    void setFontShapesListener(std::shared_ptr<graphikos::nucleus::IFontShapeListener> listener);
    virtual void buildRenderTree(std::string id = "");
    std::string getCurrentDocId();

    void clearDocumentId();
    void setCurrentDocId(std::string docId);

    virtual std::string getPictureKey(const com::zoho::shapes::PictureValue& picValue) { return ""; }

    void setFontShapes(google::protobuf::RepeatedPtrField<com::zoho::shapes::FontShape>* fontShapes);

    google::protobuf::RepeatedPtrField<com::zoho::shapes::FontShape>* getFontShapes() {
        return fontShapes;
    }

    virtual graphikos::painter::GLRect getWholeRegionOfContainerShapes(SelectedShape selectedShape) {
        return graphikos::painter::GLRect();
    }
    void initRenderingStyles();
    virtual void onInitRenderingStyles();

    ///  @d-todo to move this to a more meaning place
    std::string offScreenWindowName;
    std::string getGpuWindowName() {
        return offScreenWindowName;
    }
    void setOffScreenWindowName(std::string windowName) {
        offScreenWindowName = windowName;
    }

    graphikos::painter::ShapeDetails getScrollEnabledShape(graphikos::painter::ShapeDetails shapedetails);
    graphikos::painter::ShapeDetails getScrollEnabledShape(graphikos::painter::GLPoint point, const SelectionContext& sc);
    graphikos::painter::ShapeDetails getShapeDetailsWithId(com::zoho::shapes::ShapeObject* shapeobject, std::string shapeId, const SelectionContext& sc);
    std::vector<graphikos::painter::ShapeDetails> getDetailsWithPoint(com::zoho::shapes::ShapeObject* shapeobject, graphikos::painter::GLPoint point, const SelectionContext& sc);
    virtual graphikos::painter::ShapeDetails getDetailsWithRect(com::zoho::shapes::ShapeObject* shapeobject, graphikos::painter::GLRect range, const SelectionContext& sc);
    std::vector<graphikos::painter::ShapeDetails> getShapeDetailsWithName(com::zoho::shapes::ShapeObject* shapeobject, std::string shapeName, const SelectionContext& sc);
    std::vector<graphikos::painter::ShapeDetails> traverseShapes(google::protobuf::RepeatedPtrField<com::zoho::shapes::ShapeObject>* shapes, graphikos::painter::GLPoint point, const SelectionContext& sc);

    std::shared_ptr<NLPictureRecorder> convertShapeAsPicture(com::zoho::shapes::ShapeObject* shapeObject, const graphikos::painter::RenderSettings& renderSettings, float scaleValue = 1.0, graphikos::painter::GLRect bound = graphikos::painter::GLRect()) {
        return cacheBuilder->convertShapeAsPicture(shapeObject, renderSettings, scaleValue, bound);
    }
    virtual com::zoho::shapes::Locks* getContainerLocks(ShapeContainer& shape); // specially for container

    ZSelectionHandler* getSelectionHandler() {
        return selectionHandler;
    }

    // move to test part of code @d-todo
    bool setJSON(std::string jsonStr);
    GL_Ptr<void> getRenderData();
    void setShapeObject(std::shared_ptr<com::zoho::shapes::ShapeObject> shapeObject) {
        this->renderData = shapeObject;
    }
    void setBytes(const uint8_t* data, const size_t data_len);
    void setCommentsBytes(const uint8_t* data, const size_t data_len, std::string docId);
    virtual void onSetBytes(const uint8_t* data, const size_t data_len);
    virtual void onSetCommentsBytes(const uint8_t* data, const size_t data_len, std::string docId) {};

    void setFontShapeData(std::shared_ptr<com::zoho::startwith::build::FontShapeData> fontShapeData);

    graphikos::painter::GLRect getDocumentBound();

    virtual std::shared_ptr<com::zoho::shapes::ShapeObject> convertContainerAsShapeObject(GL_Ptr<google::protobuf::Message> screenOrShapeObject, const graphikos::painter::RenderSettings& renderSettings);
    virtual google::protobuf::RepeatedPtrField<com::zoho::shapes::ShapeObject>* getContainerShapes(GL_Ptr<google::protobuf::Message> screenOrShapeObject);
    virtual std::vector<graphikos::painter::ShapeDetails> getShapeDetailsWithinRange(graphikos::painter::GLRect range, const SelectionContext& sc, bool addToFrameDetailsArr = false);
    virtual std::vector<graphikos::painter::ShapeDetails> getShapeDetailsWithinRange(graphikos::painter::GLRect range, bool addToFrameDetailsArr = false);
    virtual std::vector<std::string> getAllShapeIdsByType(com::zoho::shapes::ShapeNodeType type);
    virtual graphikos::painter::ShapeDetails getContainerShapeDetails(graphikos::painter::GLPoint point, const SelectionContext& sc);
    virtual com::zoho::shapes::ShapeObject* getContainerShapeObject(std::string containerId);
    virtual std::vector<graphikos::painter::GLRect> getShapeRects(std::vector<std::string> shapeIds) { return {}; };
    virtual void updateContainer(std::vector<std::string> shapeIds) {};
    virtual bool isShapeInRange(graphikos::painter::GLRect range, std::string shapeId) { return false; }
    bool isSelectedShapeInRange(graphikos::painter::GLRect range);
    virtual SkColor getBackgroundColor(bool useDocBackground = true);
    virtual bool setJSONProject(std::string jsonStr) {
        return false;
    }
    virtual float getShapeCountRatio(std::vector<int> rootLevelElemIndices) { return 0; };

// d-todo move to nila.cpp parallel to renderDoc
#ifdef NL_ENABLE_FILESYSTEM_API
    virtual bool loadProject(std::filesystem::path folder);
    virtual bool loadFile(std::filesystem::path file);
#endif

    virtual std::multimap<std::string, com::zoho::shapes::Transform> getContainerNameAndTransform();
    virtual com::zoho::shapes::Transform* getContainerTransform(std::string id);
    virtual graphikos::painter::GLPath getEmbedTitleRegion(com::zoho::shapes::ShapeObject* shapeObject, graphikos::painter::Matrices matrices);

    virtual com::zoho::shapes::Properties* getStyleProps(std::string styleId, std::string documentId) { return nullptr; }

    //shapeDetails fns
    virtual std::vector<graphikos::painter::ShapeDetails> getShapeDetailsFromHitTest(graphikos::painter::GLPoint point, const SelectionContext& sc);
    virtual std::vector<graphikos::painter::ShapeDetails> getShapeDetailsFromHitTest(const std::string& shapeId, graphikos::painter::GLPoint point, const SelectionContext& sc);

    virtual graphikos::painter::ShapeDetails getShapeDetailsFromHitTest(graphikos::painter::GLPoint mouse, graphikos::painter::GLRect frame, bool onModifier, const SkMatrix& matrix);
    virtual graphikos::painter::ShapeDetails getShapeDetailsFromHitTest(graphikos::painter::GLPoint mouse, graphikos::painter::GLRect frame, bool onModifier, const SkMatrix& matrix, SelectionContext& sc);

    virtual graphikos::painter::ShapeDetails getShapeDetailsById(std::vector<std::string> ids, bool includeContainers = true);
    virtual graphikos::painter::ShapeDetails getShapeDetailsById(std::string shapeId, bool includeContainers = true, bool checkInnerShape = false, bool addToFrameDetailsArr = false);
    virtual graphikos::painter::ShapeDetails getShapeDetailsById(std::string shapeId, std::string docId, bool includeScreens = true, bool checkInnerShape = false, bool fromClonedData = false, bool addToFrameDetailsArr = false);

    virtual std::vector<graphikos::painter::ShapeDetails> getShapeDetailsByName(std::string shapeName, std::string docId, bool includeContainers = true, const SelectionContext& sc = SelectionContext());

    std::vector<IDataListener*> receivers;
    std::vector<IDataListener*> preReceivers;

    void addPreDataListener(IDataListener* dataReceivable);
    void addDataListener(IDataListener* dataReceivable);
    void fireDataInitEvent();
    void fireDataChangeEvent();
    void firePreDataChangeEvent();

    std::string getShapeIdAsPerCache(const std::string& shapeId);

    //vani
    void selectShapesInRange(graphikos::painter::GLRect range);

    //for selection listeners
    virtual void populateSelectedData() {}

    SelectedShape getSelectedShapeByInnerShapeId(std::string shapeId);
    SelectedCellDetails getSelectedCellDetails();

    graphikos::painter::GLRect getRenderBounding();
    void reRenderRegion(std::vector<std::string> shapeIds, std::vector<int> opTypes = {});

    void buildCache();
    virtual void regenerateAndRenderFullDocument(const std::string& docId);

    virtual graphikos::painter::ShapeObjectsDetails getShapeObjectDetails(const NLCache* cache);
    virtual std::vector<graphikos::painter::ShapeDetails> getShapeDetails(std::vector<std::vector<NLCache const*>> caches);
    virtual bool isPageFrame(std::string shapeId);
    virtual bool isPageFrameShape(std::string shapeId);


    virtual int getIndex(graphikos::painter::ShapeObjectsDetails shape);
    bool isShapeWithinPoint(const std::string& shapeId, graphikos::painter::GLPoint point);
    void retrieveAndCopyShapeTransformationDetails(graphikos::painter::ShapeDetails shapeDetails, SelectionContext& sc);
    virtual bool allowOverFlowForBestFit(com::zoho::shapes::ShapeObject* shapeObject);

    graphikos::painter::GLRect getShapeBounds(std::string shapeId);

#ifdef __EMSCRIPTEN__
    virtual void triggerDrawObjectCallback(std::shared_ptr<CallBacks> callback, DrawData drawObject) {};
#endif

    ~NLDataController();
};
#endif
