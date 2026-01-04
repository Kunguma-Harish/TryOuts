//
//  ZMacAuth.m
//  Hello World TouchID
//
//  Created by Kumareshwaran on 11/10/17.
//  Copyright © 2017 Kumareshwaran. All rights reserved.
//

#import "ZMacAuth.h"
#import "ZMacAuthZIAMUtil.h"
#import "ZMacAuthKeychainUtil.h"
#import "ZMacAuthHelpers.h"

@implementation ZMacAuth

+ (void) initWithClientID: (NSString*)clientID
                    Scope:(NSArray*)scopearray
                URLScheme:(NSString*)URLScheme
                BuildType:(ZMacAuthBuildType)buildType{
    [[ZMacAuthZIAMUtil sharedUtil] initWithClientID:clientID Scope:scopearray URLScheme:URLScheme BuildType:buildType];
}
+ (void) initWithClientID: (NSString*)clientID
                    Scope:(NSArray*)scopearray
                URLScheme:(NSString*)URLScheme
          SharedAppTarget:(NSArray *)sharedTargetPaths
                  Service:(NSString *)service
                BuildType:(ZMacAuthBuildType)buildType{
    [[ZMacAuthZIAMUtil sharedUtil] initWithClientID:clientID Scope:scopearray URLScheme:URLScheme BuildType:buildType];
    [ZMacAuthZIAMUtil sharedUtil].SharedTargetPaths = sharedTargetPaths;
    [ZMacAuthZIAMUtil sharedUtil].KeychainService = service;
    
}

+ (void)setHavingAppExtensionWithAppGroup:(NSString *)appGroup{
    [ZMacAuthZIAMUtil sharedUtil].ExtensionAppGroup = appGroup;
}

+ (void) getOAuth2Token:(ZMacAuthKitAccessTokenHandler)tokenBlock {
    [ZMacAuth getOAuth2TokenForZUID:[ZMacAuth currentZUID] token:tokenBlock];
}

+ (void) getOAuth2TokenForZUID:(NSString*) zuid token:(ZMacAuthKitAccessTokenHandler)tokenBlock{
    [[ZMacAuthZIAMUtil sharedUtil] getOauth2TokenForZUID:zuid success:^(NSString *token) {
        tokenBlock(token,nil);
    } failure:^(NSError *error) {
        tokenBlock(nil,error);
    }];
}

+ (void) getOAuth2TokenForWMS:(ZMacAuthKitWMSAccessTokenHandler)tokenBlock{
    [ZMacAuth getOAuth2TokenForWmsHavingZUID:[ZMacAuth currentZUID] token:tokenBlock];
}

+ (void) getOAuth2TokenForWmsHavingZUID:(NSString*) zuid token:(ZMacAuthKitWMSAccessTokenHandler)tokenBlock{
    [[ZMacAuthZIAMUtil sharedUtil]getTokenForWMSHavingZUID:zuid success:^(NSString *token, long expiresMillis) {
        tokenBlock(token,expiresMillis,nil);
    } failure:^(NSError *error) {
        tokenBlock(nil,0,error);
    }];
}

+ (void) presentInitialViewControllerInContentView:(NSView *) contentView signinBlock:(ZMacAuthKitSigninHandler)signinBlock{
    [[ZMacAuthZIAMUtil sharedUtil] presentInitialViewControllerInContentView:contentView withSuccess:^(NSString *token) {
        signinBlock(token, nil);
    } andFailure:^(NSError *error) {
        signinBlock(nil, error);
    }];
}

+ (void) presentInitialViewControllerInContentView:(NSView *) contentView withCustomParams:(NSString *)urlParams
                                        signinHandler:(ZMacAuthKitSigninHandler)signinBlock{

    [ZMacAuthZIAMUtil sharedUtil]->UrlParams = urlParams;
    [[ZMacAuthZIAMUtil sharedUtil] presentInitialViewControllerInContentView:contentView withSuccess:^(NSString *token) {
        signinBlock(token, nil);
    } andFailure:^(NSError *error) {
        signinBlock(nil, error);
    }];
}

