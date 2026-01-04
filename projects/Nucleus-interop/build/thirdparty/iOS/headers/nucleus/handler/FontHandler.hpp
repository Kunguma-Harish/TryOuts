#ifndef __NL_FONTHANDLER_H
#define __NL_FONTHANDLER_H

#include <string>
#include <vector>
#include <map>

namespace com {
namespace zoho {
namespace shapes {
class Font;
}
}
}

class SkFont;
class SkTypeface;
class SkFontStyle;

template <typename T>
class sk_sp;

/**
 * @class FontHandler
 * Provides functions for loading and selecting fonts
 */
class FontHandler {
private:
    static FontHandler* instance;
    FontHandler();

public:
    static FontHandler* getInstance();

    /**
   * @brief Get the Available Font Families from the operating system
   * @return std::vector<std::string>
   */
    static std::vector<std::string> getAvailableFontFamilies();

    /**
   * @brief Return the available fontWeights for the given family name
   * @param familyName
   * @return std::map<std::string,SkFontStyle*>
   */
    std::map<std::string, SkFontStyle*> getFontWeights(std::string familyName);

    /// @note performs IO operation, should not call for every render operation
    std::vector<sk_sp<SkTypeface>> __getTypefaces();
    std::vector<sk_sp<SkTypeface>> getTypefaces(std::string familyName);
    std::vector<sk_sp<SkTypeface>> getTypefacesFromPoscriptName(
        std::string postScriptName);
    /**
   * @brief Use this if font.proto is set to have a font
   *
   * @param portion
   * @return sk_sp<SkTypeface>
   */
    sk_sp<SkTypeface> getTypeface(com::zoho::shapes::Font* font);

    /**
   * @brief Returns the default the typeface of the platform
   * @return SkTypeface*
   */
    sk_sp<SkTypeface> getDefaultTypeface();

    /**
   * @brief internally calls getDefaultTypeface
   * @return SkFont default font in the platform
   */
    SkFont getDefaultFont();
};

#endif
