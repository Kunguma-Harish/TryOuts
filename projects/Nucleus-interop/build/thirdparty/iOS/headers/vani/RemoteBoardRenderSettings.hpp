#ifndef __VANI_RENDER_SETTINGS__
#define __VANI_RENDER_SETTINGS__

#include <painter/RenderSettings.hpp>

struct RemoteBoardRenderSettings {
    graphikos::painter::RenderSettings rs;

    RemoteBoardRenderSettings() {
        rs.useTransformFromProperties = true;
        rs.flipTextNeeded = false;
        rs.useLocalFonts = true;
        rs.usePxForText = true;
        rs.renderEmojiWithImage = true;
        rs.useFontShapes = false;
        rs.removeDuplicateStops = true;
    }

    /* controls whether we should draw 'shadow' for frame or not */
    bool drawShadowForFrame = true;
};

#endif
