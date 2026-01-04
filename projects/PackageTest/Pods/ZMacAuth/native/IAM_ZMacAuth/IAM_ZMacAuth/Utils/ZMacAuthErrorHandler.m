//
//  ZMacAuthErrorHandler.m
//  ZMacAuth
//
//  Created by Kumareshwaran on 03/07/18.
//

#import "ZMacAuthErrorHandler.h"
#import "ZMacAuthUtilConstants.h"
#import "ZMacAuthConstants.h"
#import "ZMacAuthHelpers.h"

@implementation ZMacAuthZIAMUtil(ZMacAuthErrorHandler)

-(NSError *)handleAccessTokenFetchError:(ZMacAuthInternalError)type error:(NSError *)error{
    if (type == ZMacAuth_ERR_JSON_NIL) {
        // JSON is Nil
        DLog(@"AccessToken fetch JSON nil");
        [ZMacAuthZIAMUtil log:[NSString stringWithFormat:@"\n%@", @"\nAccessToken fetch JSON nil"]];
        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]init];
        [userInfo setValue:@"AccessToken Fetch Nil" forKey:NSLocalizedDescriptionKey];
        return [NSError errorWithDomain:kZMacAuthErrorDomain code:k_ZMacAuthTokenFetchNil userInfo:userInfo];
    } else if (type == ZMacAuth_ERR_JSONPARSE_FAILED) {
        // JSON parse failed with error
        DLog(@"AccessToken fetch JSON parse failed: %@", [error localizedDescription]);
        [ZMacAuthZIAMUtil log:[NSString stringWithFormat:@"\n%@", [NSString stringWithFormat:@"AccessToken fetch JSON parse failed: %@", [error localizedDescription]]]];
        return error;
    } else if (type == ZMacAuth_ERR_SERVER_ERROR) {
        //Server returned an error
        DLog(@"AccessToken fetch Error: %@", [error.userInfo valueForKey:@"error"]);
        [ZMacAuthZIAMUtil log:[NSString stringWithFormat:@"\n%@", [NSString stringWithFormat:@"AccessToken fetch Error: %@", [error.userInfo valueForKey:@"error"]]]];
        return [NSError errorWithDomain:kZMacAuthErrorDomain code:k_ZMacAuthTokenFetchError userInfo:[self getUserInfoFromError:error]];
    } else if (type == ZMacAuth_ERR_NOTHING_WAS_RECEIVED) {
        //Nothing was received
        DLog(@"AccessToken fetch Nothing was received");
        [ZMacAuthZIAMUtil log: [NSString stringWithFormat:@"\n%@", @"AccessToken fetch Nothing was received"]];
        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]init];
        [userInfo setValue:@"Fetch Nothing was Received." forKey:NSLocalizedDescriptionKey];
        return [NSError errorWithDomain:kZMacAuthErrorDomain code:k_ZMacAuthTokenFetchNothingReceived userInfo:userInfo];
    } else if (type == ZMacAuth_ERR_CONNECTION_FAILED) {
        //Connection failed!
        DLog(@"AccessTokenFetch Connection failed with Error: %@", [error localizedDescription]);
        [ZMacAuthZIAMUtil log: [NSString stringWithFormat:@"\n%@", [NSString stringWithFormat:@"AccessTokenFetch Connection failed with Error: %@", [error localizedDescription]]]];
        return error;
    }else{
        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]init];
        [userInfo setValue:@"General Error" forKey:NSLocalizedDescriptionKey];
        [ZMacAuthZIAMUtil log:[NSString stringWithFormat:@"\n%@", @"General Error"]];
        return [NSError errorWithDomain:kZMacAuthErrorDomain code:k_ZMacAuthTokenFetchGeneralError userInfo:userInfo];
    }
}

-(void)handleRevokeError:(ZMacAuthInternalError)type error:(NSError *)error failureBlock:(requestLogoutFailureBlock)failed {

    if (type == ZMacAuth_ERR_JSON_NIL) {
        // JSON is Nil
        DLog(@"revoke JSON nil");
        NSMutableDictionary* userInfo = [[NSMutableDictionary alloc] init];
        [userInfo setValue:@"RevokeToken fetch nil " forKey:NSLocalizedDescriptionKey];
        [ZMacAuthZIAMUtil log:[NSString stringWithFormat:@"\n%@", @"RevokeToken fetch nil "]];
        NSError *error = [NSError errorWithDomain:kZMacAuthErrorDomain code:k_ZMacAuthRevokeTokenResultNil userInfo:userInfo];
        failed(error);
    }else if (type == ZMacAuth_ERR_JSONPARSE_FAILED) {
        // JSON parse failed with error
        DLog(@"revoke JSON parse failed: %@", [error localizedDescription]);
        failed(error);
    } else if (type == ZMacAuth_ERR_SERVER_ERROR) {
        //Server returned an error
        DLog(@"revoke Error: %@", [error.userInfo valueForKey:@"error"]);
        NSError *returnerror = [NSError errorWithDomain:kZMacAuthErrorDomain code:k_ZMacAuthRevokeTokenError userInfo:[self getUserInfoFromError:error]];
        failed(returnerror);
    } else if (type == ZMacAuth_ERR_NOTHING_WAS_RECEIVED) {
        //Nothing was received
        DLog(@"revoke Nothing was received");
        NSMutableDictionary* userInfo = [[NSMutableDictionary alloc] init];
        [userInfo setValue:@"RevokeToken nothing was received " forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:kZMacAuthErrorDomain code:k_ZMacAuthRevokeTokenNothingReceived userInfo:userInfo];
        failed(error);
    } else if (type == ZMacAuth_ERR_CONNECTION_FAILED) {
        //Connection failed!
        failed(error);
    }
}

