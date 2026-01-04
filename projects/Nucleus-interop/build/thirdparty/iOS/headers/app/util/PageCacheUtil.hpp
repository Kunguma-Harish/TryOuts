#ifndef __NL_PAGECACHEUTIL_H
#define __NL_PAGECACHEUTIL_H

#include <skia-extension/GLRect.hpp>
#include <map>
#include <string>
#include <include/core/SkImage.h>

struct PageCache {
    sk_sp<SkImage> fullFrameCache;
    graphikos::painter::GLRect maxCoverageRectCache;
    SkMatrix cameraMatrixCache;
    SkMatrix canvasMatrixCache;
    bool rerenderNeeded = false;
    bool hasBitmap;
};
class PageCacheUtil {
public:
    static std::map<std::string, PageCache> bitmapCache;

    static void addToCache(std::string docId, sk_sp<SkImage> fullFrame, sk_sp<SkImage> currentFrame, graphikos::painter::GLRect maxCoverageRect, SkMatrix cameraMatrix, SkMatrix canvasMatrix);
    static void addToCache(std::string docId, graphikos::painter::GLRect maxCoverageRect, SkMatrix cameraMatrix, SkMatrix canvasMatrix);
    static void deleteFromCache(std::string docId);
};

#endif
