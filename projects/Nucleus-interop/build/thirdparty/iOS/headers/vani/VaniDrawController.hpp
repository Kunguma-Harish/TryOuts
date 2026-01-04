#ifndef __NL_VANIDRAWCONTROLLER_H
#define __NL_VANIDRAWCONTROLLER_H

#include <app/DrawController.hpp>

class VaniDrawController : public DrawController {

private:
    std::shared_ptr<NLInstanceLayer> containerNameHashLayer = nullptr;
    std::shared_ptr<NLInstanceLayer> containerNameTextLayer = nullptr;
    std::shared_ptr<skia::textlayout::Paragraph> frameNameParagraphMap;

public:
    VaniDrawController(NLDataController* dataController, ZSelectionHandler* selectionHandler, ControllerProperties* properties, NLEditorProperties* editorProperties);
    void onAttach() override;
    void onDetach() override;

    void clear() override;
    void drawContainerName(float scale = 1.0f) override;
};

#endif