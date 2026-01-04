//
//  CppNucleusBinder.hpp
//  Nucleus-interop
//
//  Created by kunguma-14252 on 15/04/25.
//

#ifndef CppNucleusBinder_hpp
#define CppNucleusBinder_hpp

#include <iostream>
#include <native-window-cpp/common/event/NWTEvents.hpp>
#include <vani/nl_api/VaniAppBinder.hpp>
//#include <app/nl_api/AppBinder.hpp>
//#include <vani/Vani.hpp>
//#include <app/util/ZShapeAlignUtil.hpp>
//#include <shapeselection.pb.h>

//#include <vani/data/VaniDataController.hpp>
//#include <app/CollabController.hpp>
//#include <composer/ProtoBuilder.hpp>
//#include <vani/nl_api/VaniCallBacks.hpp>
//#include <nucleus/core/layers/NLScrollLayer.hpp>
//#include <vani/VaniCommentHandler.hpp>

class CppNucleusBinder {
private:
    int value;
    
public:
    CppNucleusBinder(int value);
    int getValue();
};

#endif /* CppNucleusBinder_hpp */
