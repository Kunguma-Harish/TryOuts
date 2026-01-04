#ifndef __NL_VANICOMMENTSHANDLER_H
#define __NL_VANICOMMENTSHANDLER_H

#include <app/controllers/NLEventController.hpp>
#include <nucleus/core/layers/NLInstanceLayer.hpp>
#include <nucleus/core/layers/NLAnimLayer.hpp>
#include <vani/nl_api/VaniCallBacks.hpp>

namespace com {
namespace zoho {
namespace shapes {
}
}
}

class VaniCommentHandler : public NLEventController {
    NLDataController* dataController = nullptr;
    ControllerProperties* properties;
    NLEditorProperties* editorProperties = nullptr;

    float zoomEventTime = 0;
    float currentScale = 0;

    struct GroupCommentDetail {
        std::vector<std::string> shapeIds;
        std::vector<std::string> listIds;
        bool hasUnreadComment = false;
        graphikos::painter::GLRect bound;
        graphikos::painter::GLRect renderedRect;
        float scale;
        std::shared_ptr<NLInstanceLayer> instanceLayer = nullptr;
        GroupCommentDetail() {};
        GroupCommentDetail(std::vector<std::string> _shapeIds, std::vector<std::string> _listIds, graphikos::painter::GLRect _bound, graphikos::painter::GLRect _renderedRect, float _scale, bool _hasUnreadComment = false) {
            this->shapeIds = _shapeIds;
            this->listIds = _listIds;
            this->bound = _bound;
            this->renderedRect = _renderedRect;
            this->scale = _scale;
            this->hasUnreadComment = _hasUnreadComment;
        }
    };

    std::unordered_map<std::string, GroupCommentDetail> grpCommentMap;
    std::shared_ptr<NLLayer> grpCommentInstanceLayer;
    std::unordered_map<std::string, std::string> shapeIdGroupIdMap;

    enum CommentType {
        RESOLVED,
        READ,
        UNREAD,
        DRAFT,
        ACTIVE
    };

    struct CommentDetails {
        std::vector<std::string> listIds;
        std::vector<std::string> innerShapeIds;     //optional non-modifyable innerShapeIds
        std::string parentShapeId = "";             //optional modifyable parentShapeId
    };
    std::unordered_map<std::string, std::vector<std::string>> commentIdAssociationMap; //commentId - key , associated ShapeIds - value
    std::map<std::string, CommentDetails> shapeIdCommentIdMap;                         //shapeId - key ,vector of  listId + type as value
    std::unordered_map<std::string, graphikos::painter::GLPoint> pinCommentMap;        //listId - postion Map
    std::shared_ptr<NLLayer> commentsIconLayer = nullptr;
    std::shared_ptr<NLShapeLayer> commentShapeOverlayLayer = nullptr;
    std::shared_ptr<NLShapeLayer> fillHoverLayer = nullptr;
    std::shared_ptr<NLAnimLayer> shapeOverlayAnimLayer = nullptr;

    //para comments
    struct ParaCommentDetail {
        std::string shapeId;
        std::vector<std::string> paraIds;
        int si;
        int ei;
        ParaCommentDetail(std::string shapeId, std::vector<std::string> paraIds, int si, int ei) {
            this->shapeId = shapeId;
            this->paraIds = paraIds;
            this->si = si;
            this->ei = ei;
        }
    };

    //non modifyable innerShape Details
    struct InnerShapeCommentDetail {
        std::vector<std::string> listIds;
        std::string parentShapeId;
    };

    std::vector<std::string> currentHightlightShapeIds;
    std::string currentHoverCommentId = "";
    graphikos::painter::GLPoint currentoffset = graphikos::painter::GLPoint(0, 0);
    bool currentActivePin = false;
    std::vector<ParaCommentDetail> paraCommentDetails;
    std::shared_ptr<NLRenderTree> paraCmtsRenderTree;
    std::shared_ptr<NLRenderLayer> textLayer;
    std::shared_ptr<TextEditorController> paraTextEditorController;

public:
    std::map<CommentType, std::shared_ptr<NLInstanceLayer>> commentIconMap; //commenttype and picture
    VaniCommentHandler(NLDataController* dataController, ZSelectionHandler* selectionHandler, ControllerProperties* properties, NLEditorProperties* editorProperties, std::shared_ptr<ZBBox> bbox);

    void onAttach() override;
    void onDetach() override;
    void onDataChange() override;
    void onViewTransformed(const ViewTransform& viewTransform, const SkMatrix& totalMatrix) override;
    void onLoop(SkMatrix parentMatrix) override;
    bool onMouseDown(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onMouseUp(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onMouseMove(const graphikos::painter::GLPoint& mouse, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onDrag(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLPoint& prevPoint, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;

    //comment api
    void addComment(std::string listId, std::vector<std::string> shapeIds, std::vector<std::string> paraIds, std::string type);
    void addDraftComment(graphikos::painter::GLPoint position);
    void removeComment(std::string listId, std::string shapeId);
    void removeDraftComment();
    void addPinComment(std::string listId, graphikos::painter::GLPoint position, std::string type);
    void updateCommentType(std::string listId, std::string type);

    void removeAllComments();
    graphikos::painter::GLRect getCommentIconRect(std::string shapeId, std::string listId, const SkMatrix& matrix);
    graphikos::painter::GLRect getGroupCommentIconRect(std::string shapeId, std::string listId, const SkMatrix& matrix);

    void addHighlightComment(std::vector<std::string> shapeIds, std::vector<std::string> paraIds);
    void removeHighlightComment(std::vector<std::string> shapeIds, std::vector<std::string> paraIds);
    graphikos::painter::GLRect getRenderedParahighlight(std::string shapeId, std::vector<std::string> paraIds);
    int getSpotWidth();
    //commentAPI end

    void hideCommentSpots(bool needToRemoveDraftComment = true);
    void showCommentSpots(bool show);
    void refreshCommentsLayer();

    std::vector<CommentType> getAllCommentTypes();
    std::string getTypeAsString(CommentType type);
    CommentType getTypeFromString(std::string type);
    void generateCommentPictures();
    void renderShapeHighlight(std::string shapeId);
    void renderParaHighlight(std::string shapeId, std::vector<std::string> paraIds);
    std::pair<int, int> getSiEi(std::string shapeId, std::vector<std::string> paraIds, graphikos::painter::ShapeDetails shpDetails = graphikos::painter::ShapeDetails());
    void drawCommentIcon(CommentType type, std::string listId, std::string shapeId, graphikos::painter::GLPoint position, int commentIndex);
    bool removePreviousComment(std::string shapeId, int lastCommentIndex);
    void reRendercomment(std::string shapeId);
    void removeAssociationComment(std::string shapeId, std::string listId);
    void removeCurrentHoverComment();

    //Comment Grouping fn
    void splitGroup(std::string groupId);
    void drawGroupIconShape(CommentType type, std::string groupCommentId, graphikos::painter::GLPoint position, graphikos::painter::GLPoint offset, int commentsCount);
    float getGroupingThreshold(float scale);
    std::string addToGroup(std::string shapeID, std::string listId, graphikos::painter::GLRect shapeBound, CommentType categoryClass, bool isCommentHeightOverflow, float currentScale);
    void getAssociatedSpot(std::string listId, std::string type, graphikos::painter::ShapeDetails shpDetails, int commentIndex = -1, graphikos::painter::GLPoint position = graphikos::painter::GLPoint());

    //para comments
    void renderParaCommentHighlightAsPicture(std::string shapeId, std::vector<std::string> paraIds);
};

#endif
