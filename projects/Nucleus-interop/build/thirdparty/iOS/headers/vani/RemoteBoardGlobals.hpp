#ifndef __NL_REMOTEBOARDGLOBALS_H
#define __NL_REMOTEBOARDGLOBALS_H

#include <vani/RemoteBoardModel.hpp>
#include <vani/RemoteBoardShapeDefaults.hpp>

class RemoteBoardDefaultValues;

class RemoteBoardGlobals {
public:
    static RemoteBoardModel* rbModel;
    static RemoteBoardShapeDefaults* rbShapeDefault;
    static RemoteBoardDefaultValues* defaultValues;

    static RemoteBoardModel* getRBModel() {
        return rbModel;
    }
};

#endif