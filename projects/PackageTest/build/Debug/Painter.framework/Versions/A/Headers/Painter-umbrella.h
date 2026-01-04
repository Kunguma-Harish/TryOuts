#ifdef __OBJC__
#import <Cocoa/Cocoa.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "LRUCache.h"
#import "LRUCache.hpp"

FOUNDATION_EXPORT double PainterVersionNumber;
FOUNDATION_EXPORT const unsigned char PainterVersionString[];

