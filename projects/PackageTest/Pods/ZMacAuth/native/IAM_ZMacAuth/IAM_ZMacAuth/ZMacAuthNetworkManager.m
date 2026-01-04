//
//  ZMacAuthNetworkManager.m
//  ZMacAuth_Demo
//
//  Created by Abinaya Ravichandran on 07/02/17.
//  Copyright © 2017 Zoho. All rights reserved.
//


#import "ZMacAuthNetworkManager.h"
#import "ZMacAuthZIAMUtil.h"
#import "ZMacAuthUtilConstants.h"

@implementation ZMacAuthNetworkManager
+(ZMacAuthNetworkManager*)sharedManager {
    static ZMacAuthNetworkManager *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

-(void)sendPOSTRequestForURL:(NSString*)urlString
         parameters:(NSDictionary*)params
       successBlock:(void (^)(NSDictionary* jsonDict, NSHTTPURLResponse *httpResponse))success
       failureBlock:(void (^)(ZMacAuthInternalError errorType, NSError* error))failed {

    NSMutableURLRequest * request = [self requestWithURL:urlString params:params isJson:NO];
    [request setHTTPMethod:@"POST"];
    [self processRequest:request successBlock:success failureBlock:failed];
}

-(void)sendJSONPOSTRequestForURL:(NSString*)urlString
  parameters:(NSDictionary*)params
successBlock:(void (^)(NSDictionary* jsonDict, NSHTTPURLResponse *httpResponse))success
                    failureBlock:(void (^)(ZMacAuthInternalError errorType, NSError* errorInfo))failed{
    NSMutableURLRequest * request = [self requestWithURL:urlString params:params isJson:YES];
    [request setHTTPMethod:@"POST"];
    [self processRequest:request successBlock:success failureBlock:failed];
}

-(void)sendGETRequestForURL:(NSString *)urlString
        parameters:(NSDictionary *)params
      successBlock:(void (^)(NSDictionary *, NSHTTPURLResponse *))success
      failureBlock:(void (^)(ZMacAuthInternalError, NSError*))failed {
    NSMutableURLRequest * request = [self requestWithURL:urlString params:params  isJson:NO];
    [request setHTTPMethod:@"GET"];
    [self processRequest:request successBlock:success failureBlock:failed];
}

-(void)sendGETRequestForURL:(NSString*)urlString
        parameters:(NSDictionary*)params
successBlockWithData:(void (^)(NSData* data, NSHTTPURLResponse *httpResponse))success
      failureBlock:(void (^)(ZMacAuthInternalError errorType, NSError* error))failed {
    NSMutableURLRequest * request = [self requestWithURL:urlString params:params  isJson:NO];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse*)response;
        if ([data length] > 0 && error == nil && [httpResponse statusCode] == 200) {
            success(data,httpResponse);
        } else if (error != nil) {
            //connection error received
            failed(ZMacAuth_ERR_CONNECTION_FAILED,error);
        }else if ([data length] == 0 && error == nil) {
            //Nothing was received
            failed(ZMacAuth_ERR_NOTHING_WAS_RECEIVED, error);
        } else {
            // When all the above cases fails..
            NSDictionary *userInfo      =   @{ NSLocalizedDescriptionKey : @"Generic error: ZMacAuth network call failed with unknown error!" };
            NSError *genericError = [NSError errorWithDomain:request.URL.host code:k_ZMacAuthGenericError userInfo:userInfo];
            failed(ZMacAuth_ERR_CONNECTION_FAILED,genericError);
        }
    }];
    [task resume];
}

-(void)processRequest:(NSURLRequest*)request successBlock:(void (^)(NSDictionary *, NSHTTPURLResponse *))success
         failureBlock:(void (^)(ZMacAuthInternalError, id))failed {
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse*)response;
        if ([data length] > 0 && error == nil && [httpResponse statusCode] == 200) {
            NSError *jsonError;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            if (responseDictionary == nil) {
                //fetch nil
                failed(ZMacAuth_ERR_JSONPARSE_FAILED,jsonError);
            } else if ([responseDictionary valueForKey:@"error"]) {
                //fetch error received
                NSError *err = [NSError errorWithDomain:kZMacAuthErrorDomain code:0 userInfo:responseDictionary];
                failed(ZMacAuth_ERR_SERVER_ERROR, err);
            } else if (jsonError != nil) {
                //JSON parse error
                failed(ZMacAuth_ERR_JSON_NIL,jsonError);
            } else {
                //fetch success
                success(responseDictionary,httpResponse);
            }
        } else if ([data length] == 0 && error == nil) {
            //Nothing was received
            failed(ZMacAuth_ERR_NOTHING_WAS_RECEIVED, error);
        } else if (error != nil) {
            //connection error received
            failed(ZMacAuth_ERR_CONNECTION_FAILED,error);
        }else {
            // When all the above cases fails..
            NSDictionary *userInfo      =   @{ NSLocalizedDescriptionKey : @"Generic error: ZMacAuth network call failed with unknown error!" };
            
            NSError *genericError = [NSError errorWithDomain:request.URL.host code:k_ZMacAuthGenericError userInfo:userInfo];
            failed(ZMacAuth_ERR_CONNECTION_FAILED,genericError);
        }
    }];
    [task resume];

}

//Helpers
-(NSMutableURLRequest*)requestWithURL:(NSString*)urlString params:(NSDictionary*)parameters isJson:(BOOL)isJson  {
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *postData;
    if(isJson){
        postData= [self getJSONData:parameters];
    }else{
        postData= [self getData:parameters];
    }
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    //Create request with the given url and params
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPBody:postData];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    //Set HTTP Headers.....
    NSDictionary* dictHeaders = [parameters valueForKey:ZMacAuth_HTTPHeaders];
    for (NSString* HTTPHeaderField in dictHeaders) {
        NSString* header = [dictHeaders valueForKey:HTTPHeaderField];
        [request setValue:header forHTTPHeaderField:HTTPHeaderField];
    }
    return request;
}
-(NSData*)getData:(NSDictionary*)paramDict {
    NSString *paramThread;
    for (id key in paramDict) {
        if (![key isEqualToString:ZMacAuth_HTTPHeaders]) {
            if (paramThread) {
                paramThread = [paramThread stringByAppendingString:[NSString stringWithFormat:@"&%@=",key]];
                paramThread = [paramThread stringByAppendingString:[paramDict valueForKey:key]];
            } else {
                paramThread = [NSString stringWithFormat:@"%@=",key];
                paramThread = [paramThread stringByAppendingString:[paramDict valueForKey:key]];
            }
        }
    }

    NSData *postData = [paramThread dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];

    return postData;
}

-(NSData*)getJSONData:(NSDictionary*)paramDict {
    NSString *paramThread;
    NSError * err;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict addEntriesFromDictionary:paramDict];
    if (dict.count > 0) {

        if ([dict valueForKey:ZMacAuth_HTTPHeaders]) {
            [dict removeObjectForKey:ZMacAuth_HTTPHeaders];
        }
        NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:dict
                                                             options:0
                                                               error:&err];

//        NSString *myString = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
//        DLog(@"jsonform %@",myString);
//        DLog(@"paramThread %@",paramThread);
        return  jsonData;

    }
    NSData *postData = [paramThread dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];

    return postData;
}

@end
