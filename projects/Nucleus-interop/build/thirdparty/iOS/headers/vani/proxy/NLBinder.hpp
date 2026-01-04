
#ifndef NLBinder_hpp
#define NLBinder_hpp

#include <iostream>
#include <native-window-cpp/common/event/NWTEvents.hpp>
#include <vani/nl_api/VaniAppBinder.hpp>

#include <app/handler/ResourceHandler.hpp>
#include <skia-extension/GLPoint.hpp>
#include <skia-extension/GLRect.hpp>
#include <include/gpu/ganesh/mtl/GrMtlBackendSurface.h>
#include <include/gpu/GrBackendSurface.h>




#ifdef __cplusplus
extern "C" {
#endif

#include <CoreGraphics/CoreGraphics.h>


#ifdef __cplusplus
}
#endif

struct NucleusCallBacks {
    // std::function<void* (const char*)> getTextureForKey;
    std::function<ResourceDetails(const char*, bool, std::function<void(ResourceDetails, std::string, bool)>)> getTextureForKey;
    std::function<void(const char*, int, bool, std::function<void(std::vector<uint8_t> data, size_t len, std::string fontFamily, int weight, bool italic)>)> requestFont;
    std::function<void(std::string, std::string, float, float, float, float)> triggerEmbedAction;
    std::function<void(float, float, float)> triggerViewTransFormed;
    std::function<void()> triggerDocumentRendered;
    std::function<void(const char* key)> releaseMtlTexture;
    std::function<void(std::vector<std::string>)> triggerShapeSelected;


};
using GetTextureSizeCallback = std::pair<int, int> (*)(void* texture);
using FontReceivedCallback = void (*)(std::vector<uint8_t> data, size_t len, const char* fontFamily, int weight, bool italic);


class NLBinder {

    
private:
    std::shared_ptr<VaniAppBinder> appBinder;
    NWTEvents* nwtEvent;
   
    GetTextureSizeCallback getTextureSizeCallback;
    int startx, starty;
public:
    
    NLBinder(int width, int height);
    void initNucleus(int width,int height);
    void setProjectData(std::vector<uint8_t> projectData);
    void setCallback(NucleusCallBacks callback);
    void setTextureSizeCallback(GetTextureSizeCallback callback);
    void fireFontReceivedCallback(std::vector<uint8_t> data, size_t len, const char* fontFamilyCStr, int weight, bool italic);


    // Getters

    std::pair<int, int> getTextureSize(void* texture) const;
    
    std::vector<std::string> getDocumentIds();
    std::vector<std::string> getDocumentTitles();
    void renderDocument(std::string document);
    std::string getProjectTitle();
   
    void* fetchMetalView();
    void* getMetalDevice();
    
    
    graphikos::painter::GLPoint getCurrentTranslate();
    float getCurrentScale();
    graphikos::painter::GLRect getDocumentCoverageRect();
    graphikos::painter::GLRect getCurrentViewPort();
    std::vector<uint8_t> getFullDocAsImage(int width, int height);

    //CollabSelection 
    void selectCollabShape(std::string shapeId, std::string zuid, std::string name, uint32_t color);
    void unSelectCollabShape(std::string shapeId, std::string zuid);
    void addTextCollabDetails(std::string shapeId, std::string zuid, int si, int ei, float r, float g, float b, float alpha, std::string cellId, std::string textBodyId);
    void deleteTextCollabDetails(std::string shapeId, std::string zuid, std::string cellId, std::string textBodyId);



    // Event Propogators
    void scroll(double deltaX, double deltaY, double x, double y, int modifier);
    void magnify(double magnification, double x, double y);
    void mouseUp(int x, int y);
    void mouseDown(int x, int y);
    void orientationChanged(int width, int height);
    void syncCanvasZoom(float magnification, float x, float y);
    void syncCanvasTranslate(float x, float y, float scale);
    void runLoop(); //push to native window
    GrBackendTexture nl_texture;

    ~NLBinder();

};

#endif
