#ifndef __NL_APPBINDER_H
#define __NL_APPBINDER_H

#include <iostream>
#include <app/Nucleus.hpp>
#include <app/handler/AssetHandler.hpp>
#include <include/core/SkFontMgr.h>
#include <app/TableEditingController.hpp>

namespace theme {
enum class Type;
};

struct ApplicationContext;
class NWTWebView;

class AppBinder {
protected:
    std::shared_ptr<Nucleus> nl = nullptr;
    std::shared_ptr<ApplicationContext> app = nullptr;
    NWTWebView* webView = nullptr;

public:
    AppBinder();

    bool launchApplication(int width, int height, std::string windowName, std::string offscreenWindowName, bool isRunLoopNeeded = true, bool withoutAppMain = false, bool withoutWindow = false);
    bool initApplication(std::shared_ptr<NLApplicationMain> appMain, int width, int height, std::string windowName, std::string offscreenWindowName, bool withoutAppMain = false, bool withoutWindow = false);
    int runWindow(bool manual);
    void setWindowVisibleOffset(int left, int top);
    void setWindowSize(int width, int height);
    void setProjectData(const uint8_t* data, const size_t data_len);
    void setProjectData_nx(std::vector<uint8_t> data) {
        setProjectData(data.data(), data.size());
    }
    void setCommentsAsBytes(const uint8_t* data, const size_t data_len, std::string docId);
    void setCommentsAsBytes_nx(std::vector<uint8_t> data, std::string docId) {
        setCommentsAsBytes(data.data(), data.size(), docId);
    }
    void runLoop_nx() {
        app->app_instance->window->spinLoop();
    }
    void drawFrame();
    NWTEvents* getNWTEvents();
    void json2pb(std::string value, google::protobuf::Message* message);
    virtual void renderDocument(std::string docId);

    void allowScroll(bool allowScrollX, bool allowScrollY);
    void allowMagnify(bool allowMagnifyX, bool allowMagnifyY);

    void clearSelectedShapes();
    void clearSelectedShape(bool triggerEvent, std::string shapeId = "");
    std::vector<SelectedShape>& getSelectedShapes();
    std::vector<graphikos::painter::ShapeDetails> getShapeDetailsWithinRange(graphikos::painter::GLRect range);
    graphikos::painter::ShapeDetails getShapeDetailsById(std::string shapeId);
    com::zoho::shapes::ShapeObject getShapeObjectById(std::string shapeId, bool fromCache = true);
    bool isContainerType(std::string shapeId);
    com::zoho::shapes::Transform getMergedTransform(std::string shapeId, bool fromCache = true);
    CallBacks* getCallBackClass();
    bool isErrorLineRenderingEnabled();

    void setContentOffset(float leftOffset, float topOffset, float rightOffset, float bottomOffset);
    void setCurrentScale(float scale);
    float getCurrentScale();
    void setCurrentTranslate(float dx, float dy, float scale, bool needAnimation = false);
    void enableScrollOnDrag(bool scrollOnDrag);
    graphikos::painter::GLPoint getCurrentTranslate();
    graphikos::painter::GLRect getCurrentViewPort();

    void setScrollSpeed(float _scrollSpeed);
    float getScrollSpeed();
    void setZoomSpeed(float _zoomSpeed);
    float getZoomSpeed();

    void addFontFile(std::vector<uint8_t> bytes, std::string familyName, int weight, bool italic);
    void completedAllRequestsForFamily(std::string familyName);

    void setBackgroundColor(SkColor backgroundColor);
    graphikos::painter::GLRect getDocCoverageRect();

    std::shared_ptr<Asset> getShapeStringAsImage(std::string str, int width, int height);
    std::shared_ptr<Asset> getShapeObjectAsImage(com::zoho::shapes::ShapeObject* shape, int width, int height);

    Asset* getShapeAsAssetWithCallBack(ExportDetails exportDetails);
    std::vector<uint8_t> getShapeAssetUsingJSON(ExportDetails exportDetails, std::string json);
    std::vector<uint8_t> getShapeAssetUsingShapeObject(ExportDetails exportDetails, com::zoho::shapes::ShapeObject shapeObject);
    graphikos::painter::GLRect getPropsRange(com::zoho::shapes::ShapeObject shape);
    void freeAsset(int imageId);

    //editor
    virtual bool isTextEditMode();
    // void fitToScreen(bool resetRect);
    void fitFullPage(bool resetRect = false, bool needAnimation = false);

    void handleZoomByPoint(float magnification, float x, float y);
    void setGif(std::vector<uint8_t> data, std::string key);
    std::string getCurrentDocId();
    void setImage(ResourceDetails details, std::string key);
    void setUpSampledImage(ResourceDetails details, std::string key);
    void setDownSampledImage(std::string key);
    bool holdsUpSampledImage(std::string key);
    graphikos::painter::GLRect getRectForCell(std::string shapeId, std::string cellId);

    void setCustomViewport(graphikos::painter::GLRect customViewport);
    graphikos::painter::GLRect getCustomViewport();

