#ifndef __NL_PICTURECACHE_H
#define __NL_PICTURECACHE_H

#include <nlpainter/caches/BaseCache.hpp>

class PropertiesCache;

namespace com::zoho::shapes {
class ShapeObject;
class Picture;
class Transform;
}

class PictureCache : public BaseCache {
public:
    com::zoho::shapes::Picture* picture = nullptr;

    std::shared_ptr<PropertiesCache> propsCache;

    PictureCache(com::zoho::shapes::ShapeObject* shapeObject, const CacheContext* cacheContext, const CacheInput& input);
    PictureCache(com::zoho::shapes::Picture* picture, const CacheContext* cacheContext, const CacheInput& input);
    bool preDraw(SkCanvas* canvas, NLCacheContext* context) override;
    void computePropsBound() override;
    bool contains(const graphikos::painter::GLPoint& point, const SelectionSettings& ss) override;

    void populateCache(const CacheContext* cacheContext);
};

#endif // __NL_PICTURECACHE_H
