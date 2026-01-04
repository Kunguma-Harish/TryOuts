#ifndef __NL_EDITORCALLBACKS_H
#define __NL_EDITORCALLBACKS_H
#include <app/nl_api/CallBacks.hpp>
#include <app/ZShapeModified.hpp>
#include <app/ConnectorController.hpp>
#include <app/TableEditingController.hpp>

struct ShapeData;
class EditorCallBacks : public CallBacks {
public:
#if defined(NL_ENABLE_NEXUS)
    CREATE_CALLBACK_NEXUS(StopTextListenerCallBack, void);
    CREATE_CALLBACK_NEXUS(TextListenerCallBack, void, std::string, int, int, std::string, float, float, float, float);
    CREATE_CALLBACK_NEXUS(TextInsertRestrictCallBack, void, graphikos::painter::ShapeDetails);
    CREATE_CALLBACK_NEXUS(CustomTextInsertRestrictCallBack, void);
    CREATE_CALLBACK_NEXUS(CustomTextModifiedCallBack, void, std::string, int, int, std::string, int, int);
    CREATE_CALLBACK_NEXUS(CustomTextInitOrExitCallBackCallBack, void);
    CREATE_CALLBACK_NEXUS(InsertTextBoxCallBack, void, com::zoho::shapes::Transform, bool, graphikos::painter::GLPoint, com::zoho::shapes::PointOnPath);
    CREATE_CALLBACK_NEXUS(ShapeCreatedCallBack, void, com::zoho::shapes::ShapeObject*, graphikos::painter::GLPoint);
    CREATE_CALLBACK_NEXUS(ShapeCreatedAndModifiedCallBack, void, com::zoho::shapes::ShapeObject*, std::vector<ShapeData>, graphikos::painter::GLPoint);
    CREATE_CALLBACK_NEXUS(ResizeMinMaxCallBack, void, ZEditorUtil::MinMax);

    CREATE_CALLBACK_NEXUS(TableHeightChangedCallBack, void);

    CREATE_CALLBACK_NEXUS(ShapeMoveStartCallBack, void);

    CREATE_CALLBACK_NEXUS(EditingCallBack, void, std::vector<ShapeData>, bool, bool, graphikos::painter::GLPoint);
    CREATE_CALLBACK_NEXUS(ExternalShapeCallBack, void, std::vector<ShapeData>, bool);

    //drawcontroller
    CREATE_CALLBACK_NEXUS(DrawModeClearCallBack, void);

    //editorController
    CREATE_CALLBACK_NEXUS(LockMessageCallBack, void, std::string);

    //tableediting controller
    CREATE_CALLBACK_NEXUS(AddTableRowOrColumnCallBack, void, bool, bool);
    CREATE_CALLBACK_NEXUS(DeleteTableRowOrColumnCallBack, void, bool);
    CREATE_CALLBACK_NEXUS(RowColumnSwapCallBack, void, TableEditingController::TableSwapDetails, std::vector<ShapeData>);
    CREATE_CALLBACK_NEXUS(TableDistributeCallBack, void, bool);

    //conectorcontroller
    CREATE_CALLBACK_NEXUS(ShowConnectorShapePopoverCallBack, void, ZConnectorCDP);

    // image crop controller
    CREATE_CALLBACK_NEXUS(CropModeExit, void);

    //text editor
    CREATE_CALLBACK_NEXUS(SpellAfterCallBack, void);

    //to rerender the selection - used to update table cell on textediting for now
    CREATE_CALLBACK_NEXUS(ReRenderSelectionCallBack, void, com::zoho::shapes::ShapeObject*, graphikos::painter::ShapeDetails, com::zoho::shapes::TextBody*);

#else
    //zshapemodified
    CREATE_CALLBACK(StopTextListenerCallBack, void());
    CREATE_CALLBACK(TextListenerCallBack, void(std::string, int, int, std::string, float, float, float, float));
    CREATE_CALLBACK(TextInsertRestrictCallBack, void(graphikos::painter::ShapeDetails));
    CREATE_CALLBACK(CustomTextInsertRestrictCallBack, void());
    CREATE_CALLBACK(CustomTextModifiedCallBack, void(std::string, int, int, std::string, int, int));
    CREATE_CALLBACK(CustomTextInitOrExitCallBackCallBack, void());
    CREATE_CALLBACK(InsertTextBoxCallBack, void(com::zoho::shapes::Transform, bool, graphikos::painter::GLPoint, com::zoho::shapes::PointOnPath));
    CREATE_CALLBACK(ShapeCreatedCallBack, void(com::zoho::shapes::ShapeObject*, graphikos::painter::GLPoint));
    CREATE_CALLBACK(ShapeCreatedAndModifiedCallBack, void(com::zoho::shapes::ShapeObject*, std::vector<ShapeData>, graphikos::painter::GLPoint));
    CREATE_CALLBACK(ResizeMinMaxCallBack, void(ZEditorUtil::MinMax));

    CREATE_CALLBACK(TableHeightChangedCallBack, void());

    CREATE_CALLBACK(ShapeMoveStartCallBack, void());

    CREATE_CALLBACK(EditingCallBack, void(std::vector<ShapeData>, bool, bool, graphikos::painter::GLPoint));
    CREATE_CALLBACK(ExternalShapeCallBack, void(std::vector<ShapeData>, bool));

    //drawcontroller
    CREATE_CALLBACK(DrawModeClearCallBack, void());

    //editorController
    CREATE_CALLBACK(LockMessageCallBack, void(std::string));

    //tableediting controller
    CREATE_CALLBACK(AddTableRowOrColumnCallBack, void(bool, bool));
    CREATE_CALLBACK(DeleteTableRowOrColumnCallBack, void(bool));
    CREATE_CALLBACK(RowColumnSwapCallBack, void(TableEditingController::TableSwapDetails, std::vector<ShapeData>));

    CREATE_CALLBACK(TableDistributeCallBack, void(bool));

    //conectorcontroller
    CREATE_CALLBACK(ShowConnectorShapePopoverCallBack, void(ZConnectorCDP));

    // image crop controller
    CREATE_CALLBACK(CropModeExit, void());

    //text editor
    CREATE_CALLBACK(SpellAfterCallBack, void());

    //to rerender the selection - used to update table cell on textediting for now
    CREATE_CALLBACK(ReRenderSelectionCallBack, void(com::zoho::shapes::ShapeObject*, graphikos::painter::ShapeDetails, com::zoho::shapes::TextBody*));

#endif
    CREATE_CALLBACK(ShapeEditStartCallBack, void(std::vector<std::string>));
};
#endif