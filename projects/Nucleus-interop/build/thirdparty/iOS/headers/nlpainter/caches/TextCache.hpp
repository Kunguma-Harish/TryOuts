#ifndef __NL_TEXTCACHE_H
#define __NL_TEXTCACHE_H

#include <nucleus/core/NLCacheNode.hpp>
#include <nlpainter/caches/BaseCache.hpp>

class SkPicture;
namespace com::zoho::shapes {
class TextBody;
class Transform;
class Properties;
class NonVisualShapeProps;
}

class TextCache : public NLCache {
public:
    // SkPictureCache text;
    com::zoho::shapes::TextBody* text = nullptr;
    // com::zoho::shapes::Transform* transform;
    com::zoho::shapes::Properties* props = nullptr;
    com::zoho::shapes::NonVisualShapeProps* nvoprops = nullptr;
    sk_sp<SkPicture> picture;

    // temp members
    graphikos::painter::Matrices matrices;
    com::zoho::shapes::Transform* gTrans = nullptr;
    graphikos::painter::IProvider* provider = nullptr;

    TextCache(com::zoho::shapes::TextBody* text, const CacheContext* cacheContext, com::zoho::shapes::Properties* props, com::zoho::shapes::NonVisualShapeProps* nvoprops, graphikos::painter::Matrices matrices, com::zoho::shapes::Transform* gTrans);
    bool preDraw(SkCanvas* canvas, NLCacheContext* context) override;

    void populateCache(const CacheContext* cacheContext);
    void computePropsBound() override;
    bool contains(const graphikos::painter::GLPoint& point, const SelectionSettings& ss) override;
};

#endif // __NL_TEXTCACHE_H
