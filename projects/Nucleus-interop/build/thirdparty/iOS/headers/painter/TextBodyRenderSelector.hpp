#pragma once

#include <skia-extension/Matrices.hpp>
#include <painter/IProvider.hpp>
#include <painter/DrawingContext.hpp>

namespace com {
namespace zoho {
namespace shapes {
class Properties;
class Transform;
class TextBody;
}
}
}

namespace graphikos {
namespace painter {
class TextBodyRenderSelector {
public:
    static bool drawFillPath(com::zoho::shapes::TextBody* textBody, const com::zoho::shapes::Transform& transform, bool textbox, const com::zoho::shapes::Properties* gProps, const DrawingContext& dc);
    static bool draw(com::zoho::shapes::TextBody* textBody, const com::zoho::shapes::Transform& transform, bool textbox, const com::zoho::shapes::Properties* gProps, const DrawingContext& dc, std::string shapeId = "", std::string cellId = "", com::zoho::shapes::Properties* props = nullptr);
    static GLPath getPath(com::zoho::shapes::TextBody* textBody, const com::zoho::shapes::Transform& transform, bool textbox, const DrawingContext& dc, bool needRefreshFrame, std::string shapeId);
    static  bool isPointWithinTextBody(com::zoho::shapes::TextBody* textBody, const com::zoho::shapes::Transform& transform, bool textbox, const DrawingContext& dc, std::string shapeId, graphikos::painter::GLPoint point);
    static GLPath getParaRectsAsPath(com::zoho::shapes::TextBody* textBody, const com::zoho::shapes::Transform& transform, bool textbox, const DrawingContext& dc, std::string shapeId);


};
}
}
