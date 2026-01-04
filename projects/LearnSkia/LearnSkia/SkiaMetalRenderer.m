//
//  SkiaMetalRenderer.m
//  LearnSkia
//
//  Created by kunguma-14252 on 21/03/25.
//

#import "SkiaBridge.h"
#import "include/gpu/ganesh/GrDirectContext.h"
#import "include/gpu/ganesh/mtl/GrMtlBackendContext.h"
#import "include/gpu/ganesh/mtl/GrMtlDirectContext.h"
#import "include/gpu/ganesh/mtl/GrMtlBackendSurface.h"
#import "include/gpu/ganesh/GrBackendSurface.h"
#import "include/gpu/ganesh/SkSurfaceGanesh.h"
#import "include/core/SkSurface.h"
#include "include/ports/SkCFObject.h"
#include "include/core/SkCanvas.h"
#include "include/core/SkPaint.h"
#include "include/core/SkColorSpace.h"
  
#include "include/core/SkColorType.h"
#include "include/gpu/ganesh/GrContextOptions.h"
#include "include/gpu/ganesh/mtl/GrMtlTypes.h"
#include "include/gpu/ganesh/mtl/SkSurfaceMetal.h"
#include "include/effects/SkGradientShader.h"
#include <stdlib.h>

static float randomFloat() {
    return static_cast<float>(arc4random()) / UINT32_MAX;
}

// Function to generate a random SkColor4f
static SkColor4f randomSkColor4f() {
    float red = randomFloat();
    float green = randomFloat();
    float blue = randomFloat();
    float alpha = randomFloat();

    return SkColor4f{red, green, blue, alpha};
}

static void config_paint(SkPaint* paint) {
//    if (!paint->getShader()) {
        const SkColor4f colors[2] = {randomSkColor4f(), randomSkColor4f()};
        const SkPoint points[2] = {{0, -1024}, {0, 1024}};
        paint->setShader(SkGradientShader::MakeLinear(points, colors, nullptr, nullptr, 2,
                                                      SkTileMode::kClamp, 0, nullptr));
//    }
}

static void draw_example(SkSurface* surface, const SkPaint& paint, double rotation) {
    SkCanvas* canvas = surface->getCanvas();
    canvas->save();
    canvas->translate(surface->width() * 0.5f, surface->height() * 0.5f);
    canvas->rotate(rotation);
    canvas->drawPaint(paint);
    canvas->restore();
    
    int radius = 5;
    for (int i = 0; i < surface->width(); i += radius * 2) {
        for (int j = 0; j < surface->height(); j += radius * 2) {
            SkPaint paint = SkPaint(randomSkColor4f());
            canvas->drawCircle(i, j, radius, paint);
        }
    }
}

@interface SkiaMetalRenderer ()
@property (strong) id<MTLDevice> metalDevice;
@property (strong) id<MTLCommandQueue> metalQueue;
@property(nonatomic, assign) GrDirectContext* skiaContext;
@end

@implementation SkiaMetalRenderer

sk_sp<GrDirectContext> _skiaContextHolder;
SkPaint fPaint;

- (instancetype)initWithDevice:(id<MTLDevice>)device {
    self = [super init];
    if (self) {
        [self setMetalQueue:[device newCommandQueue]];
        GrMtlBackendContext backendContext = {};
        backendContext.fDevice.reset((__bridge void*)device);
        backendContext.fQueue.reset((__bridge void*)[self metalQueue]);
        
        _skiaContextHolder = GrDirectContexts::MakeMetal(backendContext);
        self.skiaContext = _skiaContextHolder.get();
    }
    return self;
}

- (void)drawInMTKView:(MTKView *)view {
    if (![self skiaContext] || !view) {
        return;
    }
    config_paint(&fPaint);
    float rotation = 45;

    id<CAMetalDrawable> nextDrawable = [(CAMetalLayer*)view.layer nextDrawable];
    void* texture = (__bridge void*)(nextDrawable.texture);
    
    GrMtlTextureInfo textureInfo;
    textureInfo.fTexture.retain(texture);
    GrBackendRenderTarget backendRT = GrBackendRenderTargets::MakeMtl(nextDrawable.texture.width,
                                                                      nextDrawable.texture.height,
                                                                      textureInfo);
    sk_sp<SkSurface> surface = SkSurfaces::WrapBackendRenderTarget(self.skiaContext,
                                                  backendRT,
                                                  kTopLeft_GrSurfaceOrigin,
                                                  kBGRA_8888_SkColorType,
                                                  nullptr,
                                                  nullptr);
    draw_example(surface.get(), fPaint, rotation);
    surface = nullptr;
    self.skiaContext->flushAndSubmit();
    
    id<MTLCommandBuffer> commandBuffer = [[self metalQueue] commandBuffer];
    [commandBuffer presentDrawable:nextDrawable];
    [commandBuffer commit];
}
@end

