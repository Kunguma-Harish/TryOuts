#include <Cocoa/Cocoa.h>
#include<native-window-cpp/platform/macos/event/MacEvents.hpp>


@interface WindowDelegate : NSWindowController <NSWindowDelegate> // NSObject<NSWindowDelegate>

- (BOOL)windowShouldClose:(NSWindow*)sender;

- (void) windowDidResize:(NSNotification*)notification;

- (void) windowDidMiniaturize:(NSNotification*)notification;

- (void) windowDidDeminiaturize:(NSNotification*)notification;

- (void) windowDidMove:(NSNotification*)notification;

- (void)setEventManager:(MacEvents *)events;
@end
