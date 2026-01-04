#ifndef __NL_SHAPECACHE_H
#define __NL_SHAPECACHE_H

#include <nlpainter/caches/BaseCache.hpp>
#include <nlpainter/caches/PropertiesCache.hpp>
#include <nlpainter/caches/TextCache.hpp>

namespace com::zoho::shapes {
class ShapeObject;
class Shape;
class Transform;
}

class ShapeCache : public BaseCache {
public:
    com::zoho::shapes::Shape* shape = nullptr;

    std::shared_ptr<PropertiesCache> propsCache;
    std::shared_ptr<TextCache> textCache;

    ShapeCache(com::zoho::shapes::ShapeObject* shapObject, const CacheContext* cacheContext, const CacheInput& input);
    ShapeCache(com::zoho::shapes::Shape* shape, const CacheContext* cacheContext, const CacheInput& input);
    bool preDraw(SkCanvas* canvas, NLCacheContext* context) override;
    void computePropsBound() override;
    bool contains(const graphikos::painter::GLPoint& point, const SelectionSettings& ss) override;

    void populateCache(const CacheContext* cacheContext);
};

#endif // __NL_SHAPECACHE_H
