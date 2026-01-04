//
//  LRUCache.h
//  CachePolicy
//
//  Created by Jaganraj Palanivel on 05/07/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LRUCache<KeyType, ObjectType> : NSObject
- (void)setObject:(ObjectType _Nonnull)obj forKey:(KeyType _Nonnull)key size:(int)objSize;
- (void)setObject:(ObjectType _Nonnull)obj forKey:(KeyType _Nonnull)key;
- (ObjectType _Nullable)objectForKey:(KeyType _Nonnull)key;
- (void)removeObjectForKey:(KeyType _Nonnull)key;
- (void)removeAllObjects;
- (NSUInteger)size;
- (void)evictPercent:(float) percent;

@property NSUInteger totalCostLimit;

- (void)printListOrder;
@end

NS_ASSUME_NONNULL_END
