/**
 * Project Untitled
 */

#ifndef _FONTMANAGER_H
#define _FONTMANAGER_H

#include <iostream>
#include <memory>

class SkFont;

namespace graphikos {
namespace painter {
namespace text {
class FontManager {
private:
    static std::shared_ptr<FontManager> instance;

public:
    FontManager();

    /**
 * @param font
 */
    void addFont(SkFont font);

    /**
 * @param fontName
 */
    void removeFont(std::string fontName);

    static std::shared_ptr<FontManager> getInstance();
};
}
}
}

#endif //_FONTMANAGER_H