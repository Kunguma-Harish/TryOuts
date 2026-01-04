#ifndef __NL_VANICOMMONUTIL_H
#define __NL_VANICOMMONUTIL_H

#include <app/ZSelectionHandler.hpp>
#include <app/NLDataController.hpp>
#include <nucleus/core/layers/NLInstanceLayer.hpp>
#include <vani/VaniReactionController.hpp>
#include <vani/VaniCommentHandler.hpp>

namespace com {
namespace zoho {
namespace remoteboard {
class Frame;
}
namespace shapes {
}
}
}

class VaniCommonUtil {
    ControllerProperties* _properties = nullptr;
    NLDataController* dataController = nullptr;
    ZSelectionHandler* selectionHandler = nullptr;

protected:
    std::shared_ptr<NLLayer> containerNameLayer = nullptr;
    std::map<std::string, std::shared_ptr<NLInstanceLayer>> containerNameMap;
    std::shared_ptr<NLLayer> gifButtonLayer = nullptr;
    std::map<std::string, std::shared_ptr<NLInstanceLayer>> gifButtonMap;
    std::string editingContainerNameId = "";
    bool isContainerTextEditMode = false;
    std::shared_ptr<VaniCommentHandler> commentsHandler = nullptr;

    std::shared_ptr<NLInstanceLayer> frameNameHashLayer = nullptr;
    std::shared_ptr<NLInstanceLayer> frameNameHashHoverLayer = nullptr;
    std::map<std::string, std::shared_ptr<skia::textlayout::Paragraph>> frameNameParagraphMap;
    std::map<std::string, std::vector<std::string>> frameNameEmojis; // contains the list of emoji's imageKey for every framename

public:
    std::shared_ptr<NLInstanceLayer> getContainerNameLayer(std::string frameId);
    void removeContainerNameLayer(std::string frameId);
    bool canRenderContainerName(com::zoho::remoteboard::Frame* frame);
    std::shared_ptr<VaniReactionController> reactionController = nullptr;
    bool hoverPlaceHolderIcon(graphikos::painter::ShapeDetails shapeDetails, graphikos::painter::GLPoint point);
    VaniCommonUtil(NLDataController* dataController, ControllerProperties* properties, ZSelectionHandler* selectionHandler);
    graphikos::painter::ShapeDetails getShapeDetails(graphikos::painter::GLPoint mouse, graphikos::painter::GLRect frame, bool onModifier, const SkMatrix& matrix);
    void populateContainerNameData(std::string frameId, float scale = 1.0f, bool needHover = false);
    void renderFrameNameText(std::string frameId, float scale, graphikos::painter::GLRect frameRect);
    void generateFrameNameHashPicture();
    void removeDuplicatedContainerName(); // in order to remove the duplicated frame name inserted during alt+drag.
    void onContainerModify(std::vector<std::string> shapeIds, std::vector<int> opTypes, float scale = 1.0f);
    void clearAllContainerName();
    graphikos::painter::GLRect getFrameNameRect(std::string frameId, const SkMatrix& matrix);
    bool insideGifButton(graphikos::painter::ShapeDetails shapeDetails, const graphikos::painter::GLPoint& point, bool playGif, const SkMatrix& totalMatrix, const graphikos::painter::GLRect& frame, const SkMatrix& matrix);
    void renderGifButton(std::string shapeId);
    void renderGifButtonUsingRect(std::string& shapeId, graphikos::painter::GLRect bounds = graphikos::painter::GLRect());
    void removeGifButton(std::string shapeId);
    void handleGifButtonInnerShape(com::zoho::shapes::ShapeObject* groupShape, graphikos::painter::Matrices matrices);
    void clearAllGifButton();
    VaniCommentHandler* getCommentHandler();
    void refreshFrameShapeObject(std::vector<std::string>& shapeIds);
};

#endif