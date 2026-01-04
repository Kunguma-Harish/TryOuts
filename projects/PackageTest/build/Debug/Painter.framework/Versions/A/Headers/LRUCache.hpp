//
//  LRUCache.hpp
//  CachePolicy
//
//  Created by Jaganraj Palanivel on 17/06/22.
//

#ifdef __cplusplus

#ifndef LRUCache_hpp
#define LRUCache_hpp

#include <unordered_map>
#include <list>
#include <string>
#include <ctime>
#include <iostream>
#include <optional>
#include <atomic>
#include <shared_mutex>

namespace CachePolicy {
template<class Key, class Value>
struct CacheBlock {
	int size;
	time_t lastaccessedTime;
	int hits;
	Value value;
	Key key;
};

template<class Key, class Value, class Hash = std::hash<Key>>
class LRUCache {
private:
	std::list<CacheBlock<Key, Value> *> list; //usually implemented as a doubly-linked list
	std::unordered_map<Key, typename std::list<CacheBlock<Key, Value> *>::iterator, Hash> hashmap;
	std::atomic_uint occupiedSize;
	std::atomic_uint allowedSize = 0; //0 is unlimited size
	mutable std::shared_mutex mutex;

public:
	void setObject(const Key& key, const Value& value, int size);
	std::optional<Value> objectForKey(const Key& key);
	void removeObject(const Key& key);
	void clear();
	int size();
	void evictPercent(float percent);
	void evict(int size);
	int limit();
	void setLimit(int limit);

	//debug methods
	void printListOrder();
};

template <class Key, class Value, class Hash>
void LRUCache<Key, Value, Hash>::setObject(const Key& key, const Value& value, int size) {
	CacheBlock<Key, Value> *block = new CacheBlock<Key, Value>;
	block->value = value;
	block->key = key;
	block->size = size;

	if (allowedSize != 0 && occupiedSize + size > allowedSize) {
		evict(occupiedSize + size - allowedSize);
	}

	mutex.lock();
	list.push_front(block);
	hashmap[key] = list.begin();
	occupiedSize += block->size;
	mutex.unlock();
}

template <class Key, class Value, class Hash>
std::optional<Value> LRUCache<Key, Value, Hash>::objectForKey(const Key& key) {
	mutex.lock();
	const auto& itr = hashmap.find(key);
	if (itr != hashmap.end()) {
		CacheBlock<Key, Value> *block = *(itr->second);
		list.splice(list.end(), list, itr->second);
		mutex.unlock();
		return block->value;
	}
	mutex.unlock();
	return std::nullopt;
}

template <class Key, class Value, class Hash>
void LRUCache<Key, Value, Hash>::removeObject(const Key& key) {
	mutex.lock();
	const auto& itr = hashmap.find(key);
	if (itr != hashmap.end()) {
		CacheBlock<Key, Value> *block = *(itr->second);
		list.erase(itr->second);
		hashmap.erase(itr);
		occupiedSize -= block->size;
		delete block;
	}
	mutex.unlock();
}

template <class Key, class Value, class Hash>
void LRUCache<Key, Value, Hash>::clear() {
	mutex.lock();
	for (const CacheBlock<Key, Value> *block : list) {
		delete block;
	}
	list.clear();
	hashmap.clear();
	occupiedSize = 0;
	mutex.unlock();
}

template <class Key, class Value, class Hash>
int LRUCache<Key, Value, Hash>::size() {
	return occupiedSize;
}

template <class Key, class Value, class Hash>
void LRUCache<Key, Value, Hash>::evictPercent(float percent) {
	int fifty_percent = int((percent / 100.0 )* occupiedSize);
	evict(fifty_percent);
}

template <class Key, class Value, class Hash>
void LRUCache<Key, Value, Hash>::evict(int size) {
	while (size > 0) {
		mutex.lock_shared();
		CacheBlock<Key, Value> *front = list.front();
		mutex.unlock_shared();
		size -= front->size;
		removeObject(front->key);
	}
}

template <class Key, class Value, class Hash>
void LRUCache<Key, Value, Hash>::printListOrder() {
	mutex.lock_shared();
	for(CacheBlock<Key, Value> *val : list) {
		std::cout << &val->key << "\n";
	}
	mutex.unlock_shared();
}

template <class Key, class Value, class Hash>
int LRUCache<Key, Value, Hash>::limit() {
	return allowedSize;
}

template <class Key, class Value, class Hash>
void LRUCache<Key, Value, Hash>::setLimit(int limit) {
	allowedSize = limit;
	if (allowedSize != 0 && occupiedSize > allowedSize) {
		evict(occupiedSize - allowedSize);
	}
}
}

#endif /* LRUCache_hpp */
#endif /* __cplusplus */
