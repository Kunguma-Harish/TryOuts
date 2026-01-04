//
//  ZMacAuthZIAMUtil.m
//  SSO_Demo
//
//  Created by Kumareshwaran on 8/7/15.
//  Copyright © 2015 Zoho. All rights reserved.
//

#import "ZMacAuthZIAMUtil.h"
#include "ZMacAuthUtilConstants.h"
#include "ZMacAuthUser+Internal.h"
#include "ZMacAuthProfileData+Internal.h"
#import "ZMacAuthKeychainUtil.h"
#import "ZMacAuthTokenFetch.h"
#include "ZMacAuth_NSData+AES.h"
#include "ZMacAuthNSData+Base64.h"
#include "ZMacAuthErrorHandler.h"
#import "ZMacAuthHelpers.h"
#import "ZMacAuthKeyPairUtil.h"

@interface ZMacAuthZIAMUtil ()

@end

@implementation ZMacAuthZIAMUtil

+ (ZMacAuthZIAMUtil *)sharedUtil {
    static ZMacAuthZIAMUtil *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance initTokenFetch];
    });
    
    return sharedInstance;
}

-(BOOL)handleURL:url sourceApplication:sourceApplication annotation:annotation{
    NSString* queryString = [url query];
    
    NSMutableDictionary *queryStringDictionary = [[NSMutableDictionary alloc] init];
    NSArray *urlComponents = [queryString componentsSeparatedByString:@"&"];
    for (NSString *keyValuePair in urlComponents)
    {
        NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
        NSString *key = [[pairComponents firstObject] stringByRemovingPercentEncoding];
        NSString *value = [[pairComponents lastObject] stringByRemovingPercentEncoding];
        DLog(@"Key : %@------- Value:%@",key,value);
        [queryStringDictionary setObject:value forKey:key];
    }
    if([queryStringDictionary objectForKey:@"code"] || [queryStringDictionary objectForKey:@"error"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"sfsafariredirection" object:queryStringDictionary];
        return YES;
    }
    return NO;
}

- (void)setHavingAppExtensionWithAppGroup:(NSString *)appGroup{
    _ExtensionAppGroup = appGroup;
}

- (void) initExtensionWithClientID:(NSString*)clientID
                             Scope:(NSArray*)scopearray
                         URLScheme:(NSString*)URLScheme
                         BuildType:(ZMacAuthBuildType)buildType{
    
    ClientID = clientID;
    // Create a string to concatenate all scopes existing in the _scopes array.
    Scopes = @"";
    BOOL isProfileScopeGiven = NO;
    BOOL isContactsScopeGiven = NO;
    
    for (int i=0; i<[scopearray count]; i++) {
        if([[scopearray objectAtIndex:i] caseInsensitiveCompare:@"aaaserver.profile.READ"] == NSOrderedSame){
            isProfileScopeGiven = YES;
        }
        if([[scopearray objectAtIndex:i] caseInsensitiveCompare:@"zohocontacts.userphoto.READ"] == NSOrderedSame){
            isContactsScopeGiven = YES;
        }
        
        Scopes = [Scopes stringByAppendingString:[scopearray objectAtIndex:i]];
        
        // If the current scope is other than the last one, then add the "+" sign to the string to separate the scopes.
        if (i < [scopearray count] - 1) {
            Scopes = [Scopes stringByAppendingString:@","];
        }
    }
    if(!isProfileScopeGiven){
        if([Scopes isEqualToString:@""]){
            Scopes = [Scopes stringByAppendingString:@"aaaserver.profile.READ"];
        }else{
            Scopes = [Scopes stringByAppendingString:@",aaaserver.profile.READ"];
        }
        
    }
    if(!isContactsScopeGiven){
        Scopes = [Scopes stringByAppendingString:@",zohocontacts.userphoto.READ"];
    }
    if(![URLScheme hasSuffix:@"://"]){
        UrlScheme = [URLScheme stringByAppendingString:@"://"];
    }else{
        UrlScheme = URLScheme;
    }
    NSBundle *bundle = [NSBundle mainBundle];
    
    if ([[bundle infoDictionary] valueForKey:@"ZMacAuthKIT_MAIN_APP_BUNDLE_ID"]) {
        AppName = [[bundle infoDictionary] valueForKey:@"ZMacAuthKIT_MAIN_APP_BUNDLE_ID"];
    }else{
        AppName = [bundle bundleIdentifier];
    }
    [self initMode:buildType];
}

