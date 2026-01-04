#ifndef __NL_TEXTCHANGEDEPENDENCYIMPL_H
#define __NL_TEXTCHANGEDEPENDENCYIMPL_H
#include <app/util/TextChangeDependency.hpp>
#include <sktexteditor/editor.h>

class TextChangeDependencyImpl : public TextChangeDependency {
public:
    TextChangeDependencyImpl() {}

    void init(com::zoho::shapes::Transform* transform, com::zoho::shapes::TextBody* textBody, graphikos::painter::Matrices matrices, graphikos::painter::IProvider* provider, bool textbox = false) override;
    std::pair<std::vector<ShapeData>, bool> textDependencyChanges(com::zoho::shapes::ShapeObject* shapeObject, com::zoho::shapes::TextBody* textBody, graphikos::painter::Matrices matrices, NLDataController* dataLayer, com::zoho::shapes::Transform* transform = nullptr, ConnectorController* connectorController = nullptr, SelectedShape shape = SelectedShape(), bool doNotAutofit = false) override;

    static std::pair<std::vector<ShapeData>, bool> textDependencyChanges(com::zoho::shapes::ShapeObject* shapeObject, com::zoho::shapes::TextBody* textBody, graphikos::painter::Matrices matrices, NLDataController* dataLayer, sktexteditor::Editor* textEditor, com::zoho::shapes::Transform* transform = nullptr, ConnectorController* connectorController = nullptr, SelectedShape shape = SelectedShape(), bool doNotAutofit = false, TableDependentDetails* tableDetails = nullptr);
    static std::vector<float> updateRowHeight(SelectedShape shape, NLCacheBuilder* cacheBuilder, graphikos::painter::IProvider* provider, int selectedRowIndex, int selectedCellIndex, com::zoho::shapes::Transform* shapeTransform, com::zoho::shapes::Transform* updatedTransform);

    static void changeLineSpaceScale(float diffInlineSpace, sktexteditor::Editor* textEditor);
    static void changeFontScale(float fontScale, sktexteditor::Editor* _textEditor);
    static graphikos::painter::GLPoint updateTableTransform(SelectedShape& shape, std::vector<ShapeData>& tempData, float height, float width, graphikos::painter::IProvider* provider, ConnectorController* connectorController, com::zoho::shapes::Transform* mergedTransform);
    static graphikos::painter::GLPoint updateTableTransform(SelectedShape& shape, std::vector<ShapeData>& tempData, float height, float width, graphikos::painter::IProvider* provider, std::vector<ModifyData>& dataTobeModified, ConnectorController* connectorController, com::zoho::shapes::Transform* mergedTransform);

    ~TextChangeDependencyImpl() override;

private:
    sktexteditor::Editor* textEditor = nullptr;
};

#endif