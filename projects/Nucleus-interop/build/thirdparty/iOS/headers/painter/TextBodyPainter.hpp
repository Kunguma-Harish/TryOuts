#pragma once

#include <string>
#include <vector>

#include <painter/DrawingContext.hpp>
#include <skia-extension/GLRect.hpp>
#include <painter/IProvider.hpp>

#include <include/core/SkFontMgr.h>
#include <modules/skparagraph/include/TextStyle.h>
#include <modules/skparagraph/include/ParagraphBuilder.h>
#include <include/core/SkImage.h>
#include <cfloat>

namespace com {
namespace zoho {
namespace shapes {
class PortionProps;
class TextBody;
class TextField;
class Transform;
class Paragraph;
class TextStyle;
class Portion;

class Margin;
class ParaStyle_ListStyle_BulletData_NumberedBullet;
class ParaStyle_ListStyle_BulletData_SelectableBullet;
}
namespace common {
enum HorizontalAlignType : int;
class Dimension;
enum HorizontalAlignType : int;
}
}
}

namespace google {
namespace protobuf {
template <typename T>
class RepeatedPtrField;
}
}

namespace skia {
namespace textlayout {
class Paragraph;
class ParagraphBuilder;
class ParagraphStyle;
class TextStyle;
class PlaceholderStyle;
class FontCollection;
}
}

class SkImage;
class SkData;
class SkCanvas;
class SkFontMgr;

namespace graphikos {
namespace painter {
namespace internal {
struct TextBulletDetails;
}
}
}

#define GET_UNIQUE_EMOJI_ID(POSTSCRIPT_NAME, CODEPOINT) \
    "FONT-" + POSTSCRIPT_NAME + "-" + CODEPOINT
#define EMOJI_SYSTEM_DEFAULT_FONT_KEY "_SystemDefault_"

namespace graphikos {
namespace painter {
class TextBodyPainter {
public:
    struct TextBlock {
        std::string text;
        skia::textlayout::TextStyle textStyle;
        size_t startIndex = 0;
        bool isError = false; // for spell check
        bool isUnderLine = false;
        std::optional<SkPaint> highlightBgPaint = std::nullopt;
    };

    struct FontRequestData {
        std::string fontName;
        int weight;
        bool italic;
    };

protected:
    com::zoho::shapes::TextBody* textBody = nullptr;
    sk_sp<SkFontMgr> fontMgr;
    // Value of shape.nvOProps.nvODProps.textbox.
    bool textbox;

private:
    typedef std::vector<std::pair<std::string, sk_sp<SkImage>>> EmojiImages;

    struct PreBuildParaData {
        const google::protobuf::RepeatedPtrField<com::zoho::shapes::Paragraph>& paras;
        const com::zoho::shapes::TextBoxProps& textBoxProps;
        GLRect textBox;
        const com::zoho::shapes::Transform& transform;
        bool usePxForText;
        bool drawOnlyFill;
        bool useLocalFonts;
        bool useFallbackFontRenderer;
        bool isTextBox;
        bool truncateWithEllipsis;
        bool renderTextInEndlessLine;
        bool createBulletForEmptyLines;
        SkColor colorForFieldUser;
        SkMatrix invertedForFill;

        PreBuildParaData(const google::protobuf::RepeatedPtrField<com::zoho::shapes::Paragraph>& paras, const com::zoho::shapes::TextBoxProps& textBoxProps, GLRect textBox, const com::zoho::shapes::Transform& transform, const graphikos::painter::RenderSettings& rs, bool isTextBox, SkMatrix invertedForFill)
            : paras(paras), textBoxProps(textBoxProps), textBox(textBox), transform(transform), isTextBox(isTextBox), invertedForFill(invertedForFill) {
            usePxForText = rs.usePxForText;
            drawOnlyFill = rs.drawOnlyFill;
            useLocalFonts = rs.useLocalFonts;
            useFallbackFontRenderer = rs.useFallbackFontRenderer;
            truncateWithEllipsis = rs.truncateWithEllipsis;
            renderTextInEndlessLine = rs.renderTextInEndlessLine;
            createBulletForEmptyLines = rs.createBulletForEmptyLines;
            colorForFieldUser = rs.colorForFieldUser;
        }
    };