- (void) initWithClientID: (NSString*)clientID
                    Scope:(NSArray*)scopearray
                URLScheme:(NSString*)URLScheme
                BuildType:(ZMacAuthBuildType)buildType{
    [self initExtensionWithClientID:clientID Scope:scopearray URLScheme:URLScheme BuildType:buildType];
    
}

- (void) presentInitialViewControllerInContentView:(NSView *) contentView withSuccess:(requestSuccessBlock)success andFailure:(requestFailureBlock)failure{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self->finalSuccessBlock = success;
        self->finalFailureBlock = failure;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self->sfview = [[ZMacAuthLoginViewController alloc] init];
            self->sfview.success = success;
            self->sfview.failure = failure;
            
            [contentView addSubview:self->sfview.view];
            [self->sfview.view setTranslatesAutoresizingMaskIntoConstraints:NO];
            if (@available(macOS 10.10, *)) {
                [NSLayoutConstraint constraintWithItem:self->sfview.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeWidth multiplier:1 constant:0].active = YES;
            } else {
                // Fallback on earlier versions
            }
            if (@available(macOS 10.10, *)) {
                [NSLayoutConstraint constraintWithItem:self->sfview.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeHeight multiplier:1 constant:0].active = YES;
            } else {
                // Fallback on earlier versions
            }
        });
    });
}

- (void)getTokenForWMSHavingZUID:(NSString*)zuid success:(requestWMSSuccessBlock)successBlock failure:(requestFailureBlock)failureBlock{
    wmsCallBack = YES;
    [self getOauth2TokenForZUID:zuid success:^(NSString *token) {
        successBlock(token,self->expiresinMillis-wmsTimeCheckMargin);
        self->wmsCallBack = NO;
    } failure:^(NSError *error) {
        failureBlock(error);
        self->wmsCallBack = NO;
    }];
}

-(void) getOauth2TokenForZUID:(NSString*) zuid success:(requestSuccessBlock)successBlock failure:(requestFailureBlock)failureBlock {
    NSString *refresh_token = [self getRefreshTokenForZuid:zuid];
    DLog(@"Refresh Token Check ZMacAuthZIAMUtil: %@",refresh_token);
    
    if(refresh_token){
        //Get the CurrentTime!
        long millis = [[ZMacAuthZIAMUtil sharedUtil] getCurrentMilliSeconds];
        
        NSMutableDictionary* accessTokenDictionary = (NSMutableDictionary *) [self getAccessTokenDictForZuid:zuid];
        NSArray* tokenArray = [accessTokenDictionary objectForKey:Scopes];
        DLog(@"Keychain Dictionary objects test Token Final: %@",tokenArray[0]);
        NSString* timeStampString = tokenArray[1];

        long timeStamp = [timeStampString longLongValue];
        if(wmsCallBack){
            expiresinMillis = timeStamp - millis;
            millis = millis + wmsTimeCheckMargin;
        }else{
            expiresinMillis = timeStamp - millis;
            millis = millis + timecheckbuffer;
        }
            
        DLog(@"Current Time:%ld TimeStamp:%ld",millis,timeStamp);
            
        if(millis < timeStamp) {
            DLog(@"Time Check Success!!!");
            NSString* token = tokenArray[0];
            successBlock(token);
        }else{
            DLog(@"Time Check Failed!!!");
            [self processTokenFetchForZUID:zuid WithSuccess:successBlock andFailure:failureBlock];
        }
    }else{
        //No Access Token Found in Keychain...
        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]init];
        [userInfo setValue:@"There is no Access Token" forKey:NSLocalizedDescriptionKey];
        NSError *returnError = [NSError errorWithDomain:kZMacAuthErrorDomain code:k_ZMacAuthNoAccessToken userInfo:userInfo];
        failureBlock(returnError);
        return ;
    }
}

