#ifndef SP_RENDERSETTINGS_H
#define SP_RENDERSETTINGS_H

#include <memory>
#include <map>
#include <string>
#include <vector>
#include <painter/util/FieldUtil.hpp>

#include <include/core/SkColor.h>
#include <include/core/SkSamplingOptions.h>

#define STRINGIFY(X) #X
// TODO: Add descriptions for all
#define SP_RENDER_SETTINGS_OPTIONS(O)                                                                                            \
    O(bool, antiAlias, true, "Use antialias")                                                                                    \
    O(bool, doNotRenderFill, false, "Draw stroke")                                                                               \
    O(bool, drawOnlyFill, false, "Draw only fill")                                                                               \
    O(bool, drawBoxOverText, false, "Draws box over the text can be used for testing")                                           \
    O(bool, renderEmojiWithImage, false, "Draw emoji using image")                                                               \
    O(bool, doNotConsiderMask, false, "Do not use mask")                                                                         \
    O(bool, doNotRenderText, false, "Disable text rendering")                                                                    \
    O(bool, renderTextInEndlessLine, false, "Ennable endless text rendering")                                                    \
    O(bool, cloneForTable, true, "Have copy in memory for table ")                                                               \
    O(bool, cacheData, false, "caches table dimension to cache")                                                                 \
    O(bool, fetchDataFromCache, true, "decides wheather to fetch data from cache")                                               \
    O(bool, rendering, false, "")                                                                                                \
    O(bool, usePxForText, false, "Use pixels instead of points when rendering text")                                             \
    O(bool, useFontShapes, true, "controls whether fontshapes should be used or not")                                            \
    O(bool, useLocalFonts, false, "controls whether local fonts loaded through --fonts should be used")                          \
    O(bool, useFallbackFontRenderer, true, "controls whether we should fallback to default, if both local and fontshapes fails") \
    O(bool, useTransformFromProperties, true, "")                                                                                \
    O(bool, clipTextNeeded, false, "controls whether we should clip text inside transform or not")                               \
    O(bool, flipTextNeeded, true, "controls whether we should flip text or not")                                                 \
    O(bool, truncateWithEllipsis, false, "should we truncate text and suffix '...' for text")                                    \
    O(bool, renderErrorLine, true, "should we render error line ")                                                               \
    O(bool, createBulletForEmptyLines, false, "should we render bullet for paras containing an empty text")                      \
    O(bool, drawOnlyStrokePath, false, "Draw only strokePath used to draw only coonnectorPath without textbodies")               \
    O(bool, removeDuplicateStops, false, "Remove the duplicate stop values in the gradient to match the rendering with svg")

#define DEFINE_STRUCT(TYPE, VARIABLE, DEFAULT_VALUE, DESC) TYPE VARIABLE = DEFAULT_VALUE;
#define COPY_RS_VAL(TYPE, VARIABLE, DEFAULT_VALUE, DESC) this->VARIABLE = rs.VARIABLE;

#define CHECK_VECTOR(TYPE, VARIABLE, DEFAULT_VALUE, DESC)                                                          \
    if (std::find(enableSettings.begin(), enableSettings.end(), STRINGIFY(VARIABLE)) != enableSettings.end()) {    \
        this->VARIABLE = true;                                                                                     \
    }                                                                                                              \
    if (std::find(disableSettings.begin(), disableSettings.end(), STRINGIFY(VARIABLE)) != disableSettings.end()) { \
        this->VARIABLE = false;                                                                                    \
    }

namespace graphikos {
namespace painter {
struct RenderSettings {
private:
    RenderSettings(const RenderSettings& rs) {
        SP_RENDER_SETTINGS_OPTIONS(COPY_RS_VAL);
        this->colorForFieldUser = rs.colorForFieldUser;
        this->rowIndex = rs.rowIndex;
        this->cellIndex = rs.cellIndex;
        this->editingTextID = rs.editingTextID;
        this->renderTextInEndlessLine = rs.renderTextInEndlessLine;
    }

public:
    SP_RENDER_SETTINGS_OPTIONS(DEFINE_STRUCT);
    /* com::zoho::shapes::Shape ID of the text that is being edited by the user in an external view */
    std::string editingTextID = "";
    int rowIndex = -1;
    int cellIndex = -1;
    SkColor colorForFieldUser = SkColorSetARGB(255, 17, 85, 221);

    RenderSettings() {}
    RenderSettings clone() const {
        return RenderSettings(*this);
    }

    void merge(std::vector<std::string> enableSettings, std::vector<std::string> disableSettings) {
        SP_RENDER_SETTINGS_OPTIONS(CHECK_VECTOR);
    }

    virtual ~RenderSettings() {}
};
}
}
#undef STRINGIFY
#undef DEFINE_STRUCT
#undef COPY_RS_VAL
#undef CHECK_VECTOR

#endif
