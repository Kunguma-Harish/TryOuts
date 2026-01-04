#ifndef __NL_IRENDERLISTENER_H
#define __NL_IRENDERLISTENER_H
#include<string>
#include <include/core/SkRect.h>

class IRenderListener {
private:
    
public:
    SkRect maxCoverageRect;
    void setMaxCoverageRect(SkRect coverageRect) { maxCoverageRect = coverageRect; }
    virtual void onViewPortChange(SkRect query) {}
};

#endif
