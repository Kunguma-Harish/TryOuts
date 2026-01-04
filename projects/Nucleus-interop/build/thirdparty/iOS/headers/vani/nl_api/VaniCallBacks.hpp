#ifndef __NL_VANICALLBACKS_H
#define __NL_VANICALLBACKS_H
#include <app/nl_api/EditorCallBacks.hpp>
namespace com {
namespace zoho {
namespace collaboration {
class DocumentContentOperation_Component_Text;
}
}
}
class VaniCallBacks : public EditorCallBacks {
public:
#if defined(NL_ENABLE_NEXUS)
    //vaniediting controller
    CREATE_CALLBACK_NEXUS(EmbedActionCallBack, void, com::zoho::shapes::Transform, com::zoho::shapes::ShapeObject*, com::zoho::shapes::NonVisualProps, std::string, std::string);
    CREATE_CALLBACK_NEXUS(AudioActionCallBack, void, std::string, float, com::zoho::shapes::ShapeObject*, std::string, std::string);
    CREATE_CALLBACK_NEXUS(ContainerNameEditedCallBack, void, std::string, std::string);
    CREATE_CALLBACK_NEXUS(PlaceholderIconClickCallBack, void, std::string);
    CREATE_CALLBACK_NEXUS(ReactionActionCallBack, void, com::zoho::shapes::ShapeObject, graphikos::painter::GLRect, std::string, std::string, graphikos::painter::GLPoint);
    CREATE_CALLBACK_NEXUS(DrawObjCallBack, void, DrawData);

    //vanicollabcontroller
    CREATE_CALLBACK_NEXUS(MoreMembersIconActionCallBack, void, std::string, graphikos::painter::GLPoint);

    //vanidataconrtoller
    CREATE_CALLBACK_NEXUS(EmbedRenderedCallBack, void, com::zoho::shapes::ShapeObject);
    CREATE_CALLBACK_NEXUS(PictureRenderedCallBack, void, com::zoho::shapes::Picture);

    //vanianchorcontroller
    CREATE_CALLBACK_NEXUS(AnchorEditedCallBack, void, std::string, std::string, std::string);

    //vanishapemodified
    CREATE_CALLBACK_NEXUS(TextEditingCallBack, void, std::string, std::vector<com::zoho::collaboration::DocumentContentOperation_Component_Text>, std::string, std::string, std::string, std::vector<ShapeData>, bool, bool, bool);
    CREATE_CALLBACK_NEXUS(TableCellTextDeleteCallBack, void, std::vector<std::string>, std::vector<com::zoho::collaboration::DocumentContentOperation_Component_Text>, std::string, std::string);
    CREATE_CALLBACK_NEXUS(ScrollOnDragOnMouseUp, void);
    CREATE_CALLBACK_NEXUS(ScrollOnDragOnMouseDown, void);

    //vaniCommentHandler
    CREATE_CALLBACK_NEXUS(CommentActionCallBack, void, std::string, std::string, std::vector<std::string>, std::string, graphikos::painter::GLPoint);
    CREATE_CALLBACK_NEXUS(GroupCommentIconClickCallBack, void, graphikos::painter::GLPoint, float, std::vector<std::string>);

    //vaniFlowController
    CREATE_CALLBACK_NEXUS(AddFrameToFlowCallBack, void, std::string);

#else
    //vaniediting controller
    CREATE_CALLBACK(EmbedActionCallBack, void(com::zoho::shapes::Transform, com::zoho::shapes::ShapeObject*, com::zoho::shapes::NonVisualProps, std::string, std::string));
    CREATE_CALLBACK(AudioActionCallBack, void(std::string, float, com::zoho::shapes::ShapeObject*, std::string, std::string));
    CREATE_CALLBACK(ContainerNameEditedCallBack, void(std::string, std::string));
    CREATE_CALLBACK(PlaceholderIconClickCallBack, void(std::string));
    CREATE_CALLBACK(ReactionActionCallBack, void(com::zoho::shapes::ShapeObject, graphikos::painter::GLRect, std::string, std::string, graphikos::painter::GLPoint));
    CREATE_CALLBACK(DrawObjCallBack, void(DrawData));

    //vanicollabcontroller
    CREATE_CALLBACK(MoreMembersIconActionCallBack, void(std::string, graphikos::painter::GLPoint));

    //vanidataconrtoller
    CREATE_CALLBACK(EmbedRenderedCallBack, void(com::zoho::shapes::ShapeObject));
    CREATE_CALLBACK(PictureRenderedCallBack, void(com::zoho::shapes::Picture));
    //vanianchorcontroller
    CREATE_CALLBACK(AnchorEditedCallBack, void(std::string, std::string, std::string));

    //vanishapemodified
    CREATE_CALLBACK(TextEditingCallBack, void(std::string, std::vector<com::zoho::collaboration::DocumentContentOperation_Component_Text>, std::string, std::string, std::string, std::vector<ShapeData> shapeDatas, bool, bool, bool));
    CREATE_CALLBACK(TableCellTextDeleteCallBack, void(std::vector<std::string>, std::vector<com::zoho::collaboration::DocumentContentOperation_Component_Text>, std::string, std::string));
    CREATE_CALLBACK(ScrollOnDragOnMouseUp, void());
    CREATE_CALLBACK(ScrollOnDragOnMouseDown, void());

    //vaniCommentHandler
    CREATE_CALLBACK(CommentActionCallBack, void(std::string, std::string, std::vector<std::string>, std::string, graphikos::painter::GLPoint));
    CREATE_CALLBACK(GroupCommentIconClickCallBack, void(graphikos::painter::GLPoint, float, std::vector<std::string>));

    //vaniFlowController
    CREATE_CALLBACK(AddFrameToFlowCallBack, void(std::string));
#endif
};
#endif
