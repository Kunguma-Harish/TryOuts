#pragma once
#include <app/TableEditingController.hpp>

class VaniTableEditingController : public TableEditingController {
public:
    VaniTableEditingController(NLDataController* dataController, ZSelectionHandler* selectionHandler, ControllerProperties* properties, NLEditorProperties* editorProperties, std::shared_ptr<NLLayer> bboxLayer, std::shared_ptr<ZBBox> bbox);
    void setTextEditor() override;
};
