#ifndef GL_LOGGER
#define GL_LOGGER
#include <iostream>
#include <set>
#include <cstdio>
#include <map>
#include <mutex>
#include <sstream>
#include <thread>
#include <logger/logger_export.h>

#ifdef LOGGERENABLED
#if defined(__clang__) && !defined(_WIN32)
#pragma clang diagnostic ignored "-Wstring-plus-int"
#elif defined(__GNUC__) && !defined(__clang__) && !defined(_WIN32)
#pragma GCC diagnostic ignored "-Wstring-plus-int"
#endif
#endif
#define __FILENAME__ (__FILE__)

namespace logger {

extern LOGGER_EXPORT bool isLoggingEnabled;
extern LOGGER_EXPORT bool isVerboseEnabled;
extern LOGGER_EXPORT bool isPrintEnabled;
extern LOGGER_EXPORT bool redirectToStdErr;

extern std::map<std::thread::id, std::string> color_map;
extern std::mutex color_map_mutex;
extern std::mutex ssstream_mutex;
extern int thread_count;

#define ANSI_RESET_COLOR "\033[0m"

extern std::string ansi_colors[];

inline std::string get_color_for_thread() {
    std::lock_guard<std::mutex> guard(color_map_mutex);
    std::thread::id thread_id = std::this_thread::get_id();
    if (color_map.find(thread_id) == color_map.end()) {
        // assign one color, new thread has entered logger
        // repeat colors incase there are more threads than colors
        /// @todo use sizeof(ansi_colors)
        color_map[thread_id] = ansi_colors[thread_count % 2];
        thread_count++;
    }
    return color_map[thread_id];
}

enum class LogType {
    LOGGER_INFO,
    LOGGER_VERBOSE,
    LOGGER_WARN,
    LOGGER_ERROR,
    LOGGER_PRINT,
    LOGGER_OUT,
    LOGGER_END
};

class Logger {
private:
    std::stringstream ss;
    unsigned int line = 0;
    std::string fileName;
    std::string functionName;
    [[maybe_unused]] LogType type;
    friend class Logger;

public:
    LOGGER_EXPORT Logger(LogType type);
    LOGGER_EXPORT Logger& debugInfo(unsigned int line, const char* fileName, const char* functionName);
    template <typename T>
    Logger& operator<<(T msg) {
        std::lock_guard<std::mutex> guard(ssstream_mutex);
        ss << msg;
        return *this;
    }
    template <typename T>
    Logger& operator<<(std::set<T> msg) {
        for (T t : msg) {
            std::lock_guard<std::mutex> guard(ssstream_mutex);
            ss << t << ", ";
        }
        return *this;
    }
    Logger& operator<<(Logger const& msg);
};

/// @todo Use macros for readability
extern LOGGER_EXPORT Logger _loginfo;
extern LOGGER_EXPORT Logger _logverbose;
extern LOGGER_EXPORT Logger _logwarn;
extern LOGGER_EXPORT Logger _logerror;
extern LOGGER_EXPORT Logger _logprint;
extern LOGGER_EXPORT Logger _logout;
extern LOGGER_EXPORT Logger end;

#define loginfo _loginfo.debugInfo(__LINE__, __FILENAME__, __func__)
#define logverbose _logverbose.debugInfo(__LINE__, __FILENAME__, __func__)
#define logwarn _logwarn.debugInfo(__LINE__, __FILENAME__, __func__)
#define logerror _logerror.debugInfo(__LINE__, __FILENAME__, __func__)
#define logprint _logprint.debugInfo(__LINE__, __FILENAME__, __func__)
#define logout _logout.debugInfo(__LINE__, __FILENAME__, __func__)
}

#endif
