#ifndef __NL_WINDOWCONFIG_H
#define __NL_WINDOWCONFIG_H
#include <string>

namespace graphikos {
namespace painter {
struct GLRect;
}
}

/**
 * @brief Contains properties related to window
 */
struct WindowConfig {
    int width = 0;          /* width of a window */
    int height = 0;         /* height of a window */
    float csrX = 1;         /* width content scale ratio */
    float csrY = 1;         /* height content scale ratio */
    int xOffset = 0;        /* xOffset of visible area */
    int yOffset = 0;        /* yOffset of visible area */
    int monitorWidth = 0;   /* width of the monitor */
    int monitorHeight = 0;  /* height of the monitor */
    std::string windowName; /* name of the window */
int isWindowHidden = 0;

    void updateWindow();
    /**
     * @brief Set the screen coordinates, different from screen buffer size
     * @param width
     * @param height
     */
    void setResolution(int width, int height);

    graphikos::painter::GLRect getWindowRect() const;
};

#endif
