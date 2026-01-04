#ifndef __NL_TEXTCHANGEDEPENDENCY_H
#define __NL_TEXTCHANGEDEPENDENCY_H
#include <skia-extension/Matrices.hpp>
#include <app/ConnectorController.hpp>
#include <painter/IProvider.hpp>
#include <app/controllers/NLController.hpp>
namespace com {
namespace zoho {
namespace shapes {
class TextBody;
class Transform;
}
}
}
// TODO: Should we expose ShapeData here? This must be handled without it.
struct ShapeData;
struct TableDependentDetails {
    NLCacheBuilder* cacheBuilder;
    int selectedRowIndex;
    int selectedCellIndex;
    ControllerProperties* properties;

public:
    TableDependentDetails(NLCacheBuilder* cacheBuilder, int selectedRowIndex, int selectedCellIndex, ControllerProperties* properties) {
        this->cacheBuilder = cacheBuilder;
        this->selectedRowIndex = selectedRowIndex;
        this->selectedCellIndex = selectedCellIndex;
        this->properties = properties;
    }
    TableDependentDetails();
    bool operator==(const TableDependentDetails& tableData) const {
        if (tableData.cacheBuilder == this->cacheBuilder && tableData.properties == this->properties && tableData.selectedCellIndex == this->selectedCellIndex && tableData.selectedRowIndex == this->selectedRowIndex)
            return true;
        else
            return false;
    }
};
class TextChangeDependency {
public:
    static std::shared_ptr<TextChangeDependency> create();

    virtual void init(com::zoho::shapes::Transform* transform, com::zoho::shapes::TextBody* textBody, graphikos::painter::Matrices matrices, graphikos::painter::IProvider* provider, bool textbox = false) = 0;
    virtual std::pair<std::vector<ShapeData>, bool> textDependencyChanges(com::zoho::shapes::ShapeObject* shapeObject, com::zoho::shapes::TextBody* textBody, graphikos::painter::Matrices matrices, NLDataController* dataLayer, com::zoho::shapes::Transform* transform = nullptr, ConnectorController* connectorController = nullptr, SelectedShape shape = SelectedShape(), bool doNotAutofit = false) = 0;

    virtual ~TextChangeDependency() {};
};

#endif