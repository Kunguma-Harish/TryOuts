#ifndef __NL_PROPERTIESCACHE_H
#define __NL_PROPERTIESCACHE_H

#include <nlpainter/caches/BaseCache.hpp>
#include <nlpainter/utils/PropertiesUtil.hpp>
#include <painter/PropertiesPainter.hpp>

namespace com::zoho::shapes {
class Properties;
}

class PropertiesCache : public NLCache {
public:
    PropertiesUtil::PropertiesInfo propsInfo;

    com::zoho::shapes::Properties* props = nullptr;
    PropertiesCache(com::zoho::shapes::Properties* props, const CacheContext* cacheContext, graphikos::painter::Matrices matrices);
    bool preDraw(SkCanvas* canvas, NLCacheContext* context) override;
    void computePropsBound() override;
    bool contains(const graphikos::painter::GLPoint& point, const SelectionSettings& ss) override;

    void populateCache(const CacheContext* cacheContext, graphikos::painter::Matrices matrices);
    bool drawStrokes(SkCanvas* canvas, NLCacheContext* context, bool drawInner = true, bool drawOuter = true);
};

#endif // __NL_PROPERTIESCACHE_H
