#ifndef __NL_GROUPSHAPECACHE_H
#define __NL_GROUPSHAPECACHE_H

#include <nlpainter/caches/BaseCache.hpp>
#include <nlpainter/caches/PropertiesCache.hpp>
#include <nlpainter/utils/GroupShapeUtil.hpp>

#include <painter/GroupShapePainter.hpp>

namespace com::zoho::shapes {
class ShapeObject;
class ShapeObject_GroupShape;
class Transform;
}

class GroupShapeCache : public BaseCache {
public:
    std::shared_ptr<NLCache> maskShapeCache;
    SkPath maskClipPath;
    sk_sp<SkPicture> backgroundBlur;
    std::optional<SkPaint> effectsPaint;
    graphikos::painter::GLRect bounds;

    com::zoho::shapes::ShapeObject_GroupShape* groupShape = nullptr;

    GroupShapeCache(com::zoho::shapes::ShapeObject* shapeObject, const CacheContext* cacheContext, const CacheInput& input);
    GroupShapeCache(com::zoho::shapes::ShapeObject_GroupShape* groupShape, const CacheContext* cacheContext, const CacheInput& input);
    bool preDraw(SkCanvas* canvas, NLCacheContext* context) override;
    bool postDraw(SkCanvas* canvas, NLCacheContext* context) override;
    void computePropsBound() override;

    std::vector<std::vector<const NLCache*>> getCache(const graphikos::painter::GLPoint& point, const SelectionSettings& ss) override;

    void populateCache(const CacheContext* cacheContext);
};

struct ComponentFollowerCache {
    GroupShapeUtil::SmartShapeFollowerInfo followerInfo;
};

struct ComponentLeaderCache {
    std::shared_ptr<PropertiesCache> propertiesCache;
};

class ComponentCache : public BaseCache {
public:
    com::zoho::shapes::ShapeObject_GroupShape* groupShape = nullptr;

    std::variant<std::monostate, ComponentLeaderCache, ComponentFollowerCache> leaderOrFollowerCache;

    ComponentCache(com::zoho::shapes::ShapeObject* shapeObject, const CacheContext* cacheContext, const CacheInput& input);
    ComponentCache(com::zoho::shapes::ShapeObject_GroupShape* groupShape, const CacheContext* cacheContext, const CacheInput& input);
    bool preDraw(SkCanvas* canvas, NLCacheContext* context) override;
    void computePropsBound() override;

    std::vector<std::vector<const NLCache*>> getCache(const graphikos::painter::GLPoint& point, const SelectionSettings& ss) override;

    void populateCache(const CacheContext* cacheContext);
};

#endif // __NL_GROUPSHAPECACHE_H
