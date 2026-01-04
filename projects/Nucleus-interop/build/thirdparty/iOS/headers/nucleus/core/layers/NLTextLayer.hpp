#ifndef __NL_TEXTLAYER_H
#define __NL_TEXTLAYER_H

#include <nucleus/core/layers/NLLayer.hpp>
#include <modules/skparagraph/include/ParagraphBuilder.h>
#include <nucleus/core/layers/NLRenderLayer.hpp>

struct TextProperties {
    std::string textId = "";
    std::string data = "";
    graphikos::painter::GLPoint point;
    SkFont font;
    SkPaint paint;
    bool retain_scale = false;
    graphikos::painter::GLPoint offset;
    bool showEllipsis = false;
    graphikos::painter::GLRect textRect;
    graphikos::painter::GLRect ellipsisRect;
    float minEllipsisWidth = 0;
    graphikos::painter::GLRect restrictorRect;
    graphikos::painter::GLRect cullRect;
    sk_sp<SkFontMgr> customFontMgr;
    std::shared_ptr<skia::textlayout::Paragraph> paragraph = nullptr;
    void updateData(std::string data, SkFont font);

    float rotate = 0.0f; // degrees (need to completely handle this - for now works only with rendering text rotated, isWithinText will not work correctly for this)

    bool retain_width = false;
    int reatinedWidth = 0;
    bool isBeingEdited = false; //skips to render the text under onDraw

    TextProperties();
    TextProperties(std::string data, graphikos::painter::GLPoint point, SkFont font, SkPaint paint, bool retain_scale = false, graphikos::painter::GLPoint offset = graphikos::painter::GLPoint(0, 0), bool showEllipsis = false, graphikos::painter::GLRect ellipsisRect = graphikos::painter::GLRect(), bool retain_width = false, int retainedWidth = 0, std::string textId = "", graphikos::painter::GLRect restrictorRect = graphikos::painter::GLRect(), graphikos::painter::GLRect cullRect = graphikos::painter::GLRect(), sk_sp<SkFontMgr> customFontMgr = nullptr, float rotate = 0.0f);
};

struct DirtyTextProperties {
    graphikos::painter::GLPoint point;
    graphikos::painter::GLPoint offset;
    bool retain_scale = false;
    graphikos::painter::GLRect textRect;
    float rotate = 0.0f;

    DirtyTextProperties(const TextProperties& text);
};

class NLTextLayer : public NLLayer {
    bool isLayerEditable = false;

protected:
    std::vector<DirtyTextProperties> dirtyTexts;
    std::vector<TextProperties> texts;
    graphikos::painter::GLRect getDirtyRectFromData(const SkMatrix& totalMatrix) override;
    bool useNativeTextInput = false;
    int clickCount = 0;

    //vars for editor implemantation.
    bool isEditorAttached = false; // set as true when a text is enters text-edit mode
    int editorTextIndex = -1;      // index of the text under texts that is currenty under text-edit mode

public:
    static std::shared_ptr<NLTextLayer> create(bool setAsEditable, NLLayerProperties* properties, graphikos::painter::GLRect viewPortRect, SkColor layerColor = SK_ColorTRANSPARENT);
    NLTextLayer(bool setAsEditable, NLLayerProperties* properties, graphikos::painter::GLRect viewPortRect, SkColor layerColor = SK_ColorTRANSPARENT);
    void onDataChange() override;
    bool onDraw(SkCanvas* canvas, NLDeferredDetails* dd, SkMatrix totalMatrix = SkMatrix(), bool applyContentScale = true) override;

    void addTextProperties(TextProperties text);
    bool deleteTextProperty(size_t index);
    void emptyTextProperties();
    TextProperties getTextProperties(const std::string& textId);
    int getTextIndexFromId(std::string textId);

    std::vector<TextProperties> getTexts();
    bool hasTexts();

    void updateTextData(std::string& textId, std::string data, SkFont font);
    void updateTextData(size_t index, std::string data, SkFont font);

    bool shouldPreventTextRender(TextProperties text, const SkMatrix& matrix);
    bool isWithinText(const graphikos::painter::GLPoint& point, TextProperties text, const SkMatrix& matrix);
    bool isWithinText(const graphikos::painter::GLPoint& point, std::string textId, const SkMatrix& matrix);
    int isWithinText(const graphikos::painter::GLPoint& point, const SkMatrix& matrix);
    virtual graphikos::painter::GLRect getBoundingRectForTextEditor() { return graphikos::painter::GLRect(); }
    graphikos::painter::GLRect getContentRect();
};

class TextLayerUtil {
public:
    static std::shared_ptr<skia::textlayout::Paragraph> getParagraph(const std::string data, const SkFont font, const SkPaint paint, bool showEllipsis, float layoutWidth, sk_sp<SkFontMgr> customFontMgr = nullptr);
    static float measureText(SkFont font, std::string value);
    static std::vector<size_t> characterBreaks(const char* utf8, size_t len);
};

#endif
