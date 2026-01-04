//
//  ZMacAuthHelpers.h
//  ZMacAuth
//
//  Created by Kumareshwaran on 03/07/18.
//

#import <Foundation/Foundation.h>
#import "ZMacAuthZIAMUtil.h"

@interface ZMacAuthZIAMUtil(ZMacAuthHelpers)

//Internal Methods
-(void)initMode:(ZMacAuthBuildType)mode;
-(NSString *_Nonnull) getUserAgentString;
- (NSString *_Nonnull)currentModel;
-(void)storeItemsInKeyChainOnSuccess;
-(BOOL)isUserSignedIn;
-(long) getCurrentMilliSeconds;
-(void)clearDataForLogoutHavingZUID:(NSString *_Nonnull)zuid;

-(NSString *_Nonnull)transformURL:(NSString *_Nonnull)url AppName:(NSString *_Nonnull)appName zuid:(NSString*_Nonnull) zuid;
-(NSDictionary *_Nonnull)getDCLInfoForCurrentUser;
-(NSDictionary *)getDCLInfoForZuid: (NSString*) zuid;
-(NSString *_Nonnull)transformURL:(NSString *_Nonnull)url AppName:(NSString *_Nonnull)appName ZUID:(NSString *_Nonnull)zuid Location:(NSString *_Nonnull)dclLocation;
-(NSString *)transformURL:(NSString *)url AppName:(NSString *)appName ZUID:(NSString *)zuid Location:(NSString *)dclLocation meta:(NSData *)dclmeta;
-(NSMutableDictionary *_Nonnull)getUserInfoFromError:(NSError *_Nonnull)error;
@end
