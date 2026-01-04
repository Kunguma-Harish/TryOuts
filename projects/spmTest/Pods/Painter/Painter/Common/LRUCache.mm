//
//  LRUCache.m
//  CachePolicy
//
//  Created by Jaganraj Palanivel on 05/07/22.
//

#import "LRUCache.h"
#import "LRUCache.hpp"
#import <Foundation/NSString.h>
#include <malloc/malloc.h>

struct Container {
	id value;
};

bool operator==(const Container& x, const Container& y) {
	return  [x.value isEqual: y.value];
}

struct HashContainer
{
	size_t operator()(const Container& foo) const {
		return [foo.value hash];
	}
};

#if TARGET_OS_IOS
#import <UIKit/UIKit.h>
NSNotificationName memoryWarningNotification = UIApplicationDidReceiveMemoryWarningNotification;
#endif

@implementation LRUCache
{
	CachePolicy::LRUCache<Container, Container, HashContainer> cache;
}

@synthesize totalCostLimit = _totalCostLimit;

#if TARGET_OS_IOS
- (id) init {
	self = [super init];
	[[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(didReceiveMemoryWarning) name:memoryWarningNotification object:nil];
	return self;
}

- (void) didReceiveMemoryWarning {
	[self evictPercent:50.0];
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}
#endif

- (void)setObject:(id)obj forKey:(id)key size:(int)objSize {
	Container cKey = { key };
	Container cObj = { obj };
	cache.setObject(cKey, cObj, objSize);
}

- (void)setObject:(id)obj forKey:(id)key {
    int size = (int)malloc_size((__bridge const void *)(obj));
    [self setObject:obj forKey:key size:size];
}

- (id)objectForKey:(id)key {
	Container cKey = { key };
	std::optional<Container> value = cache.objectForKey(cKey);
	if (value) {
		return value->value;
	}
	return  nullptr;
}

- (void)removeObjectForKey:(id)key {
	Container cKey = { key };
	cache.removeObject(cKey);
}

- (void)removeAllObjects {
	cache.clear();
}

- (NSUInteger)size {
	return cache.size();
}

- (void)evictPercent:(float) percent; {
	cache.evictPercent(percent);
}

- (void)printListOrder {
	cache.printListOrder();
}

- (void)setTotalCostLimit:(NSUInteger)totalCostLimit {
	cache.setLimit((int)totalCostLimit);
}

- (NSUInteger)totalCostLimit {
	return cache.limit();
}
@end
