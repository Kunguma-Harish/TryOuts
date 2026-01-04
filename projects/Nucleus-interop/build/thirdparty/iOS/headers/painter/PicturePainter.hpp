#pragma once

#include <painter/TransformPainter.hpp>
#include <painter/IProvider.hpp>
#include <painter/DrawingContext.hpp>

namespace com {
namespace zoho {
namespace shapes {
class Picture;
}
}
}

namespace graphikos {
namespace painter {
class PicturePainter {
private:
    com::zoho::shapes::Picture* picture = nullptr;

public:
    PicturePainter(com::zoho::shapes::Picture* picture);
    SkPaint getPicturePaint(com::zoho::shapes::Properties* props, sk_sp<SkImage> originalImage, GLRect rect, Matrices matrices, IProvider* provider, com::zoho::shapes::Transform* gTrans = nullptr);

    void draw(const DrawingContext& dc);
};
}
}