-(void)removeAllScopesForZUID:(NSString*) zuid success:(requestLogoutSuccessBlock)successBlock failure:(requestLogoutFailureBlock)failureBlock {

    NSString *refreshToken = [self getRefreshTokenForZuid:zuid];
    
    //URL
    NSString *accountsURL = [self getAccountURLForZuid:zuid];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",accountsURL,kZMacAuthRevoke_URL];
    
    //Add Parameters
    NSMutableDictionary* paramsAndHeaders = [[NSMutableDictionary alloc] init];
    [paramsAndHeaders setValue:[NSString stringWithFormat:@"%@",refreshToken] forKey:@"token"];
    
    //Add Headers
    NSMutableDictionary *headers = [[NSMutableDictionary alloc]init];
    [headers setValue:[self getUserAgentString] forKey:@"User-Agent"];
    [paramsAndHeaders setValue:headers forKey:ZMacAuth_HTTPHeaders];
    
    // Request....
    [[ZMacAuthNetworkManager sharedManager] sendPOSTRequestForURL: urlString
                                                       parameters: paramsAndHeaders
                                                     successBlock:^(NSDictionary *jsonDict, NSHTTPURLResponse *httpResponse) {
                                                         //Request success
                                                         [self clearDataForLogoutHavingZUID:zuid];
                                                         DLog(@"Logout Done for App:%@",self->AppName);
                                                         
                                                         successBlock();
                                                     } failureBlock:^(ZMacAuthInternalError errorType, NSError *error) {
                                                         //Request failed
                                                         [self handleRevokeError:errorType error:error failureBlock:failureBlock];
                                                         return;
                                                     }];
}

-(void)fetchUserInfoWithBlock:(requestFailureBlock)errorBlock {
    
    //URL
    NSString *urlString = [NSString stringWithFormat:@"%@%@",setAccountsServerURL,kZMacAuthFetchUserInfo_URL];
    
    //Add Parameters
    NSMutableDictionary *paramsAndHeaders = [[NSMutableDictionary alloc] init];
    
    //Add headers
    NSMutableDictionary *headers = [[NSMutableDictionary alloc] init ];
    [headers setValue:[NSString stringWithFormat:@"Zoho-oauthtoken %@",setAccessToken]
               forKey:@"Authorization"];
    [headers setValue:[self getUserAgentString] forKey:@"User-Agent"];
    
    [paramsAndHeaders setValue:headers forKey:ZMacAuth_HTTPHeaders];
    
    // Request....
    [[ZMacAuthNetworkManager sharedManager] sendGETRequestForURL: urlString
                                                      parameters: paramsAndHeaders
                                                    successBlock:^(NSDictionary *jsonDict, NSHTTPURLResponse *httpResponse) {
                                                        //Request success
                                                        self->setProfileInfoDict = jsonDict;
                                                        long ZUID_long = [[self->setProfileInfoDict objectForKey:@"ZUID"] longValue];
                                                        NSString *ZUID =[NSString stringWithFormat: @"%ld", ZUID_long];
                                                        
                                                        if(self->setBas64DCL_Meta_Data && ([self->setBas64DCL_Meta_Data length]>0)){
                                                           
                                                            self->ContactsUrl = [self transformURL:self->ContactsUrl AppName:self->AppName ZUID:ZUID Location:self->setLocation meta:self->setBas64DCL_Meta_Data];
                                                        }
                                                        if(self->_donotfetchphoto){
                                                            self->setProfileImageData = nil;
                                                            [self storeItemsInKeyChainOnSuccess];
                                                            errorBlock(nil);
                                                        }else{
                                                            
                                                            [self fetchProfilePhoto:errorBlock];
                                                        }
                                                        
                                                        
                                                    } failureBlock:^(ZMacAuthInternalError errorType, NSError *error) {
                                                        //Request failed
                                                        errorBlock(error);
                                                    }];
    
}

