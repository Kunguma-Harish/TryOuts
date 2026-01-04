//
//  SkiaBridge.m
//  LearnSkia
//
//  Created by kunguma-14252 on 21/03/25.
//

#import "SkiaBridge.h"
#import "include/core/SkCanvas.h"
#import "include/core/SkSurface.h"
#import "include/core/SkPaint.h"
#import "include/core/SkPixmap.h"

@implementation SkiaRenderer

- (UIImage *)drawSomething {
    int width = 200, height = 200;

    // Create Skia Surface with Raw Pixels
    SkImageInfo info = SkImageInfo::Make(width, height, kN32_SkColorType, kPremul_SkAlphaType);
    size_t rowBytes = info.minRowBytes();
    void* pixels = malloc(info.computeByteSize(rowBytes));

    if (!pixels) return nil; // Handle allocation failure

    SkPixmap pixmap(info, pixels, rowBytes);
    sk_sp<SkSurface> surface = SkSurfaces::WrapPixels(pixmap);
    SkCanvas* canvas = surface->getCanvas();

    // Draw a red circle
    SkPaint paint;
    paint.setColor(SK_ColorRED);
    canvas->drawCircle(100, 100, 50, paint);

    // Convert SkPixmap to CGImage
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(
        pixels, width, height, 8, rowBytes, colorSpace, kCGImageAlphaPremultipliedLast);
    
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    UIImage *uiImage = [UIImage imageWithCGImage:cgImage];

    // Clean up
    CGImageRelease(cgImage);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels); // Free manually allocated memory

    return uiImage;
}

@end

