#ifndef SCENEDELEGATE_HPP
#define SCENEDELEGATE_HPP
#import <UIKit/UIKit.h>
#include <native-window-cpp/platform/ios/app/AppDelegate.hpp>

@interface SceneDelegate : UIResponder <UIWindowSceneDelegate>

@property(strong, nonatomic) UIWindow* window;

@end
#endif
