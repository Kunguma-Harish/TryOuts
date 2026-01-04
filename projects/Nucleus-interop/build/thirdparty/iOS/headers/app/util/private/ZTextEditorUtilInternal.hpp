#ifndef __NL_ZTEXTEDITORUTILINTERNAL_H
#define __NL_ZTEXTEDITORUTILINTERNAL_H
#include <app/TextEditorController.hpp>
#include <painter/IProvider.hpp>
#include <sktexteditor/editor.h>

// For BEST AutoFitType
#define FONTSCALEINCREMENTVALUE 0.0500000000

// For NORMAL AutoFitType
#define FONTSCALELOWERLIMIT 0.25
#define LINESPACESCALELOWERLIMIT 0.8

namespace com {
namespace zoho {
namespace shapes {
class ShapeObject;
class TextBody;
class AutoFit;
}
}
}

class ZTextEditorUtilInternal {
public:
    struct ScaleValue {
        float fontScale;
        float lineSpaceScale;
        ScaleValue(float _fontScale = -1, float _lineSpaceScale = -1) : fontScale(_fontScale), lineSpaceScale(_lineSpaceScale) {}
    };

    struct EditorCustomStyleKey {
        static const std::string userMention;
        static const std::string emojiImageKey;
        static const std::string emojiFieldImageKey; // For the older projects, insering twemoji will be rendered as a Field.
        static const std::string hyperlink;
        static const std::string errorText;
        static const std::string highlightBgPaint;
    };

    static bool checkForBestFit(com::zoho::shapes::TextBody* textBody);
    static bool checkForShapeFit(com::zoho::shapes::TextBody* textBody);
    static ScaleValue getAutofitValue(com::zoho::shapes::AutoFit* autofit);
    static ScaleValue getAutoFitValue(com::zoho::shapes::ShapeObject* shapeObject, graphikos::painter::Matrices matrices, com::zoho::shapes::TextBody* textBody, graphikos::painter::IProvider* provider, com::zoho::shapes::Transform* trans = nullptr);
    static void setAutofitValue(com::zoho::shapes::AutoFit* autofit, ScaleValue scaleValue);
    static com::zoho::shapes::Transform getShapeFitValue(com::zoho::shapes::ShapeObject* shapeObject, graphikos::painter::Matrices matrices, com::zoho::shapes::TextBody* textBody, graphikos::painter::IProvider* provider);

    static ScaleValue checkAndGetAutoFitValue(com::zoho::shapes::ShapeObject* shapeObject, graphikos::painter::Matrices matrices, com::zoho::shapes::TextBody* textBody, graphikos::painter::IProvider* provider, sktexteditor::Editor* textEditor, com::zoho::shapes::AutoFit* autofit, com::zoho::shapes::Transform* trans = nullptr);

    static bool restrictTextInsert(graphikos::painter::ShapeDetails shapeDetail, std::string value, const TextEditorController* textEditorInterface, NLDataController* dataLayer, bool isEnter = false, bool isPaste = false);

    static sktexteditor::StringSlice replacePlaceHolderWithActualData(const sktexteditor::StringSlice& sourceText, const std::vector<sktexteditor::Editor::StyleSpan>& styles, size_t& updateIndex, bool indexCalculation = true);
    static std::string textForComposer(sktexteditor::Editor* editor, sktexteditor::Editor::SelectionRange affectedRange);

private:
    static std::vector<ScaleValue> fontScaleMapping; // fontscale , linespace scale;
    static bool checkForNormalFit(com::zoho::shapes::TextBody* textBody);
    static bool checkForRestrictFit(com::zoho::shapes::TextBody* textBody);
    static bool checkForDefinedBoundaryShape(com::zoho::shapes::TextBody* textBody);
    static ScaleValue getBestFitValue(com::zoho::shapes::ShapeObject* shapeObject, graphikos::painter::Matrices matrices, com::zoho::shapes::TextBody* textBody, graphikos::painter::IProvider* provider, sktexteditor::Editor* textEditor, com::zoho::shapes::AutoFit* currentAutofit, com::zoho::shapes::Transform* trans = nullptr);

    // for below two function inset parameter has to same so that they can be compared with each other
    static graphikos::painter::GLRect getTextContainerHeight(com::zoho::shapes::ShapeObject* shapeObject, graphikos::painter::IProvider* provider, graphikos::painter::Matrices matrices = graphikos::painter::Matrices(), bool withInset = false, com::zoho::shapes::Transform* transform = nullptr);
    static float calculateTextHeight(com::zoho::shapes::TextBody* textBody, com::zoho::shapes::ShapeObject* shapeObject, graphikos::painter::Matrices matrices, graphikos::painter::IProvider* provider, bool addInset = true, com::zoho::shapes::Transform* transform = nullptr);

    static TextEditorController::ShapingResult changeTempFontScale(float fontScale, sktexteditor::Editor* textEditor, float containerWidth);

    static ScaleValue getUpperScaleValue(com::zoho::shapes::ShapeObject* shapeObject, graphikos::painter::Matrices matrices, ScaleValue oldValue, float containerHeight, com::zoho::shapes::TextBody* textBody, graphikos::painter::IProvider* provider, com::zoho::shapes::Transform* trans = nullptr);
    static ScaleValue getLowerScaleValue(com::zoho::shapes::ShapeObject* shapeObject, graphikos::painter::Matrices matrices, ScaleValue oldValue, float containerHeight, com::zoho::shapes::TextBody* textBody, graphikos::painter::IProvider* provider, com::zoho::shapes::Transform* trans = nullptr);

    static ScaleValue getUpperBestFitValue(com::zoho::shapes::ShapeObject* shapeObject, graphikos::painter::Matrices matrices, ScaleValue oldValue, float containerHeight, float containerWidth, com::zoho::shapes::TextBody* textBody, graphikos::painter::IProvider* provider, sktexteditor::Editor* textEditor, float originalFontScale, com::zoho::shapes::Transform* trans = nullptr);
    static ScaleValue getLowerBestFitValue(com::zoho::shapes::ShapeObject* shapeObject, graphikos::painter::Matrices matrices, ScaleValue oldValue, float containerHeight, float containerWidth, com::zoho::shapes::TextBody* textBody, graphikos::painter::IProvider* provider, sktexteditor::Editor* textEditor, float originalFontScale, com::zoho::shapes::Transform* trans = nullptr);

    static float getTextBox(float maxHeight);
    static int findScaleIndex(ScaleValue scaleValue);
};
#endif
