#ifndef MACAPPLICATION_HPP
#define MACAPPLICATION_HPP
#include <Cocoa/Cocoa.h>

typedef void (^MainLoopCallback)(BOOL loopNeeded);
@interface MacApplication : NSApplication
- (void)setMainLoopCallback;
- (void)setNeedMainLoopCallback:(BOOL)callback;

@end

#endif