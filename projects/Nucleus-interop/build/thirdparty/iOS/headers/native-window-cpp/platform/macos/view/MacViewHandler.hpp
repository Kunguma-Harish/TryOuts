#include <Cocoa/Cocoa.h>

#include <native-window-cpp/platform/macos/event/MacEvents.hpp>

@interface MacViewHandler : NSView

- (void)keyDown:(NSEvent*)event;

- (void)keyUp:(NSEvent*)event;

- (void)mouseDown:(NSEvent*)event;

- (NSString*)textForClickCount:(int)clickCount;

- (void)displayText:(NSString*)text;

- (void)mouseUp:(NSEvent*)event;

- (void)mouseDragged:(NSEvent*)event;

- (void)mouseMoved:(NSEvent*)event;

- (void)magnifyWithEvent:(NSEvent*)event;

- (BOOL)acceptsFirstResponder;

- (MacEvents*)getEventManager;

- (void)setEventManager:(MacEvents*)event;

- (void)initializeKeycodes;

@end
