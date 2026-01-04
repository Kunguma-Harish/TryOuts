#ifndef __NL_EVENTCONTROLLER_H
#define __NL_EVENTCONTROLLER_H

#include <app/controllers/NLController.hpp>
#include <app/controllers/NLSelectionController.hpp>
#include <nucleus/core/layers/NLLayer.hpp>

class NLEventController : public NLController, public NLSelectionController, public NLLayer {
public:
    NLEventController(ControllerProperties* properties, ZSelectionHandler* selectionHandler, NLLayerProperties* layerProperties, graphikos::painter::GLRect viewPortRect) : NLController(properties), NLSelectionController(selectionHandler), NLLayer(layerProperties, viewPortRect) {}
};

#endif