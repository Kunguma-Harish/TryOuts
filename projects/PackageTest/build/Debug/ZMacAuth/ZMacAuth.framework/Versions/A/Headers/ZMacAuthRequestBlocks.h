//
//  ZMacAuthRequestBlocks.h
//  IAM_SSO
//
//  Created by Kumareshwaran on 24/03/17.
//  Copyright © 2017 Dhanasekar K. All rights reserved.
//

#ifndef ZMacAuthRequestBlocks_h
#define ZMacAuthRequestBlocks_h
#include "ZMacAuthUser.h"


/**
 The callback handler gives an access token or an error, if attempt to refresh was unsuccessful.

 @param accessToken This accessToken should be sent in the Authorization Header.(Header Value should be @"Zoho-oauthtoken TOKEN"  forHTTPHeaderField:@"Authorization" where TOKEN is the NSString accessToken obtained in this block)
 @param error Any error if the attempt to refresh was unsuccessful.
 */
typedef void (^ZMacAuthKitAccessTokenHandler)(NSString *accessToken,NSError *error);

/**
 The callback handler gives an access token, millis value of the respective access token's expiry time or an error, if attempt to refresh was unsuccessful.
 
 @param accessToken This accessToken should be sent in the Authorization Header.(Header Value should be @"Zoho-oauthtoken TOKEN"  forHTTPHeaderField:@"Authorization" where TOKEN is the NSString accessToken obtained in this block)
 @param expiresMillis This value gives you the millis value for which the respective accesstoken would be alive and valid.
 @param error Any error if the attempt to refresh was unsuccessful.
 */
typedef void (^ZMacAuthKitWMSAccessTokenHandler)(NSString *accessToken,long expiresMillis,NSError *error);

/**
 The callblack handler during Sign-in that gives the accessToken if there is no error. Inside this handler, you can redirect to your app's signed-in state and present your respective screens if the error is nil.
 
 @param accessToken OAuth Access Token of the Signed-in User.
 @param error Respective error object.
 */
typedef void (^ZMacAuthKitSigninHandler)(NSString *accessToken,NSError *error);


/**
 The callback handler for revoking the access token during logout. Nil error means that the access token was revoked successfully. You can handle your apps logout logic in this handler if there is no error.

 @param error Respective error object of revoke network call.
 */
typedef void (^ZMacAuthKitRevokeAccessTokenHandler)(NSError *error);



/**
 The callblack handler during Sign-in that gives the accessToken if there is no error. Inside this handler, you can redirect to your app's signed-in state and present your respective screens if the error is nil.
 
 @param accessToken OAuth Access Token of the Signed-in User.
 @param error Respective error object.
 */
typedef void (^ZMacAuthKitScopeEnhancementHandler)(NSString *accessToken,NSError *error);

/**
 The callblack handler during Sign-in that gives the accessToken if there is no error. Inside this handler, you can redirect to your app's signed-in state and present your respective screens if the error is nil.
 
 @param accessToken OAuth Access Token of the Signed-in User.
 @param error Respective error object.
 */
typedef void (^ZMacAuthKitAuthToOAuthHandler)(NSString *accessToken,NSError *error);

/**
 The callblack handler during the intermitent time when the accesstoken in the device would be valid where as the refresh_token would be revoked by the user in web. In such cases, getOAuth2Token would return you the access_token since it is alive, but on your server side you may get the invalid_oauthtoken error. If you get that error, call this method and if the shouldLogoutUser returnd in ZMacAuthKitInvalidOAuthLogoutHandler is true, take the user to the initial root onboarding/tour screen of your respective app.
 
 @param shouldLogoutUser If it is Yes/True take the user to the initial root viewcontroller. If it is No/False handle the error accordingly.
 */
typedef void (^ZMacAuthKitInvalidOAuthLogoutHandler)(BOOL shouldLogoutUser);

/**
 The callback handler for adding the secondary email id. Nil error means that the email id  was added successfully.

 @param error Respective error object of add email case.
 */
typedef void (^ZMacAuthAddEmailHandler)(NSError *error);

#endif /* ZMacAuthRequestBlocks_h */