+ (void) presentSignUpViewControllerInContentView:(NSView *) contentView signinBlock:(ZMacAuthKitSigninHandler)signinBlock {

    [ZMacAuthZIAMUtil sharedUtil]->SignUpUrl = [NSString stringWithFormat:@"%@/accounts/register?servicename=aaaserver",[ZMacAuthZIAMUtil sharedUtil]->BaseUrl];
    [[ZMacAuthZIAMUtil sharedUtil] presentInitialViewControllerInContentView:contentView withSuccess:^(NSString *token) {
        signinBlock(token, nil);
    } andFailure:^(NSError *error) {
        signinBlock(nil, error);
    }];
}

+ (void) presentSignUpViewControllerInContentView:(NSView *) contentView havingURL:(NSString *)signupUrl
                                signinHandler:(ZMacAuthKitSigninHandler)signinBlock{

    [ZMacAuthZIAMUtil sharedUtil]->SignUpUrl = signupUrl;
    [[ZMacAuthZIAMUtil sharedUtil] presentInitialViewControllerInContentView:contentView withSuccess:^(NSString *token) {
        signinBlock(token, nil);
    } andFailure:^(NSError *error) {
        signinBlock(nil, error);
    }];
}

+ (void) clearSSODetailsForFirstLaunch{
    if([ZMacAuth currentZUID])
        [[ZMacAuthZIAMUtil sharedUtil] clearDataForLogoutHavingZUID:[ZMacAuth currentZUID]];
}


+ (BOOL)handleURL:(NSURL *)url
sourceApplication:(NSString *)sourceApplication
       annotation:(id)annotation{
    return [[ZMacAuthZIAMUtil sharedUtil]handleURL:url sourceApplication:sourceApplication annotation:annotation];
}

+(void)revokeAccessToken:(ZMacAuthKitRevokeAccessTokenHandler)revoke {
    [ZMacAuth revokeAccessTokenForZUID:[ZMacAuth currentZUID] block:revoke];
}

+(void)revokeAccessTokenForZUID:(NSString *) zuid block:(ZMacAuthKitRevokeAccessTokenHandler)revoke{
    [[ZMacAuthZIAMUtil sharedUtil] removeAllScopesForZUID:zuid success:^{
        revoke(nil);
    } failure:^(NSError *error) {
        revoke(error);
    }];
}

+(ZMacAuthUser *)getCurrentUser{
    return [[ZMacAuthZIAMUtil sharedUtil] getCurrentUser];
}

+(void) setCurrentUserHavingZUID:(NSString *)userZuid{
   [[ZMacAuthZIAMUtil sharedUtil] setCurrentUser:userZuid];
}

+(NSMutableArray *)getAllUsers{
    return [[ZMacAuthZIAMUtil sharedUtil] getAllUsers];
}

+(NSMutableArray *)getAllUsersZUIDs{
    return [[ZMacAuthZIAMUtil sharedUtil] getAllUsersZUID];
}

+(ZMacAuthUser *)getZMacAuthUserHavingZUID:(NSString *)zuid{
    return [[ZMacAuthZIAMUtil sharedUtil] getZMacAuthUserHavingZUID:zuid];
}

+ (BOOL) isUserSignedIn{
    return [[ZMacAuthZIAMUtil sharedUtil] isUserSignedIn];
}

+(NSString *)getTransformedURLStringForURL:(NSString *)url {
    return [ZMacAuth getTransformedURLStringForURL:url zuid:[ZMacAuth currentZUID]];
}

+(NSString *)getTransformedURLStringForURL:(NSString *)url zuid:(NSString*) zuid {
    return [[ZMacAuthZIAMUtil sharedUtil] getTransformedURLStringForURL:url zuid:zuid];
}

+(void) donotFetchProfilePhotoDuringSignin{
    [ZMacAuthZIAMUtil sharedUtil].donotfetchphoto = YES;
}

+(NSDictionary *)getDCLInfoForCurrentUser{
    return [[ZMacAuthZIAMUtil sharedUtil] getDCLInfoForCurrentUser];
}

+(NSDictionary *)getDCLInfoForZuid: (NSString*) zuid {
    return [[ZMacAuthZIAMUtil sharedUtil] getDCLInfoForZuid:zuid];
}

+(void) pointToChinaSetup{
    [ZMacAuthZIAMUtil sharedUtil].ChinaSetup = YES;
}

+(void) cancelPointToChinaSetup{
    [ZMacAuthZIAMUtil sharedUtil].ChinaSetup = NO;
}

