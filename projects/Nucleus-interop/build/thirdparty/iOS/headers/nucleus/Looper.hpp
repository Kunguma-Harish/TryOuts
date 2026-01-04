#ifndef __NL_LOOPER_H
#define __NL_LOOPER_H
#include <queue>
#include <functional>
#include <thread>
#include <mutex>
#include <atomic>
#include <unordered_map>

/** 
 * Update UI thread using Looper
 */
class Looper {
public:
    // semaphore for important high priority tasks
    int iHighAhead = 0;
    // semaphore for negligible high priority task
    std::unordered_map<std::string, int> nHighAhead;
    // semaphore for important low priority tasks
    int iLowAhead = 0;
    // semaphore for negligible low priority tasks
    std::unordered_map<std::string, int> nLowAhead;
    enum Type {
        IMPORTANT, /* Considered important. Will not be dropped */
        NEGLIGIBLE /* Will be dropped if something new is available */
    };
    enum Priority {
        HIGH,
        LOW
    };

private:
    struct Task {
        Task(std::function<void(void)> func, Priority priority, Type type, std::string id) {
            this->func = func;
            this->priority = priority;
            this->type = type;
            this->id = id;
        }
        std::function<void(void)> func;
        Type type;
        Priority priority;
        std::string id;
    };
    std::queue<Task*> updates;
    std::queue<Task*> lowPriorityTasks;
    std::mutex updateMutex;
    std::atomic<std::thread::id> threadId;
    friend class ZWindow;
    Task* reorder(std::queue<Task*>& taskQueue);

public:
    /**
     * @note Construct Looper only from UI thread
     */

    Looper();
    void onLoop();
    bool onContinueLoop();

    /**
     * @brief Every update is done in a queue fashion
     * @param update runs the given function in UI thread
     */
    void update(std::function<void(void)> func, Priority priority = Priority::LOW, Type type = Type::NEGLIGIBLE, std::string id = "");
    /**
     * @brief updates the first UI change in the queue and dequeues it
     */
    void execute();
    /**
     * @brief Set the Thread Id object
     * 
     * @param threadId 
     */
    void setThreadId(std::thread::id threadId);
    void clearQueue();
    void clearTasks(std::string id);
};

#endif