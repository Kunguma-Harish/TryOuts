
#include <memory>
#include <skia-extension/GLPath.hpp>
#include <skia-extension/GLPoint.hpp>
#include <modules/skparagraph/include/ParagraphBuilder.h>

#include <parastyle.pb.h>

namespace graphikos {
namespace painter {
namespace internal {
struct TextBulletDetails {
    int hasBullet = 0;
    std::unique_ptr<skia::textlayout::ParagraphBuilder> bulletBuilder;
    SkPaint paint;
    com::zoho::shapes::ParaStyle paraStyle; // Entire ParaStyle is required for updating bullet data, because some data outside of Bullet like indent, margin, level, etc are required too.
    int bulletNo = 0;
    graphikos::painter::GLPath bulletPath;
    graphikos::painter::GLPoint bulletPosition;
    bool isStriked = false;
    float bulletWidth = 0;
    float bulletHeight = 0;
    float fontSize = 0;
    bool hasText = false;
};
}
}
}