#ifndef __NL_VANIREACTIONPAINTER_H
#define __NL_VANIREACTIONPAINTER_H
#include <vani/data/VaniDataController.hpp>
#include <vani/VaniProvider.hpp>

namespace com {
namespace zoho {
namespace common {
enum Reaction_ReactionStatus : int;
class Reaction;
}
namespace shapes {
class ShapeObject;
}
}
}
namespace google {
namespace protobuf {
template <typename T>
class RepeatedPtrField;
}
}
#define REACTION_GAP 5
#define EXTRA_REACTION_WIDTH 10
class VaniReactionPainter {
private:
    com::zoho::shapes::ShapeObject* shapeObject = nullptr;

public:
    static std::string myZuid;
    struct reactionResult {
        bool isMyZuidPresent = false;
        int count = 0;
        com::zoho::common::Reaction_ReactionStatus status;
        int index = 0;
    };
    struct RenderReactionData {
        float left;
        float top;
        float width;
        float totalWidth;
    };
    static void setMyZuid(std::string zuid);
    VaniReactionPainter();
    VaniReactionPainter(com::zoho::shapes::ShapeObject* shapeObject);

    void renderReactions(const DrawingContext& dc, com::zoho::shapes::Transform& mergedTransform);
    void renderReaction(const DrawingContext& dc, RenderReactionData* data, com::zoho::shapes::ShapeObject* reactionshape, reactionResult renderData);
    std::vector<std::pair<int, reactionResult>> reactionList(google::protobuf::RepeatedPtrField<com::zoho::common::Reaction>* reactions);
    std::string getReactionString(com::zoho::common::Reaction_ReactionStatus status);
    void getRenderReactionData(com::zoho::shapes::Transform* shapeTransform, RenderReactionData* data, int count, float width, float height);
    void getReactionDetails(std::vector<graphikos::painter::ShapeDetails>* shapedetailsArray, graphikos::painter::GLPoint point, com::zoho::shapes::Transform mergedTransform);
    graphikos::painter::GLRect getReactionRegion(google::protobuf::RepeatedPtrField<com::zoho::common::Reaction>* reactions, com::zoho::shapes::Transform* shapeTransform, graphikos::painter::Matrices matrices, VaniProvider* provider);
    graphikos::painter::GLRect getReactionStatusRect(std::string reactionStatus, com::zoho::shapes::Transform* mergeTransform);
};

#endif