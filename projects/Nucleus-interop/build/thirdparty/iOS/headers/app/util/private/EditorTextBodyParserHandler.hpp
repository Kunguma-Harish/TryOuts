#ifndef __NL_EDITORTEXTBODYPARSERHANDLER_H
#define __NL_EDITORTEXTBODYPARSERHANDLER_H
#include <painter/TextBodyPainter.hpp>
#include <sktexteditor/editor.h>
#include <app/private/TextEditorControllerImpl.hpp>
#include <sktexteditor/characterbreaks.h>
#include <parastyle.pb.h>
#include <portion.pb.h>
#define REPLACEMENT_CHARACTER "\uFFFC"

namespace com {
namespace zoho {
namespace shapes {
class ParaStyle;
class Portion;
}
}
}
class EditorTextBodyParserHandler : public graphikos::painter::TextBodyPainter::TextBodyParserHandler {
public:
    std::vector<sktexteditor::Editor::TextParagraph> paras;
    std::unique_ptr<std::vector<std::unique_ptr<graphikos::painter::internal::TextBulletDetails>>> bulletDetails = std::make_unique<std::vector<std::unique_ptr<graphikos::painter::internal::TextBulletDetails>>>();

    EditorTextBodyParserHandler(sktexteditor::Editor* editor) {
        this->editor = editor;
        this->applyBulletStrike = false;
        this->applyStyleForField = false;
        this->applyStyleForHyperlink = false;
        this->createBulletForEmptyLines = true;
    }

    void beginParagraph(skia::textlayout::ParagraphStyle paraStyle, com::zoho::shapes::ParaStyle protoParaStyle, std::optional<skia::textlayout::PlaceholderStyle> bulletStyle, sk_sp<skia::textlayout::FontCollection> fontCollection) override {
        if (editor)
            editor->setFontCollection(fontCollection);
        sktexteditor::Editor::EditorParaStyle editorParaStyle;
        editorParaStyle.paraStyle = paraStyle;
        editorParaStyle.paraSpacingBefore = graphikos::painter::TextBodyPainter::getParaSpacingBefore(protoParaStyle);
        editorParaStyle.paraSpacingAfter = graphikos::painter::TextBodyPainter::getParaSpacingAfter(protoParaStyle);
        editorParaStyle.bulletStyle = bulletStyle;
        this->currentParaStyle = editorParaStyle;
        this->protoParaStyle = protoParaStyle;
    }
    void newPortion(const com::zoho::shapes::Portion* portion, skia::textlayout::TextStyle textStyle, const com::zoho::shapes::Transform& transform, graphikos::painter::IProvider* provider, std::optional<std::pair<std::string, skia::textlayout::PlaceholderStyle>> emojiPlaceholder = std::nullopt) override {
        sktexteditor::Editor::PortionStyle portionStyle;
        portionStyle.skStyle = textStyle;
        std::string text = portion->has_t() ? portion->t() : "";
        if (portion->has_type() && portion->type() == com::zoho::shapes::Portion::FIELD) {
            if (portion->field().type() == com::zoho::shapes::TextField::USER) {
                portionStyle.customStyle[ZTextEditorUtilInternal::EditorCustomStyleKey::userMention] = portion->field().user().zuid();
                portionStyle.singleUnit = true;
            } else if (portion->field().type() == com::zoho::shapes::TextField::EMOJI && emojiPlaceholder.has_value()) {
                portionStyle.customStyle[ZTextEditorUtilInternal::EditorCustomStyleKey::emojiFieldImageKey] = emojiPlaceholder.value().first;
                portionStyle.placeholderStyle = emojiPlaceholder.value().second;
                text = REPLACEMENT_CHARACTER;
            }
        } else {
            if (emojiPlaceholder.has_value()) {
                portionStyle.customStyle[ZTextEditorUtilInternal::EditorCustomStyleKey::emojiImageKey] = emojiPlaceholder.value().first;
                portionStyle.placeholderStyle = emojiPlaceholder.value().second;
                text = REPLACEMENT_CHARACTER;
            }
        }
        if (graphikos::painter::TextBodyPainter::isHyperlink(portion->props())) {
            portionStyle.customStyle[ZTextEditorUtilInternal::EditorCustomStyleKey::hyperlink] = true;
        }
        if (graphikos::painter::TextBodyPainter::isErrorText(*portion)) {
            portionStyle.customStyle[ZTextEditorUtilInternal::EditorCustomStyleKey::errorText] = true;
        }
        std::optional<SkPaint> highlightPaint = graphikos::painter::TextBodyPainter::getHighlightBgPaint(*portion, transform, provider);
        if (highlightPaint.has_value()) {
            portionStyle.customStyle[ZTextEditorUtilInternal::EditorCustomStyleKey::highlightBgPaint] = highlightPaint.value();
        }
        this->currentRuns.push_back({text, portionStyle});
    }
    void endParagraph(std::unique_ptr<graphikos::painter::internal::TextBulletDetails> bulletDetails, float noWrapTranslateX, float layoutWidth) override {
        std::string text;
        std::vector<sktexteditor::Editor::StyleSpan> textStyles;
        size_t currentLength = 0;
        for (auto run : this->currentRuns) {
            currentLength += sktexteditor::charactersCount(run.first.c_str(), run.first.length());
            text += run.first;
            textStyles.push_back({currentLength, run.second});
        }
        sktexteditor::Editor::TextParagraph newPara({text.c_str(), text.size()});
        newPara.styles = textStyles;
        newPara.paraStyle = this->currentParaStyle;
        newPara.layoutWidth = layoutWidth;
        if (this->protoParaStyle.has_margin() && this->protoParaStyle.mutable_margin()->has_left()) {
            newPara.fOrigin.fX = this->protoParaStyle.mutable_margin()->left();
        }
        newPara.fOrigin.fX += noWrapTranslateX;
        if (editor)
            editor->addPara(newPara);
        paras.push_back(newPara);

        this->currentRuns.clear();
        this->bulletDetails->push_back(std::move(bulletDetails));
    }

private:
    sktexteditor::Editor* editor = nullptr;
    sktexteditor::Editor::EditorParaStyle currentParaStyle;
    com::zoho::shapes::ParaStyle protoParaStyle;
    std::vector<std::pair<std::string, sktexteditor::Editor::PortionStyle>> currentRuns;
};

#endif