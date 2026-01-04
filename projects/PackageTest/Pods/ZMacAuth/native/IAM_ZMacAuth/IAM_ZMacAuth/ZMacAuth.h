//
//  ZMacAuth.h
//  Hello World TouchID
//
//  Created by Kumareshwaran on 11/10/17.
//  Copyright © 2017 Kumareshwaran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "ZMacAuthConstants.h"
#import "ZMacAuthEnums.h"
#import "ZMacAuthRequestBlocks.h"
#import "ZMacAuthProfileData.h"
API_AVAILABLE(macos(10.10))
@interface ZMacAuth : NSObject

/**
 This method helps you to initialize the parameters which are required by the SSOKit.
 Call this method during App Launch in Extensions and iWatch.
 (Note: Add your main app's bundle id in your extensions info.plist for "SSOKIT_MAIN_APP_BUNDLE_ID" key)
 
 @param clientID The client ID of your app will be given by the IAM Team.(Note: Use different Client ID's for Local Zoho and IDC.)
 @param scopearray The API scopes requested by the app, represented in an array of |NSString|s. The default value is |@[aaaserver.profile.READ,zohocontacts.userphoto.READ]|.(Get the list of scopes required for your app from the respective service teams. Each Scope String should follow the proper syntax. -> 'servicename'.'scopename'.'operation type' Example: aaaserver.profile.READ.
 @param URLScheme Your App's URL Scheme.(!Please WhiteList the URL Scheme "ZOA"!)
 @param buildType This is the Enum of your build type. (LocalZoho, Live etc...)
 */
+ (void) initWithClientID: (NSString*)clientID
                    Scope:(NSArray*)scopearray
                URLScheme:(NSString*)URLScheme
                BuildType:(ZMacAuthBuildType)buildType;

+ (void) initWithClientID: (NSString*)clientID
                    Scope:(NSArray*)scopearray
                URLScheme:(NSString*)URLScheme
          SharedAppTarget:(NSArray *)sharedTargetPaths
                  Service:(NSString *)service
                BuildType:(ZMacAuthBuildType)buildType;


/**
 Method for letting us know that your app has an App Extension, so that we will place the respective data in the keychain within the specified app group. Call this method in App Delegate launch after the above initializeWithClientID method. This should be called before you call clearSSODetailsForFirstLaunch method.
 
 @param appGroup appgroup string in which you want the keychain data to be available.
 */
+ (void)setHavingAppExtensionWithAppGroup:(NSString *)appGroup;


/**
 Gets the access token. In case the access token has expired or is about to expire, this method get a new token.
 
 @param tokenBlock callback in which you will get the required access token.
 */
+ (void) getOAuth2Token:(ZMacAuthKitAccessTokenHandler)tokenBlock NS_EXTENSION_UNAVAILABLE_IOS("");
+ (void) getOAuth2TokenForZUID:(NSString*) zuid token:(ZMacAuthKitAccessTokenHandler)tokenBlock NS_EXTENSION_UNAVAILABLE_IOS("");

/**
 Gets the access token along with its expiry time for WMS Special case handling of web sockets. In case the access token has expired or is about to expire(Reduced from 60mins to 53mins), this method get a new token.
 
 @param tokenBlock callback in which you will get the required access token.
 */
+ (void) getOAuth2TokenForWMS:(ZMacAuthKitWMSAccessTokenHandler)tokenBlock;
+ (void) getOAuth2TokenForWmsHavingZUID:(NSString*) zuid token:(ZMacAuthKitWMSAccessTokenHandler)tokenBlock;

/**
 Presents the initial viewcontroller - (SFSafariViewController for Sign in/ SSOUserAccountsTableViewController for SSO Account Chooser).
 
 @param signinBlock handler block.
 */
+ (void) presentInitialViewControllerInContentView:(NSView *) contentView signinBlock:(ZMacAuthKitSigninHandler)signinBlock;