    struct ParaBuildData {
        std::shared_ptr<skia::textlayout::ParagraphStyle> currentParaStyle = nullptr;
        std::optional<skia::textlayout::PlaceholderStyle> currentBulletPlaceholderStyle = std::nullopt;
        std::string totalString = "";
        EmojiImages emojiImagesWithKey;
        std::vector<FontRequestData> fontRequestData = {};

        struct TextBlockForPaint : TextBlock {
            enum BlockType {
                string,
                placeholder
            };
            BlockType type;
            skia::textlayout::PlaceholderStyle placeholderStyle;
        };
        std::vector<TextBlockForPaint> textBlocksForPaint = {};
        struct TextBlockForParser : TextBlock {
            std::shared_ptr<com::zoho::shapes::Portion> portion = nullptr;
            std::optional<std::pair<std::string, skia::textlayout::PlaceholderStyle>> emojiPlaceholder = std::nullopt;
        };
        std::vector<TextBlockForParser> textBlocksForParser = {};

        struct FinalParaData {
            size_t paraIndex;
            std::shared_ptr<skia::textlayout::Paragraph> paragraph;
            float xOffset;
            float noWrapTranslateX;
            float paraHeight;
            float beforeSpacing;
            float afterSpacing;
            std::string paraId;
            bool containsBulletPlaceholder;
            float firstLinePos;
        };
        std::shared_ptr<FinalParaData> finalParaData;

        size_t getByteSize() const;
    };

    static std::unordered_map<std::string, std::pair<ParaBuildData, bool>> paraBuildDataCache;
    static size_t currentPreBuildParaDataByteSize;

public:
    /**
     * @brief Constructs a TextBodyPainter object.
     *
     * @param _textBody A pointer to the com::zoho::shapes::TextBody object that the painter will work with.
     * @param textbox Set this from 'shape.nvOProps.nvODProps.textbox'.
     */
    TextBodyPainter(com::zoho::shapes::TextBody* _textBody, bool textbox);
    static sk_sp<SkFontMgr> GetFontMgr(const RenderSettings& rs);
    class TextBodyParserHandler {
    public:
        bool applyBulletStrike = true;
        bool applyStyleForField = true;
        bool applyStyleForHyperlink = true;
        /**
        * @brief Populates bullet data for empty lines as if it is not empty.
        * Bullets of other non-empty lines are generated as usual considering empty lines as empty.
        * Example:
        * 1. First line
        * 2. <empty line>
        * 3. Second line
        */
        bool createBulletForEmptyLines = false;
        virtual void beginParagraph(skia::textlayout::ParagraphStyle paraStyle, com::zoho::shapes::ParaStyle protoParaStyle, std::optional<skia::textlayout::PlaceholderStyle> bulletStyle, sk_sp<skia::textlayout::FontCollection> fontCollection) = 0;
        virtual void newPortion(const com::zoho::shapes::Portion* portion, skia::textlayout::TextStyle textStyle, const com::zoho::shapes::Transform& transform, IProvider* provider, std::optional<std::pair<std::string, skia::textlayout::PlaceholderStyle>> emojiPlaceholder = std::nullopt) = 0;
        virtual void endParagraph(std::unique_ptr<internal::TextBulletDetails> bulletDetails, float noWrapTranslateX, float layoutWidth) = 0;
    };
    bool parseTextBody(const com::zoho::shapes::Transform& transform, const DrawingContext& dc, std::string shapeId, TextBodyParserHandler* handler);
    static sk_sp<SkFontMgr> getCustomFontMgr() { return customFontMgr; }
    static sk_sp<SkFontMgr> getDefaultFontMgr() { return defaultFontMgr; }
    static void setDefaultFontMgr(sk_sp<SkFontMgr> fontMgr);
    static void setCustomFontMgr(sk_sp<SkFontMgr> fontMgr);
    static std::vector<sk_sp<SkData>> customFontDatas;
    static void addFontDataToCustomFontMgr(sk_sp<SkData> fontData);
    static void addFontDataToDefaultFontMgr(sk_sp<SkData> fontData);
    static void addFontDatasToDefaultFontMgr(std::vector<sk_sp<SkData>> fontDatas);
    static std::vector<SkString> getDefaultFontFamilies() { return defaultFontFamilies; }
    static bool checkAndRequestFallbackFonts(std::string str, std::string shapeId, IProvider* provider);

