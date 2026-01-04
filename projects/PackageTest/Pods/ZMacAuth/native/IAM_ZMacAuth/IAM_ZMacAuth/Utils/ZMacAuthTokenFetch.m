//
//  ZMacAuthTokenFetch.m
//  Pods-OAuthTesting
//
//  Created by Kumareshwaran on 29/06/18.
//

#import "ZMacAuthTokenFetch.h"
#include "ZMacAuthUtilConstants.h"
#import "ZMacAuthKeychainUtil.h"
#import "ZMacAuthHelpers.h"
#import "ZMacAuthErrorHandler.h"

@implementation ZMacAuthZIAMUtil(ZMacAuthTokenFetch)
- (void)initTokenFetch {
    serialDispatchQueue = dispatch_queue_create("com.zoho.ssokit.tokenfetch", DISPATCH_QUEUE_SERIAL);
}

-(void)processTokenFetchForZUID:(NSString *)zuid WithSuccess:(requestSuccessBlock)success andFailure:(requestFailureBlock)failure{
    
    dispatch_async(serialDispatchQueue, ^{
        NSString *successKey = [NSString stringWithFormat:@"successblocks_%@",zuid];
        NSString *failureKey = [NSString stringWithFormat:@"failureblocks_%@",zuid];
        NSString *isLoadingKey = [NSString stringWithFormat:@"isloading_%@",zuid];

        
        [self addSuccessInStackBlockDict:success forKey:successKey];
        [self addFailureInStackBlockDict:failure forKey:failureKey];
        
        
        if(self->stackBlocksDictionary && [self->stackBlocksDictionary objectForKey:isLoadingKey]) {
            return;
        }
        
        [self->stackBlocksDictionary setObject:@"yes" forKey:isLoadingKey];
        [self fetchAccessTokenFromServerForZUID:zuid success:^(NSString *token) {
            [self processSuccessWithAccessToken:token havingSuccessKey:successKey andFailureKey:failureKey];
            [self->stackBlocksDictionary removeObjectForKey:isLoadingKey];
        } failure:^(NSError *error) {
            [self processFailureWithError:error havingSuccessKey:successKey andFailureKey:failureKey];
            [self->stackBlocksDictionary removeObjectForKey:isLoadingKey];
        }];
    });
    
}

-(void)addSuccessInStackBlockDict:(requestSuccessBlock)success forKey:(NSString *)key{
    dispatch_async(self->serialDispatchQueue, ^{
        if(!self->stackBlocksDictionary){
            self->stackBlocksDictionary = [[NSMutableDictionary alloc] init];
        }
        NSMutableArray *successBlocks = [self->stackBlocksDictionary objectForKey:key];
        if(successBlocks){
            [successBlocks addObject:success];
            [self->stackBlocksDictionary setObject:successBlocks forKey:key];
        }else{
            NSMutableArray *successBlocks = [[NSMutableArray alloc]init];
            [successBlocks addObject:success];
            [self->stackBlocksDictionary setObject:successBlocks forKey:key];
        }
    });
}

-(void)addFailureInStackBlockDict:(requestFailureBlock)failure forKey:(NSString *)key{
    dispatch_async(self->serialDispatchQueue, ^{
        if(!self->stackBlocksDictionary){
            self->stackBlocksDictionary = [[NSMutableDictionary alloc] init];
        }
        NSMutableArray *failureBlocks = [self->stackBlocksDictionary objectForKey:key];
        if(failureBlocks){
            [failureBlocks addObject:failure];
            [self->stackBlocksDictionary setObject:failureBlocks forKey:key];
        }else{
            NSMutableArray *failureBlocks = [[NSMutableArray alloc]init];
            [failureBlocks addObject:failure];
            [self->stackBlocksDictionary setObject:failureBlocks forKey:key];
        }
    });
}

