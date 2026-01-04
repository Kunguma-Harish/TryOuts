#ifndef __NL_BASERENDERER_H
#define __NL_BASERENDERER_H

#include <skia-extension/GLRect.hpp>
#include <app/NLCacheBuilder.hpp>

class BaseRenderer {
public:
    virtual std::vector<graphikos::painter::GLRect> updateCache(const std::vector<ComposedContent>& composedContents);
    virtual void refreshRect(std::vector<graphikos::painter::GLRect> rects);
    virtual void preRender(const std::vector<ComposedContent>& composedContents);
    virtual void postRender(const std::vector<ComposedContent>& composedContents);
};

#endif
