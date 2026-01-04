//
//  ZMacAuthErrorHandler.h
//  ZMacAuth
//
//  Created by Kumareshwaran on 03/07/18.
//

#import <Foundation/Foundation.h>
#import "ZMacAuthZIAMUtil.h"
#import "ZMacAuthNetworkManager.h"

@interface ZMacAuthZIAMUtil(ZMacAuthErrorHandler)
-(NSError *)handleAccessTokenFetchError:(ZMacAuthInternalError)type error:(NSError *)error;
-(void)handleRevokeError:(ZMacAuthInternalError)type error:(NSError *)error failureBlock:(requestLogoutFailureBlock)failed;
-(void)handleScopeEnhancementError:(ZMacAuthInternalError)type error:(NSError *)error;
-(void)handleAuthToOAuthError:(ZMacAuthInternalError)type error:(NSError*)error failureBlock:(requestFailureBlock)failure;
-(NSError *)handleLoginError:(ZMacAuthInternalError)type error:(NSError *)error;
@end
