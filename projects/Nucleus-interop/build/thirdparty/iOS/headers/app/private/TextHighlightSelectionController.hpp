#ifndef __NL_TEXTHIGHLIGHTSELECTIONCONTROLLER_H
#define __NL_TEXTHIGHLIGHTSELECTIONCONTROLLER_H

#include <app/private/TextEditorControllerImpl.hpp>
class TextHighlightSelectionController : public TextEditorControllerImpl {
public:
    TextHighlightSelectionController(NLDataController* dataController, ZSelectionHandler* selectionHandler, ControllerProperties* properties, NLEditorProperties* editorProperties, std::shared_ptr<ZBBox> bbox);

    void setEditingCloneTextBody(std::shared_ptr<com::zoho::shapes::TextBody> textBody) override;
    std::shared_ptr<com::zoho::shapes::TextBody> getEditingTextBody() const override;

private:
    std::shared_ptr<com::zoho::shapes::TextBody> currentTextBody; 
};
#endif
