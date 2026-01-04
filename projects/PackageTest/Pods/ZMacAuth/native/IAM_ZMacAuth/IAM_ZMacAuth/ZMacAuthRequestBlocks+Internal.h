//
//  ZMacAuthRequestBlocks+Internal.h
//  IAM_SSO
//
//  Created by Kumareshwaran on 30/03/17.
//  Copyright © 2017 Dhanasekar K. All rights reserved.
//

#ifndef ZMacAuthRequestBlocks_Internal_h
#define ZMacAuthRequestBlocks_Internal_h
#import <Cocoa/Cocoa.h>

typedef void (^requestSuccessBlock)(NSString *token);
typedef void (^requestFailureBlock)(NSError *error);
typedef void (^requestWMSSuccessBlock)(NSString *token,long expiresMillis);
typedef void (^requestViewControllerSuccessBlock)(NSViewController *returnViewController);
typedef void (^requestViewControllerFailureBlock)(NSError *error);
typedef void (^profileSuccessBlock)(NSDictionary *profileDictionary);
typedef void (^photoSuccessBlock)(NSData *photoData);
typedef void (^requestRevokeBlock)(NSError *error);
typedef void (^requestCheckLogoutBlock)(BOOL shouldLogout);
typedef void (^requestLogoutSuccessBlock)(void);
typedef void (^requestLogoutFailureBlock)(NSError *error);

typedef void (^ZMacAuthKitScopeEnhancementSuccessHandler)(NSString *token);
typedef void (^ZMacAuthKitScopeEnhancementFailureHandler)(NSError *error);

typedef void (^ZMacAuthAddEmailHandler)(NSError *error);

#endif /* ZMacAuthRequestBlocks_Internal_h */
