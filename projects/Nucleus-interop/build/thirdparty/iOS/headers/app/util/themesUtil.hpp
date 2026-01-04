#ifndef THEMES_UTIL_HPP
#define THEMES_UTIL_HPP

#include <map>
#include <vector>

namespace theme {
enum class Type;
};

namespace com {
namespace zoho {
namespace theme {
class ThemeInfo;
}
}
}

class ThemesUtil {
public:
    static com::zoho::theme::ThemeInfo getThemeDefault(theme::Type themeName);
    static void addThemeInfo(const com::zoho::theme::ThemeInfo themeInfo, theme::Type themeName);

private:
    static com::zoho::theme::ThemeInfo themes[];
};
#endif
