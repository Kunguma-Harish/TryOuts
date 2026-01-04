#ifndef __NL_VANIREACTIONCONTROLLER_H
#define __NL_VANIREACTIONCONTROLLER_H

#include <app/controllers/NLEventController.hpp>

namespace com {
namespace zoho {
namespace common {
enum Reaction_ReactionStatus : int;
class Reaction;
}
}
}
class VaniReactionController : public NLEventController {
    NLDataController* data = nullptr;
    ControllerProperties* properties;

public:
    bool enableEditing = false;
    bool isReactionPopoverOpened = false;
    VaniReactionController(NLDataController* dataController, ZSelectionHandler* selectionHandler, ControllerProperties* properties);
    void onAttach() override;
    void onDetach() override;
    void onDataChange() override;

    bool onMouseDown(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onMouseMove(const graphikos::painter::GLPoint& mouse, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onMouseUp(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
};

#endif