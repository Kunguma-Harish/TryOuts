#pragma once
#include <iostream>
#include <functional>
#ifndef __CUSTOM_SHARED_PTR__
#include <memory>
#endif

#ifdef __CUSTOM_SHARED_PTR__
template <class T>
class GL_Ptr {
private:
    std::shared_ptr<T> object1;
    bool willDelete;

public:
    GL_Ptr(T* t, std::function<void(T* obj)> lambda) {
        object1 = std::shared_ptr<T>(t, lambda);
        willDelete = true;
    }
    GL_Ptr() {
        object1 = std::make_shared<T>();
    }
    GL_Ptr(T* t) {
        object1 = std::shared_ptr<T>(t);
        willDelete = true;
    }
    GL_Ptr(nullptr_t n) {
        object1 = nullptr;
        /// check this later
        willDelete = false;
    }
    auto getSharedPointer() {
        return object1;
    }
    auto get() {
        return object1.get();
    }
    bool isUnique() {
        return object1.unique();
    }
    T* operator->() {
        return object1.get();
    }
    bool operator==(T* t) {
        if (object1.get() == t) {
            return true;
        }
        return false;
    }
    bool operator!=(T* t) {
        if (object1.get() != t) {
            return true;
        }
        return false;
    }
    template <class U>
    T operator=(U u) {
        return static_cast<T>(u);
    }
};
#else
template <class T>
using GL_Ptr = std::shared_ptr<T>;
#endif

template <class T>
class GL_Ptrs {
public:
    static GL_Ptr<T> make_raw(T* t) {
        return GL_Ptr<T>(t, [](T* t) {});
    }
    static GL_Ptr<T> with_customDeleter(T* t, std::function<void(T* obj)> lambda) {
        return GL_Ptr<T>(t, lambda);
    }
};
