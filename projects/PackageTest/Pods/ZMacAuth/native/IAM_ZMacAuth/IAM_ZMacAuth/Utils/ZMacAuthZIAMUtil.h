//
//  ZMacAuthZIAMUtil.h
//  SSO_Demo
//
//  Created by Kumareshwaran on 8/7/15.
//  Copyright © 2015 Zoho. All rights reserved.
//

#include "ZMacAuthConstants.h"
#include <Foundation/Foundation.h>
#include <AppKit/AppKit.h>
#import "ZMacAuthEnums.h"
#import "ZMacAuthUser.h"
#import "ZMacAuthRequestBlocks+Internal.h"
#include "ZMacAuthNetworkManager.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "ZMacAuthLoginViewController.h"

typedef void (^requestSuccessBlock)(NSString *token);

typedef void (^requestFailureBlock)(NSError *error);

typedef void (^requestLogoutSuccessBlock)(void);
typedef void (^requestLogoutFailureBlock)(NSError *error);

static const long wmsTimeCheckMargin = 420000 ;
static const long timecheckbuffer = 60000;


@class WKWebView;

API_AVAILABLE(macos(10.10))
@interface ZMacAuthZIAMUtil :NSObject
{
@public
    NSString* Scopes;
    NSString* AppName;
    NSString* BaseUrl;
    NSString *ContactsUrl;
    NSString* ClientID;
    NSString* ClientSecret;
    NSString *UrlScheme;
    NSView *contentView;
    requestSuccessBlock finalSuccessBlock;
    requestFailureBlock finalFailureBlock;
    
    ZMacAuthKitScopeEnhancementSuccessHandler finalScopeEnhancementSuccessBlock;
    ZMacAuthKitScopeEnhancementFailureHandler finalScopeEnhancementFailureBlock;
    
    ZMacAuthAddEmailHandler finalAddEmailIDBlock;
    
    void (^logger)(NSString *log);
    
    NSString *User_ZUID;
    
    NSString *UnconfirmedUserURL;
    
    BOOL wmsCallBack;
    long expiresinMillis;
    
    NSData *setProfileImageData;
    NSDictionary *setProfileInfoDict;
    NSString *setClientSecret;
    NSString *setAccessToken;
    NSString *setExpiresIn;
    NSString *setRefreshToken;
    NSString *setAccountsServerURL;
    NSString *setLocation;
    NSData *setBas64DCL_Meta_Data;
    
    NSString *UrlParams;
    NSString *ScopeEnhancementUrl;
    NSString *AddSecondaryEmailURL;
    NSString *SignUpUrl;
    void (^showPreloginProgressBlock)(void);
    void (^endPreloginProgressBlock)(void);
    void (^showProgressBlock)(void);
    void (^endProgressBlock)(void);
    
    NSMutableDictionary *stackBlocksDictionary;
    dispatch_queue_t serialDispatchQueue;
    
    JSContext *context;
    ZMacAuthLoginViewController *sfview;
    
    NSDictionary *cachedFrequentlyUsedItemsDict;
}

@property BOOL donotfetchphoto;
@property BOOL donotSendScopesParam;
@property NSString *ExtensionAppGroup;
@property NSArray *SharedTargetPaths;
@property NSString *KeychainService;
@property BOOL ChinaSetup;

+ (ZMacAuthZIAMUtil *)sharedUtil;
-(BOOL)handleURL:url sourceApplication:sourceApplication annotation:annotation;


- (void) initWithClientID: (NSString*)clientID
                    Scope:(NSArray*)scopearray
                URLScheme:(NSString*)URLScheme
                BuildType:(ZMacAuthBuildType)buildType;


- (void) initExtensionWithClientID:(NSString*)clientID
                             Scope:(NSArray*)scopearray
                         URLScheme:(NSString*)URLScheme
                         BuildType:(ZMacAuthBuildType)buildType;

- (void)setHavingAppExtensionWithAppGroup:(NSString *)appGroup;


-(void)getOauth2TokenForZUID:(NSString*) zuid success:(requestSuccessBlock)successBlock failure:(requestFailureBlock)failureBlock;

- (void)getTokenForWMSHavingZUID:(NSString*)zuid success:(requestWMSSuccessBlock)successBlock failure:(requestFailureBlock)failureBlock;

- (void) presentInitialViewControllerInContentView:(NSView *) contentView withSuccess:(requestSuccessBlock)success andFailure:(requestFailureBlock)failure;

-(void)removeAllScopesForZUID:(NSString*) zuid success:(requestLogoutSuccessBlock)successBlock failure:(requestLogoutFailureBlock)failureBlock;

-(ZMacAuthUser *)getCurrentUser;

-(NSString *)getTransformedURLStringForURL:(NSString *)url zuid:(NSString*) zuid;

-(NSMutableArray *)getAllUsers;
-(NSMutableArray *)getAllUsersZUID;
-(ZMacAuthUser *)getZMacAuthUserHavingZUID:(NSString *)zuid;

-(void)enhanceScopeInContentView:(NSView *) contentView WithSuccess:(ZMacAuthKitScopeEnhancementSuccessHandler)success
                    andFailure:(ZMacAuthKitScopeEnhancementFailureHandler)failure;
-(void)enhanceScopeInContentView:(NSView *) contentView ForZuid:(NSString *)zuid WithSuccess:(ZMacAuthKitScopeEnhancementSuccessHandler)success
                andFailure:(ZMacAuthKitScopeEnhancementFailureHandler)failure;

-(void)addSecondaryEmailIDInContentView:(NSView *) contentView WithCallback:(ZMacAuthAddEmailHandler)failure;
-(void)addSecondaryEmailIDInContentView:(NSView *) contentView ForZuid:(NSString *)zuid WithCallback:(ZMacAuthAddEmailHandler)failure;

-(void)getOAuth2TokenUsingAuthToken:(NSString *)authtoken forApp:(NSString *)appName havingAccountsURL:(NSString *)accountsBaseURL havingSuccess:(requestSuccessBlock)success
                         andFailure:(requestFailureBlock)failure;
-(void)checkAndLogout:(requestCheckLogoutBlock)logoutBlock;
-(void)checkAndLogoutForZUID:(NSString *)zuid handler:(requestCheckLogoutBlock)logoutBlock;

//Internal
-(void)getForceFetchOAuthTokenForZUID:(NSString *)zuid success:(requestSuccessBlock)success andFailure:(requestFailureBlock)failure;
-(void) dismissLoginController;
-(void)fetchUserInfoWithBlock:(requestFailureBlock _Nonnull )errorBlock;
+(void) log:(NSString *_Nullable) message;
+(NSString *_Nonnull)getEncodedStringForString:(NSString *_Nonnull)str;

@end
