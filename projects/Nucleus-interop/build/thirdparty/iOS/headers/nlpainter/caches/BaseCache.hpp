#ifndef __NL_APPCACHE_H
#define __NL_APPCACHE_H

#include <nucleus/core/NLCacheNode.hpp>
#include <skia-extension/Matrices.hpp>

#include <unordered_map>

namespace graphikos::painter {
class IProvider;
}

namespace com::zoho::shapes {
class Transform;
class ShapeObject;
}

namespace google::protobuf {
class Message;
}

struct CacheContext : NLCacheContext {
    graphikos::painter::IProvider* provider = nullptr;
    std::unordered_map<std::string, std::shared_ptr<NLCache>>* cacheMap = nullptr;
    std::unordered_map<std::string, std::shared_ptr<NLCache>>* componentCacheMap = nullptr;
};

struct CacheInput {
    CacheInput();
    CacheInput(graphikos::painter::Matrices matrices, com::zoho::shapes::Transform* gTrans);

    graphikos::painter::Matrices matrices;
    com::zoho::shapes::Transform* gTrans = nullptr;
    graphikos::painter::GLRect customRect;
    graphikos::painter::GLRect customParentRect;
};

class BaseCache : public NLCache {
public:
    com::zoho::shapes::ShapeObject* shapeObject = nullptr;
    const CacheInput input;

    BaseCache(com::zoho::shapes::ShapeObject* shapeObject, const CacheInput& input);
    virtual google::protobuf::Message* getMessage();
    virtual std::string getShapeId();
};

#endif // __NL_APPCACHE_H