    static void removeFontFromFallbackMap(std::string fontFamily);
    static void clearParagraphCache();

    /**
   * @brief Draws text on the specified canvas based on the given params
   * @param canvas Canvas to draw
   * @param textBody com::zoho::shapes::TextBody to draw to the canvas
   * @param transform
   * @param matrix
   * @return true Rendering was a success
   * @return false Rendering failed
   */

    bool draw(const com::zoho::shapes::Transform& transform, const DrawingContext& dc, std::string shapeId = "", std::string cellId = "", com::zoho::shapes::Properties* props = nullptr, float customWidth = -1);
    bool getCombinedTextPath(graphikos::painter::GLPath& result, const com::zoho::shapes::Transform& transform, const DrawingContext& dc, bool needRefreshFrame, std::string shapeId);
    std::vector<GLRect> getParaRects(const com::zoho::shapes::Transform& transform, const DrawingContext& dc, std::string shapeId);

    /**
     * Sets the font families and font style for the given text style based on the provided portion properties.
     *
     * @param props The portion properties containing font-related attributes.
     * @param skStyle The Skia TextStyle object to be updated with the font settings.
     * @param useLocalFonts A boolean indicating whether to use local fonts.
     * @param useFallbackFontRenderer A boolean indicating whether to use a fallback font renderer.
     * @param provider A pointer to the font provider interface for resolving font resources.
     * @param fontRequestData A reference to the FontRequestData object for handling font requests.
     * @return True if the font families and style were successfully set; otherwise, false.
     */
    static bool setFontFamiliesAndFontStyle(const com::zoho::shapes::PortionProps& props, skia::textlayout::TextStyle& skStyle, bool useLocalFonts, bool useFallbackFontRenderer, IProvider* provider, FontRequestData& fontRequestData);
    static bool buildPortions(const com::zoho::shapes::Portion& portion, const com::zoho::shapes::Transform& transform, com::zoho::shapes::ParaStyle& mergedStyle, IProvider* provider, bool usePxForText, bool drawOnlyFill, bool useLocalFonts, bool useFallbackFontRenderer, SkColor colorForFieldUser, ParaBuildData& currentParaBuildData, sk_sp<SkFontMgr> fontMgr, bool isStriked, SkMatrix invertedForFill, bool& textPresent, float lineSpacing, float fontSizeScale, bool& linebreakContinuation, TextBodyParserHandler* parserHandler, std::string shapeId);
    static bool buildParas(PreBuildParaData preBuildData, IProvider* provider, ParaBuildData& currentParaBuildData, sk_sp<SkFontMgr> fontMgr, std::function<void(size_t, skia::textlayout::Paragraph*, internal::TextBulletDetails*, float, float, float, float, std::string, bool)> visitorFn, TextBodyParserHandler* parserHandler, std::string shapeId = "");
    static std::unique_ptr<internal::TextBulletDetails> createBulletDetails(skia::textlayout::ParagraphStyle paraStyle, const com::zoho::shapes::ParaStyle* protoParaStyles, const bool* textPresent, float fontSize, int paraIndex, const com::zoho::shapes::Transform& transform, SkPaint textColor, bool usePxForText, IProvider* provider);
    static void updateBulletDetails(internal::TextBulletDetails* bulletDetails, std::optional<com::zoho::common::HorizontalAlignType> halign, float fontSize, float lineOffset, float firstLinePos);
    static std::pair<std::unique_ptr<internal::TextBulletDetails>, std::optional<skia::textlayout::PlaceholderStyle>> buildBulletDetails(skia::textlayout::ParagraphStyle paraStyle, const com::zoho::shapes::ParaStyle* protoParaStyles, const bool* textPresent, float fontSize, int paraIndex, const com::zoho::shapes::Transform& transform, SkPaint textColor, bool usePxForText, IProvider* provider);
    float getParaHeight(const com::zoho::shapes::Transform& transform, Matrices matrices, IProvider* provider, std::string shapeId);
    com::zoho::common::Dimension getShapeDimForMaxWidth(float maxWidth, Matrices matrices, IProvider* provider);
    com::zoho::common::Dimension getShapeDimForFixedWidth(float fixedWidth, Matrices matrices, IProvider* provider, const RenderSettings& renderSettings, std::string shapeId = "");
    bool isPointOnBullet(const com::zoho::shapes::Transform& transform, Matrices matrices, IProvider* provider, float x, float y);

