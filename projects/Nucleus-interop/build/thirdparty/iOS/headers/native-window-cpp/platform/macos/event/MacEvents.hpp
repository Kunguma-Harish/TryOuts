#ifndef MAC_EVENTS_HPP
#define MAC_EVENTS_HPP
#include <native-window-cpp/common/event/NWTEvents.hpp>

class MacEvents: public NWTEvents {
    public :
    void initEvents(void* window) override;
    ~MacEvents();
};

#endif