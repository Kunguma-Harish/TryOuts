#pragma once

#include <include/gpu/GrDirectContext.h>
#include <include/encode/SkPngEncoder.h>
#include <include/encode/SkJpegEncoder.h>
#include <include/core/SkCanvas.h>
#include <include/core/SkSurface.h>


namespace ImageEncoder {

    enum ImageType {
        BMP,
        PNG,
        JPEG
    };
    
    sk_sp<SkData> getPNGImageData(GrDirectContext* ctx, const SkImage* img, const SkPngEncoder::Options& options);
    sk_sp<SkData> getJPEGImageData(GrDirectContext* ctx, const SkImage* img, const SkJpegEncoder::Options& options);
    sk_sp<SkData> getEncodedImageData(GrDirectContext* ctx, const SkImage* img,ImageType imageType);
}