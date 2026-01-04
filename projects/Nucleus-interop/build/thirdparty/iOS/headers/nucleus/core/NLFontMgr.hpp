#ifndef __NL_FONTMGR_H
#define __NL_FONTMGR_H

#include <include/core/SkFontMgr.h>
#include <vector>

class NLFontMgr {
private:
    static std::vector<sk_sp<SkData>> defaultFontDatas;
    static sk_sp<SkFontMgr> defaultFontManager;

    static void initialise();

public:
    static sk_sp<SkFontMgr> getDefaultFontManager();
};

#endif
