#ifndef __NL_IDATALISTENER_H
#define __NL_IDATALISTENER_H
#include<string>
#include <include/core/SkRect.h>

class ZData;
class NLDataController;
class IDataListener {
public:
    /**
     * @brief Called when project data is loaded
     */

    virtual void onDataInit(NLDataController* data) {}
    virtual void onDataInit(ZData* data) {}

    /**
     * @todo fix naming and have proper class for renderData 
     */
    virtual void onDataChange(std::string docId) {}
    virtual void onViewPortChange(SkRect query) {}
};

#endif