-(void)fetchProfilePhoto:(requestFailureBlock)errorBlock {
    //URL
    NSString *urlString = [NSString stringWithFormat:@"%@",ContactsUrl];
    
    //Add Parameters
    NSMutableDictionary *paramsAndHeaders = [[NSMutableDictionary alloc] init];
    
    //Add headers
    NSMutableDictionary *headers =[[NSMutableDictionary alloc] init];
    [headers setValue:[NSString stringWithFormat:@"Zoho-oauthtoken %@",setAccessToken] forKey:@"Authorization"];
    [headers setValue:[self getUserAgentString] forKey:@"User-Agent"];
    
    [paramsAndHeaders setValue:headers forKey:ZMacAuth_HTTPHeaders];
    
    // Request....
    [[ZMacAuthNetworkManager sharedManager] sendGETRequestForURL: urlString
                                                      parameters: paramsAndHeaders
                                            successBlockWithData:^(NSData *data, NSHTTPURLResponse *httpResponse) {
                                                //Request success
                                                
                                                self->setProfileImageData = data;
                                                [self storeItemsInKeyChainOnSuccess];
                                                errorBlock(nil);
                                            } failureBlock:^(ZMacAuthInternalError errorType, NSError *error) {
                                                //Request failed
                                                self->setProfileImageData = nil;
                                                [self storeItemsInKeyChainOnSuccess];
                                                errorBlock(nil);
                                            }];
}

-(NSString *)getTransformedURLStringForURL:(NSString *)url zuid:(NSString*) zuid{
    return [self transformURL:url AppName:AppName zuid:zuid];
}

-(ZMacAuthUser *)getZMacAuthUserHavingZUID:(NSString *)zuid{
    
    NSArray *userDetails = [self getUserDetailsForZuid:zuid];
    if(userDetails){
        ZMacAuthProfileData *profileData = [[ZMacAuthProfileData alloc]init];
        NSData *returnProfilePhotoData;
        NSData *profileImageData = [userDetails objectAtIndex:2];
        if(![profileImageData isEqual:[NSNull null]] && [[userDetails objectAtIndex:2] isKindOfClass:[NSData class]]){
            returnProfilePhotoData = profileImageData;
        }
        [profileData initWithEmailid:[userDetails objectAtIndex:1]
                                name:[userDetails objectAtIndex:0]
                         displayName:[userDetails objectAtIndex:0]
                            hasImage:YES
                    profileImageData:returnProfilePhotoData];
        
        ZMacAuthUser *ZUser = [[ZMacAuthUser alloc]init];
        //        NSString *zuid = [self getCurrentUserForApp:AppName];
        
        NSArray *scopesArray = [[NSArray alloc]init];
        scopesArray = [Scopes componentsSeparatedByString:@","];
        
        NSString *accountsURL = [self getAccountURLForZuid:zuid];
        NSString *location = [self getDCLLocationForZuid:zuid];
        
        [ZUser initWithZUID:zuid Profile:profileData accessibleScopes:scopesArray accountsUrl:accountsURL location:location];
        return ZUser;
        
    }
    return nil;
}

-(ZMacAuthUser *)getCurrentUser{
    return [self getZMacAuthUserHavingZUID:[self getCurrentUserForApp]];
}

-(NSMutableArray *)getAllUsersZUID{
    return [self getZUIDs];
}

-(NSMutableArray *)getAllUsers{
    NSMutableArray *zuids = [self getAllUsersZUID];
    if(!zuids){
        return nil;
    }
    NSMutableArray *ZMacAuthUsers = [[NSMutableArray alloc]init];
    for (id zuid in zuids){
        ZMacAuthUser *user = [self getZMacAuthUserHavingZUID:zuid];
        if(user){
            [ZMacAuthUsers addObject:user];
        }
    }
    return ZMacAuthUsers;
}

