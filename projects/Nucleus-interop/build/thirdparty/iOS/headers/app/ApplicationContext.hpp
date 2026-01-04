#ifndef __NL_APPLICATIONCONTEXT_H
#define __NL_APPLICATIONCONTEXT_H

#include <memory>
#include <map>

#include <nucleus/core/WindowConfig.hpp>
#include <nucleus/core/WindowConfig.hpp>
#include <nucleus/nucleus_export.h>
#include <nucleus/Looper.hpp>
#include <nucleus/interface/ILoopListener.hpp>

//refactor
#include <app/NLDataController.hpp>
#include <nucleus/core/NLOffscreenLayer.hpp>
#include <painter/RenderSettings.hpp>
#include <nucleus/core/NLApplicationMain.hpp>
#include <nucleus/core/NLView.hpp>

class ZWindow;
class NLView;
class ZRenderer;
class ZRenderBackend;
class ImageHandler;
class ZEvents;
class AssetHandler;
class SkCanvas;
class NLDataController;
enum class AsyncRenderMode;

namespace graphikos {
namespace painter {
class ResourceHandler;
}
namespace nucleus {
class EmojiHandler;
}
}
/**
 * @brief
 * Except window, every field is owned by ApplicationContext
 */
struct NUCLEUS_EXPORT ApplicationContext : public ILoopListener {

    std::shared_ptr<NLApplicationMain> app_instance = nullptr;

    std::shared_ptr<AssetHandler> assetHandler = nullptr;
    std::shared_ptr<graphikos::nucleus::EmojiHandler> emojiHandler = nullptr;
    std::shared_ptr<ImageHandler> imageHandler = nullptr;
    std::string offscreenWindowName;
    const WindowConfig* getWindowConfig();
    graphikos::painter::ResourceHandler* getResourceHandler();
    bool isTestMode = false;

    //refactor

    std::shared_ptr<NLDataController> dataController;
    std::shared_ptr<NLOffscreenLayer> offscreenLayer;

    std::shared_ptr<Looper> looper = nullptr;
    void onLoop(float time) override;
    bool onContinueLoop() override;

    /**
     * @brief Sets up the ZData, ZEvents
     */
    void bootstrap();

    //setters
    void setRenderBackend(std::map<std::string, void*> extras);
    void setRenderBackend(std::shared_ptr<ZRenderBackend> curentRenderBackend);
    void setDataController(std::shared_ptr<NLDataController> currentController);
    void setAssetHandler(std::shared_ptr<AssetHandler> assetHandler);
    void setRenderSettings(const graphikos::painter::RenderSettings& renderSetting);
    void setOffScreenLayer(std::shared_ptr<NLOffscreenLayer> offScreenLayer);
    void setDataToProvider();

};

#endif
