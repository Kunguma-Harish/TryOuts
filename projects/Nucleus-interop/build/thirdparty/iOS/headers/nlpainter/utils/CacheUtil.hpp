#ifndef __NL_CACHEUTIL_H
#define __NL_CACHEUTIL_H

#include <nlpainter/caches/BaseCache.hpp>

#include <nlpainter/caches/ShapeCache.hpp>
#include <nlpainter/caches/CombinedObjectCache.hpp>
#include <nlpainter/caches/GroupShapeCache.hpp>
#include <nlpainter/caches/PictureCache.hpp>

#include <painter/GL_Ptr.h>

namespace com::zoho::shapes {
enum ShapeNodeType : int;
}

struct SkPictureCache : BaseCache {

    sk_sp<SkPicture> picture;

    SkPictureCache(com::zoho::shapes::ShapeObject* shapeObject, const CacheContext* cacheContext, const CacheInput& input);
    bool preDraw(SkCanvas* canvas, NLCacheContext* context) override;
    void computePropsBound() override;
    void populateCache(const CacheContext* cacheContext);
};

class CacheFactory {
public:
    static std::shared_ptr<NLCache> MakeCache(com::zoho::shapes::ShapeObject* shapeObject, const CacheContext* cacheContext, const CacheInput& cacheInput = CacheInput());
};

GL_Ptr<com::zoho::shapes::ShapeObject> getWrapperShapeObject();

graphikos::painter::Matrices getMatrix(com::zoho::shapes::Transform* transform, const CacheInput& input);

com::zoho::shapes::ShapeNodeType getShapeNodeType(const BaseCache* cache);
#endif // __NL_CACHEUTIL_H