//Scope Enhancement
-(void)enhanceScopeInContentView:(NSView *) contentView WithSuccess:(ZMacAuthKitScopeEnhancementSuccessHandler)success
                    andFailure:(ZMacAuthKitScopeEnhancementFailureHandler)failure{
    [self enhanceScopeInContentView:contentView ForZuid:[self getCurrentUserForApp] WithSuccess:success andFailure:failure];
}
-(void)enhanceScopeInContentView:(NSView *) contentView ForZuid:(NSString *)zuid WithSuccess:(ZMacAuthKitScopeEnhancementSuccessHandler)success
                andFailure:(ZMacAuthKitScopeEnhancementFailureHandler)failure{
    
    finalScopeEnhancementSuccessBlock = success;
    finalScopeEnhancementFailureBlock = failure;
    User_ZUID = zuid;
    [self getOauth2TokenForZUID:zuid success:^(NSString *token) {
            NSString* client_secret = [self getClientSecretForZuid:zuid];
            NSString *encoded_gt_sec=CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)client_secret, NULL, (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ", CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
            
            //URL
            NSString *urlString = [NSString stringWithFormat:@"%@%@",[self getAccountURLForZuid:zuid],kZMacAuthScopeEnhancement_URL];
            
            //Add Parameters
            NSMutableDictionary *paramsAndHeaders = [[NSMutableDictionary alloc] init];
            [paramsAndHeaders setValue:@"enhancement_scope" forKey:@"grant_type"];
            [paramsAndHeaders setValue:[NSString stringWithFormat:@"%@",self->ClientID] forKey:@"client_id"];
            [paramsAndHeaders setValue:[NSString stringWithFormat:@"%@",encoded_gt_sec] forKey:@"client_secret"];
            if (![ZMacAuthZIAMUtil sharedUtil].donotSendScopesParam) {
                [paramsAndHeaders setValue:[NSString stringWithFormat:@"%@",self->Scopes] forKey:@"scope"];
            }
            
            
            //Add headers
            NSMutableDictionary *headers = [[NSMutableDictionary alloc]init];
            [headers setValue:[NSString stringWithFormat:@"Zoho-oauthtoken %@",token] forKey:@"Authorization"];
            [headers setValue:[self getUserAgentString] forKey:@"User-Agent"];
        
            [paramsAndHeaders setValue:headers forKey:ZMacAuth_HTTPHeaders];
            
            // Request....
            [[ZMacAuthNetworkManager sharedManager] sendPOSTRequestForURL: urlString
                                                          parameters: paramsAndHeaders
                                                        successBlock:^(NSDictionary *jsonDict, NSHTTPURLResponse *httpResponse) {
                                                            //Request success
                                                            if([[jsonDict objectForKey:@"status"] isEqualToString:@"success"]){
                                                                DLog(@"Success Response ");
                                                                NSString *scopeEnhancementAccessToken = [jsonDict objectForKey:@"scope_token"];
                                                                if ([ZMacAuthZIAMUtil sharedUtil].donotSendScopesParam) {
                                                                    self->ScopeEnhancementUrl = [NSString stringWithFormat:@"%@%@?client_id=%@&redirect_uri=%@&state=Test&response_type=code&access_type=offline&scope_token=%@",[self getAccountURLForZuid:zuid],kZMacAuthAddScope_URL,self->ClientID,self->UrlScheme,scopeEnhancementAccessToken];
                                                                }else{
                                                                    self->ScopeEnhancementUrl = [NSString stringWithFormat:@"%@%@?client_id=%@&scope=%@&redirect_uri=%@&state=Test&response_type=code&access_type=offline&scope_token=%@",[self getAccountURLForZuid:zuid],kZMacAuthAddScope_URL,self->ClientID,self->Scopes,self->UrlScheme,scopeEnhancementAccessToken];
                                                                }

                                                                //present SFSafari to show scope enhancement
                                                                self->finalSuccessBlock = success;
                                                                self->finalFailureBlock = failure;
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    self->sfview = [[ZMacAuthLoginViewController alloc] init];
                                                                    self->sfview.success = success;
                                                                    self->sfview.failure = failure;
                                                                    
                                                                    [contentView addSubview:self->sfview.view];
                                                                    [self->sfview.view setTranslatesAutoresizingMaskIntoConstraints:NO];
                                                                    if (@available(macOS 10.10, *)) {
                                                                        [NSLayoutConstraint constraintWithItem:self->sfview.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeWidth multiplier:1 constant:0].active = YES;
                                                                    } else {
                                                                        // Fallback on earlier versions
                                                                    }
                                                                    if (@available(macOS 10.10, *)) {
                                                                        [NSLayoutConstraint constraintWithItem:self->sfview.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeHeight multiplier:1 constant:0].active = YES;
                                                                    } else {
                                                                        // Fallback on earlier versions
                                                                    }
                                                                });
                                                            }else{
                                                                //failure handling...
                                                                DLog(@"Status: Failure Response");
                                                                NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]init];
                                                                [userInfo setValue:@"Get Extra Scope Server Error Occured" forKey:NSLocalizedDescriptionKey];
                                                                NSError *returnError = [NSError errorWithDomain:kZMacAuthErrorDomain code:k_ZMacAuthScopeEnhancementServerError userInfo:userInfo];
                                                                failure(returnError);
                                                            }
                                                            
                                                        } failureBlock:^(ZMacAuthInternalError errorType, NSError *error) {
                                                            //Request failed
                                                            
                                                            DLog(@"Failure Response");
                                                            [self handleScopeEnhancementError:errorType error:error];
                                                            
                                                            
                                                        }];
    } failure:^(NSError *error) {
        failure(error);
    }];
}