/**
 Presents the initial viewcontroller with custom params for Sign in page - (SFSafariViewController for Sign in/ SSOUserAccountsTableViewController for SSO Account Chooser).
 
 @param urlParams custom urlparams to be passed to the sign-in page.
 @param signinBlock handler block.
 */
+ (void) presentInitialViewControllerInContentView:(NSView *) contentView withCustomParams:(NSString *)urlParams
                                        signinHandler:(ZMacAuthKitSigninHandler)signinBlock;

/**
 Presents the SignUpViewController instance of SFSafari. Normal Accounts Signup page will be shown.
 
 @param signinBlock handler block.
 */
+ (void) presentSignUpViewControllerInContentView:(NSView *) contentView signinBlock:(ZMacAuthKitSigninHandler)signinBlock;

/**
 Presents the SignUpViewController instance of SFSafari having a custom signup flow. Your respective service team should be contacting IAM for service url param and will have to set the same on their signup page's register.js.
 
 @param signupUrl custom signup url.
 @param signinBlock handler block.
 */
+ (void) presentSignUpViewControllerInContentView:(NSView *) contentView havingURL:(NSString *)signupUrl
                                signinHandler:(ZMacAuthKitSigninHandler)signinBlock;


/**
 Method to clear the keychain items stored by SSOKit which would be persistant even after uninstalling the app. (Call this method if it is going to be your apps firt time launch. Not requried post iOS 10.3)
 */
+ (void) clearSSODetailsForFirstLaunch;


/**
 Method to get the Signed-in status of user in your app.
 
 @return YES if there is already a user signed-in to your app or NO if there is no user signed in to your app.
 */
+ (BOOL) isUserSignedIn;


/**
 Method to get the Current User object of your App.
 
 @return ZMacAuthUser object of the current user.
 */
+(ZMacAuthUser *)getCurrentUser;


/**
 If your app supports Multi Account, you can use this method to set the current user of your app.

 @param userZuid zuid value of the user
 */
+(void) setCurrentUserHavingZUID:(NSString *)userZuid;


/**
 If your app supports Mutli Account, you can use this method to get the array having ZMAcAuthUser objects of all the users of your app

 @return array having ZMAcAuthUser objects
 */
+(NSMutableArray *)getAllUsers;


/**
 If your app supports Mutli Account, you can use this method to get the array having ZUID values of all the users of your app

 @return array having ZUID values
 */
+(NSMutableArray *)getAllUsersZUIDs;


/**
 If your app supports Mutli Account, Method to get ZMacAuthUser object for a specific ZUID.

 @param zuid zuid value of the user
 @return ZMacAuthUser object of the respective user
 */
+(ZMacAuthUser *)getZMacAuthUserHavingZUID:(NSString *)zuid;


/**
 Method to be called during Logout. This will revoke the access token from the server and clears the keychain items stored by SSOKit.
 
 @param revoke handler block.
 */
+(void)revokeAccessToken:(ZMacAuthKitRevokeAccessTokenHandler)revoke;


/**
 If your app supports Mutli Account, Method to revokeAccessToken for a particular ZUID.

 @param zuid zuid value of the user
 @param revoke handler block.
 */
+(void)revokeAccessTokenForZUID:(NSString *) zuid block:(ZMacAuthKitRevokeAccessTokenHandler)revoke;


/**
 Method to get the transformed URL which does the DCL handling. (Call this method once and persist the transformed URL)
 
 @param url Input URL which needs to be transformed.
 @return Output transformed URL based upon the users DCL data.
 */
+(NSString *)getTransformedURLStringForURL:(NSString *)url;


/**
 If your app supports Mutli Account, Method to get the transformed URL for a particular ZUID which does the DCL handling. (Call this method once and persist the transformed URL)

 @param url Input URL which needs to be transformed.
 @param zuid zuid value of the user
 @return Output transformed URL based upon the users DCL data.
 */
+(NSString *)getTransformedURLStringForURL:(NSString *)url zuid:(NSString*) zuid;

/**
 Call this method to skip fetching the profile photo during sign in. This might improve the performace by reducing the time taken for completing the Sign in.
 */
