#ifndef __NL_IVIEW_H
#define __NL_IVIEW_H

#include <nucleus/core/Compositor.hpp>

class IView {
public:
    Compositor* getCompositor();
    /**
     * @brief Get the Layer object
     * 
     * @param layerId the id given by the view when it was attached
     * @return Layer* 
     */
    Layer* getLayer(int layerId);
};

#endif