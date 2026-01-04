#pragma once

#include <painter/IProvider.hpp>
#include <painter/DrawingContext.hpp>

namespace graphikos {
namespace painter {
class GifPainter {
private:
    GifData* gifData = nullptr;
    std::vector<GifData*> gifCache;

public:
    GifPainter();
    GifPainter(GifData* gifData);
    GifPainter(std::vector<GifData*> gifCache);
    bool drawGifsFromCache(graphikos::painter::IProvider* provider);
    bool drawGif(graphikos::painter::IProvider* provider, std::string key);
    std::vector<std::vector<GLRect>> getUpdateRects(const DrawingContext& dc); // will be used in future.
};
}
}