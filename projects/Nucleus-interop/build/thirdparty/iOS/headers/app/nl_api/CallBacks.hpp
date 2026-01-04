#ifndef __NL_CALLBACKS_H
#define __NL_CALLBACKS_H
#include <iostream>
#include <app/structs/SelectionStructs.hpp>
#include <app/structs/AssetStructs.hpp>
#include <painter/ShapeObjectPainter.hpp>
#include <app/ZSelectionHandler.hpp>
#include <nucleus/wasm/EventCallBacks.hpp>

namespace com {
namespace zoho {
namespace shapes {
class HyperLink;
enum HyperLink_LinkOpenType : int;
}
}
}
class CallBacks {

public:
    std::shared_ptr<EventCallBacks> eventCallBacks = nullptr;

#if defined(NL_ENABLE_NEXUS)
    void set_eventCallBacks_nx(EventCallBacks* evt);
    EventCallBacks* get_eventCallBacks_nx();
    CREATE_CALLBACK_NEXUS(ViewTransformedCallBack, void, graphikos::painter::GLPoint, float);

    //selectionhandler
    CREATE_CALLBACK_NEXUS(SelectShapeCallBack, void, std::vector<SelectedShape>);
    CREATE_CALLBACK_NEXUS(UnSelectShapeCallBack, void, std::vector<SelectedShape>, bool);
    CREATE_CALLBACK_NEXUS(TextSelectCallBack, void, std::string, int, int, std::string);
    CREATE_CALLBACK_NEXUS(TextClearCallBack, void, std::string, std::string, std::string, bool);
    CREATE_CALLBACK_NEXUS(PlayGifCallBack, void, std::vector<std::string>, std::vector<std::string>);
    CREATE_CALLBACK_NEXUS(ReplaceGifCallBack, void, std::vector<std::string>);

    //customSelectionController
    CREATE_CALLBACK_NEXUS(MaxDimReachedCallBack, void);
    CREATE_CALLBACK_NEXUS(RectResizedCallBack, void);
    CREATE_CALLBACK_NEXUS(ClearedCallBack, void);

    //table controller
    CREATE_CALLBACK_NEXUS(SelectedTableCellsCallBack, void, SelectedCellDetails);
    CREATE_CALLBACK_NEXUS(ClearTableCellsCallBack, void);
    CREATE_CALLBACK_NEXUS(UpdateSelectedTextObjCallBack, void, SelectedCellDetails);

    //datacontroller
    CREATE_CALLBACK_NEXUS_WITH_RETURN(RenderShapeCallback, bool, std::string);
    CREATE_CALLBACK_NEXUS(LogDuplicateShapeIdCallback, void, std::string, std::string);
    CREATE_CALLBACK_NEXUS_WITH_RETURN(UserNameCallback, std::string, std::string, std::string);
    CREATE_CALLBACK_NEXUS(DocumentRenderedCallBack, void);

    //asset handler
    CREATE_CALLBACK_NEXUS(AssetRequestCallBack, void, Asset*, std::string, std::string, std::string);
    CREATE_CALLBACK_NEXUS(DecodeImageCallBack, void, Asset*);
    CREATE_CALLBACK_NEXUS(ShapeDetailsByteRequestCallBack, void, Asset*, Asset*, Asset*, ExportDetails);

    //resource handler
    CREATE_CALLBACK_NEXUS(SetImageCallBack, void, std::vector<uint8_t>);

    CREATE_CALLBACK_NEXUS(OpenUrlCallBack, void, com::zoho::shapes::HyperLink);
    NXCallbackHandlerWithReturn<ResourceDetails, std::string, std::string> ImageDataCallBacks;
    NXCallbackHandler<void, std::string, int, bool> FontRequestCallBack;
    void addOnFontRequest(NXCallBack<void, std::string, int, bool> cb) {
        FontRequestCallBack.add(cb);
    }
    void addOnImageDataRequest(NXCallBack<ResourceDetails, std::string, std::string> cb) {
        ImageDataCallBacks.add(cb);
    }

    CREATE_CALLBACK_NEXUS(ClearHover, void);
#else
    //ZView
    CREATE_CALLBACK(ViewTransformedCallBack, void(graphikos::painter::GLPoint, float));

    //selectionhandler
    CREATE_CALLBACK(SelectShapeCallBack, void(std::vector<SelectedShape>));
    CREATE_CALLBACK(UnSelectShapeCallBack, void(std::vector<SelectedShape>, bool));
    CREATE_CALLBACK(TextSelectCallBack, void(std::string, int, int, std::string));
    CREATE_CALLBACK(TextClearCallBack, void(std::string, std::string, std::string, bool));
    CREATE_CALLBACK(PlayGifCallBack, void(std::vector<std::string>, std::vector<std::string>));
    CREATE_CALLBACK(ReplaceGifCallBack, void(std::vector<std::string>));

    //customSelectionController
    CREATE_CALLBACK(MaxDimReachedCallBack, void());
    CREATE_CALLBACK(RectResizedCallBack, void());
    CREATE_CALLBACK(ClearedCallBack, void());

    //table controller
    CREATE_CALLBACK(SelectedTableCellsCallBack, void(SelectedCellDetails));
    CREATE_CALLBACK(ClearTableCellsCallBack, void());

    //datacontroller
    CREATE_CALLBACK(DocumentRenderedCallBack, void());
    CREATE_CALLBACK(LogDuplicateShapeIdCallback, void(std::string, std::string));

    //asset handler
    CREATE_CALLBACK(AssetRequestCallBack, void(std::shared_ptr<Asset>, std::string, std::string, std::string));
    CREATE_CALLBACK(DecodeImageCallBack, void(std::shared_ptr<Asset>));
    CREATE_CALLBACK(ShapeDetailsByteRequestCallBack, void(std::shared_ptr<Asset>, std::shared_ptr<Asset>, std::shared_ptr<Asset>, ExportDetails));

    //resource handler
    CREATE_CALLBACK(SetImageCallBack, void(std::vector<uint8_t>));
    CallbackHandlerWithReturn<ResourceDetails(std::string, std::string)> ImageDataCallBacks;
    CallbackHandler<void(std::string, std::string, bool loadFullRes)> ImageDataSamplingCallBack;
    CallbackHandler<void(std::string, int, bool)> FontRequestCallBack;


    // common functions
    CREATE_CALLBACK(OpenUrlCallBack, void(com::zoho::shapes::HyperLink));

    CREATE_CALLBACK(ClearHover, void());

    CREATE_CALLBACK_WITH_RETURN(UserNameCallback, std::string(std::string, std::string));
#endif
    virtual ~CallBacks();
};
#endif
