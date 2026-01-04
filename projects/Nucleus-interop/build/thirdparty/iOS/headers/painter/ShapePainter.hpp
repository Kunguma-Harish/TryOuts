#pragma once

#include <painter/DrawingContext.hpp>

namespace com {
namespace zoho {
namespace shapes {
class Shape;
class Properties;
}
}
}

namespace graphikos {
namespace painter {
class ShapePainter {
private:
    com::zoho::shapes::Shape* shape = nullptr;

public:
    ShapePainter(com::zoho::shapes::Shape* shape);
    void draw(com::zoho::shapes::Properties* gProps, const DrawingContext& dc);
    GLRect getTextBox();
};
}
}