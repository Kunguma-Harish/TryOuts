#pragma once

#include <painter/PropertiesPainter.hpp>
#include <painter/ShapeObjectPainter.hpp>
#include <painter/DrawingContext.hpp>

namespace com {
namespace zoho {
namespace shapes {
class GraphicFrame;
class Transform;
}
}
}
namespace google {
namespace protobuf {
template <typename T>
class RepeatedPtrField;
}
}

namespace graphikos {
namespace painter {
class GraphicFramePainter {
private:
    com::zoho::shapes::GraphicFrame* graphicFrame = nullptr;

public:
    GraphicFramePainter(com::zoho::shapes::GraphicFrame* _graphicFrame);
    com::zoho::shapes::GraphicFrame* getGraphicFrame();
    void draw(com::zoho::shapes::Properties* gProps, const DrawingContext& dc, bool canMergeBorders);
    graphikos::painter::GLRect getTextBox();
    graphikos::painter::GLPath getRectPath(Matrices matrices, com::zoho::shapes::Transform* gtrans, graphikos::painter::IProvider* provider);
    ShapeDetails traverseGraphicFrame(graphikos::painter::GLRegion region, Matrices matrices, graphikos::painter::GLPoint point, bool onModifier, com::zoho::shapes::Transform* gTrans, graphikos::painter::IProvider* provider);
    ShapeDetails traverseGraphicFrameById(Matrices matrices, std::string cellId, com::zoho::shapes::Transform* gTrans, graphikos::painter::IProvider* provider);
    GLPath getPropsRange(IProvider* provider, Matrices matrices);
};
}
}
