#ifndef __NL_NILAPROVIDER_H
#define __NL_NILAPROVIDER_H

#include <painter/IProvider.hpp>
#include <skia-extension/GLRect.hpp>
#include <app/util/themesUtil.hpp>

class SampleProvider : public graphikos::painter::IProvider {

public:
    graphikos::painter::RenderSettings renderSettings;
    theme::Type currentThemeType;

    SampleProvider();
    void setCurrentThemeType(theme::Type type);
    void getColorFromType(com::zoho::shapes::Color* color) override;

    virtual const graphikos::painter::RenderSettings& getRenderSettings() override;
    virtual void setRenderSettings(const graphikos::painter::RenderSettings& renderSetting) override;
    virtual graphikos::painter::RenderSettings& mutableRenderSettings() override;

    com::zoho::shapes::Properties* getStyleProps(std::string styleId, std::string documentId) override;
    com::zoho::shapes::ParaStyle* getStyleForParaStyle(std::string styleId, std::string docId) override;
    com::zoho::shapes::PortionProps* getStyleForPortionProps(std::string styleId, std::string docId) override;
    com::zoho::shapes::TextBoxProps* getTextPropsDefaults() override;
    const com::zoho::shapes::ParaStyle* getParaStyleDefault(int level) override;
    const com::zoho::shapes::ParaStyle* getParaStyleShapeDefault(int level) override;
    com::zoho::shapes::ShapeObject* getLeaderShape(std::string shapeId, std::string docId, com::zoho::shapes::ShapeObject& currentShape) override;

    sk_sp<SkImage> getImage(const com::zoho::shapes::PictureValue& picValue, graphikos::painter::GLRect rect, std::thread::id threadId, com::zoho::shapes::Picture* picture) override;
    void setImageShader(const com::zoho::shapes::PictureValue& picValue, sk_sp<SkShader> shader, graphikos::painter::GLRect rect, graphikos::painter::GLRect refreshRect, SkMatrix matrix, com::zoho::shapes::PictureFill_PictureFillType* picFillType) override;
    com::zoho::shapes::FontShape* getFontShape(std::string postscriptName) override;
    std::multimap<std::string, com::zoho::shapes::Transform> getContainerNameAndTransform() override;

    bool getIsNew() {
        return isNew;
    }
    void setIsNew(bool newMode) override {
        isNew = newMode;
    }
};

#endif
