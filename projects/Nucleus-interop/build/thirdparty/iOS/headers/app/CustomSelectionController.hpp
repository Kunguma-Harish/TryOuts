#ifndef __NL_NLCUSTOMSELECTIONCONTROLLER_H
#define __NL_NLCUSTOMSELECTIONCONTROLLER_H
#include <app/controllers/NLScrollEventController.hpp>
#include <app/NLDataController.hpp>
#include <nucleus/core/layers/NLInstanceLayer.hpp>
#include <app/ZBBox.hpp>
#include <app/util/ZEditorUtil.hpp>
#include <app/util/BBoxUtils.hpp>

namespace asset {
enum class Type;
};

class CustomSelectionController : public NLScrollEventController {
public:
    struct CustomSelectionOptions {
        float maxWidth = 8000;
        float maxHeight = 8000;
    };

    CustomSelectionOptions getCustomSelectionOptions() {
        return customSelectionOptions;
    }

    CustomSelectionController(NLDataController* dataController, ZSelectionHandler* selectionHandler, ControllerProperties* properties);
    void onAttach() override;
    void onDetach() override;
    void enable();
    void disable();
    void setCursor(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame);
    ZEditorUtil::BoxCorner pointInBboxCorner(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame);
    void updateRect(graphikos::painter::GLRect rect);
    graphikos::painter::GLRect getRect();

    //events
    bool onTranslate(float transX, float transY) override;
    bool onMagnify(float magnification, graphikos::painter::GLPoint byPoint) override;
    bool onMouseDown(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onDoubleClickEnd(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onDoubleClick(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onMouseMove(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onMouseHold(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLPoint& prevPoint, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onDrag(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLPoint& prevPoint, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onKeyPress(int keyCode, int modifier, std::string keyCharacter, const SkMatrix& matrix) override;
    bool onKeyDown(int keyCode, int modifier, bool repeat, std::string keyCharacter, const SkMatrix& matrix) override;
    bool onKeyRelease(int keyAction, int key, const SkMatrix& matrix) override;
    bool onMouseUp(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;

private:
    CustomSelectionOptions customSelectionOptions;
    bool isEnabled = false;
    bool enableSODO = true;
    graphikos::painter::GLRect innerRect;
    std::shared_ptr<ZBBox> bbox;
    std::map<std::string, asset::Type> bboxes;
    NLDataController* dataLayer = nullptr;
    std::shared_ptr<NLLayer> bboxLayer = nullptr;
    std::shared_ptr<NLInstanceLayer> overlayLayer = nullptr;
    std::shared_ptr<com::zoho::shapes::Transform> customTransform;
    ZEditorUtil::EditingData eventData;
    void emptyCustomSelection();
    void drawCustomSelection();
};
#endif