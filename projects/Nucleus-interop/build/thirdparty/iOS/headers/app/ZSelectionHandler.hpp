#ifndef __NL_ZSELECTIONHANDLER_H
#define __NL_ZSELECTIONHANDLER_H

#include <skia-extension/GLPath.hpp>
#include <include/core/SkMatrix.h>
#include <painter/ShapeObjectPainter.hpp>
#include <skia-extension/util/FnTypes.hpp>
class ISelectionListener;

using SelectedShapeDetails = graphikos::painter::ShapeObjectsDetails;

struct ZConnectorData {
    std::string pos;
    std::string shapeId;
    std::string connectorId;
};

struct SelectedShape {
    SkColor bBoxColor;
    SelectedShapeDetails selectedShapeDetail;
    std::vector<SelectedShapeDetails> parentShapeDetails;
    std::vector<ZConnectorData> connector;
    std::string selectedTextBodyId;
    std::shared_ptr<com::zoho::shapes::Transform> getMergedTransformOnScreen();
    com::zoho::shapes::Transform getMergedTransform();
    void set(graphikos::painter::ShapeDetails& shapedetails);

    std::vector<std::string> getParentIds();
    std::string getContainerId();
};
struct BPath {
    graphikos::painter::GLPath bounds;
    graphikos::painter::GLPath boxes;
};
class CallBacks;
class ZSelectionHandler {
private:
    std::string DEPENDENT_CONNECTOR = "_dependent";
    SelectedShape get(std::string shapeId);
    void add(SelectedShape& selectedShape, bool triggerEvent);
    void remove(std::vector<SelectedShape>::iterator itr, bool triggerEvent);
    std::vector<ISelectionListener*> selectionReceivers;
    CallBacks* cbs = nullptr;

public:
    void setCallBackClass(CallBacks* cbs);
    std::vector<SelectedShape> selectedShapes;
    std::unordered_map<std::string, bool> selectedShapeIds;

    void init();
    std::vector<SelectedShape>& getSelectedShapes();
    SelectedShape getShapeById(std::string shapeId) {
        return get(shapeId);
    }

    bool showRotateHandle(std::vector<SelectedShape> shapes) {
        if (shapes.size() == 1) {
            // TODO - check is locked shape - if not locked return true;
        }
        return false;
    }
    std::unordered_map<std::string, bool> getSelectedShapeIds() {
        return this->selectedShapeIds;
    }
    std::string getDependentString() {
        return this->DEPENDENT_CONNECTOR;
    }
    void insertSelectedShapeId(SelectedShape& selectedShape);
    void removeSelectedId(SelectedShape selectedShape);
    void selectShapes(std::vector<graphikos::painter::ShapeDetails>& shapes);
    void selectShape(graphikos::painter::ShapeDetails shape, bool triggerEvent = true);
    void selectShape(graphikos::painter::ShapeDetails shapedetails, SkColor bBoxColor, bool triggerEvent = true);

    void selectAllShapes();
    void clear(bool triggerEvent = true, bool willSelect = false);
    int isSelectedShape(std::string shapeId);                                                // returns 1 if the id is selected , 2 if id is  parent of selected shape, 0 other wise
    int isSelectedShape(NLDataController* data, std::vector<int> indices, size_t level = 0); // returns 1 if the id is selected , 2 if id is  parent of selected shape, 0 other wise

    void update();
    void unSelectShape(std::string shapeId, bool triggerEvent = true);
    void unSelectShapes(std::vector<std::string> shapeIds, bool triggerEvent = true);
    void unselectShapes(std::vector<graphikos::painter::ShapeDetails> shapes);

    bool notSelected(graphikos::painter::ShapeDetails shapedetail);
    bool isSelected(const std::string& shapeId);
    const SelectedShape* getSelectedShapeById(std::string& shapeId);
    const SelectedShape* getSelectedShapeByIndex(NLDataController* data, std::vector<int> indices, size_t level = 0);

    void addSelectionListener(ISelectionListener* dataReceivable);
    void removeSelectionListener(ISelectionListener* dataReceivable);
    void fireSelectionListener();
    void tempFireBboxChange(); // bbox render trigger , used for rendering table bbox
    void firePopulateConnector(std::vector<SelectedShape>& shape);
};

#endif
