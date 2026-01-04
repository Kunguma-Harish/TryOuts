//
//  NLRepeatedPtrField.hpp
//  NLProtoGenerator
//
//  Created by kunguma-14252 on 15/05/25.
//

#ifndef NLRepeatedPtrField_hpp
#define NLRepeatedPtrField_hpp

#import <Foundation/Foundation.h>

@interface NLRepeatedPtrField<ObjectType> : NSObject
- (NSUInteger)count;
- (ObjectType)get:(NSUInteger)index;
@end

#endif /* NLRepeatedPtrField_hpp */

#ifdef __cplusplus

#define DEFINE_REPEATED_PTR_FIELD_WRAPPER(WrapperClassName, CppType, ObjCType)        \
@interface WrapperClassName : NLRepeatedPtrField<ObjCType *>                \
- (instancetype)init:(const google::protobuf::RepeatedPtrField<CppType>*)pointer; \
@end

#else

#define DEFINE_REPEATED_PTR_FIELD_WRAPPER(WrapperClassName, CppType, ObjCType)        \
@interface WrapperClassName : NLRepeatedPtrField<ObjCType *>                \
@end

#endif

#define IMPLEMENT_REPEATED_PTR_FIELD_WRAPPER(WrapperClassName, CppType, ObjCType)        \
@implementation WrapperClassName {                                              \
    const google::protobuf::RepeatedPtrField<CppType> *repeatedField;                  \
}                                                                               \
- (instancetype)init:(const google::protobuf::RepeatedPtrField<CppType>*)pointer { \
    self = [super init];                                                        \
    if (self) {                                                                 \
        self->repeatedField = pointer;                                           \
    }                                                                           \
    return self;                                                                \
}                                                                               \
- (NSUInteger)count {                                                           \
    return self->repeatedField->size();                                         \
}                                                                               \
- (ObjCType *)get:(NSUInteger)index {                                 \
    return [[ObjCType alloc] init:&self->repeatedField->Get(index)];           \
}                                                                               \
@end
