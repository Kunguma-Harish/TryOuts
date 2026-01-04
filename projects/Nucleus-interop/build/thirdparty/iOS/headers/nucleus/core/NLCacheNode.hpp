#ifndef __NL_CACHENODE_H
#define __NL_CACHENODE_H

#include <vector>
#include <include/core/SkRefCnt.h>
#include <skia-extension/GLRect.hpp>
#include <memory>

class SkCanvas;
class NLDeferredDetails;
class NLSkRTree;

///TODO: check if drawSettings can be used by extending rather than including all settings here
struct DrawSettings {
    bool skipText = false;
    bool skipReactions = false;
};

///TODO: create NLDrawContext and NLHitTestContext

struct NLCacheContext {
    NLDeferredDetails* dd = nullptr;
    DrawSettings drawSettings;
    // shall we use typedef or Using ??
    // virtual ~NLCacheContext(){};
};

struct SelectionSettings {
    bool checkSubShapes = false;
    float selectionOffset = 0.0f;
    bool includeAllShapes = false;
    bool includeHidden = false;
    bool checkBoundsAlone = false;
    bool checkContainerAlone = false;
};

class NLCache {
public:
    bool isHidden = false;
    NLCache* parent = nullptr;
    std::optional<graphikos::painter::GLRect> propsBound;     // bound of full properties
    std::optional<graphikos::painter::GLRect> selectionBound; // bound that would be needed for selection
    std::vector<std::shared_ptr<NLCache>> caches;
    std::shared_ptr<NLSkRTree> childrenTree;

    virtual ~NLCache();

    virtual bool preDraw(SkCanvas* canvas, NLCacheContext* context);
    bool draw(SkCanvas* canvas, NLCacheContext* context);
    virtual bool postDraw(SkCanvas* canvas, NLCacheContext* context);

    virtual void computePropsBound();
    graphikos::painter::GLRect getPropsBound(bool forceCompute = false);

    void setParent(NLCache* parent);
    void addChildNode(std::shared_ptr<NLCache> childNode);

    virtual std::vector<std::vector<const NLCache*>> getCache(const graphikos::painter::GLPoint& point, const SelectionSettings& ss);
    virtual bool contains(const graphikos::painter::GLPoint& point, const SelectionSettings& ss);

#ifdef NL_CACHE_TEMP
    bool skipPreDraw = false;
    bool skipPostDraw = false;
    void setSkipPreDraw(const bool& skipPreDraw);
    void setSkipPreDraw(const bool& skipPreDraw);
#endif // NL_CACHE_TEMP
};

#endif // __NL_CACHENODE_H