//Add Secondary Email
-(void)addSecondaryEmailIDInContentView:(NSView *) contentView WithCallback:(ZMacAuthAddEmailHandler)failure{
    [self addSecondaryEmailIDInContentView:contentView ForZuid:[self getCurrentUserForApp] WithCallback:failure];
}
-(void)addSecondaryEmailIDInContentView:(NSView *) contentView ForZuid:(NSString *)zuid WithCallback:(ZMacAuthAddEmailHandler)failure{
    
    finalAddEmailIDBlock = failure;
    User_ZUID = zuid;
    [self getOauth2TokenForZUID:zuid success:^(NSString *token) {
        NSMutableDictionary* paramsAndHeaders = [[NSMutableDictionary alloc] init];
        NSMutableDictionary* redirectURL = [[NSMutableDictionary alloc] init];
        [redirectURL setValue:self->UrlScheme forKey:@"redirect_uri"];
        [paramsAndHeaders setValue:redirectURL forKey:@"token"];
        
        //Add headers
        NSMutableDictionary *headers = [[NSMutableDictionary alloc]init];
        [headers setValue:[NSString stringWithFormat:@"Zoho-oauthtoken %@",token] forKey:@"Authorization"];
        [headers setValue:[self getUserAgentString] forKey:@"User-Agent"];

        [paramsAndHeaders setValue:headers forKey:ZMacAuth_HTTPHeaders];
        //URL
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[self getAccountURLForZuid:zuid],kZMacAuthAddSecondaryEmailToken_URL];
        
            // Request....
            [[ZMacAuthNetworkManager sharedManager] sendJSONPOSTRequestForURL: urlString
                                                          parameters: paramsAndHeaders
                                                        successBlock:^(NSDictionary *jsonDict, NSHTTPURLResponse *httpResponse) {
                                                            //Request success
                                                            int status_code = [[jsonDict objectForKey:@"status_code"]intValue];
                                                            if(status_code == 201 ){
                                                                DLog(@"Success Response ");
                                                                self->AddSecondaryEmailURL = [NSString stringWithFormat:@"%@%@?temp_token=%@",[self getAccountURLForZuid:zuid],kZMacAuthAddSecondaryEmail_URL,[jsonDict objectForKey:@"message"]];
                                                                    
                                                                //present SFSafari to show Add Email
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    self->sfview = [[ZMacAuthLoginViewController alloc] init];
                                                                    
                                                                    [contentView addSubview:self->sfview.view];
                                                                    [self->sfview.view setTranslatesAutoresizingMaskIntoConstraints:NO];
                                                                    if (@available(macOS 10.10, *)) {
                                                                        [NSLayoutConstraint constraintWithItem:self->sfview.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeWidth multiplier:1 constant:0].active = YES;
                                                                    } else {
                                                                        // Fallback on earlier versions
                                                                    }
                                                                    if (@available(macOS 10.10, *)) {
                                                                        [NSLayoutConstraint constraintWithItem:self->sfview.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeHeight multiplier:1 constant:0].active = YES;
                                                                    } else {
                                                                        // Fallback on earlier versions
                                                                    }
                                                                });
                                                            }else{
                                                                //failure handling...
                                                                DLog(@"Status: Failure Response");
                                                                NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]init];
                                                                [userInfo setValue:@"Get Extra Scope Server Error Occured" forKey:NSLocalizedDescriptionKey];
                                                                NSError *returnError = [NSError errorWithDomain:kZMacAuthErrorDomain code:k_ZMacAuthScopeEnhancementServerError userInfo:userInfo];
                                                                failure(returnError);
                                                            }
                                                            
                                                        } failureBlock:^(ZMacAuthInternalError errorType, NSError *error) {
                                                            //Request failed
                                                            
                                                            DLog(@"Failure Response");
                                                            [self handleScopeEnhancementError:errorType error:error];
                                                            
                                                            
                                                        }];
    } failure:^(NSError *error) {
        failure(error);
    }];
}

