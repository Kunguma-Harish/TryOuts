//
//  ZMacAuthUtilConstants.h
//  ZohoSSO
//
//  Created by Kumareshwaran on 1/25/16.
//  Copyright © 2016 Dhanasekar K. All rights reserved.
//

#ifndef ZMacAuthUtilConstants_h
#define ZMacAuthUtilConstants_h

#ifdef DEBUG
#	define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#	define DLog(...)
#endif

#define kZMacAuthVersion @"1.0.4-beta2"

#define kServiceKeychainItem @"com.zoho.ZMacAuth.oauth"
#define kZMacAuthErrorDomain @"com.zoho.zmacauth"

#define SHARED_SECRET @"1234567890123456"

//API End Points
#define kZMacAuthAccountsSignUp_URL @"/accounts/register?servicename=aaaserver"
#define kZMacAuthRevoke_URL @"/oauth/v2/token/revoke"
#define kZMacAuthScopeEnhancement_URL @"/oauth/v2/token/internal/getextrascopes"
#define kZMacAuthAddScope_URL @"/oauth/v2/token/addscope"
#define kZMacAuthAuthToOAuth_URL @"/oauth/v2/token/internal/authtooauth"
#define kZMacAuthFetchToken_URL @"/oauth/v2/token"
#define kZMacAuthClientPortalRemoteLogin_URL @"/oauth/v2/mobile/internal/getremoteloginkey"
#define kZMacAuthFetchUserInfo_URL @"/oauth/user/info"
#define kZMacAuthMobileAuth_URL @"/oauth/v2/mobile/auth"
#define kZMacAuthUnconfirmedUser_URL @"/oauth/v2/mobile/unconfirmed"
#define kZMacAuthAddSecondaryEmailToken_URL @"/api/v1/ssokit/token"
#define kZMacAuthAddSecondaryEmail_URL @"/ssokit/addemail"
#define kZMacAuthSendOTPMobile @"/ssokit/v1/user/self/mobile"

//Base URL's
#define kCSEZ_Base_URL @"https://accounts.csez.zohocorpin.com"

#define kLocalZoho_Base_URL @"https://accounts.localzoho.com"
#define kLocalZoho_DEV_Base_URL @"https://accounts-dev.localzoho.com"

#define kCONTACTS_Localzoho_PROFILE_PHOTO @"https://contacts.localzoho.com/file/download"

#define kContacts_CSEZ_Base_URL @"https://contacts.csez.zohocorpin.com"

#define kCONTACTS_prezoho_PROFILE_PHOTO @"https://precontacts.zoho.com/file/download"

#define kZoho_Pre_URL @"https://preaccounts.zoho.com"
#define kZoho_iAccounts_URL @"https://iaccounts.zoho.com"

#define kAccountsSkyDesk_URL @"https://accounts.skydesk.jp"
#define kAccountsSkyDeskStage_URL @"https://accounts.stage.skydesk.jp"
#define kAccountsSkyDeskPre_URL @"https://preaccounts.skydesk.jp"

#define kContactsSkyDesk_URL @"https://contacts.skydesk.jp"
#define kContactsSkyDeskStage_URL @"https://contacts.stage.skydesk.jp"
#define kContactsSkyDeskPre_URL @"https://contacts.skydesk.jp"



#define kZoho_Base_URL @"https://accounts.zoho.com"
#define kCONTACTS_Zoho_PROFILE_PHOTO @"https://contacts.zoho.com/file/download"

#define kZoho_CN_Base_URL @"https://accounts.zoho.com.cn"
#define kCONTACTS_Zoho_CN_PROFILE_PHOTO @"https://contacts.zoho.com.cn/file/download"
#endif /* ZMacAuthUtilConstants_h */
