#pragma once

#ifdef __EMSCRIPTEN__
#include <emscripten.h>
#include <emscripten/val.h>
#endif
#if defined(NL_ENABLE_NEXUS) && defined(NL_BINDING_LANG_JAVASCRIPT)
#include<nexus_support/web_idl/nexus_support_emcc.hpp>
#endif
#if defined(NL_ENABLE_NEXUS) && defined(NL_BINDING_LANG_JAVA)
#include<nexus_support/JNI/nexus_support.hpp>
#endif
#include <functional>
#include <skia-extension/core/types.h>
// #include <painter/shapespainter_export.h>

#define __GC_UTIL_GET_STRING(X) #X
#define GC_UTIL_GET_STRING(X) __GC_UTIL_GET_STRING(X)

namespace graphikos {
namespace painter {

template <typename T>
class  Callback {
    std::function<T> f = nullptr;
#ifdef __EMSCRIPTEN__
    emscripten::val emsF = emscripten::val::undefined();
#endif

public:
    Callback() {}
    Callback(std::function<T> f) {
        this->f = f;
    }
#ifdef __EMSCRIPTEN__
    Callback(emscripten::val emsF) {
        this->emsF = emsF;
    }
#endif
    template <typename... Args>
    void fireEvent(Args... args) {
        if (f) {
            f(args...);
        }
#ifdef __EMSCRIPTEN__
        if (emsF != emscripten::val::undefined()) {
            emsF(args...);
        }
#endif
    }

    template <typename... Args>
    typename std::function<T>::result_type fireEventWithReturn(Args... args) {
        if (f) {
            return f(args...);
        }
#ifdef __EMSCRIPTEN__
        if (emsF != emscripten::val::undefined()) {
            emscripten::val returnValue = emsF(args...);
            return returnValue.as<typename std::function<T>::result_type>();
        }
#endif
    }

    bool isEmpty() {
        return f == nullptr
#ifdef __EMSCRIPTEN__
               && emsF == emscripten::val::undefined()
#endif
            ;
    }
};
}
}

#define SET_FUNC_NAME(CALLBACK_NAME) \
    set##CALLBACK_NAME

#define FIRE_EVENT_VAR(CALLBACK_NAME) \
    _fire##CALLBACK_NAME

#define FIRE_EVENTS_VAR(CALLBACK_NAME) \
    _fire##CALLBACK_NAME##s

#define FIRE_EVENT(CALLBACK_FN, ARGS)   \
    if (!CALLBACK_FN.isEmpty()) {       \
        CALLBACK_FN.fireEvent(ARGS...); \
    }

#if defined(NL_ENABLE_NEXUS)
    template <typename T, typename... Args>
    struct first_type {
        using type = T;
    };
    #define FIRE_EVENT_NEXUS(CALLBACK_FN, ARGS) \
         if (CALLBACK_FN.function_id!=NXC_NO_CALLBACK) {      \
            CALLBACK_FN.fireEvent(ARGS...); \
        } 
    
    #define FIRE_EVENT_NEXUS_WITH_RETURN(CALLBACK_FN, ARGS) \
         if (CALLBACK_FN.function_id!=NXC_NO_CALLBACK) {      \
            return CALLBACK_FN.fireEventWithReturn(ARGS...); \
        } 

    #define NEW_CALLBACK_NEXUS(CALLBACK_NAME, ...) \
        NXCallBack<__VA_ARGS__> FIRE_EVENT_VAR(CALLBACK_NAME)


    #define SET_EVENT_NEXUS(CALLBACK_NAME, ...)                                         \
        void SET_FUNC_NAME(CALLBACK_NAME)(NXCallBack<__VA_ARGS__> cb) { \
            FIRE_EVENT_VAR(CALLBACK_NAME) = cb;                                             \
        }

    #define CHECK_EVENT_NEXUS_WITH_RETURN(CALLBACK_FN) \
        return (CALLBACK_FN.function_id != NXC_NO_CALLBACK);

    #define CREATE_CALLBACK_NEXUS(CALLBACK_NAME, ...)                \
        NEW_CALLBACK_NEXUS(CALLBACK_NAME, __VA_ARGS__);                      \
        template <typename... Args>                          \
        void fire##CALLBACK_NAME(Args... args) {             \
            FIRE_EVENT_NEXUS(FIRE_EVENT_VAR(CALLBACK_NAME), args); \
        }                                                    \
        SET_EVENT_NEXUS(CALLBACK_NAME, __VA_ARGS__);

    #define CREATE_CALLBACK_NEXUS_WITH_RETURN(CALLBACK_NAME, ...)                \
        NEW_CALLBACK_NEXUS(CALLBACK_NAME, __VA_ARGS__);                      \
        template <typename... Args>                          \
        typename first_type<__VA_ARGS__>::type fire##CALLBACK_NAME(Args... args) {             \
            FIRE_EVENT_NEXUS_WITH_RETURN(FIRE_EVENT_VAR(CALLBACK_NAME), args); \
        }                                                                        \
        bool isSet##CALLBACK_NAME() {                                           \
            CHECK_EVENT_NEXUS_WITH_RETURN(FIRE_EVENT_VAR(CALLBACK_NAME));       \
        }                                                                        \
        SET_EVENT_NEXUS(CALLBACK_NAME, __VA_ARGS__);

    #define CREATE_CALLBACK_STATIC_NEXUS(CALLBACK_NAME, ...)                                                        \
        static NEW_CALLBACK_NEXUS(CALLBACK_NAME, __VA_ARGS__);                                                              \
        template <typename... Args>                                                                         \
        GL_DPR("Static callbacks are dangerous, don't use them! Will be removed in the next major version") \
        static void fire##CALLBACK_NAME(Args... args) {                                                     \
        FIRE_EVENT_NEXUS(FIRE_EVENT_VAR(CALLBACK_NAME), args);                                                \
    }                                                                                                   \
        GL_DPR("Static callbacks are dangerous, don't use them! Will be removed in the next major version") \
        static SET_EVENT_NEXUS(CALLBACK_NAME, __VA_ARGS__);

    #define CALLBACK_STATIC_DEFINITION_NEXUS(CLASS_NAME, CALLBACK_NAME, ...) \
        NXCallBack<__VA_ARGS__> CLASS_NAME::FIRE_EVENT_VAR(CALLBACK_NAME)
    
