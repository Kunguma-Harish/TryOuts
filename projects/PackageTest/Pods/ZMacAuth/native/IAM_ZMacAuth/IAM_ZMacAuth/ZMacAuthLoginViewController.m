//
//  ViewController.m
//  Hello World TouchID
//
//  Created by Kumareshwaran on 17/02/17.
//  Copyright © 2017 Kumareshwaran. All rights reserved.
//

#import "ZMacAuthLoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#include "ZMacAuthKeyPairUtil.h"
#include "ZMacAuthNSData+Base64.h"
#include <sys/time.h>
#include "ZMacAuth_NSData+AES.h"
#include "ZMacAuthZIAMUtil.h"
#include "ZMacAuthConstants.h"
#import "ZMacAuthNetworkManager.h"
#import "ZMacAuthUtilConstants.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "ZMacAuthErrorHandler.h"
#include "ZMacAuthUtilConstants.h"
#include "ZMacAuthHelpers.h"

@interface ZMacAuthLoginViewController () <WKNavigationDelegate>
{
    NSString *oauthpub;
    NSString *encryptedDataString;
    BOOL DoneButtonClicked;
    
    
    NSString*                   gt_hash;
    
    NSString*                   gt_sec;
    NSString*                   code;
    
    NSString* refresh_token;
    NSString* access_token;
    NSString* expires_in;
    
    NSString *dcl_prefix;
    NSData *Bas64DCL_Meta_Data;
    
    NSString *accountsServer;
    NSString *location;
    
    
    NSDictionary* profileInfoDict;
    NSString *transformedContactsURL;
    
    BOOL isSFSafariDisplayed;
    
    BOOL isNotificationReceived;
    JSContext *context;
    
    ZMacAuthKeyPairUtil *keygen;
    
}

@property (nonatomic) NSProgressIndicator *progressIndicator;

@end

@implementation ZMacAuthLoginViewController

-(void) loadView
{
    self.view = [NSView new];
}

-(WKWebView*) webkitview
API_AVAILABLE(macos(10.10)){
    if(_webkitview == nil )
    {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        WKUserContentController *controller = [[WKUserContentController alloc] init];
        config.userContentController = controller;
        _webkitview = [[WKWebView alloc] initWithFrame:self.view.frame configuration:config];
        _webkitview.navigationDelegate = self;
    }
    return _webkitview;
}

-(NSProgressIndicator*) progressIndicator {
    if (!_progressIndicator) {
        _progressIndicator = [NSProgressIndicator new];
        _progressIndicator.style = NSProgressIndicatorSpinningStyle;
    }
    return _progressIndicator;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showPreloginProgress];
    //PublicKey to be Stored in IAM Server!
    // Do any additional setup after loading the view.
    keygen= [[ZMacAuthKeyPairUtil alloc] init];
    [keygen setIdentifierForPublicKey:@"com.zoho.publicKey"
                           privateKey:@"com.zoho.privateKey"
                      serverPublicKey:@"com.zoho.serverPublicKey"];
    [keygen generateKeyPairRSA];

    oauthpub = [keygen getPublicKeyAsBase64ForJavaServer];

    [self loadLoginWebView:oauthpub];
}

