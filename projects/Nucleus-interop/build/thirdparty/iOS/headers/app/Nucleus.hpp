#ifndef __NL_NUCLEUS_H
#define __NL_NUCLEUS_H
#include <iostream>
#include <skia-extension/util/FnTypes.hpp>
#include <app/handler/ThreadFactory.hpp>
#include <nucleus/nucleus_export.h>
#include <nucleus/core/NLLoopHandler.hpp>
#include <app/controllers/NLScrollEventController.hpp>
#include <app/BaseRenderer.hpp>

namespace google {
namespace protobuf {
class Arena;
}
}

class ZGLBindings;
class ZRenderBackend;
class ZRenderer;
class ZWindow;
struct ApplicationContext;
class ZSelectionHandler;
struct NLEditorProperties;
class NLApplicationMain;

class NUCLEUS_EXPORT Nucleus : public BaseRenderer {
protected:
    std::shared_ptr<ApplicationContext> app = nullptr;
    std::map<std::string, void*> extras;
    virtual void onInitApplication(std::shared_ptr<ZWindow> window, bool withoutAppMain = false, std::shared_ptr<ZRenderBackend> renderBackend = nullptr);
    std::shared_ptr<NLLoopHandler> loopHandler = nullptr;
    std::shared_ptr<ControllerProperties> properties = nullptr;
    std::shared_ptr<NLEditorProperties> editorProperties = nullptr;
    std::shared_ptr<ZSelectionHandler> selectionHandler = nullptr;
    std::shared_ptr<NLScrollEventController> eventController = nullptr;
    bool isEditor = false;


public:
    Nucleus();
    /*
     * @brief Can be used to pass imlementation specific data
     */
    void setExtras(std::map<std::string, void*> extras);
    void initAppContext(std::shared_ptr<NLApplicationMain> appMain, int width, int height, std::string windowName, std::string offscreenWindowName);

    std::shared_ptr<ApplicationContext> initApplication(std::shared_ptr<NLApplicationMain> appMain, int width, int height, std::string windowName, std::string offscreenWindow, bool withoutAppMain = false);
    std::shared_ptr<ApplicationContext> initApplicationWithWindow(std::shared_ptr<ZWindow> window, std::shared_ptr<ZRenderBackend> renderBackend = nullptr);

    ApplicationContext* getApplicationContext();
    void setThreadMode(ThreadMode mode);
    virtual void setBackgroundColor(SkColor color);
    void setCustomZoomRange(float min, float max);
    void selectAll();
    void dataUpdated(bool needRender, std::vector<std::string> shapeIds);
    void refreshSelectedLayer(std::vector<std::string> shapeIds);
    std::shared_ptr<NLScrollEventController> getCurrentController() { return eventController; }
    void setContentOffset(float leftOffset, float topOffset, float rightOffset, float bottomOffset);
    void enableScrollOnDrag(bool enable);

    //selection
    ZSelectionHandler* getSelectionHandler();
    void selectShape(std::string shapeId, SkColor color, bool triggerEvent = true, bool needAnimation = false);
    void selectShape(std::string shapeId, bool triggerEvent = true, bool needToFit = true, bool needAnimation = false, bool maintainScale = false, bool alwaysFit = false);
    void selectShape(std::vector<std::string> ids, bool triggerEvent = true, bool needToFit = true, bool needAnimation = false, bool maintainScale = false, bool alwaysFit = false);
    void clearSelectedShapes(bool triggerEvent, std::string shapeId = "");

    //fit
    void fitShapes(const std::vector<std::string>& shapeIds, bool needAnimation = false, bool maintainScale = false, bool fitContainer = false, bool alwaysFit = false);
    void fitSelectedShapes(std::vector<SelectedShape> shapes, bool needAnimation = false, bool maintainScale = false, bool fitContainer = false, bool alwaysFit = false, float fitRatio = 0);
    void fitFullPage(bool resetRect, bool needAnimation);
    void fitToDefault(bool needAnimation);
    // updating view matrix
    void setTranslateWithoutTrigger(float transX, float transY, float scale, bool needAnimation = false);

    float getCurrentScale();

    graphikos::painter::GLPoint getCurrentTranslate();

    graphikos::painter::GLRect getCurrentViewPort();

    virtual ~Nucleus() {}

    virtual void createCallBackClass();
    std::shared_ptr<CallBacks> getCallBackClass();

    virtual std::string getProductName();
    void renderDocument();

    void setMode(bool isEditor = false);

    void setScrollSpeed(float _scrollSpeed);
    float getScrollSpeed();
    void setZoomSpeed(float _zoomSpeed);
    float getZoomSpeed();

    void setCustomViewport(graphikos::painter::GLRect customViewport);
    graphikos::painter::GLRect getCustomViewport();
    void updateShapeSelection(const std::vector<std::string>& deletedShapeIds, const std::vector<std::string>& insertedShapeIds , const std::vector<std::string>& updatedShapeIds);

};

#endif
