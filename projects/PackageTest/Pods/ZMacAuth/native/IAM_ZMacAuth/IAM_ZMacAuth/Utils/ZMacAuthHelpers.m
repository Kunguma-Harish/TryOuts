//
//  ZMacAuthHelpers.m
//  ZMacAuth
//
//  Created by Kumareshwaran on 03/07/18.
//

#import "ZMacAuthHelpers.h"
#include "ZMacAuthUtilConstants.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import <sys/utsname.h>
#include <sys/time.h>
#include "ZMacAuthUser+Internal.h"
#include "ZMacAuthProfileData+Internal.h"
#import "ZMacAuthKeychainUtil.h"


@implementation ZMacAuthZIAMUtil(ZMacAuthHelpers)

-(void)initMode:(ZMacAuthBuildType)mode{
    
    if(mode == 0){
        BaseUrl = kLocalZoho_Base_URL;
        ContactsUrl = kCONTACTS_Localzoho_PROFILE_PHOTO;
    }else if(mode ==1){
        BaseUrl = kLocalZoho_DEV_Base_URL;
        ContactsUrl = kCONTACTS_Localzoho_PROFILE_PHOTO;
    }else if(mode ==2){
        BaseUrl = kZoho_Base_URL;
        ContactsUrl = kCONTACTS_Zoho_PROFILE_PHOTO;
    }else if(mode ==3){
        BaseUrl = kCSEZ_Base_URL;
        ContactsUrl = kContacts_CSEZ_Base_URL;
    }else if(mode ==4){
        BaseUrl = kCSEZ_Base_URL;
        ContactsUrl = kContacts_CSEZ_Base_URL;
    }else if(mode ==5){
        BaseUrl = kCSEZ_Base_URL;
        ContactsUrl = kContacts_CSEZ_Base_URL;
    }
}

