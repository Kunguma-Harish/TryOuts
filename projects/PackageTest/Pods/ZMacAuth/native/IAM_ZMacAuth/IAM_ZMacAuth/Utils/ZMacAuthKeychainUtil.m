//
//  ZMacAuthKeychainUtil.m
//  Pods-ZohoMail
//
//  Created by Rahul T on 10/11/17.
//

#import "ZMacAuthKeychainUtil.h"
#import "ZMacAuthKeyChainWrapper.h"

@implementation ZMacAuthZIAMUtil(ZMacAuthKeychainUtil)

-(NSArray *)getAllItemsFromKeychainForService:(NSString *)service accessGroup:(NSString*) accessgroup{
    return [ZMacAuthKeyChainWrapper itemsForService:service accessGroup:accessgroup];
}
//MARK:- Frequently Used Keychain Items

-(void)storeFrequentlyUsedItemsInKeychainHavingClientSecret:(NSString *)clientSecret refershToken:(NSString *)refreshToken accessTokenDictData:(NSData *)accessTokenData currentUserZUID:(NSString *)currentUserZuid accountsURL:(NSString *)accountsURL dcllocation:(NSString *)dclLocation dclmeta:(NSData *)dclMeta forZuid:(NSString*) zuid{
    NSMutableDictionary *frequentlyUsedSSOKitKeychainItems = [[NSMutableDictionary alloc]init];
    [frequentlyUsedSSOKitKeychainItems setValue:clientSecret forKey:@"client_secret"];
    [frequentlyUsedSSOKitKeychainItems setValue:refreshToken forKey:@"refresh_token"];
    NSDictionary* accessTokenDictionary = (NSMutableDictionary *) [NSKeyedUnarchiver unarchiveObjectWithData:accessTokenData];
    [frequentlyUsedSSOKitKeychainItems setObject:accessTokenDictionary forKey:@"access_token_dictionary"];
    [frequentlyUsedSSOKitKeychainItems setValue:accountsURL forKey:@"accounts_url"];
    [frequentlyUsedSSOKitKeychainItems setValue:dclLocation forKey:@"dcl_location"];
    [frequentlyUsedSSOKitKeychainItems setObject:dclMeta forKey:@"dcl_meta"];
    [self setFrequentlyUsedItemsDict:frequentlyUsedSSOKitKeychainItems ForZuid:zuid];
}

-(NSDictionary *)getFrequentlyUsedItemsDictForZuid:(NSString*) zuid{
    NSString *frequentKeychainItemsKey = [NSString stringWithFormat:@"%@_%@_zmacauth",AppName,zuid];
    return [[self getFrequentItemsDict] objectForKey:frequentKeychainItemsKey];
}
-(void)setFrequentlyUsedItemsDict:(NSMutableDictionary *)frequentlyUsedSSOKitKeychainItems ForZuid:(NSString*) zuid{
    NSMutableDictionary *frequentItems = (NSMutableDictionary *)[self getFrequentItemsDict];
    if(!frequentItems){
        frequentItems = [[NSMutableDictionary alloc]init];
    }
    NSString *frequentKeychainItemsKey = [NSString stringWithFormat:@"%@_%@_zmacauth",AppName,zuid];
    [frequentItems setObject:frequentlyUsedSSOKitKeychainItems forKey:frequentKeychainItemsKey];
    [frequentItems setValue:zuid forKey:@"current_user"];
    if([frequentItems objectForKey:@"zuids"]){
        NSMutableArray *zuids = [frequentItems objectForKey:@"zuids"];
        [zuids addObject:zuid];
        [frequentItems setObject:zuids forKey:@"zuids"];
    }else{
        NSMutableArray *zuids = [[NSMutableArray alloc] init];
        [zuids addObject:zuid];
        [frequentItems setObject:zuids forKey:@"zuids"];
    }
    [self setFrequentItemsDictInKeychain:frequentItems];
}
-(void)updateFrequentlyUsedItemsDict:(NSMutableDictionary *)frequentlyUsedSSOKitKeychainItems ForZuid:(NSString*) zuid{
    NSMutableDictionary *frequentItems = (NSMutableDictionary *)[self getFrequentItemsDict];
    NSString *frequentKeychainItemsKey = [NSString stringWithFormat:@"%@_%@_zmacauth",AppName,zuid];
    [frequentItems setObject:frequentlyUsedSSOKitKeychainItems forKey:frequentKeychainItemsKey];
    [self setFrequentItemsDictInKeychain:frequentItems];
}
-(void)removeFrequentlyUsedItemsInKeychainForZuid:(NSString*) zuid{
    NSString *frequentKeychainItemsKey = [NSString stringWithFormat:@"%@_%@_zmacauth",AppName,zuid];
    NSMutableDictionary *frequentItemsDict = (NSMutableDictionary *)[self getFrequentItemsDict];
    [frequentItemsDict removeObjectForKey:frequentKeychainItemsKey];
    if([zuid isEqualToString:[frequentItemsDict valueForKey:@"current_user"]]){
        [frequentItemsDict removeObjectForKey:@"current_user"];
    }
    NSMutableArray *zuids = [frequentItemsDict objectForKey:@"zuids"];
    if(zuids){
        [zuids removeObject:zuid];
        if([zuids count] > 0){
            [frequentItemsDict setObject:zuids forKey:@"zuids"];
        }else{
            [frequentItemsDict removeObjectForKey:@"zuids"];
        }
        
    }
    if([frequentItemsDict count] > 0){
        [self setFrequentItemsDictInKeychain:frequentItemsDict];
    }else{
        [ZMacAuthKeyChainWrapper removeItemForKey:[NSString stringWithFormat:@"%@_zmacauth",AppName]];
        cachedFrequentlyUsedItemsDict = nil;
    }
}
//Main Item ZUID Specific Key Dict
-(NSDictionary *)getFrequentItemsDict{
    if(cachedFrequentlyUsedItemsDict){
        return cachedFrequentlyUsedItemsDict;
    }
    NSData *frequentlyUsedSSOKitKeychainItemsData = [ZMacAuthKeyChainWrapper dataForKey:[NSString stringWithFormat:@"%@_zmacauth",AppName]];
    cachedFrequentlyUsedItemsDict = (NSDictionary *) [NSKeyedUnarchiver unarchiveObjectWithData:frequentlyUsedSSOKitKeychainItemsData];
    return cachedFrequentlyUsedItemsDict;
}
-(void)setFrequentItemsDictInKeychain:(NSDictionary *)frequentItems{
    cachedFrequentlyUsedItemsDict = frequentItems;
    NSData *dictionaryRep = [NSKeyedArchiver archivedDataWithRootObject:frequentItems];
    
    [ZMacAuthKeyChainWrapper setData:dictionaryRep forKey:[NSString stringWithFormat:@"%@_zmacauth",AppName]];
}

