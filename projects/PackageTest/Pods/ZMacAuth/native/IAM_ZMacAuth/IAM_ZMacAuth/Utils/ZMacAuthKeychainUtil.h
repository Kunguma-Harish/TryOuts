//
//  ZMacAuthKeychainUtil.h
//  Pods-ZohoMail
//
//  Created by Rahul T on 10/11/17.
//

#import <Foundation/Foundation.h>
#import "ZMacAuthZIAMUtil.h"

@interface ZMacAuthZIAMUtil(ZMacAuthKeychainUtil)

-(NSArray *)getAllItemsFromKeychainForService:(NSString *)service accessGroup:(NSString*) accessgroup;

-(void)storeFrequentlyUsedItemsInKeychainHavingClientSecret:(NSString *)clientSecret refershToken:(NSString *)refreshToken accessTokenDictData:(NSData *)accessTokenData currentUserZUID:(NSString *)currentUserZuid accountsURL:(NSString *)accountsURL dcllocation:(NSString *)dclLocation dclmeta:(NSData *)dclMeta forZuid:(NSString*) zuid;
-(void)removeFrequentlyUsedItemsInKeychainForZuid:(NSString*) zuid;
//Frequently Used Keychain Items
-(void)setAccessTokenDict:(NSDictionary *)accessTokenDict forZuid:(NSString*) zuid;
-(void)setCurrentUser:(NSString *)currentUserZuid;

-(NSString*) getClientSecretForZuid:(NSString*) zuid;
-(NSString*) getRefreshTokenForZuid:(NSString*) zuid;
-(NSDictionary *) getAccessTokenDictForZuid:(NSString*) zuid;
-(NSString*) getCurrentUserForApp;
-(NSString*) getAccountURLForZuid:(NSString*) zuid;



//Not Frequently Used Keychain Items
-(NSArray*) getCurrentUserDetails;

-(NSArray*) getUserDetailsForZuid:(NSString *)zuid;
-(void)setUserDetailsDataInKeychainForZUID:(NSString *)zuid userdetail:(NSData *)userdetails;
-(void)removeUserDetailsDataInKeychainForZUID:(NSString *)zuid;

-(NSString*) getDCLLocationForZuid:(NSString*) zuid;

-(NSData*) getDCLMetaDataForZuid:(NSString*) zuid;

-(NSMutableArray*) getZUIDs;
//
//-(NSString*) getClientSecretKeyForApp:(NSString *) app zuid:(NSString*) zuid;
//-(NSString*) getRefreshTokenKeyForApp:(NSString *) app zuid:(NSString*) zuid;
//-(NSString*) getAccessTokenDictKeyForApp:(NSString*) app zuid:(NSString*) zuid;
//-(NSString*) getCurrentUserKeyForApp:(NSString*) app;
//-(NSString*) getUserDetailsKeyForApp:(NSString*) app zuid: (NSString*) zuid;
////-(NSString*) getUserDataKeyForApp:(NSString*) app zuid: (NSString*) zuid;
//-(NSString*) getAccountURLKeyForApp:(NSString*) app zuid: (NSString*) zuid;
//-(NSString*) getDCLLocationKeyForApp:(NSString*) app zuid: (NSString*) zuid;
//-(NSString*) getDCLMetaDataKeyForApp:(NSString*) app zuid:(NSString*) zuid;
//-(NSString*) getZUIDsKeyForApp:(NSString *)app;
@end