template <typename ReturnType ,typename... Args>
class NXCallbackHandler{
private:
    std::vector<NXCallBack<ReturnType,Args...>> callbacks;

public:
    void add(NXCallBack<ReturnType , Args...> cb) {
        callbacks.emplace_back(cb);
    }

    void fire(Args... args) {
        for (auto& fn : callbacks) {
            if (fn.function_id!=NXC_NO_CALLBACK) {
                fn.fireEvent(args...);
            }
        }
    }
};

template <typename... Args>
class NXCallbackHandler<void, Args...>{
private:
    std::vector<NXCallBack<void,Args...>> callbacks;

public:
    void add(NXCallBack<void , Args...> cb) {
        callbacks.emplace_back(cb);
    }

    void fire(Args... args) {
        for (auto& fn : callbacks) {
            if (fn.function_id!=NXC_NO_CALLBACK) {
                fn.fireEvent(args...);
            }
        }
    }
};

template <typename ReturnType ,typename... Args>
class NXCallbackHandlerWithReturn {
private:
    std::vector<NXCallBack<ReturnType, Args...>> callbacks;
    std::vector<ReturnType> returnValues;

public:
    void add(NXCallBack<ReturnType , Args...> cb) {
        callbacks.emplace_back(cb);
    }

    std::vector<ReturnType> fire(Args... args) {
        returnValues.clear();
        for (auto& fn : callbacks) {
            if (fn.function_id!=NXC_NO_CALLBACK) {
                auto value = fn.fireEventWithReturn(args...);
                returnValues.emplace_back(value);
            }
        }
        return returnValues;
    }
    bool isSet() const {                      
        return callbacks.size();                    
    }   
};
#endif

#define FIRE_EVENTS(CALLBACK_NAME, ARGS)              \
    for (auto& fn : FIRE_EVENTS_VAR(CALLBACK_NAME)) { \
        FIRE_EVENT(fn, ARGS);                         \
    }

#define NEW_CALLBACK(CALLBACK_NAME, T) \
    graphikos::painter::Callback<T> FIRE_EVENT_VAR(CALLBACK_NAME)

#define NEW_CALLBACKS(CALLBACK_NAME, T) \
    std::vector<graphikos::painter::Callback<T>> FIRE_EVENTS_VAR(CALLBACK_NAME)

#define SET_EVENT(CALLBACK_NAME, FUNCTION_TYPE)                                         \
    void SET_FUNC_NAME(CALLBACK_NAME)(graphikos::painter::Callback<FUNCTION_TYPE> cb) { \
        FIRE_EVENT_VAR(CALLBACK_NAME) = cb;                                             \
    }
#define FIRE_EVENT_WITH_RETURN_CB(CALLBACK_FN, ARGS)   \
    if (!CALLBACK_FN.isEmpty()) {       \
       return CALLBACK_FN.fireEventWithReturn(ARGS...); \
    }
#define CHECK_EVENT_WITH_RETURN_CB(CALLBACK_FN) \
    return !CALLBACK_FN.isEmpty();

