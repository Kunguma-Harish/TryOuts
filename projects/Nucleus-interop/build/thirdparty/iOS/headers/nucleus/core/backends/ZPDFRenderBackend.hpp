#ifndef __NL_ZPDFRENDERBACKEND_H
#define __NL_ZPDFRENDERBACKEND_H
#include <nucleus/core/ZRenderBackend.hpp>

class SkDynamicMemoryWStream;
class SkDocument;

class ZPDFRenderBackend : public ZRenderBackend {
private:
    SkDynamicMemoryWStream* pdfStream;
    sk_sp<SkDocument> pdfDoc;
	SkCanvas* canvas = nullptr;
    // SkFILEWStream* pdfStream;
    void onCreateCanvas(int width, int height, uint32_t flags) override;
    bool onFlush() override;
public:
    ZPDFRenderBackend();
    ~ZPDFRenderBackend();
	SkCanvas* getCanvas() override;
    sk_sp<SkData> getData() override;
    void makeContextCurrent() override;
    sk_sp<SkData> getPDF();
    void makePdf();
    SkCanvas* beginPage(int width,int height); 
};

#endif