-(void)handleScopeEnhancementError:(ZMacAuthInternalError)type error:(NSError *)error {
    NSError *returnError;
    if (type == ZMacAuth_ERR_JSON_NIL) {
        // JSON is Nil
        
        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]init];
        [userInfo setValue:@"Get Extra Scope Fetch Nil" forKey:NSLocalizedDescriptionKey];
        returnError = [NSError errorWithDomain:kZMacAuthErrorDomain code:k_ZMacAuthScopeEnhancementFetchNil userInfo:userInfo];
        
    } else if (type == ZMacAuth_ERR_JSONPARSE_FAILED) {
        // JSON parse failed with error
        returnError = error;
    } else if (type == ZMacAuth_ERR_SERVER_ERROR) {
        //Server returned an error
        DLog(@"Get Extra Scope fetch Error: %@", [error.userInfo valueForKey:@"error"]);
        returnError = [NSError errorWithDomain:kZMacAuthErrorDomain code:k_ZMacAuthScopeEnhancementFetchError userInfo:[self getUserInfoFromError:error]];
    } else if (type == ZMacAuth_ERR_NOTHING_WAS_RECEIVED) {
        //Nothing was received
        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]init];
        [userInfo setValue:@"Get Extra Scope Fetch Nothing was Received." forKey:NSLocalizedDescriptionKey];
        returnError = [NSError errorWithDomain:kZMacAuthErrorDomain code:k_ZMacAuthScopeEnhancementFetchNothingReceived userInfo:userInfo];
    } else if (type == ZMacAuth_ERR_CONNECTION_FAILED) {
        //Connection failed!
        returnError = error;
    }
    finalScopeEnhancementFailureBlock(returnError);
}

-(void)handleAuthToOAuthError:(ZMacAuthInternalError)type error:(NSError*)error failureBlock:(requestFailureBlock)failure{
    NSError *returnError;
    if (type == ZMacAuth_ERR_JSON_NIL) {
        // JSON is Nil
        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]init];
        [userInfo setValue:@"Auth to OAuth Fetch Nil" forKey:NSLocalizedDescriptionKey];
        returnError = [NSError errorWithDomain:kZMacAuthErrorDomain code:k_ZMacAuthAuthToOAuthFetchNil userInfo:userInfo];
        
    } else if (type == ZMacAuth_ERR_JSONPARSE_FAILED) {
        // JSON parse failed with error
        returnError = error;
    } else if (type == ZMacAuth_ERR_SERVER_ERROR) {
        //Server returned an error
        DLog(@"Auth to OAuth fetch Error: %@", [error.userInfo valueForKey:@"error"]);
        returnError = [NSError errorWithDomain:kZMacAuthErrorDomain code:k_ZMacAuthAuthToOAuthFetchError userInfo:[self getUserInfoFromError:error]];
    } else if (type == ZMacAuth_ERR_NOTHING_WAS_RECEIVED) {
        //Nothing was received
        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]init];
        [userInfo setValue:@"Auth to OAuth Fetch Nothing was Received." forKey:NSLocalizedDescriptionKey];
        returnError = [NSError errorWithDomain:kZMacAuthErrorDomain code:k_ZMacAuthAuthToOAuthNothingReceived userInfo:userInfo];
    } else if (type == ZMacAuth_ERR_CONNECTION_FAILED) {
        //Connection failed!
        returnError = error;
    }
    failure(returnError);
}

-(NSError *)handleLoginError:(ZMacAuthInternalError)type error:(NSError *)error {
    NSError *returnError;
    if (type == ZMacAuth_ERR_JSON_NIL) {
        // JSON is Nil
        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]init];
        [userInfo setValue:@"RefreshToken Fetch Nil" forKey:NSLocalizedDescriptionKey];
        returnError = [NSError errorWithDomain:kZMacAuthErrorDomain code:k_ZMacAuthRefreshTokenFetchNil userInfo:userInfo];
    } else if (type == ZMacAuth_ERR_JSONPARSE_FAILED) {
        // JSON parse failed with error
        returnError = error;
    } else if (type == ZMacAuth_ERR_SERVER_ERROR) {
        //Server returned an error
        DLog(@"RefreshToken fetch Error: %@", [error.userInfo valueForKey:@"error"]);
        returnError = [NSError errorWithDomain:kZMacAuthErrorDomain code:k_ZMacAuthRefreshTokenFetchError userInfo:[self getUserInfoFromError:error]];
    } else if (type == ZMacAuth_ERR_NOTHING_WAS_RECEIVED) {
        //Nothing was received
        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]init];
        [userInfo setValue:@"RefreshToken Fetch Nothing was Received." forKey:NSLocalizedDescriptionKey];
        returnError = [NSError errorWithDomain:kZMacAuthErrorDomain code:k_ZMacAuthRefreshTokenFetchNothingReceived userInfo:userInfo];
    } else if (type == ZMacAuth_ERR_CONNECTION_FAILED) {
        //Connection failed!
        returnError = error;
    }
    return returnError;
}
@end
