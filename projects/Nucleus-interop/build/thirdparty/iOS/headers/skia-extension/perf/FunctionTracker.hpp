#ifndef FUNCTIONTRACKER_H
#define FUNCTIONTRACKER_H


#include <cstddef> // For std::size_t
#include <unordered_map>
#include <string>
#include <chrono>


namespace Performance {

struct TrackedData {
    std::size_t maxMemoryAllocated;
    std::size_t totalMemoryInUse;
    std::chrono::system_clock::time_point start_time;
    std::chrono::system_clock::time_point end_time;
    float duration;
    std::size_t allocations;
    std::size_t deallocations;
    std::string tag;
};

} // namespace performance

#ifdef ENABLE_TRACKING

namespace Performance {
class FunctionTracker {

    TrackedData trackedData;

    bool isTrackingMemory;
    bool internalCall;

    std::string currentTag;
    std::size_t allocations;
    std::size_t deallocations;

    std::unordered_map<void*, std::size_t> memoryAllocations;

public:
    bool controlledTracking;   
    FunctionTracker() = default;
    ~FunctionTracker() = default;
    FunctionTracker(const std::string& tag, bool controlledTracking = false);

    void newAllocation(void* ptr, std::size_t size);
    void deleteAllocation(void* ptr);
    std::string getCurrentTag() const;

    void startTracking();
    void stopTracking();
    TrackedData getTrackedData() const;
    void printTrackedData() const;

};

} // namespace performance

#endif // ENABLE_TRACKING

#endif // FUNCTIONTRACKER_H