+(void) donotFetchProfilePhotoDuringSignin;


/**
 Method to get the DCL Related Data if required for any special handling in your app.
 
 @return dcl information.
 */
+(NSDictionary *)getDCLInfoForCurrentUser;
+(NSDictionary *)getDCLInfoForZuid: (NSString*) zuid;

/**
 Method used for Scope Enhancements. Call this method once if you are introducing new scopes in your app update.
 
 @param enhanceHandler handler block.
 */
+(void)enhanceScopesInContentView:(NSView *) contentView enhanceHandler:(ZMacAuthKitScopeEnhancementHandler)enhanceHandler;

/**
 Method used for Scope Enhancements. Call this method once if you are introducing new scopes in your app update for any particular ZUID.
 
 @param enhanceHandler handler block.
 @param zuid zuid value of the user
 */
+(void)enhanceScopesInContentView:(NSView *) contentView enhanceHandler:(ZMacAuthKitScopeEnhancementHandler)enhanceHandler zuid:(NSString*) zuid;

/**
 Method used for Adding Secondary Email ID. Web UI will be presented for entering Email ID and verifying the OTP.
 
 @param addEmailHandler handler block.
 */
+(void)addSecondaryEmailIDInContentView:(NSView *) contentView WithCallback:(ZMacAuthAddEmailHandler)addEmailHandler;

/**
 Method used for Adding Secondary Email ID. Web UI will be presented for entering Email ID and verifying the OTP. Call this method for adding secondary email id to a particular account.
 
 @param addEmailHandler handler block.
 @param zuid zuid value of the user
 */
+(void)addSecondaryEmailIDInContentView:(NSView *) contentView ForZuid:(NSString *)zuid WithCallback:(ZMacAuthAddEmailHandler)addEmailHandler;

/**
 Method used to migrate the existing AuthToken users to OAuth.
 
 @param authToken existing user's AuthToken
 @param appName Contact IAM Team and get the value for AppName.
 @param accountsBaseURL accounts base URL for the respective user.
 @param authToOAuthBlock handler block.
 */
+(void)getOAuth2TokenUsingAuthToken:(NSString *)authToken
                             forApp:(NSString *)appName
                  havingAccountsURL:(NSString *)accountsBaseURL
                 authToOAuthHandler:(ZMacAuthKitAuthToOAuthHandler)authToOAuthBlock;
/**
 Calling this method will point to China setup thereby showing the China Sign in page.
 */
+(void) pointToChinaSetup;


/**
 Call this method to nullify the effect of the above pointToChinaSetup method.
 */
+(void) cancelPointToChinaSetup;

/**
 Call this method everytime when your server gives you the invalid OAuth token error to check if it is a valid error case and to determine if you should logout the user and take them to your onboarding screen.
 
 @param logoutHandler handler block.
 */
+(void)checkAndLogoutUserDuringInvalidOAuth:(ZMacAuthKitInvalidOAuthLogoutHandler)logoutHandler;

/**
 Call this method everytime when your server gives you the invalid OAuth token error to check if it is a valid error case and to determine if you should logout the user and take them to your onboarding screen for a particular ZUID.
 
 @param logoutHandler handler block.
 @param zuid zuid value of the user
 */
+(void)checkAndLogoutUserDuringInvalidOAuth:(ZMacAuthKitInvalidOAuthLogoutHandler)logoutHandler zuid:(NSString*) zuid;

+(void) startPreloginProgress:(void (^)(void)) callbackBlock;
+(void) endPreloginProgress:(void (^)(void)) callbackBlock;
+(void) startProgress:(void (^)(void)) callbackBlock;
+(void) endProgress:(void (^)(void)) callbackBlock;

/**
 If this method is called before calling the present methods, we will not send the scopes paramater during Sign in and Sign up cases.
 */
+(void)donotSendScopesParam;

/**
Call this method to get debug logs
*/

+(void) logger: (void (^)(NSString *)) logger;
@end
