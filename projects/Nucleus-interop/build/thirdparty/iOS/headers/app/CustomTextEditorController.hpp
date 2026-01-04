#ifndef __NL_CUSTOMTEXTEDITORCONTROLLER_H
#define __NL_CUSTOMTEXTEDITORCONTROLLER_H

#include <app/controllers/NLEventController.hpp>
#include <app/NLDataController.hpp>

namespace com {
namespace zoho {
namespace shapes {
class TextBody;
}
}
}

class CustomTextEditorController : public NLEventController {
public:
    CustomTextEditorController(NLDataController* dataController, ZSelectionHandler* selectionHandler, ControllerProperties* properties) : NLEventController(properties, selectionHandler, dataController->getLayerProperties(), dataController->getViewPortRect()) {
        this->data = dataController;
    }

    static std::shared_ptr<CustomTextEditorController> create(NLDataController* dataController, ZSelectionHandler* selectionHandler, ControllerProperties* properties);

    virtual void initText(graphikos::painter::GLRect rect, std::shared_ptr<com::zoho::shapes::TextBody> textBody, bool usePxForText = true) = 0;
    virtual void reInitCustomTextEditor(std::string text, const SkMatrix& totalMatrix, int si = 0, int ei = 0) = 0;
    virtual void updateTextRect(graphikos::painter::GLRect rect, const SkMatrix& matrix = SkMatrix()) = 0;
    virtual void setMaxTextLimit(int textLimit) = 0;
    virtual bool getIsCustomTextEditMode() = 0;
    virtual void exitText() = 0;
    virtual std::string getText() = 0;
    virtual void setData(bool retain_scale, graphikos::painter::GLPoint position, graphikos::painter::GLPoint offset) = 0;
    virtual void enableMouseDrag() = 0;
    virtual void refreshEmojiImages(std::string imageKey, const SkMatrix& totalMatrix) = 0;

    virtual std::vector<int> getSiEi() const = 0;
    virtual std::vector<int> getCharacterPos(int si) = 0;
    virtual bool paste(std::string value, const SkMatrix& totalMatrix) = 0;
    virtual std::string getSelectedText() = 0;
    virtual void cutText(const SkMatrix& totalMatrix) = 0;

    virtual void renderText(const SkMatrix& matrix = SkMatrix()) = 0;
    virtual void addDefaultFontFamilies(std::vector<std::string> fontFamilies) = 0;

protected:
    NLDataController* data = nullptr;
};

#endif