+(void)checkAndLogoutUserDuringInvalidOAuth:(ZMacAuthKitInvalidOAuthLogoutHandler)logoutHandler{
    [[ZMacAuthZIAMUtil sharedUtil] checkAndLogout:^(BOOL shouldLogout) {
        logoutHandler(shouldLogout);
    }];
}
+(void)checkAndLogoutUserDuringInvalidOAuth:(ZMacAuthKitInvalidOAuthLogoutHandler)logoutHandler zuid:(NSString*) zuid{
    [[ZMacAuthZIAMUtil sharedUtil] checkAndLogoutForZUID:zuid handler:^(BOOL shouldLogout) {
        logoutHandler(shouldLogout);
    }];
}

+(void)enhanceScopesInContentView:(NSView *) contentView enhanceHandler:(ZMacAuthKitScopeEnhancementHandler)enhanceHandler{
    [[ZMacAuthZIAMUtil sharedUtil] enhanceScopeInContentView:contentView WithSuccess:^(NSString *token) {
        enhanceHandler(token,nil);
    } andFailure:^(NSError *error) {
        enhanceHandler(nil,error);
    }];
}
+(void)enhanceScopesInContentView:(NSView *) contentView enhanceHandler:(ZMacAuthKitScopeEnhancementHandler)enhanceHandler zuid:(NSString*) zuid{
    [[ZMacAuthZIAMUtil sharedUtil] enhanceScopeInContentView:contentView ForZuid:zuid WithSuccess:^(NSString *token) {
        enhanceHandler(token,nil);
    } andFailure:^(NSError *error) {
        enhanceHandler(nil,error);
    }];
}

+(void)addSecondaryEmailIDInContentView:(NSView *) contentView WithCallback:(ZMacAuthAddEmailHandler)addEmailHandler{
    [[ZMacAuthZIAMUtil sharedUtil] addSecondaryEmailIDInContentView:contentView WithCallback:^(NSError *error) {
        addEmailHandler(error);
    }];
}

+(void)addSecondaryEmailIDInContentView:(NSView *) contentView ForZuid:(NSString *)zuid WithCallback:(ZMacAuthAddEmailHandler)addEmailHandler{
    [[ZMacAuthZIAMUtil sharedUtil] addSecondaryEmailIDInContentView:contentView ForZuid:zuid WithCallback:^(NSError *error) {
        addEmailHandler(error);
    }];
}

+(void)getOAuth2TokenUsingAuthToken:(NSString *)authToken
                             forApp:(NSString *)appName
                  havingAccountsURL:(NSString *)accountsBaseURL
                 authToOAuthHandler:(ZMacAuthKitAuthToOAuthHandler)authToOAuthBlock{
    [[ZMacAuthZIAMUtil sharedUtil]getOAuth2TokenUsingAuthToken:authToken forApp:appName havingAccountsURL:accountsBaseURL havingSuccess:^(NSString *token) {
        authToOAuthBlock(token,nil);
    } andFailure:^(NSError *error) {
        authToOAuthBlock(nil,error);
    }];
}
+(NSString*) currentZUID {
    return [[ZMacAuthZIAMUtil sharedUtil] getCurrentUserForApp];
}

+(void) startPreloginProgress:(void (^)(void)) callbackBlock {
    [ZMacAuthZIAMUtil sharedUtil]->showPreloginProgressBlock = callbackBlock;
}

+(void) endPreloginProgress:(void (^)(void)) callbackBlock {
    [ZMacAuthZIAMUtil sharedUtil]->endPreloginProgressBlock = callbackBlock;
}

+(void) startProgress:(void (^)(void)) callbackBlock {
    [ZMacAuthZIAMUtil sharedUtil]->showProgressBlock = callbackBlock;
}

+(void) endProgress:(void (^)(void)) callbackBlock {
    [ZMacAuthZIAMUtil sharedUtil]->endProgressBlock = callbackBlock;
}

+(void)donotSendScopesParam{
    [ZMacAuthZIAMUtil sharedUtil].donotSendScopesParam = YES;
    [ZMacAuthZIAMUtil sharedUtil]->Scopes = @"";
}

+(void) logger: (void (^)(NSString *)) logger {
    [ZMacAuthZIAMUtil sharedUtil]->logger = logger;
}

@end
