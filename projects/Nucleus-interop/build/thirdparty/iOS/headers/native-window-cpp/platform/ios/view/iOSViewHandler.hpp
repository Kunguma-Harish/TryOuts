#ifndef IOS_VIEW_HANDLER_HPP
#define IOS_VIEW_HANDLER_HPP
#import <UIKit/UIKit.h>
#import <MetalKit/MetalKit.h>
#include <native-window-cpp/common/event/NWTEvents.hpp>

@interface iOSViewHandler : UIViewController <MTKViewDelegate, UIScrollViewDelegate>

- (void)setEventManager:(NWTEvents*)event;
- (void)attachScrollViewToContainer;
- (void) attachMouseViewToContainer;
@property (nonatomic, assign) BOOL scrollDecelerated;
@property (nonatomic, assign) CGPoint initialContentOffset;

@end
#endif
