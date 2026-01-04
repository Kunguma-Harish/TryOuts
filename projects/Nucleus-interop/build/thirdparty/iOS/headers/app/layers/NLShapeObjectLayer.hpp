#ifndef __NL_SHAPEOBJECTLAYER_H
#define __NL_SHAPEOBJECTLAYER_H

#include <nucleus/core/layers/NLScrollLayer.hpp>
#include <nucleus/recorder/NLPictureRecorder.hpp>

namespace com::zoho::shapes {
class ShapeObject;
}

class NLShapeObjectLayer : public NLLayer {
public:
    struct AutoLayout {
        enum Direction {
            NO_DIRECTION,
            HORIZONTAL,
            VERTICAL,
            BOTH
        };
        Direction direction = NO_DIRECTION;
    };
    NLShapeObjectLayer(NLLayerProperties* layerProperties, graphikos::painter::GLRect viewPortRect, SkColor layerColor = SK_ColorTRANSPARENT);

    void onDataChange() override;
    bool onDraw(SkCanvas* canvas, NLDeferredDetails* dd, SkMatrix totalMatrix = SkMatrix(), bool applyContentScale = true) override;
    graphikos::painter::GLRect getTotalBounds();

    void addShapeObject(const std::shared_ptr<com::zoho::shapes::ShapeObject>& shape);
    void removeShapeObject(const std::shared_ptr<com::zoho::shapes::ShapeObject>& shape);
    void removeShapeObject(const std::string& id);
    void removeAll();

    void setLayout(AutoLayout layout);

private:
    class ShapeObjectCache {
    public:
        ShapeObjectCache(std::shared_ptr<com::zoho::shapes::ShapeObject> shapeCache);
        std::shared_ptr<com::zoho::shapes::ShapeObject> shapeObject = nullptr;
        std::shared_ptr<NLPictureRecorder> temp_pictureCache = nullptr;

        SkMatrix layoutMatrix;
        graphikos::painter::GLRect bounds;

        bool operator<(const ShapeObjectCache& rhs) const;
    };
    graphikos::painter::GLRect cacheCoverageRect;
    std::vector<ShapeObjectCache> shapeObjectCaches;
    AutoLayout layout;

    bool cacheInvalidated = false;
    void populateShapeObjectCache();
    std::vector<ShapeObjectCache> getLayoutedCache(std::vector<ShapeObjectCache>& shapesCacheArray);
    graphikos::painter::GLRect getCoverageRect() override;
};

#endif