-(void)processSuccessWithAccessToken:(NSString *)access_token havingSuccessKey:(NSString *)successKey andFailureKey:(NSString *)failureKey{
    dispatch_async(self->serialDispatchQueue, ^{
        
        NSMutableArray *successBlocks = [self->stackBlocksDictionary objectForKey:successKey];
        for (requestSuccessBlock successBlock in successBlocks) {
            successBlock(access_token);
        }
        [self->stackBlocksDictionary removeObjectForKey:successKey];
        [self->stackBlocksDictionary removeObjectForKey:failureKey];
    });
}

-(void)processFailureWithError:(NSError *)error havingSuccessKey:(NSString *)successKey andFailureKey:(NSString *)failureKey{
    dispatch_async(self->serialDispatchQueue, ^{
        
        NSMutableArray *failureBlocks = [self->stackBlocksDictionary objectForKey:failureKey];
        for (requestFailureBlock failureBlock in failureBlocks) {
            failureBlock(error);
        }
        [self->stackBlocksDictionary removeObjectForKey:successKey];
        [self->stackBlocksDictionary removeObjectForKey:failureKey];
    });
}

-(void)fetchAccessTokenFromServerForZUID:(NSString *) zuid  success:(requestSuccessBlock)success failure:(requestFailureBlock)failure{
    
        NSString* client_secret = [[ZMacAuthZIAMUtil sharedUtil] getClientSecretForZuid:zuid];
        
        NSString *encoded_gt_sec=CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)client_secret, NULL, (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ", CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
    
        NSString* refresh_token = [[ZMacAuthZIAMUtil sharedUtil] getRefreshTokenForZuid:zuid];
        
        
        //URL
        NSString *accountsURL = [[ZMacAuthZIAMUtil sharedUtil] getAccountURLForZuid:zuid];
        NSString *urlString = [NSString stringWithFormat:@"%@%@",accountsURL,kZMacAuthFetchToken_URL];
        
        //Add Parameters
        NSMutableDictionary *paramsAndHeaders = [[NSMutableDictionary alloc] init];
        [paramsAndHeaders setValue:@"refresh_token" forKey:@"grant_type"];
        [paramsAndHeaders setValue:[NSString stringWithFormat:@"%@",ClientID] forKey:@"client_id"];
        [paramsAndHeaders setValue:[NSString stringWithFormat:@"%@",encoded_gt_sec] forKey:@"client_secret"];
        if (![ZMacAuthZIAMUtil sharedUtil].donotSendScopesParam) {
            [paramsAndHeaders setValue:[NSString stringWithFormat:@"%@",Scopes] forKey:@"scope"];
        }
        [paramsAndHeaders setValue:[NSString stringWithFormat:@"%@",refresh_token] forKey:@"refresh_token"];
        
        //Add headers
        NSMutableDictionary *headers = [[NSMutableDictionary alloc]init];
        [headers setValue:[self getUserAgentString] forKey:@"User-Agent"];
        [paramsAndHeaders setValue:headers forKey:ZMacAuth_HTTPHeaders];
        
        // Request....
        [[ZMacAuthNetworkManager sharedManager] sendPOSTRequestForURL: urlString
                                                           parameters: paramsAndHeaders
                                                         successBlock:^(NSDictionary *jsonDict, NSHTTPURLResponse *httpResponse) {
                                                             //Give the Access token when asked!
                                                             NSString* access_token = [jsonDict objectForKey:@"access_token"];
                                                             NSString* expires_in = [jsonDict objectForKey:@"expires_in"];
                                                             
                                                             DLog(@"AccessToken: %@ Expires in : %@",access_token,expires_in);
                                                             
                                                             if(access_token!=nil){
                                                                 
                                                                 long millis = [[ZMacAuthZIAMUtil sharedUtil] getCurrentMilliSeconds];
                                                                 long expiresIn = [expires_in longLongValue];
                                                                 long timeStampMillis = millis+expiresIn;
                                                                 NSString* timeStamp = [NSString stringWithFormat:@"%ld",timeStampMillis];
                                                                 DLog(@"TIME Stamp : %@",timeStamp);
                                                                 
                                                                 
                                                                 NSMutableDictionary* accessTokenDictionary = (NSMutableDictionary *) [self getAccessTokenDictForZuid:zuid];
                                                                 
                                                                 NSArray *accessTokenArray = @[access_token, timeStamp];
                                                                 [accessTokenDictionary setObject:accessTokenArray forKey:self->Scopes];
                                                                 DLog(@"AccessToken Refreshed for Scope: %@",self->Scopes);
                                                                 DLog(@"Access Token Array: %@",accessTokenArray)
                                                                 DLog(@"AccessToken Dict: %@",accessTokenDictionary)
                                                                 [self setAccessTokenDict:accessTokenDictionary forZuid:zuid];
                                                                 success(access_token);
                                                                 return ;
                                                             }else{
                                                                 NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]init];
                                                                 [userInfo setValue:@"Oops AccessToken Fetch Nil" forKey:NSLocalizedDescriptionKey];
                                                                 NSError *returnError = [NSError errorWithDomain:kZMacAuthErrorDomain code:k_ZMacAuthTokenFetchNil userInfo:userInfo];
                                                                 
                                                                 failure(returnError);
                                                                 return ;
                                                             }
                                                             
                                                         } failureBlock:^(ZMacAuthInternalError errorType, NSError* error) {
                                                             //Request failed
                                                             NSDictionary *responseDict = error.userInfo;
                                                             NSString* errorMessage = [responseDict valueForKey:@"error"];
                                                             if (errorType == ZMacAuth_ERR_SERVER_ERROR && [errorMessage isEqualToString:@"invalid_mobile_code"]) {
                                                                 [[ZMacAuthZIAMUtil sharedUtil] clearDataForLogoutHavingZUID:zuid];
                                                             }else if(errorType == ZMacAuth_ERR_SERVER_ERROR && [errorMessage isEqualToString:@"unconfirmed_user"]){
                                                                 NSString *unc_token = [responseDict valueForKey:@"unc_token"];
                                                                 self->UnconfirmedUserURL = [NSString stringWithFormat:@"%@%@?redirect_uri=%@&unc_token=%@",[self getAccountURLForZuid:zuid],kZMacAuthUnconfirmedUser_URL,self->UrlScheme,unc_token];
                                                                 
                                                                 self->User_ZUID = zuid;
                                                                 //present Webview
                                                                 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                                     self->finalSuccessBlock = success;
                                                                     self->finalFailureBlock = failure;
                                                                     self->sfview = [[ZMacAuthLoginViewController alloc] init];
                                                                     self->sfview.success = success;
                                                                     self->sfview.failure = failure;
                                                                     
                                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                                         
                                                                         [self->contentView addSubview:self->sfview.view];
                                                                         [self->sfview.view setTranslatesAutoresizingMaskIntoConstraints:NO];
                                                                         if (@available(macOS 10.10, *)) {
                                                                             [NSLayoutConstraint constraintWithItem:self->sfview.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self->contentView attribute:NSLayoutAttributeWidth multiplier:1 constant:0].active = YES;
                                                                         } else {
                                                                             // Fallback on earlier versions
                                                                         }
                                                                         if (@available(macOS 10.10, *)) {
                                                                             [NSLayoutConstraint constraintWithItem:self->sfview.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self->contentView attribute:NSLayoutAttributeHeight multiplier:1 constant:0].active = YES;
                                                                         } else {
                                                                             // Fallback on earlier versions
                                                                         }
                                                                     });
                                                                 });
                                                                 return;
                                                             }
                                                             NSError *err = [[ZMacAuthZIAMUtil sharedUtil] handleAccessTokenFetchError:errorType error:error];
                                                             failure(err);
                                                             return;
                                                         }];
}

@end
