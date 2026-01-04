//
//  ZMacAuthConstants.h
//  Pods
//
//  Created by Kumareshwaran on 24/03/17.
//
//

#ifndef ZMacAuthConstants_h
#define ZMacAuthConstants_h


/**
 * Unable to fetch token from server.
 */
static const int k_ZMacAuthTokenFetchError = 201;
/**
 * Access token fetch:Response is nil.
 */
static const int k_ZMacAuthTokenFetchNil = 202;
/**
 * Unable to fetch token. Nothing was received.
 */
static const int k_ZMacAuthTokenFetchNothingReceived = 204;
/**
 * Unable to fetch token. GeneralError.
 */
static const int k_ZMacAuthTokenFetchGeneralError = 205;
/**
 * There is no access token.
 */
static const int k_ZMacAuthNoAccessToken = 302;
/**
 *  Unable to fetch user's profile info.
 */
static const int k_SSOUserInfoFetchError = 601;
/**
 * User's profile info fetch:Response is nil.
 */
static const int k_SSOUserInfoFetchNil = 602;
/**
 * Unable to fetch user's profile info. Nothing was received.
 */
static const int k_SSOUserInfoFetchNothingReceived = 604;
/**
 * Unable to fetch user's profile photo. Some error occured.
 */
static const int k_SSOUserPhotoFetchError = 701;
/**
 * Unable to fetch user's profile photo. Nothing was received.
 */
static const int k_SSOUserPhotoFetchNothingReceived = 704;
/**
 * Unable to revoke token.
 */
static const int k_ZMacAuthRevokeTokenError = 801;
/**
 * Revoke token fetch:Response is nil.
 */
static const int k_ZMacAuthRevokeTokenResultNil = 802;
/**
 * Revoke token fetch. Nothing was received.
 */
static const int k_ZMacAuthRevokeTokenNothingReceived = 804;
/**
 * Network call failed with unknown error.
 */
static const int k_ZMacAuthGenericError = 901;
/**
 * Unable to fetch Refresh token from server.
 */
static const int k_ZMacAuthRefreshTokenFetchError = 901;
/**
 * Refresh token fetch:Response is nil.
 */
static const int k_ZMacAuthRefreshTokenFetchNil = 902;
/**
 * Unable to fetch Refresh token. Nothing was received.
 */
static const int k_ZMacAuthRefreshTokenFetchNothingReceived = 904;
/**
 * OAuth Server Error Occured during redirection
 */
static const int k_ZMacAuthOAuthServerError = 905;
/**
 * There is no access token for the given scopes.
 */
static const int k_ZMacAuthScopeNotFound = 906;
/**
 * Unable to Enhance Scope from server.
 */
static const int k_ZMacAuthScopeEnhancementFetchError = 1001;
/**
 * Scope Enhancement:Response is nil.
 */
static const int k_ZMacAuthScopeEnhancementFetchNil = 1002;
/**
 * Unable to Enhance Scope. Nothing was received.
 */
static const int k_ZMacAuthScopeEnhancementFetchNothingReceived = 1003;
/**
 * OAuth Scope Enhancement Server Error Occured during redirection
 */
static const int k_ZMacAuthScopeEnhancementServerError = 1004;
/**
 * OAuth Scope Enhancement Done button tapped on SFSafari page
 */
static const int k_ZMacAuthScopeEnhancementDismissedError = 1005;
/**
 * AddSecondaryEmail error
 */
static const int k_ZMacAuthAddSecondaryEmailServerError = 8001;
/**
 * Unable to get OAuth token using AuthToken from server.
 */
static const int k_ZMacAuthAuthToOAuthFetchError = 2001;
/**
 * Auth to OAuth:Response is nil.
 */
static const int k_ZMacAuthAuthToOAuthFetchNil = 2002;
/**
 * Unable to OAuth token using AuthToken. Nothing was received.
 */
static const int k_ZMacAuthAuthToOAuthNothingReceived = 2003;
/**
 * OAuth to Auth Server Error Occured during redirection
 */
static const int k_ZMacAuthAuthToOAuthServerError = 2004;

#endif /* ZMacAuthConstants_h */
