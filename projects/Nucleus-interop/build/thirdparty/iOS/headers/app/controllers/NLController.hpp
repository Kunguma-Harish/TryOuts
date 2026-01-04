#ifndef __NL_CONTROLLER_H
#define __NL_CONTROLLER_H

#include <nucleus/util/FitToScreenUtil.hpp>
#include <nucleus/core/ZEventKeys.hpp>
#include <skia-extension/util/FnTypes.hpp>
#include <nucleus/core/NLCursor.hpp>
#include <app/nl_api/CallBacks.hpp>
#include <include/core/SkFontMgr.h>
#include <string>

struct ControllerProperties {
    graphikos::common::FitToScreenUtil::FitType fitType = graphikos::common::FitToScreenUtil::FitType::DEFAULT_100_FIT;
    bool doNotFit = false;
    bool scrollOnDrag = false;
    bool isRightClick = false;
    bool forceResize = false;
    std::shared_ptr<CallBacks> callBackClass = nullptr;
    NLCursor* cursor = nullptr;
    ControllerProperties(const ZWindow* window, NLCursor* cursor);
    ~ControllerProperties();
    bool doNotTriggerViewTransformCallback = false;
    sk_sp<SkFontMgr> temp_customFontMgr = nullptr;

    const ZWindow* getParentWindow() { return window; }

    void setCustomViewport(graphikos::painter::GLRect customViewport) {
        this->customViewport = customViewport;
    }

    graphikos::painter::GLRect getCustomViewport() {
        return this->customViewport;
    }

private:
    // Should this really be a const?
    // We might want to make it mutable in the future if required.
    // For now, it will remain const.
    const ZWindow* window;
    graphikos::painter::GLRect customViewport = graphikos::painter::GLRect();
};

class NLController {
protected:
    ControllerProperties* properties;

public:
    NLController() {}
    NLController(ControllerProperties* properties);

    //properties setters
    virtual void onDisplayTypeChange();
    void setDisplayType(graphikos::common::FitToScreenUtil::FitType fitType);
    graphikos::common::FitToScreenUtil::FitType getDisplayType() {
        return properties->fitType;
    }
    virtual void dataUpdated(bool needRenderer, std::vector<std::string> shapeId);
    virtual void refreshSelectedLayer(std::vector<std::string> shapeIds, bool isFontAdd = false);

    void fireViewTransformed(float currentScale, graphikos::painter::GLPoint translate);
    ControllerProperties* getControllerProperties();
};

#endif
