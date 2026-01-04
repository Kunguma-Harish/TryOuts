//
//  ZMacAuthProfileData+Internal.h
//  IAM_SSO
//
//  Created by Kumareshwaran on 26/03/17.
//  Copyright © 2017 Dhanasekar K. All rights reserved.
//

#ifndef ZMacAuthProfileData_Internal_h
#define ZMacAuthProfileData_Internal_h
#import "ZMacAuthProfileData.h"

@interface ZMacAuthProfileData(){
    
}
// The Zoho user's email.
@property(nonatomic, readwrite) NSString *email;

// The Zoho user's full name.
@property(nonatomic, readwrite) NSString *name;

// The Zoho user's display name.
@property(nonatomic, readwrite) NSString *displayName;

// Whether or not the user has profile image.
@property(nonatomic, readwrite) BOOL hasImage;

// The Zoho user's profile image data.
@property(nonatomic, readwrite) NSData * profileImageData;

-(void)initWithEmailid:(NSString *)emailid name:(NSString *)username displayName:(NSString *)userDisplayName hasImage:(BOOL)isHavingPhoto profileImageData:(NSData *)photoData;
-(ZMacAuthProfileData *)initWithProfileObject:(ZMacAuthProfileData *)profileObject;

@end
#endif /* ZMacAuthProfileData_Internal_h */
