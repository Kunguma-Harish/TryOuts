//
//  ViewController.h
//  Hello World TouchID
//
//  Created by Kumareshwaran on 17/02/17.
//  Copyright © 2017 Kumareshwaran. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Webkit/Webkit.h"
#import "ZMacAuthRequestBlocks+Internal.h"


API_AVAILABLE(macos(10.10))
@interface ZMacAuthLoginViewController : NSViewController
@property requestSuccessBlock success;
@property requestFailureBlock failure;
@property (nonatomic,strong) WKWebView *webkitview;

@end