//Frequent Items Setter Methods
-(void)setAccessTokenDict:(NSDictionary *)accessTokenDict forZuid:(NSString*) zuid{
    NSMutableDictionary *frequentlyUsedItemsDict = (NSMutableDictionary *)[self getFrequentlyUsedItemsDictForZuid:zuid];
    [frequentlyUsedItemsDict setObject:accessTokenDict forKey:@"access_token_dictionary"];
    
    //Migrating UserDetails Data from FrequentlyUsedItems to separate Keychain item for UserDetails
    if([frequentlyUsedItemsDict objectForKey:@"user_details"]){
        NSMutableArray* userDetailsArray = (NSMutableArray *)[[frequentlyUsedItemsDict objectForKey:@"user_details"] mutableCopy];
        NSData *userDetailsdata = [NSKeyedArchiver archivedDataWithRootObject:userDetailsArray];
        [self setUserDetailsDataInKeychainForZUID:zuid userdetail:userDetailsdata];
        //Removing the User Details from frequentlyUsedItemsDict which causes delay in gettoken due to profile image data
        [frequentlyUsedItemsDict removeObjectForKey:@"user_details"];
    }
    
    [self updateFrequentlyUsedItemsDict:frequentlyUsedItemsDict ForZuid:zuid];
}
-(void)setCurrentUser:(NSString *)currentUserZuid{
    NSMutableDictionary *frequentItemsDict = (NSMutableDictionary *)[self getFrequentItemsDict];
    [frequentItemsDict setValue:currentUserZuid forKey:@"current_user"];
    [self setFrequentItemsDictInKeychain:frequentItemsDict];
}

//Frequent Items Getter Methods
-(NSString*) getClientSecretForZuid:(NSString*) zuid {
    return [[self getFrequentlyUsedItemsDictForZuid:zuid] valueForKey:@"client_secret"];
}

-(NSString*) getRefreshTokenForZuid:(NSString*) zuid{
    return [[self getFrequentlyUsedItemsDictForZuid:zuid] valueForKey:@"refresh_token"];
}
-(NSDictionary*) getAccessTokenDictForZuid:(NSString*) zuid{
    return [[self getFrequentlyUsedItemsDictForZuid:zuid] objectForKey:@"access_token_dictionary"];
}
-(NSString*) getAccountURLForZuid:(NSString*) zuid {
    return [[self getFrequentlyUsedItemsDictForZuid:zuid] valueForKey:@"accounts_url"];
}
-(NSString*) getCurrentUserForApp {
    return [[self getFrequentItemsDict] valueForKey:@"current_user"];
}

//MARK:- Not Frequently Used Keychain Items

-(NSMutableArray*) getZUIDs {
    return [[self getFrequentItemsDict] objectForKey:@"zuids"];
}


-(NSArray*) getCurrentUserDetails {
    return [self getUserDetailsForZuid:[self getCurrentUserForApp]];
}

