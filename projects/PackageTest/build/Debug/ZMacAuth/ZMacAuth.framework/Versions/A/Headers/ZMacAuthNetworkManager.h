//
//  ZMacAuthNetworkManager.h
//  ZMacAuth_Demo
//
//  Created by Abinaya Ravichandran on 07/02/17.
//  Copyright © 2017 Zoho. All rights reserved.
//

#define ZMacAuth_HTTPHeaders @"ZMacAuth_HTTPHeaders"
#import <Foundation/Foundation.h>

/*!
 @typedef ZMacAuthInternalError
 @brief Types of error handled in every API calls.
 */
typedef NS_ENUM(NSInteger, ZMacAuthInternalError) {
    ZMacAuth_ERR_JSONPARSE_FAILED,
    ZMacAuth_ERR_JSON_NIL,
    ZMacAuth_ERR_SERVER_ERROR,
    ZMacAuth_ERR_CONNECTION_FAILED,
    ZMacAuth_ERR_NOTHING_WAS_RECEIVED
};

@interface ZMacAuthNetworkManager : NSObject

+(ZMacAuthNetworkManager*)sharedManager;

-(void)sendPOSTRequestForURL:(NSString*)urlString
         parameters:(NSDictionary*)params
       successBlock:(void (^)(NSDictionary* jsonDict, NSHTTPURLResponse *httpResponse))success
       failureBlock:(void (^)(ZMacAuthInternalError errorType, NSError* error))failed;

-(void)sendJSONPOSTRequestForURL:(NSString*)urlString
  parameters:(NSDictionary*)params
successBlock:(void (^)(NSDictionary* jsonDict, NSHTTPURLResponse *httpResponse))success
                    failureBlock:(void (^)(ZMacAuthInternalError errorType, NSError* errorInfo))failed;

-(void)sendGETRequestForURL:(NSString*)urlString
         parameters:(NSDictionary*)params
       successBlock:(void (^)(NSDictionary* jsonDict, NSHTTPURLResponse *httpResponse))success
       failureBlock:(void (^)(ZMacAuthInternalError errorType, NSError* error))failed;

-(void)sendGETRequestForURL:(NSString*)urlString
         parameters:(NSDictionary*)params
       successBlockWithData:(void (^)(NSData* data, NSHTTPURLResponse *httpResponse))success
       failureBlock:(void (^)(ZMacAuthInternalError errorType, NSError* error))failed;


@end
