//
//  ZMacAuthUser+Internal.h
//  IAM_SSO
//
//  Created by Kumareshwaran on 26/03/17.
//  Copyright © 2017 Dhanasekar K. All rights reserved.
//

#ifndef ZMacAuthUser_Internal_h
#define ZMacAuthUser_Internal_h
#import "ZMacAuthUser.h"
@interface ZMacAuthUser() {
    
}
// Zoho user ID(ZUID).
@property(nonatomic, readwrite) NSString *userZUID;

// Representation of the Basic profile data. It is only available if |SignIn| has been completed successfully.
@property(nonatomic, readwrite) ZMacAuthProfileData *profile;

// The API scopes requested by the app in an array of |NSString|s.
@property(nonatomic, readwrite) NSArray *accessibleScopes;

// Zoho accounts url of the user.
@property(nonatomic, readwrite) NSString *accountsUrl;

// Zoho location of the user.
@property(nonatomic, readwrite) NSString *location;

-(void)initWithZUID:(NSString*)zuid Profile:(ZMacAuthProfileData *)profiledata accessibleScopes:(NSArray*)scopeArray accountsUrl:(NSString *)accountsserver location:(NSString *)dcllocation;
- (id)initWithCoder:(NSCoder *)coder;

@end

#endif /* ZMacAuthUser_Internal_h */
