//
//  SkiaBridge.h
//  LearnSkia
//
//  Created by kunguma-14252 on 21/03/25.
//

#ifndef SkiaBridge_h
#define SkiaBridge_h

#import <UIKit/UIKit.h>
#import <MetalKit/MetalKit.h>

@interface SkiaRenderer : NSObject
- (UIImage *)drawSomething;
@end

@interface SkiaMetalRenderer : NSObject

- (instancetype)initWithDevice:(id<MTLDevice>)device;
- (void)drawInMTKView:(MTKView *)view;

@end

#endif /* SkiaBridge_h */
