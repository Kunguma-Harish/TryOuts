#ifndef __NL_COMBINEDOBJECTCACHE_H
#define __NL_COMBINEDOBJECTCACHE_H

#include <nlpainter/caches/BaseCache.hpp>
class PropertiesCache;

namespace com::zoho::shapes {
class ShapeObject;
class ShapeObject_CombinedObject;
class Transform;
}

class CombinedObjectCache : public BaseCache {
public:
    com::zoho::shapes::ShapeObject_CombinedObject* combinedObject = nullptr;

    std::shared_ptr<PropertiesCache> propsCache;
    std::vector<std::shared_ptr<NLCache>> combinedNodes;

    CombinedObjectCache(com::zoho::shapes::ShapeObject* shapeObject, const CacheContext* cacheContext, const CacheInput& input);
    CombinedObjectCache(com::zoho::shapes::ShapeObject_CombinedObject* combinedObject, const CacheContext* cacheContext, const CacheInput& input);
    bool preDraw(SkCanvas* canvas, NLCacheContext* context) override;
    void computePropsBound() override;
    std::vector<std::vector<const NLCache*>> getCache(const graphikos::painter::GLPoint& point, const SelectionSettings& ss) override;
    bool contains(const graphikos::painter::GLPoint& point, const SelectionSettings& ss) override;

    void populateCache(const CacheContext* cacheContext);
};

#endif // __NL_COMBINEDOBJECTCACHE_H
