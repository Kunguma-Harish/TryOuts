#ifndef __NL_ZSVGRENDERBACKEND_H
#define __NL_ZSVGRENDERBACKEND_H
#include <nucleus/core/ZRenderBackend.hpp>

class SkDynamicMemoryWStream;
class SkData;

class ZSVGRenderBackend : public ZRenderBackend {
private:
    SkDynamicMemoryWStream* svgStream;
	SkCanvas* canvas = nullptr;
    // SkFILEWStream* svgStream;
    void onCreateCanvas(int width, int height, uint32_t flags = 0) override;
    bool onFlush() override;

public:
    ZSVGRenderBackend(bool clearColor = SK_ColorTRANSPARENT);
    ~ZSVGRenderBackend();
	SkCanvas* getCanvas() override;
    void makeContextCurrent() override;
    sk_sp<SkData> getSVG();
    sk_sp<SkData> getData() override;
};

#endif