-(void) loadLoginWebView:(NSString*) pub {
    // Do any additional setup after loading the view.
    //PublicKey to be Stored in IAM Server!
    [ZMacAuthZIAMUtil log: @"Login webview loaded"];
    NSString* encoded_oauthPub = [ZMacAuthZIAMUtil getEncodedStringForString: pub];
    DLog(@"%@", encoded_oauthPub)
    long long timePassed_ms = ([[NSDate date] timeIntervalSince1970] * 1000);
    
    NSString* rt_cook_string = [NSString stringWithFormat:@"%@__i__%@__i__%lld__i__%@",[[ZMacAuthZIAMUtil sharedUtil] currentModel],[ZMacAuthZIAMUtil sharedUtil]->AppName,timePassed_ms,[[NSHost currentHost] localizedName]];
    
    NSData *data = [rt_cook_string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [data AES128EncryptedDataWithKey:SHARED_SECRET];
    encryptedDataString = [encryptedData base64EncodedStringWithOptions:0];
    encryptedDataString = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)encryptedDataString, NULL, (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ", CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
    
    [self.view addSubview:self.webkitview];
    self.webkitview.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.webkitview attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.webkitview attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    
    
    NSString *urlString;
    if([ZMacAuthZIAMUtil sharedUtil].ChinaSetup){
        [ZMacAuthZIAMUtil sharedUtil]->BaseUrl = kZoho_CN_Base_URL;
        [ZMacAuthZIAMUtil sharedUtil]->ContactsUrl = kCONTACTS_Zoho_CN_PROFILE_PHOTO;
    }
    if([ZMacAuthZIAMUtil sharedUtil]->SignUpUrl){
        NSString *serviceUrl;
        if([ZMacAuthZIAMUtil sharedUtil].donotSendScopesParam){
            serviceUrl = [NSString stringWithFormat:@"%@%@?client_id=%@&redirect_uri=%@&state=Test&response_type=code&access_type=offline&newmobilepage=true&ss_id=%@&rook_cook=%@",[ZMacAuthZIAMUtil sharedUtil]->BaseUrl,kZMacAuthMobileAuth_URL,[ZMacAuthZIAMUtil sharedUtil]->ClientID,[ZMacAuthZIAMUtil sharedUtil]->UrlScheme,encoded_oauthPub,encryptedDataString];
        }else{
            serviceUrl = [NSString stringWithFormat:@"%@%@?client_id=%@&scope=%@&redirect_uri=%@&state=Test&response_type=code&access_type=offline&newmobilepage=true&ss_id=%@&rook_cook=%@",[ZMacAuthZIAMUtil sharedUtil]->BaseUrl,kZMacAuthMobileAuth_URL,[ZMacAuthZIAMUtil sharedUtil]->ClientID,[ZMacAuthZIAMUtil sharedUtil]->Scopes,[ZMacAuthZIAMUtil sharedUtil]->UrlScheme,encoded_oauthPub,encryptedDataString];
        }
        
        NSString *encoded_serviceUrl=CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)serviceUrl, NULL, (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ", CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
        
        urlString  = [NSString stringWithFormat:@"%@&serviceurl=%@&IAM_CID=%@",[ZMacAuthZIAMUtil sharedUtil]->SignUpUrl,encoded_serviceUrl,[ZMacAuthZIAMUtil sharedUtil]->ClientID];
        [ZMacAuthZIAMUtil sharedUtil]->SignUpUrl = nil;
    }else if([ZMacAuthZIAMUtil sharedUtil]->ScopeEnhancementUrl){
        urlString = [ZMacAuthZIAMUtil sharedUtil]->ScopeEnhancementUrl;
        [ZMacAuthZIAMUtil sharedUtil]->ScopeEnhancementUrl = nil;
    }else if([ZMacAuthZIAMUtil sharedUtil]->UnconfirmedUserURL){
        urlString = [ZMacAuthZIAMUtil sharedUtil]->UnconfirmedUserURL;
        [ZMacAuthZIAMUtil sharedUtil]->UnconfirmedUserURL = nil;
    }else if([ZMacAuthZIAMUtil sharedUtil]->AddSecondaryEmailURL){
        urlString = [ZMacAuthZIAMUtil sharedUtil]->AddSecondaryEmailURL;
        [ZMacAuthZIAMUtil sharedUtil]->AddSecondaryEmailURL = nil;
    }else{
        if([ZMacAuthZIAMUtil sharedUtil].donotSendScopesParam){
            urlString = [NSString stringWithFormat:@"%@%@?client_id=%@&redirect_uri=%@&state=Test&response_type=code&access_type=offline&newmobilepage=true&ss_id=%@&rook_cook=%@",[ZMacAuthZIAMUtil sharedUtil]->BaseUrl,kZMacAuthMobileAuth_URL,[ZMacAuthZIAMUtil sharedUtil]->ClientID,[ZMacAuthZIAMUtil sharedUtil]->UrlScheme,encoded_oauthPub,encryptedDataString];
        }else{
            urlString = [NSString stringWithFormat:@"%@%@?client_id=%@&scope=%@&redirect_uri=%@&state=Test&response_type=code&access_type=offline&newmobilepage=true&ss_id=%@&rook_cook=%@",[ZMacAuthZIAMUtil sharedUtil]->BaseUrl,kZMacAuthMobileAuth_URL,[ZMacAuthZIAMUtil sharedUtil]->ClientID,[ZMacAuthZIAMUtil sharedUtil]->Scopes,[ZMacAuthZIAMUtil sharedUtil]->UrlScheme,encoded_oauthPub,encryptedDataString];
        }
        
        if([ZMacAuthZIAMUtil sharedUtil]->UrlParams){
            urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&%@",[ZMacAuthZIAMUtil sharedUtil]->UrlParams]];
            [ZMacAuthZIAMUtil sharedUtil]->UrlParams = nil;
        }
    }
    
    NSURL * url =  [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [ZMacAuthZIAMUtil log: [NSString stringWithFormat:@"URL to load %@", url]];
    [self.webkitview loadRequest:request];
}

-(void) showPreloginProgress {
    if ([ZMacAuthZIAMUtil sharedUtil]->showPreloginProgressBlock != nil) {
        [ZMacAuthZIAMUtil sharedUtil]->showPreloginProgressBlock();
    } else {
        [self showProgress];
    }
}

-(void) endPreloginProgress {
    if ([ZMacAuthZIAMUtil sharedUtil]->endPreloginProgressBlock != nil) {
        [ZMacAuthZIAMUtil sharedUtil]->endPreloginProgressBlock();
    } else {
        [self removeProgress];
    }
}

-(void) showProgress {
    if(self.progressIndicator.superview == nil) {
        [self.view addSubview:self.progressIndicator];
        [self.view addSubview:self.progressIndicator positioned:NSWindowAbove relativeTo:self.webkitview];
        self.progressIndicator.translatesAutoresizingMaskIntoConstraints = false;
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.progressIndicator attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.progressIndicator attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.progressIndicator attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.progressIndicator attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.progressIndicator startAnimation:nil];
    }
}

-(void) removeProgress {
    if( self.progressIndicator.superview != nil) {
        [self.progressIndicator stopAnimation:nil];
        [self.progressIndicator removeFromSuperview];
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    if (self.webkitview == webView) {
        [ZMacAuthZIAMUtil log: @"didFinishNavigation"];
        [self endPreloginProgress];
    }
}

#pragma mark WebPolicyDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if (self.webkitview == webView) {
        NSString* url = [[navigationAction.request URL] description];
        DLog(@"navigating to %@", url);
        [ZMacAuthZIAMUtil log: [NSString stringWithFormat:@"navigating to %@", url]];
        //[listener use];
        NSString *scheme = [[navigationAction.request URL] scheme];
        if ([[ZMacAuthZIAMUtil sharedUtil]->UrlScheme rangeOfString:scheme].length != 0)
        {
            [self oauthpost:[[navigationAction.request URL] query]];
            decisionHandler(WKNavigationActionPolicyCancel);
        }else{
            decisionHandler(WKNavigationActionPolicyAllow);
        }
    }
    else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

- (void)oauthpost:(NSString *)queryString {
    [ZMacAuthZIAMUtil log: [NSString stringWithFormat:@"\n%@", [NSString stringWithFormat:@"calling oauthpost\n"]]];
    if ([ZMacAuthZIAMUtil sharedUtil]->showProgressBlock != nil) {
        [ZMacAuthZIAMUtil sharedUtil]->showProgressBlock();
    }else{
        [self showProgress];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"sfsafariredirection" object:nil];
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
    if([queryStringDictionary objectForKey:@"error"]){
        DLog(@"OAuth Redirection ERROR");
        NSError *returnError;
        [ZMacAuthZIAMUtil log: [NSString stringWithFormat:@"\n%@", [NSString stringWithFormat:@"OAuth Redirection ERROR___%@\n", [queryStringDictionary objectForKey:@"error"]]]];
        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]init];
        [userInfo setValue:[queryStringDictionary objectForKey:@"error"] forKey:NSLocalizedDescriptionKey];
        returnError = [NSError errorWithDomain:kZMacAuthErrorDomain code:k_ZMacAuthGenericError userInfo:userInfo];
        [self dismissReturningError:returnError];
        return;
        
    }
    if([queryStringDictionary objectForKey:@"scope_enhanced"]){
        NSString *scopeEnhanced = [queryStringDictionary objectForKey:@"scope_enhanced"];
        NSString *status = [queryStringDictionary objectForKey:@"status"];
        if([scopeEnhanced isEqualToString:@"true"] && [status isEqualToString:@"success"]){
            //Scope Enhancement Done successfully...
            DLog(@"Scope Enahcnement Done Success...");
            [[ZMacAuthZIAMUtil sharedUtil] getForceFetchOAuthTokenForZUID:[ZMacAuthZIAMUtil sharedUtil]->User_ZUID success:[ZMacAuthZIAMUtil sharedUtil]->finalScopeEnhancementSuccessBlock andFailure:[ZMacAuthZIAMUtil sharedUtil]->finalScopeEnhancementFailureBlock];
            dispatch_async(dispatch_get_main_queue(), ^{
                [ZMacAuthZIAMUtil.sharedUtil dismissLoginController];
            });
            return;
        }else{
            //Scope Enhancement Failed...
            DLog(@"Scope Enahcnement Failed...");
            NSError *returnError;
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]init];
            [userInfo setValue:@"Scope Enhancement failued" forKey:NSLocalizedDescriptionKey];
            returnError = [NSError errorWithDomain:kZMacAuthErrorDomain code:k_ZMacAuthScopeEnhancementServerError userInfo:userInfo];
            [self dismissReturningError:returnError];
            return;
        }
    }else if([[queryStringDictionary objectForKey:@"usecase"] isEqualToString:@"add_secondary_email"]){
        NSString *status = [queryStringDictionary objectForKey:@"status"];
        if([status isEqualToString:@"success"]){
            //Add EmailID Done successfully...
            DLog(@"Add EmailID Done Success...");
            if([ZMacAuthZIAMUtil sharedUtil]->finalAddEmailIDBlock){
                [ZMacAuthZIAMUtil sharedUtil]->finalAddEmailIDBlock(nil);
                [ZMacAuthZIAMUtil sharedUtil]->finalAddEmailIDBlock = nil;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ZMacAuthZIAMUtil.sharedUtil dismissLoginController];
                });
                return;
            }
        }else{
            //AddSecondaryEmail Failed...
            DLog(@"AddSecondaryEmail Failed...");
            NSError *returnError;
            
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]init];
            [userInfo setValue:@"AddSecondaryEmail Failed" forKey:NSLocalizedDescriptionKey];
            returnError = [NSError errorWithDomain:kZMacAuthErrorDomain code:k_ZMacAuthAddSecondaryEmailServerError userInfo:userInfo];
            [self dismissReturningError:returnError];
            return;
        }
    }
    [ZMacAuthZIAMUtil log: [NSString stringWithFormat:@"\n%@", [NSString stringWithFormat:@"OAuth Redirection success"]]];
    DLog(@"OAuth Redirection Success");
    gt_hash  =   [queryStringDictionary objectForKey:@"gt_hash"];
    DLog(@"gt_hash-------> %@",gt_hash);
    //Get the KeyPair!
    NSString*  encrypted_gt_sec   =   [queryStringDictionary objectForKey:@"gt_sec"];
    
    //Get the KeyPair!
    NSData *granttokenData = [NSData dataFromBase64String:encrypted_gt_sec];
    
    //Decrypt using private key
    gt_sec= [keygen decryptUsingPrivateKeyWithData:granttokenData];
    
    //Store this in app keychain
    [ZMacAuthZIAMUtil sharedUtil]->setClientSecret = self->gt_sec;
    DLog(@"gt_sec :::: %@",self->gt_sec);
    //Per User Per App
    self->dcl_prefix =   [queryStringDictionary objectForKey:@"location"];
    DLog(@"DCL PFX-------> %@",self->dcl_prefix);
    self->code = [queryStringDictionary objectForKey:@"code"];
    DLog(@"code = %@", self->code);
    self->accountsServer = [queryStringDictionary objectForKey:@"accounts-server"];
    self->location = [queryStringDictionary objectForKey:@"location"];
    [ZMacAuthZIAMUtil sharedUtil]->setAccountsServerURL= self->accountsServer;
    [ZMacAuthZIAMUtil sharedUtil]->setLocation= self->location;
    //URL Encode the client secret to post to server
    NSString *encoded_gt_sec= [ZMacAuthZIAMUtil getEncodedStringForString:gt_sec];
    //URL
    NSString *urlString = [NSString stringWithFormat:@"%@/oauth/v2/token",self->accountsServer];
    //Add Parameters
    NSMutableDictionary *paramsAndHeaders = [[NSMutableDictionary alloc] init];
    [paramsAndHeaders setValue:@"authorization_code" forKey:@"grant_type"];
    [paramsAndHeaders setValue:[NSString stringWithFormat:@"%@",[ZMacAuthZIAMUtil sharedUtil]->ClientID] forKey:@"client_id"];
    [paramsAndHeaders setValue:[NSString stringWithFormat:@"%@",encoded_gt_sec] forKey:@"client_secret"];
    //set service url here
    [paramsAndHeaders setValue:[NSString stringWithFormat:@"%@",[ZMacAuthZIAMUtil sharedUtil]->UrlScheme] forKey:@"redirect_uri"];
    [paramsAndHeaders setValue:[NSString stringWithFormat:@"%@",self->gt_hash] forKey:@"rt_hash"];
    [paramsAndHeaders setValue:[NSString stringWithFormat:@"%@",self->code] forKey:@"code"];
    //Add headers
    NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
    [headers setValue:[[ZMacAuthZIAMUtil sharedUtil] getUserAgentString] forKey:@"User-Agent"];
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
                self->Bas64DCL_Meta_Data = [NSData dataFromBase64String:base64EncodedString];
                [ZMacAuthZIAMUtil sharedUtil]->setBas64DCL_Meta_Data=self->Bas64DCL_Meta_Data;
            }
        }
        //Store the RefreshToken in keychain
        self->refresh_token = [jsonDict objectForKey:@"refresh_token"];
        DLog(@"refreshToken: %@",self->refresh_token);
        //Give the Access token when asked!
        self->access_token = [jsonDict objectForKey:@"access_token"];
        self->expires_in = [jsonDict objectForKey:@"expires_in"];
        DLog(@"AccessToken: %@ Expires in : %@",self->access_token,self->expires_in);
        DLog(@"LoginWebview--->>Login Success");
        [ZMacAuthZIAMUtil log: [NSString stringWithFormat:@"\n%@", [NSString stringWithFormat:@"LoginWebview--->>Login Success"]]];
        [ZMacAuthZIAMUtil sharedUtil]->setAccessToken= self->access_token;
        [ZMacAuthZIAMUtil sharedUtil]->setExpiresIn= self->expires_in;
        [ZMacAuthZIAMUtil sharedUtil]->setRefreshToken= self->refresh_token;
        
        [[ZMacAuthZIAMUtil sharedUtil] fetchUserInfoWithBlock:^(NSError *error) {
            if(error == nil){
                self->_success(self->access_token);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ZMacAuthZIAMUtil.sharedUtil dismissLoginController];
                    if ([ZMacAuthZIAMUtil sharedUtil]->endProgressBlock != nil) {
                        [ZMacAuthZIAMUtil sharedUtil]->endProgressBlock();
                    }
                });
            }else{
                [self dismissReturningError:error];
            }
        }];
    } failureBlock:^(ZMacAuthInternalError errorType, NSError *error) {
        //Request failed
        NSError *returnError = [[ZMacAuthZIAMUtil sharedUtil] handleLoginError:errorType error:error];
        [self dismissReturningError:returnError];
    }];
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"sfsafariredirection" object:nil];
}

-(void)dismissReturningError:(NSError *)error{
    _failure(error);
    dispatch_async(dispatch_get_main_queue(), ^{
        [ZMacAuthZIAMUtil.sharedUtil dismissLoginController];
    });
}

@end
