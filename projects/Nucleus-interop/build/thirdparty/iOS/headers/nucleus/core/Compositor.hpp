#ifndef __NL_COMPOSITOR_H
#define __NL_COMPOSITOR_H

#include <include/core/SkBitmap.h>

struct Layer {
    int layerId;
    SkBitmap buffer;
};

class Compositor {
public:
    Compositor();
};

#endif