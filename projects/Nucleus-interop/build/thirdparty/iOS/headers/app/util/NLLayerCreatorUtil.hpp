#ifndef __NL_NLLAYERCREATORUTIL_H
#define __NL_NLLAYERCREATORUTIL_H

#include <nucleus/core/layers/NLRenderLayer.hpp>
#include <app/ZSelectionHandler.hpp>
#include <app/NLDataController.hpp>

namespace com {
namespace zoho {
namespace shapes {
}
}
}

struct EditingLayer {
    bool isShapeSelected = false;
    bool isShapeTranslatable = false;
    graphikos::painter::GLRect clipRect;
    std::shared_ptr<NLRenderTree> renderTree;
    bool isDependencyConnector = false;
    int index;                                               // corresponding layer index in the editing layers
    std::vector<std::pair<std::string, bool>> innerShapeIds; // present in the case where selected shape is broken for connector. pair<shapeId, boolean to indicate whether its innerShapes should be drawn or not>
    std::vector<const SelectedShape*> shapedetails;          // selected shape details
    std::string containerId;                                 // container shapeId for non container selected case inorder to show tintLayer
    std::shared_ptr<NLRenderLayer> renderLayer = nullptr;
    std::string dependencyConnectorId = "";
    ~EditingLayer();
};

struct SelectionDetails {
    int selected = 0;
    bool DependentParent = false;
    std::map<int, SelectionDetails> innerSelectionMap;
    SelectedShape* selectedShape = nullptr;
};

class NLLayerCreatorUtil {
protected:
    NLDataController* dataController = nullptr;
    std::vector<EditingLayer> editingLayers;
    std::vector<std::string> currentShapesInLayer;
    bool prevShapeSelected = false;
    bool prevShapeTranslatable = false;
    bool traverseInnerShapes = true;
    virtual void preAddLayer();
    void addLayer(bool isShapeSelected, bool isConnectorDependency = false, std::string dependencyConnectorId = "", bool isShapeTranslatable = true);
    void processInnerShapesCache(ShapeContainer& shapeCache, std::vector<int> indices = {0}, int level = 0, bool isSelected = false, std::string selectedShapeId = "");
    bool processContainerCache(ShapeContainer& shapeCache, std::string shapeId, std::vector<int> index, int level);

private:
    ZSelectionHandler* selectionHandler = nullptr;
    std::shared_ptr<NLRenderTree> renderTreeToBeConsidered = nullptr;
    std::map<int, SelectionDetails> selectionMap;
    std::map<int, SelectionDetails> conectorDependentMap;

    std::vector<const SelectedShape*> currentSelectedShapesInLayer;
    std::vector<std::pair<std::string, bool>> currentInnerShapesInLayer;

    void addConnectorLayer(std::string shapeId, std::string dependencyConnectorId, bool isShapeSelected, bool translateable);
    void addContainerLayer(bool isSelectedShape, bool translatable);
    virtual bool processShapeCache(ShapeContainer& shapeCache, std::string shapeId, std::vector<int> index = {0}, int level = 0, std::string shapeIdToBeConsidered = "");
    bool processSelectedShape(std::string& selectedShapeId, std::string& innerShapeId, ShapeContainer& shapeCache, std::vector<int> index, int level, int isDependentConnector = 2);
    int isDependentConnector(std::vector<int> indices, int level);
    int isDependentConnector(std::string shapeId, int level, std::vector<int> indices);
    void populateSelectionMap();
    SelectionDetails populateSelectionDetail(graphikos::painter::ShapeObjectsDetails& shapeDetails, SelectionDetails details, int index = -1);
    SelectionDetails* hasShape(std::map<int, SelectionDetails>& shapeMap, std::vector<int>& indices, int& level); // when selection map present
    void addToMap(std::map<int, SelectionDetails>& shapeMap, size_t index, SelectionDetails& details);

public:
    std::vector<EditingLayer> createEditingLayers(std::shared_ptr<TreeContainer> treeContainer, std::shared_ptr<NLRenderTree> renderTreeToBeConsidered, NLDataController* dataController, ZSelectionHandler* selectionHandler, std::string shapeIdToBeConsidered = "");
};

#endif