#ifndef __NL_ISELECTIONLISTENER_H
#define __NL_ISELECTIONLISTENER_H

#include <app/ZSelectionHandler.hpp>

class ISelectionListener {
public:
    virtual void onSelectionChange() {}
    virtual void onSelectionDataChange() {}
    virtual void addConnector(std::vector<SelectedShape>& shapes) {}
};

#endif