//AuthToOAuth
-(void)getOAuth2TokenUsingAuthToken:(NSString *)authtoken forApp:(NSString *)appName havingAccountsURL:(NSString *)accountsBaseURL havingSuccess:(requestSuccessBlock)success
                         andFailure:(requestFailureBlock)failure
{
    ZMacAuthKeyPairUtil *keygen= [[ZMacAuthKeyPairUtil alloc] init];
    [keygen setIdentifierForPublicKey:@"com.zoho.publicKey"
                           privateKey:@"com.zoho.privateKey"
                      serverPublicKey:@"com.zoho.serverPublicKey"];
    [keygen generateKeyPairRSA];
    
    //PublicKey to be Stored in IAM Server!
    NSString *oauthpub = [keygen getPublicKeyAsBase64ForJavaServer];
    oauthpub = [ZMacAuthZIAMUtil getEncodedStringForString:oauthpub];
    
    long long timePassed_ms = ([[NSDate date] timeIntervalSince1970] * 1000);
    
    NSString* rt_cook_string = [NSString stringWithFormat:@"%@__i__%@__i__%lld__i__%@__i__%@__i__%@__i__%@",[self currentModel],self->AppName,timePassed_ms,[[NSHost currentHost] localizedName],self->ClientID,appName,authtoken];
    
    NSData *data = [rt_cook_string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [data AES128EncryptedDataWithKey:SHARED_SECRET];
    NSString *encryptedDataString = [encryptedData base64EncodedStringWithOptions:0];
    encryptedDataString = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)encryptedDataString, NULL, (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ", CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",accountsBaseURL,kZMacAuthAuthToOAuth_URL];
    
    //Add Parameters
    NSMutableDictionary *paramsAndHeaders = [[NSMutableDictionary alloc] init];
    [paramsAndHeaders setValue:encryptedDataString forKey:@"enc_token"];
    [paramsAndHeaders setValue:self->ClientID forKey:@"client_id"];
    [paramsAndHeaders setValue:oauthpub forKey:@"ss_id"];
    //Add headers
    NSMutableDictionary *headers = [[NSMutableDictionary alloc]init];
    [headers setValue:[self getUserAgentString] forKey:@"User-Agent"];
    [paramsAndHeaders setValue:headers forKey:ZMacAuth_HTTPHeaders];
    // Request....
    [[ZMacAuthNetworkManager sharedManager] sendPOSTRequestForURL: urlString
                                                       parameters: paramsAndHeaders
                                                     successBlock:^(NSDictionary *jsonDict, NSHTTPURLResponse *httpResponse) {
        
        //Request success
        //Header for DCL Handling
        if ([httpResponse respondsToSelector:@selector(allHeaderFields)]) {
            NSDictionary *dictionary = [httpResponse allHeaderFields];
            if([dictionary objectForKey:@"X-Location-Meta"]){
                NSString *base64EncodedString = [dictionary objectForKey:@"X-Location-Meta"];
                NSData *Bas64DCL_Meta_Data = [NSData dataFromBase64String:base64EncodedString];
                [ZMacAuthZIAMUtil sharedUtil]->setBas64DCL_Meta_Data=Bas64DCL_Meta_Data;
            }
        }
        //Request success
        if([[jsonDict objectForKey:@"status"] isEqualToString:@"success"]){
            
            self->setAccountsServerURL = accountsBaseURL;
            self->setAccessToken = [jsonDict objectForKey:@"access_token"];
            self->setExpiresIn = [jsonDict objectForKey:@"expires_in"];
            self->setLocation = [jsonDict objectForKey:@"location"];
            self->setRefreshToken = [jsonDict objectForKey:@"rt_token"];
            
            
            NSString *encrypted_gt_sec   =   [jsonDict objectForKey:@"gt_sec"];
            //Get the KeyPair!
            NSData *granttokenData = [NSData dataFromBase64String:encrypted_gt_sec];
            
            //Decrypt using private key
            self->setClientSecret= [keygen decryptUsingPrivateKeyWithData:granttokenData];
            //[self decrypt:encrypted_gt_sec completionHandler:^(NSString *value) {
            
            
            [self fetchUserInfoWithBlock:^(NSError *error) {
                if(error == nil){
                    success([jsonDict objectForKey:@"access_token"]);
                }else{
                    failure(error);
                }
            }];
            //}];
        }else{
            //failure handling...
            DLog(@"Status: Failure Response");
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]init];
            [userInfo setValue:@"Get OAuth from AuthToken Server Error Occured" forKey:NSLocalizedDescriptionKey];
            NSError *returnError = [NSError errorWithDomain:kZMacAuthErrorDomain code:k_ZMacAuthAuthToOAuthServerError userInfo:userInfo];
            failure(returnError);
        }
    } failureBlock:^(ZMacAuthInternalError errorType, NSError* error) {
        //Request failed
        DLog(@"Failure Response");
        [self handleAuthToOAuthError:errorType error:error failureBlock:failure];
    }];
}