-(NSMutableArray*) getUserDetailsForZuid:(NSString *)zuid {
    NSData *user_details_data = [ZMacAuthKeyChainWrapper dataForKey:[self getUserDetailsKeyForZuid:zuid]];
    if(user_details_data){
        NSMutableArray* userDetailsArray = (NSMutableArray *) [NSKeyedUnarchiver unarchiveObjectWithData:user_details_data];
        return userDetailsArray;
    }else{
        //Migrating UserDetails Data from FrequentlyUsedItems to separate Keychain item for UserDetails
        NSMutableArray* userDetailsArray = (NSMutableArray *)[[[self getFrequentlyUsedItemsDictForZuid:zuid] objectForKey:@"user_details"] mutableCopy];
        if(userDetailsArray){
            NSData *userDetailsdata = [NSKeyedArchiver archivedDataWithRootObject:userDetailsArray];
            [self setUserDetailsDataInKeychainForZUID:zuid userdetail:userDetailsdata];
            return userDetailsArray;
        }else{
            return nil;
        }
        
    }
}
-(void)setUserDetailsDataInKeychainForZUID:(NSString *)zuid userdetail:(NSData *)userdetails{
    [ZMacAuthKeyChainWrapper setData:userdetails forKey:[self getUserDetailsKeyForZuid:zuid]];
}
-(NSString*) getUserDetailsKeyForZuid:(NSString*) zuid {
    NSString* user_details_key = [NSString stringWithFormat:@"%@_%@_USERDETAIL",AppName,zuid];
    return user_details_key;
}
-(void)removeUserDetailsDataInKeychainForZUID:(NSString *)zuid{
    [ZMacAuthKeyChainWrapper removeItemForKey:[self getUserDetailsKeyForZuid:zuid]];
}

-(NSString*) getDCLLocationForZuid:(NSString*) zuid {
    return [[self getFrequentlyUsedItemsDictForZuid:zuid] valueForKey:@"dcl_location"];
}

-(NSData*) getDCLMetaDataForZuid:(NSString*) zuid {
    return [[self getFrequentlyUsedItemsDictForZuid:zuid] valueForKey:@"dcl_meta"];
}


//MARK:- Keys
//
//-(NSString*) getClientSecretKeyForApp:(NSString *) app zuid:(NSString*) zuid {
//    NSString* client_secret_key = [NSString stringWithFormat:@"%@_%@",app,[self getDefaultZUIDIfNull:zuid app:app]];
//    client_secret_key = [client_secret_key stringByAppendingString:@"_Client_Secret"];
//    return client_secret_key;
//}
//
//-(NSString*) getRefreshTokenKeyForApp:(NSString *) app zuid:(NSString*) zuid {
//    NSString* refresh_token_key = [NSString stringWithFormat:@"%@_%@",app,[self getDefaultZUIDIfNull:zuid app:app]];
//    refresh_token_key = [refresh_token_key stringByAppendingString:@"_ZMacAuth_refresh_token"];
//    return refresh_token_key;
//}
//
//-(NSString*) getAccessTokenDictKeyForApp:(NSString*) app zuid:(NSString*) zuid {
//    NSString* access_token_key = [NSString stringWithFormat:@"%@_%@",app,[self getDefaultZUIDIfNull:zuid app:app]];
//    access_token_key = [access_token_key stringByAppendingString:@"_ZMacAuth_access_token_dictionary"];
//    return access_token_key;
//}
//
//-(NSString*) getCurrentUserKeyForApp:(NSString*) app {
//    NSString* current_user_key = [NSString stringWithFormat:@"%@",app];
//    current_user_key = [current_user_key stringByAppendingString:@"_current_user"];
//    return current_user_key;
//}
//
//-(NSString*) getUserDetailsKeyForApp:(NSString*) app zuid: (NSString*) zuid {
//    NSString* user_details_key = [NSString stringWithFormat:@"%@_%@_USERDETAIL",app,zuid];
//    return user_details_key;
//}
//
////-(NSString*) getUserDataKeyForApp:(NSString*) app zuid: (NSString*) zuid {
////    NSString* zuser_Key = [NSString stringWithFormat:@"%@_%@_ZUser",app,zuid];
////    return zuser_Key;
////}
//
//-(NSString*) getAccountURLKeyForApp:(NSString*) app zuid:(NSString*) zuid {
//    NSString *accountsURL_Key = [NSString stringWithFormat:@"%@_%@_ZMacAuth_AccountsURL",app,zuid];
//    return accountsURL_Key;
//}
//
//-(NSString*) getDCLLocationKeyForApp:(NSString*) app zuid:(NSString*) zuid {
//    NSString* dcl_location_key = [NSString stringWithFormat:@"%@_%@_dcl_location",app,zuid];
//    return dcl_location_key;
//}
//
//-(NSString*) getDCLMetaDataKeyForApp:(NSString*) app zuid:(NSString*) zuid {
//    NSString *dcl_meta_key = [NSString stringWithFormat:@"%@_%@_dcl_meta",app,zuid];
//    return dcl_meta_key;
//}
//
//-(NSString*) getZUIDsKeyForApp:(NSString *)app {
//    return [NSString stringWithFormat:@"%@_ZUIDs",app];
//}

-(NSString*) getDefaultZUIDIfNull:(NSString*) zuid app:(NSString*) app {
    return zuid == nil ? [self getCurrentUserForApp] : zuid;
}

@end
