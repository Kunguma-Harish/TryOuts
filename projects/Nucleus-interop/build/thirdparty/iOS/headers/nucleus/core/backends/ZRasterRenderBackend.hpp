#ifndef __NL_ZRASTERRENDERBACKEND_H
#define __NL_ZRASTERRENDERBACKEND_H
#include <nucleus/core/ZRenderBackend.hpp>

class ZRasterRenderBackend : public ZRenderBackend {
private:
    void onCreateCanvas(int width, int height, uint32_t flags) override;
    bool onFlush() override;

public:
    ZRasterRenderBackend(bool clearColor);
    void makeContextCurrent() override;
    sk_sp<SkData> getData() override;
};

#endif
