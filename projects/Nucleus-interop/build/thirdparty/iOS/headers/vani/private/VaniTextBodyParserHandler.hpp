#ifndef __NL_VANITEXTBODYPARSERHANDLER_H
#define __NL_VANITEXTBODYPARSERHANDLER_H
#include <painter/TextBodyPainter.hpp>
#include <sktexteditor/characterbreaks.h>
#include <parastyle.pb.h>
#include <portion.pb.h>
#include <app/private/CustomTextEditorControllerImpl.hpp>

#define REPLACEMENT_CHARACTER "\uFFFC"

namespace com {
namespace zoho {
namespace shapes {
class ParaStyle;
class Portion;
}
}
}

class VaniTextBodyParserHandler : public graphikos::painter::TextBodyPainter::TextBodyParserHandler {
private:
    std::vector<std::pair<std::string, sktexteditor::Editor::PortionStyle>> currentRuns;

public:
    std::vector<sktexteditor::Editor::TextParagraph> paras;
    sktexteditor::Editor::EditorParaStyle currentParaStyle;
    sk_sp<skia::textlayout::FontCollection> fontCollection;

    void beginParagraph(skia::textlayout::ParagraphStyle paraStyle, com::zoho::shapes::ParaStyle protoParaStyle, std::optional<skia::textlayout::PlaceholderStyle> bulletStyle, sk_sp<skia::textlayout::FontCollection> fontCollection) override {
        sktexteditor::Editor::EditorParaStyle editorParaStyle;
        editorParaStyle.paraStyle = paraStyle;
        editorParaStyle.paraSpacingBefore = graphikos::painter::TextBodyPainter::getParaSpacingBefore(protoParaStyle);
        editorParaStyle.paraSpacingAfter = graphikos::painter::TextBodyPainter::getParaSpacingAfter(protoParaStyle);
        this->currentParaStyle = editorParaStyle;
        this->fontCollection = fontCollection;
    }

    void newPortion(const com::zoho::shapes::Portion* portion, skia::textlayout::TextStyle textStyle, const com::zoho::shapes::Transform& transform, graphikos::painter::IProvider* provider, std::optional<std::pair<std::string, skia::textlayout::PlaceholderStyle>> emojiPlaceholder) override {
        sktexteditor::Editor::PortionStyle portionStyle;
        portionStyle.skStyle = textStyle;
        std::string text = portion->has_t() ? portion->t() : "";
        if (portion->has_type() && portion->type() == com::zoho::shapes::Portion::FIELD) {
            if (portion->field().type() == com::zoho::shapes::TextField::EMOJI && emojiPlaceholder.has_value()) {
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

        paras.push_back(newPara);

        this->currentRuns.clear();
    }
};

#endif