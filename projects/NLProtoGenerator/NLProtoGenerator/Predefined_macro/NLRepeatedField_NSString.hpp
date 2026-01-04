#ifndef NLRepeatedField_NSString_hpp
#define NLRepeatedField_NSString_hpp

#import <Foundation/Foundation.h>
#include "NLRepeatedPtrField.hpp"

#ifdef __cplusplus
namespace google::protobuf {
template <typename T>
class RepeatedPtrField;
}
#endif

@interface NLRepeatedField_NSString : NSObject
//- (NSUInteger)count;
//- (NSString *)get:(NSUInteger)index;
@end

#endif
