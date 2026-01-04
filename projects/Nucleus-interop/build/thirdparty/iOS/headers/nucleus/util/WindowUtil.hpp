#ifndef __NL_WINDOWUTIL_H
#define __NL_WINDOWUTIL_H
#ifdef NL_ENABLE_FILESYSTEM_API
#include <filesystem>
#endif

#include <fstream>
#include <map>
#include <nucleus/core/ZRenderBackend.hpp>
#include <nucleus/nucleus_export.h>
#include <skia-extension/GLPath.hpp>
#include <skia-extension/util/FnTypes.hpp>

class SkData;
class ZWindow;
struct Asset;
class NLView;
class ZEvents;

class NWTWindow;
class NWTEvents;
class NWTWebView;
class NWTApplicationMain;

#ifdef __EMSCRIPTEN__
extern "C" {
char* generate_uuid();
}
#endif
namespace com {
namespace zoho {
namespace shapes {
class HyperLink;
enum HyperLink_LinkOpenType : int;
}
}
}

namespace graphikos {
namespace common {

class NUCLEUS_EXPORT WindowUtil {
public:
    static std::shared_ptr<ZWindow> createWindow(int width, int height);
    static std::shared_ptr<ZEvents> createEvent(ZWindow* window);
    /**
     * Returns a either a CPU or GPU backend based
     * on the platform's capabilities
     * @param addtional values can be passed to extra1 and extra2
     */
    static std::shared_ptr<ZRenderBackend> CreateAvailableRenderBackend(ZWindow* window, SkColor clearColor = SK_ColorTRANSPARENT, std::map<std::string, void*> extras = std::map<std::string, void*>(), ZRenderBackend* shareBackend = nullptr, bool useDefaultFrameBuffer = true);
    static NWTWebView* CreateAvailableWebViewAdapter(int width, int height);
    static NWTWindow* CreateAvailableWindowAdapter();
    static NWTEvents* CreateAvailableEventsAdapter();
    static std::unique_ptr<NWTApplicationMain> CreateAvailableApplicationManager();
};
}
}

#endif
