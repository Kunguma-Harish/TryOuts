#ifndef __NL_SELECTIONCONTROLLER_H
#define __NL_SELECTIONCONTROLLER_H

#include <string>
#include <include/core/SkColor.h>
#include <app/ZSelectionHandler.hpp>
#include <app/interface/ISelectionListener.hpp>

class NLSelectionController : public ISelectionListener {
private:
    ZSelectionHandler* selectionHandler = nullptr;

public:
    NLSelectionController(ZSelectionHandler* selectionHandler);
    ZSelectionHandler* getSelectionHandler();
    virtual void selectShape(std::string shapeId, SkColor color, bool triggerEvent = true, bool needAnimation = false);
    virtual void selectShape(std::string shapeId, bool triggerEvent = true, bool needToFit = true, bool needAnimation = false, bool maintainScale = false, bool alwaysFit = false);
    virtual void selectShape(std::vector<std::string> ids, bool triggerEvent = true, bool needToFit = true, bool needAnimation = false, bool maintainScale = false, bool alwaysFit = false);
    virtual void clearSelectedShapes(bool triggerEvent, std::string shapeId = "");
    virtual void drawSelectionBox();
};

#endif