    void setZoom(double zoomRange);
    virtual void reRenderRegion(std::vector<std::string> shapeIds, std::vector<int> opTypes = {});
    std::string getProductName();
    std::string getdStringForShapeId(std::string shapeId);
    void fitShapes(const std::vector<std::string>& shapeIds, bool needAnimation = false, bool maintainScale = false, bool fitContainer = false, bool alwaysFit = false);
    void selectShapeApp(std::string shapeId, bool triggerEvent = true, bool needToFit = true, bool needAnimation = false, bool maintainScale = false, bool alwaysFit = false);
    void selectShapeFromParentIds(std::vector<std::string> ids, bool triggerEvent, bool needToFit, bool needAnimation, bool maintainScale, bool alwaysFit);

    //nila - not nila specific , written for nila
    virtual void updateProjectDataBytes(const uint8_t* data, const size_t data_len);

    //for debuging
    static bool isFontPresent(std::string fontName);
    static void dumpFontManager(sk_sp<SkFontMgr> fontMgr);
    static void dumpCustomFontManager();
    static void dumpDefaultFontManager();

    void printImageIds(int status);
    void printAssetsInAssetHandler();

    void playGif(std::string shapeId);
    void removeGifData(std::string shapeId);
    void createGifData(std::string clientKey, std::string shapeId, std::string valueId);
    std::string getShapeIdFromValueId(std::string clientKey, std::string valueId);
    std::vector<std::string> getValueIdsFromClientKeyMap(std::string clientKey);
    std::shared_ptr<Asset> getShapeAsset(ExportDetails exportDetails, graphikos::painter::GLRect clipRect = graphikos::painter::GLRect());
    void dumpCacheInfo(std::string shapeId);

    ResourceDetails convertUint8toResourceDetails(std::vector<uint8_t> data);
    void setTileMode(bool value);
    void renderTilesOnScale(bool value);
    void setRendererMode(NLRenderer::Mode mode, bool onlyDataController);
    void setCacheImageRelOutset(float relOutset);

    // WebView Helpers...
    void createWebView(int width, int height);
    void attachWebView();
    void detachWebView();
    void loadUrl(const std::string& url);
    void registerWebViewCallbacks();
    virtual void onRegisterWebViewCallbacks();

    std::shared_ptr<ApplicationContext> getApplicationContext() {
        return app;
    }
    //app nucleus alone
    void setShapeObject(std::shared_ptr<com::zoho::shapes::ShapeObject> shapeObject);
    void setMode(bool isEditor); // temperory need to change
    graphikos::painter::GLRect getShapeBounds(std::string shapeId);
    void releaseEventBindings();

    void setCurrentThemeType(theme::Type type);
    void renderShapeFromWrapper();

    //for osx and ios integration
    void* getContextView();
    void* getContextDevice();

    std::string getEmbedName(std::string shapeId);
    std::vector<std::string> getDependencyConnectorIds(std::string shapeId);
    void assignMouseWheelOverride(bool overrideMouseWheel);
    graphikos::painter::GLPoint getPlaceHolderIconPoint(std::string shapeId);

    std::vector<graphikos::painter::GLPoint> getSelectedShapesCenter();
    void fitSelectedShapes(bool needAnimation = false, bool maintainScale = false, bool fitContainer = false, bool alwaysFit = false, float fitRatio = 0);
    bool isShapeInRange(graphikos::painter::GLRect range, std::string shapeId);
    bool isSelectedShapeInRange(graphikos::painter::GLRect range);
    graphikos::painter::GLRect getSelectionBound();
    graphikos::painter::GLRect getBoundWithMatrixGivenShapeIds(std::vector<std::string> shapeIds);
    bool isShapeSelected(std::string shapeId);
    std::vector<std::string> getVisibleShapeIds();

    float getShapeCountRatio(std::vector<int> rootLevelElemIndices);
    bool isBorderApplied(std::string tableId, std::string cellId, TableEditingController::Direction side);

    std::vector<float> getTableRowHeights(std::string tableId);
    std::vector<float> getTableRowHeightsFromShapeObject(com::zoho::shapes::ShapeObject* shapeObject);
    float getUpdatedTableWidth(com::zoho::shapes::Table* table, std::string shapeId);
    float getUpdatedTableHeight(com::zoho::shapes::Table* table, std::string shapeId);
    graphikos::painter::GLRect getUpdatedTableTransform(std::string shapeId);
    com::zoho::shapes::ShapeObject getTableCellFromIndex(int rowIndex, int cellIndex);
    graphikos::painter::TableLine getCellDetails(std::string id, graphikos::painter::GLPoint mouse);
    graphikos::painter::TableLine getCellDetailsFromShapeObject(com::zoho::shapes::ShapeObject* shapeObject, graphikos::painter::GLPoint mouse);
    void forceHorizontalScrollOnShift(bool enable);

    com::zoho::shapes::Transform getPropsRange(std::string str);

// only for wasm
#if defined(NL_ENABLE_NEXUS)
    NXByteMemoryView getShapeStringAsImageBytes(std::string str, int width, int height);
    NXByteMemoryView getShapeObjectAsImageBytes(com::zoho::shapes::ShapeObject* shape, int width, int height);
#else
    std::shared_ptr<Asset> getShapeStringAsImageBytes(std::string str, int width, int height);
    std::shared_ptr<Asset> getShapeObjectAsImageBytes(com::zoho::shapes::ShapeObject* shape, int width, int height);
#endif
};
#endif
