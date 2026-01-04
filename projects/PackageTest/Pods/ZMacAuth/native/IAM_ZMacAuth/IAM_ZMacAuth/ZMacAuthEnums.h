//
//  ZMacAuthEnums.h
//  IAM_ZMacAuth
//
//  Created by Kumareshwaran on 24/03/17.
//  Copyright © 2017 Dhanasekar K. All rights reserved.
//

#ifndef ZMacAuthEnums_h
#define ZMacAuthEnums_h


/**
 This specifies the Build type.
 */
typedef NS_ENUM(NSInteger, ZMacAuthBuildType)
{
    /**
     *  Points to localzoho server and ZMacAuth OneAuth Development setup. accounts.localzoho.com. You need to be connected to Zoho-Handhelds or ZohoCorp wifi to work in this mode.
     */
    Local_ZMacAuth_Development = 0,
    /**
     *  Points to localzoho Development server and ZMacAuth OneAuth Development setup. accounts-dev.localzoho.com. You need to be connected to Zoho-Handhelds or ZohoCorp wifi to work in this mode.
     */
    LocalDev_ZMacAuth_Development,
    /**
     *  Points to IDC server and ZMacAuth OneAuth Development/App Store setup. accounts.zoho.com.
     */
    Live_ZMacAuth,
    /**
     *  Points to accounts csez server and ZMacAuth OneAuth Development/App Store setup. accounts.csez.zohocorpin.com.
     */
    CSEZ_ZMacAuth_Dev,
    /**
     *  Points to accounts csez server and ZMacAuth OneAuth MDM App. accounts.csez.zohocorpin.com.
     */
    CSEZ_ZMacAuth_MDM,
    /**
     *  Points to preaccounts server and ZMacAuth OneAuth Development/App Store setup. preaccounts.zoho.com.
     */
    PRE_ZMacAuth_Dev,
    /**
     *  Points to preaccounts server and ZMacAuth OneAuth MDM App. preaccounts.zoho.com.
     */
    PRE_ZMacAuth_MDM,
    /**
     *  Points to iaccounts server and ZMacAuth OneAuth Development/App Store setup. iaccounts.zoho.com.
     */
    iAccounts_ZMacAuth_Dev,
    /**
     *  Points to iaccounts server and ZMacAuth OneAuth MDM App. iaccounts.zoho.com.
     */
    iAccounts_ZMacAuth_MDM,
    
};

#endif /* ZMacAuthEnums_h */
