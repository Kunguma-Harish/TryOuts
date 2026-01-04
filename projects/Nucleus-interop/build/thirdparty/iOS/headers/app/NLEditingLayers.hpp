#ifndef __NL_NLEDITINGLAYERS_H
#define __NL_NLEDITINGLAYERS_H

#include <app/util/NLLayerCreatorUtil.hpp>
#include <app/util/ZEditorUtil.hpp>
#include <painter/TablePainter.hpp>

namespace com {
namespace zoho {
namespace shapes {
}
}
}

class NLEditingLayers {
    std::vector<EditingLayer> editingLayers;
    std::vector<EditingLayer*> selectedLayers, unSelectedLayers;

    ZSelectionHandler* selectionHandler = nullptr;
    std::shared_ptr<NLDataController> dataHandler = nullptr;
    std::shared_ptr<ZRenderBackend> renderBackend = nullptr;
    Looper* looper = nullptr;
    std::shared_ptr<NLLayer> editorLayer = nullptr;
    std::shared_ptr<NLLayer> holdingLayer = nullptr;
    bool layerAttached = false;
    bool editorLayerAttached = false;

public:
    NLEditingLayers(std::shared_ptr<NLDataController> dataHandler, ZSelectionHandler* selectionHandler);
    void onAttach();
    void setBackendAndLooper(std::shared_ptr<ZRenderBackend> backend, Looper* looper);

    std::vector<EditingLayer>& getEditingLayers();
    std::vector<EditingLayer*>& getSelectedLayers();
    std::vector<EditingLayer*> getUnSelectedLayers();
    EditingLayer* getFirstSelectedEditingLayer();
    std::shared_ptr<NLLayer> getAttachedEditingLayer();
    void clearEditingLayers();
    std::shared_ptr<NLLayer>& getEditorLayer();
    const SelectedShape* getSelectedShapeFromLayerById(std::string shapeId, EditingLayer& layer);

    void attachLayers();
    void onDetach();

    void attachEditorLayers();
    void detachEditorLayers();
    bool isEditorLayerPresent();

    void refreshEditingLayers(std::vector<std::string> shapeIds);
    void refreshSelectedLayer(std::vector<std::string> shapeIds, EditingLayer* layer = nullptr);

    void refreshSelectedLayerForTextEditing(std::vector<std::string> shapeIds, com::zoho::shapes::Transform* transform = nullptr);
    void refreshSelectedLayerForTableCellTextEditing(com::zoho::shapes::TextBody* textBody, float currentTextHeight, std::function<void(graphikos::painter::ShapeDetails)> reRenderCallback = nullptr);

    ~NLEditingLayers();
};

#endif