-(void) dismissLoginController {
    [self->sfview.view removeFromSuperview];
    self->sfview = nil;
}

-(void)checkAndLogout:(requestCheckLogoutBlock)logoutBlock{
    [self checkAndLogoutForZUID:[self getCurrentUserForApp] handler:logoutBlock];
}
-(void)checkAndLogoutForZUID:(NSString *)zuid handler:(requestCheckLogoutBlock)logoutBlock{
    
    [self getForceFetchOAuthTokenForZUID:zuid success:^(NSString *token) {
        logoutBlock(NO);
    } andFailure:^(NSError *error) {
        if ([error code]== k_ZMacAuthTokenFetchError && [[error localizedDescription] isEqualToString:@"invalid_mobile_code"]) {
            [self clearDataForLogoutHavingZUID:zuid];
            logoutBlock(YES);
        }else{
            logoutBlock(NO);
        }
    }];
}
-(void)getForceFetchOAuthTokenForZUID:(NSString *)zuid success:(requestSuccessBlock)success andFailure:(requestFailureBlock)failure{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self processTokenFetchForZUID:zuid WithSuccess:success andFailure:failure];
    });
}

+(NSString *)getEncodedStringForString:(NSString *)str {
    
    //Note have to change encoding format
    NSCharacterSet * queryKVSet = [NSCharacterSet
                                   characterSetWithCharactersInString:@"!*'\"();:@&=+$,/?%#[]% "
                                   ].invertedSet;
    NSString *encoded_str = [str stringByAddingPercentEncodingWithAllowedCharacters:queryKVSet];
    //NSString *encoded_str=CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)str, NULL, (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ", CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
    return encoded_str;
}


+(void) log:(NSString *) message {
    if([ZMacAuthZIAMUtil sharedUtil]->logger != nil) {
        [ZMacAuthZIAMUtil sharedUtil]->logger(message);
    }
}
@end