    static std::string trimText(size_t& startIndex, size_t& endIndex, std::string text);
    static std::string trimText(std::string text);
    /**
     * @brief Get the Connector Points for shape connector
     * 
     * @param transform 
     * @param dc 
     * @return std::map<std::string, std::vector<std::vector<float>>> 
     */
    std::map<std::string, std::vector<GLPoint>> getConnectorPoints(const com::zoho::shapes::Transform& transform, const DrawingContext& dc);

    GLRect getTextBoxFrame(GLRect rect);
    SkMatrix getTextBoxMatrix(Matrices matrices, const com::zoho::shapes::Transform& transform, bool flipNeeded);
    static void updateTextBoxForInset(const com::zoho::shapes::Margin& margin, GLRect& textBox);
    static float getVerticalAlignOffset(const com::zoho::shapes::TextBoxProps& props, const float& mergedHeight, const float& textBoxHeight);
    static float getParaSpacingBefore(const com::zoho::shapes::ParaStyle& style);
    static float getParaSpacingAfter(const com::zoho::shapes::ParaStyle& style);
    static bool isEmptyTextBody(const com::zoho::shapes::TextBody* textBody);
    SkPaint setColorToStyle();
    com::zoho::shapes::TextBoxProps getMergedProps(const com::zoho::shapes::TextBody& textBody, IProvider* provider);
    static com::zoho::shapes::ParaStyle getMergedParaStyle(const com::zoho::shapes::Paragraph& para, IProvider* provider, bool textbox);
    bool overrideData(const com::zoho::shapes::TextBody& textBody);
    static bool isHyperlink(const com::zoho::shapes::PortionProps& props);
    static bool isErrorText(const com::zoho::shapes::Portion& portion);
    static bool isHighlightBgPresent(const com::zoho::shapes::Portion& portion);
    static std::optional<SkPaint> getHighlightBgPaint(const com::zoho::shapes::Portion& portion, const com::zoho::shapes::Transform& transform, graphikos::painter::IProvider* provider);

    static void updateStyleForHyperlink(skia::textlayout::TextStyle& style, IProvider* provider, const com::zoho::shapes::Transform& transform);
    static void updateTextColorForHyperlink(skia::textlayout::TextStyle& style, IProvider* provider, const com::zoho::shapes::Transform& transform);

    static float getMaxFontSizeInALine(skia::textlayout::LineMetrics lineMetrics);

