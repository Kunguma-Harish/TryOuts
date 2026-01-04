#ifndef TRACKER_HPP
#define TRACKER_HPP

#ifdef ENABLE_TRACKING

#include <iostream>
#include <chrono>
#include <string>
#include <unordered_map>

// Declaration of the global new and delete operators
void* operator new(std::size_t size);
void operator delete(void* ptr) noexcept;                   // Scalar delete without size
void operator delete(void* ptr, std::size_t size) noexcept; // Scalar delete with size (for completeness)

void* operator new[](std::size_t size);
void operator delete[](void* ptr) noexcept;                   // Array delete without size
void operator delete[](void* ptr, std::size_t size) noexcept; // Array delete with size

namespace Performance {
struct TrackedData;
class FunctionTracker;

// extern std::vector<Performance::FunctionTracker> trackers;
extern std::unordered_map<std::string, Performance::FunctionTracker> trackers;
extern std::unordered_map<std::string, Performance::TrackedData> trackedData;

class Tracker {
    
public:
    Tracker(const std::string& methodName, bool controlledTracking = false);
    Tracker();
    ~Tracker();

    static void newAllocation(void* ptr, std::size_t size);
    static void deleteAllocation(void* ptr);
    static TrackedData getTrackedData(const std::string& tag = "");
    static std::vector<TrackedData> getTrackedDataForAllMethods();
    static void setTrackedData(TrackedData data, const std::string& tag = "");

    static void startTracking(const std::string& tag);
    static void stopTracking(const std::string& tag);


    static void printTrackedData(const std::string& tag = "");

private:
    std::string tag;
    Performance::FunctionTracker functionTracker;
};
}

#endif // ENABLE_TRACKING

#endif // TRACKER_HPP