-(NSString *) getUserAgentString
{
    NSString* deviceModel = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[self currentModel], NULL, (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ", CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
    NSString *version =[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];//It will update depends on the build number
    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    NSString *appversion = [NSString stringWithFormat:@"%@.%@",version,build];
    NSProcessInfo *pInfo = [NSProcessInfo processInfo];
    NSString *osversion = [pInfo operatingSystemVersionString];
    NSString *userAgent = [[NSString alloc] initWithFormat:@"ZMacAuth_%@_%@/%@ (OS X %@; Apple %@; ZC_OSX Extension)",kZMacAuthVersion,AppName,appversion,osversion,deviceModel];
    return userAgent;
}

- (NSString *)currentModel {
    size_t len = 0;
    sysctlbyname("hw.model", NULL, &len, NULL, 0);
    NSString *model;
    if (len) {
        char *modelChar = malloc(len*sizeof(char));
        sysctlbyname("hw.model", modelChar, &len, NULL, 0);
        model = [NSString stringWithUTF8String:modelChar];
        free(modelChar);
    }
    if ([model hasPrefix:@"MacPro"])
    {
        return @"MacPro";
    }
    
    else if ([model hasPrefix:@"iMac"])
    {
        return @"iMac";
    }
    
    else if ([model hasPrefix:@"MacBookPro"])
    {
        return @"MacBookPro";
    }
    
    else if ([model hasPrefix:@"MacBookAir"])
    {
        return @"MacBookAir";
    }
    
    else if ([model hasPrefix:@"MacBook"])
    {
        return @"MacBook";
    }
    
    else
    {
        return model;
    }
}

-(void)storeItemsInKeyChainOnSuccess{
    BOOL isHavingImage = NO;
    if(setProfileImageData){
        isHavingImage = YES;
    }
    
    long ZUID_long = [[setProfileInfoDict objectForKey:@"ZUID"] longValue];
    DLog(@"ZUID : %ld",ZUID_long);
    
    NSString *DisplayName = [setProfileInfoDict objectForKey:@"Display_Name"];
    
    DLog(@"DN: %@",DisplayName);
    
    NSString *EmailId = [setProfileInfoDict objectForKey: @"Email"];
    
    DLog(@"Email: %@",EmailId);
    
    
    NSString *ZUID =[NSString stringWithFormat: @"%ld", ZUID_long];
    DLog(@" String ZUID : %@",ZUID);
    
    NSMutableArray *userDetailArray;
    
    if(setProfileImageData){
        userDetailArray = @[DisplayName,EmailId,setProfileImageData];
    }else{
        userDetailArray = @[DisplayName,EmailId,[NSNull null]];
    }
    NSData *userDetailsdata = [NSKeyedArchiver archivedDataWithRootObject:userDetailArray];
    
    long millis = [[ZMacAuthZIAMUtil sharedUtil] getCurrentMilliSeconds];
    
    long expiresIn = [setExpiresIn longLongValue];
    
    long timeStampMillis = millis+expiresIn;
    
    NSString* timeStamp = [NSString stringWithFormat:@"%ld",timeStampMillis];
    
    NSArray *accessTokenArray = @[setAccessToken, timeStamp];
    NSMutableDictionary* access_token_dictionary = [NSMutableDictionary dictionaryWithObject:accessTokenArray forKey:Scopes];
    DLog(@"Dictionary check:%@",[access_token_dictionary objectForKey:Scopes]);
    
    NSData *dictionaryRep = [NSKeyedArchiver archivedDataWithRootObject:access_token_dictionary];
    [self storeFrequentlyUsedItemsInKeychainHavingClientSecret:setClientSecret refershToken:setRefreshToken accessTokenDictData:dictionaryRep currentUserZUID:ZUID accountsURL:setAccountsServerURL dcllocation:setLocation dclmeta:setBas64DCL_Meta_Data forZuid:ZUID];
    [self setUserDetailsDataInKeychainForZUID:ZUID userdetail:userDetailsdata];
    
//    ZMacAuthProfileData *profileData = [[ZMacAuthProfileData alloc]init];
//    [profileData initWithEmailid:EmailId
//                            name:DisplayName
//                     displayName:DisplayName
//                        hasImage:isHavingImage
//                profileImageData:setProfileImageData];
//
//    ZMacAuthUser *ZUser = [[ZMacAuthUser alloc]init];
//
//    NSArray *scopesArray = [[NSArray alloc]init];
//    scopesArray = [Scopes componentsSeparatedByString:@","];
//    [ZUser initWithZUID:ZUID
//                Profile:profileData accessibleScopes:scopesArray accountsUrl:setAccountsServerURL location:setLocation];
//
//    NSData *ZUserData = [NSKeyedArchiver archivedDataWithRootObject:ZUser];
//
//    [self removeZUserDataForApp:AppName zuid:ZUID];
//    [self setZUserData:ZUserData forApp:AppName zuid:ZUID];
}

-(long) getCurrentMilliSeconds {
    struct timeval time;
    gettimeofday(&time, NULL);
    long millis = (time.tv_sec * 1000) + (time.tv_usec / 1000);
    return millis;
}

-(void)clearDataForLogoutHavingZUID:(NSString *)zuid{
    [self removeFrequentlyUsedItemsInKeychainForZuid:zuid];
    [self removeUserDetailsDataInKeychainForZUID:zuid];
}

#pragma mark Helper to DCL

-(NSString *)transformURL:(NSString *)url AppName:(NSString *)appName zuid:(NSString*) zuid {
    
    //    NSString *zuid = [self getCurrentUserForApp:appName];
    NSString *dclLocation = [self getDCLLocationForZuid:zuid];
    
    if(dclLocation){
        return [self transformURL:url AppName:appName ZUID:zuid Location:dclLocation];
    }else{
        return url;
    }
    
    
}

-(NSDictionary *)getDCLInfoForCurrentUser{
    return [self getDCLInfoForZuid:[self getCurrentUserForApp]];
}

-(NSDictionary *)getDCLInfoForZuid: (NSString*) zuid {
    NSString *dclLocation = [self getDCLLocationForZuid:zuid];
    NSData *bas64Data = [self getDCLMetaDataForZuid:zuid];
    
    NSError *jsonError = nil;
    NSArray *JSONArray = [NSJSONSerialization JSONObjectWithData:bas64Data options:kNilOptions error:&jsonError];
    
    NSDictionary *TargetJSONDictionary = [[NSDictionary alloc] init];
    for (int i =0; i<[JSONArray count]; i++) {
        NSDictionary *JSONDictionary = JSONArray[i];
        NSString*location = [JSONDictionary valueForKey:@"location"];
        if([location isEqualToString:dclLocation]){
            TargetJSONDictionary = JSONDictionary;
            break;
        }
    }
    return TargetJSONDictionary;
}

-(NSString *)transformURL:(NSString *)url AppName:(NSString *)appName ZUID:(NSString *)zuid Location:(NSString *)dclLocation{
    return [self transformURL:url AppName:appName ZUID:zuid Location:dclLocation meta:[self getDCLMetaDataForZuid:zuid]];
}

-(NSString *)transformURL:(NSString *)url AppName:(NSString *)appName ZUID:(NSString *)zuid Location:(NSString *)dclLocation meta:(NSData *)dclmeta{
    
    if(!dclmeta)
        return url;
    
    NSError *jsonError = nil;
    NSArray *JSONArray = [NSJSONSerialization JSONObjectWithData:dclmeta options:kNilOptions error:&jsonError];
    
    
    
    NSDictionary *TargetJSONDictionary = [[NSDictionary alloc] init];
    for (int i =0; i<[JSONArray count]; i++) {
        NSDictionary *JSONDictionary = JSONArray[i];
        NSString*location = [JSONDictionary valueForKey:@"location"];
        if([location isEqualToString:dclLocation]){
            TargetJSONDictionary = JSONDictionary;
            break;
        }
    }
    
    NSNumber *isPrefixed =(NSNumber *)[TargetJSONDictionary objectForKey:@"is_prefixed"];
    
    NSString * transformedURL = url;
    NSString *oldPrefix = @"";
    
    BOOL isDomainKnown = false;
    BOOL isWWWDomain = false;
    
    
    NSString *scheme = @"https://";
    
    if ([transformedURL hasPrefix:@"http:"]){
        
        scheme = @"http://";
        
    }
    
    // Remove scheme from URL
    
    if([transformedURL hasPrefix:@"http:"] || [transformedURL hasPrefix:@"https:"]){
        NSString *original;
        if([transformedURL hasPrefix:@"http:"]){
            original = @"http://";
        }else{
            original = @"https://";
        }
        NSString *replacement = @"";
        NSRange rOriginal = [transformedURL rangeOfString: original];
        if (NSNotFound != rOriginal.location) {
            transformedURL = [transformedURL
                              stringByReplacingCharactersInRange: rOriginal
                              withString:                         replacement];
        }
    }
    
    if([transformedURL hasPrefix:@"www."]){
        
        isWWWDomain = true;
        NSString *original = @"www.";
        NSString *replacement = @"";
        NSRange rOriginal = [transformedURL rangeOfString: original];
        if (NSNotFound != rOriginal.location) {
            transformedURL = [transformedURL
                              stringByReplacingCharactersInRange: rOriginal
                              withString:                         replacement];
        }
    }
    
    // Identify white-listed location/dcl prefix
    BOOL isWhiteListedPrefix = false;
    NSArray *prefixArray = [transformedURL componentsSeparatedByString: @"-"];
    NSString *prefix = prefixArray[0];
    for (int i =0; i<[JSONArray count]; i++) {
        NSDictionary *JSONDictionary = JSONArray[i];
        if([prefix isEqualToString:[JSONDictionary valueForKey:@"location"]]){
            isWhiteListedPrefix = true;
            break;
        }
    }
    if ([transformedURL rangeOfString:@"-"].location != NSNotFound && isWhiteListedPrefix) {
        
        oldPrefix = prefix;
        
        NSRange range1 = [transformedURL rangeOfString:prefix];
        range1.length = range1.length+1;
        transformedURL = [transformedURL
                          stringByReplacingCharactersInRange:range1
                          withString:@""];
        
    }
    
    NSString *domain = transformedURL;
    
    NSString *path = nil;
    NSString *qs = nil;
    
    
    
    // Split service url/path from domain
    
    //if ([transformedURL rangeOfString:@"/"].location == NSNotFound) {// No I18N
    if ([transformedURL containsString:@"/"]) {// No I18N
        int range = (int)[transformedURL rangeOfString:@"/"].location;
        domain = [transformedURL substringWithRange:NSMakeRange(0, range)];
        path = [transformedURL substringWithRange:NSMakeRange(range, [transformedURL length]-range)];
    }
    
    //Resolving Query String
    if([domain containsString:@"?"]){
        int range = (int)[transformedURL rangeOfString:@"?"].location;
        domain = [transformedURL substringWithRange:NSMakeRange(0, range)];
        qs = [transformedURL substringWithRange:NSMakeRange(range, [transformedURL length]-range)];
    }
    
    
    //Replace zoho.com or zoho.eu or zoho.in to required string from json
    
    for(int i=0;i<[JSONArray count];i++){
        NSDictionary *JSONDictionary = JSONArray[i];
        NSString *baseDomain = [JSONDictionary valueForKey:@"basedomain"];
        if([domain hasSuffix:baseDomain]){
            NSString *replacement = [TargetJSONDictionary objectForKey:@"basedomain"];
            NSRange rOriginal = [domain rangeOfString: baseDomain];
            if (NSNotFound != rOriginal.location) {
                domain = [domain
                          stringByReplacingCharactersInRange: rOriginal
                          withString:                         replacement];
                if([domain isEqualToString:replacement]){
                    if([isPrefixed boolValue]){
                        domain = [NSString stringWithFormat:@"%@.%@",replacement,domain];
                    }
                }else{
                    isDomainKnown = true;
                }
            }
            break;
        }else if ([TargetJSONDictionary objectForKey:@"equivalent_basedomains"] && [[TargetJSONDictionary objectForKey:@"equivalent_basedomains"] length]>0){
            NSString *ebds = [TargetJSONDictionary objectForKey:@"equivalent_basedomains"];
            NSArray *ebdsArray = [ebds componentsSeparatedByString: @","];
            NSString *ebdregex = @"";
            NSString *domainregex = @"";
            for (id ebd in ebdsArray) {
                NSString *replacedEbd =  [ebd stringByReplacingOccurrencesOfString: @"." withString:@"\\."];
                ebdregex = [NSString stringWithFormat:@"%@([^.]*%@$)|",ebdregex,replacedEbd];
                domainregex = [NSString stringWithFormat:@"%@(.*%@$)|",domainregex,replacedEbd];
            }
            if([ebdregex length]>0 ){
                ebdregex = [ebdregex substringToIndex:[ebdregex length]-2];
                domainregex = [domainregex substringToIndex:[domainregex length]-2];
                NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:ebdregex options:4 error:NULL];
                NSTextCheckingResult *match = [regex firstMatchInString:domain options:0 range:NSMakeRange(0, [domain length])];
                if([match numberOfRanges]>0){
                    NSRegularExpression *regexsd = [[NSRegularExpression alloc] initWithPattern:domainregex options:4 error:NULL];
                    NSTextCheckingResult *matchsd = [regexsd firstMatchInString:domain options:0 range:NSMakeRange(0, [domain length])];
                    if([matchsd numberOfRanges]>0){
                        NSString *subDomain = [domain stringByReplacingCharactersInRange:[matchsd range] withString:@""];
                        NSRange rOriginal = [domain rangeOfString: subDomain];
                        if (NSNotFound != rOriginal.location) {
                            NSString *tld = [domain
                                             stringByReplacingCharactersInRange: rOriginal
                                             withString:@""];
                            domain = [NSString stringWithFormat:@"%@%@",subDomain,tld];
                        }
                        
                    }
                    break;
                }
            }
        }
    }
    
    // construct final transformed URL
    
    transformedURL = [NSString stringWithFormat:@"%@",scheme];
    if(isWWWDomain){
        transformedURL = [NSString stringWithFormat:@"%@www.",transformedURL];
    }
    
    
    
    if(isDomainKnown && [isPrefixed boolValue] ){
        transformedURL = [NSString stringWithFormat:@"%@%@-",transformedURL,[TargetJSONDictionary objectForKey:@"location"]];
    }else{
        if(!isDomainKnown){
            transformedURL = [NSString stringWithFormat:@"%@%@-",transformedURL,oldPrefix];
        }
    }
    transformedURL = [NSString stringWithFormat:@"%@%@",transformedURL,domain];
    if(path!=nil){
        transformedURL = [NSString stringWithFormat:@"%@%@",transformedURL,path];
    }
    if(qs!=nil){
        transformedURL = [NSString stringWithFormat:@"%@%@",transformedURL,qs];
    }
    DLog(@"Final Transformed URL : %@",transformedURL);
    return transformedURL;
}

-(BOOL)isUserSignedIn{
    if([self getCurrentUserForApp]){
        return YES;
    }
    return NO;
}

-(NSMutableDictionary *)getUserInfoFromError:(NSError *)error{
    NSString *errorMessage = [error.userInfo valueForKey:@"error"];
    if (!errorMessage) {
        errorMessage = @"error";
    }
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]init];
    [userInfo setValue:errorMessage forKey:NSLocalizedDescriptionKey];
    return userInfo;
}
@end