    std::shared_ptr<com::zoho::shapes::TextBody> getMergedTextBody(IProvider* provider);
    static SkPath getTransformedBulletPath(internal::TextBulletDetails* bulletDetails, float baseline);
    static GLRect drawBulletFromType(internal::TextBulletDetails* bulletDetails, SkCanvas* canvas, com::zoho::common::Dimension dim, skia::textlayout::Paragraph* paragraph, float mergedWidth);
    static int getBulletPathFromType(internal::TextBulletDetails* bulletDetails, float size, float lineSpacing, const com::zoho::shapes::Transform* transform, SkPaint textColor, bool usePxForText, IProvider* provider);
    static float getWidthFromBulletWith(float fontSize, float bulletWidth, float indent, float left, float* bulletPosition, bool isSelectableBullet);
    static std::string getStringFromFieldAndUpdateStyle(const com::zoho::shapes::TextField& field, skia::textlayout::TextStyle* style, SkColor colorForFieldUser, std::string shapeId, graphikos::painter::IProvider* provider);
    static void updateStyleForUserField(SkColor colorForFieldUser, skia::textlayout::TextStyle* style);
    static std::string getStringFromNumber(const com::zoho::shapes::ParaStyle_ListStyle_BulletData_NumberedBullet& number, int i);
    static std::string convertToRomman(int i, bool upperCase);
    static std::string convertToAlphabets(int i, bool upperCase);
    static void getSelectablePathFromType(const com::zoho::shapes::ParaStyle_ListStyle_BulletData_SelectableBullet& selectable, GLPath* path);
    static int getParaListNum(const com::zoho::shapes::ParaStyle* protoParaStyles, const bool* textPresent, int num);
    static float getFirstLineMidY(skia::textlayout::Paragraph* paragraph);
    static float getFirstLineBaseline(skia::textlayout::Paragraph* paragraph);
    static float getFirstPortionMidY(skia::textlayout::Paragraph* paragraph);

    static std::shared_ptr<com::zoho::shapes::PortionProps> getMergedPortionProps(const com::zoho::shapes::PortionProps* props, const com::zoho::shapes::PortionProps* defaultProps);

    static bool checkIfEmoji(std::string text);

    static skia::textlayout::PlaceholderStyle getPlaceholderStyleForEmoji(std::string emojiId, IProvider* provider, float fontSize, std::vector<std::pair<std::string, sk_sp<SkImage>>>* emojiImagesWithKey);

    static GLPath drawErrorLine(TextBlock& textBlocksForPaint, std::vector<size_t>& lineEndOffsets, std::vector<skia::textlayout::LineMetrics>& lineMetrics, std::vector<skia::textlayout::TextBox>& rects, SkMatrix matrix, SkCanvas* canvas);
    static GLPath drawHighlight(TextBlock& textBlocksForPaint, std::vector<size_t>& lineEndOffsets, std::vector<skia::textlayout::LineMetrics>& lineMetrics, std::vector<skia::textlayout::TextBox>& rects, SkMatrix matrix, SkCanvas* canvas);
    static GLPath drawUnderLine(TextBlock& textBlocksForPaint, std::vector<size_t>& lineEndOffsets, std::vector<skia::textlayout::LineMetrics>& lineMetrics, std::vector<skia::textlayout::TextBox>& rects, SkMatrix matrix, SkCanvas* canvas);
    void drawUnderLineErrorLineAndHighlight(skia::textlayout::Paragraph* paragraph, SkCanvas* canvas, SkCanvas* canvasBehindTextAndSelection, const DrawingContext& dc, bool& errorLinePresent, GLPath& totalPath, const SkMatrix& matrix);

    static int getSizeOfCustomFonts();
    static int getSizeOfDefaultFonts();

private:
    static sk_sp<SkFontMgr> customFontMgr;
    static sk_sp<SkFontMgr> defaultFontMgr;
    static std::vector<sk_sp<SkData>> defaultFontDatas;
    static std::vector<SkString> defaultFontFamilies;
    static std::vector<std::string> supportedScripts;
    static std::map<std::string, std::unordered_set<std::string>> textFallbackFontMap;

    ParaBuildData currentParaBuildData = ParaBuildData();

    std::tuple<std::vector<size_t>, std::vector<skia::textlayout::LineMetrics>> getLineDetailsForDecorationRendering(skia::textlayout::Paragraph* paragraph);
    static void addPlaceholderForEmojiImages(const com::zoho::shapes::Portion& portion, const skia::textlayout::TextStyle& style, IProvider* provider, TextBodyParserHandler* parserHandler, ParaBuildData& currentParaBuildData, bool isUnderline, std::optional<SkPaint> highlightBgPaint);
    static void clearCaches();
};
}
}