#define CREATE_CALLBACK(CALLBACK_NAME, T)                \
    NEW_CALLBACK(CALLBACK_NAME, T);                      \
    template <typename... Args>                          \
    void fire##CALLBACK_NAME(Args... args) {             \
        FIRE_EVENT(FIRE_EVENT_VAR(CALLBACK_NAME), args); \
    }                                                    \
    SET_EVENT(CALLBACK_NAME, T);

#define CREATE_CALLBACK_WITH_RETURN(CALLBACK_NAME, T)                \
    NEW_CALLBACK(CALLBACK_NAME, T);                      \
    template <typename... Args>                          \
    auto fire##CALLBACK_NAME(Args... args) {             \
        FIRE_EVENT_WITH_RETURN_CB(FIRE_EVENT_VAR(CALLBACK_NAME), args); \
    }                                                    \
    bool isSet##CALLBACK_NAME() {                                              \
        CHECK_EVENT_WITH_RETURN_CB(FIRE_EVENT_VAR(CALLBACK_NAME));                \
    }                                                                          \
    SET_EVENT(CALLBACK_NAME, T);


#define CREATE_CALLBACKS(CALLBACK_NAME, T)                        \
    NEW_CALLBACKS(CALLBACK_NAME, T);                              \
    template <typename... Args>                                   \
    void fire##CALLBACK_NAME##s(Args... args) {                   \
        FIRE_EVENTS(CALLBACK_NAME, args)                          \
    }                                                             \
    void add##CALLBACK_NAME(graphikos::painter::Callback<T> cb) { \
        FIRE_EVENTS_VAR(CALLBACK_NAME).emplace_back(cb);          \
    }

#define CREATE_CALLBACK_STATIC(CALLBACK_NAME, T)                                                        \
    static NEW_CALLBACK(CALLBACK_NAME, T);                                                              \
    template <typename... Args>                                                                         \
    GL_DPR("Static callbacks are dangerous, don't use them! Will be removed in the next major version") \
    static void fire##CALLBACK_NAME(Args... args) {                                                     \
        FIRE_EVENT(FIRE_EVENT_VAR(CALLBACK_NAME), args);                                                \
    }                                                                                                   \
    GL_DPR("Static callbacks are dangerous, don't use them! Will be removed in the next major version") \
    static SET_EVENT(CALLBACK_NAME, T);

#define CALLBACK_STATIC_DEFINITION(CLASS_NAME, CALLBACK_NAME, T) \
    graphikos::painter::Callback<T> CLASS_NAME::FIRE_EVENT_VAR(CALLBACK_NAME)

#define CALLBACKS_STATIC_DEFINITION(CLASS_NAME, CALLBACK_NAME, T) \
    std::vector<graphikos::painter::Callback<T>> CLASS_NAME::FIRE_EVENTS_VAR(CALLBACK_NAME)

#ifdef __EMSCRIPTEN__
#define EMSCRIPTEN_FUNC_CALLBACK(CLASS_NAME, CALLBACK_NAME)                           \
    function(GC_UTIL_GET_STRING(SET_FUNC_NAME(CALLBACK_NAME)),                        \
             emscripten::optional_override([](CLASS_NAME& self, emscripten::val cb) { \
                 self.SET_FUNC_NAME(CALLBACK_NAME)(cb);                               \
             }))

#define EMSCRIPTEN_FUNC_CALLBACK_STATIC(CLASS_NAME, CALLBACK_NAME)        \
    class_function(GC_UTIL_GET_STRING(SET_FUNC_NAME(CALLBACK_NAME)),      \
                   emscripten::optional_override([](emscripten::val cb) { \
                       CLASS_NAME::SET_FUNC_NAME(CALLBACK_NAME)(cb);      \
                   }))

#endif

template <typename T>
class CallbackHandler {
private:
    std::vector<graphikos::painter::Callback<T>> callbacks;

public:
    void add(graphikos::painter::Callback<T> cb) {
        callbacks.emplace_back(cb);
    }

    template <typename... Args>
    void fire(Args... args) {
        for (auto& fn : callbacks) {
            if (!fn.isEmpty()) {
                fn.fireEvent(args...);
            }
        }
    }
};

template <typename T>
class CallbackHandlerWithReturn {
private:
    std::vector<graphikos::painter::Callback<T>> callbacks;
    std::vector<typename std::function<T>::result_type> returnValues;

public:
    void add(graphikos::painter::Callback<T> cb) {
        callbacks.emplace_back(cb);
    }

    template <typename... Args>
    std::vector<typename std::function<T>::result_type> fire(Args... args) {
        returnValues.clear();
        for (auto& fn : callbacks) {
            if (!fn.isEmpty()) {
                auto value = fn.fireEventWithReturn(args...);
                returnValues.emplace_back(value);
            }
        }
        return returnValues;
    }
};
