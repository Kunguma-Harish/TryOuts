//
//  ZMacAuthTokenFetch.h
//  Pods-OAuthTesting
//
//  Created by Kumareshwaran on 29/06/18.
//

#import <Foundation/Foundation.h>
#import "ZMacAuthZIAMUtil.h"

@interface ZMacAuthZIAMUtil(ZMacAuthTokenFetch)
- (void)initTokenFetch;
-(void)processTokenFetchForZUID:(NSString *)zuid WithSuccess:(requestSuccessBlock)success andFailure:(requestFailureBlock)failure;
@end
