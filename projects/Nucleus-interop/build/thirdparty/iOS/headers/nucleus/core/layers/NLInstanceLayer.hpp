#ifndef __NL_INSTANCELAYER_H
#define __NL_INSTANCELAYER_H

#include <nucleus/core/layers/NLLayer.hpp>
#include <skia-extension/GLPoint.hpp>

class NLPictureRecorder;

struct PositionData {
    std::string positionId;
    graphikos::painter::GLPoint positionPoint;
    graphikos::painter::GLPoint offset;
    graphikos::painter::GLRect restrictorRect;
    graphikos::painter::GLRect cullRect;
    float rotate = 0.0f; // gettings as degrees
    float scale = 1.0f;
    PositionData(std::string positionId, graphikos::painter::GLPoint positionPoint, graphikos::painter::GLPoint offset, graphikos::painter::GLRect restrictorRect, graphikos::painter::GLRect cullRect);
};
struct PictureDirtyInstance {
    graphikos::painter::GLRect instanceBounds = graphikos::painter::GLRect();
    std::vector<PositionData> dirtyPositionDataArray = {};

    PictureDirtyInstance(graphikos::painter::GLRect instanceBounds, const std::vector<PositionData>& dirtyPositionDataArray);
};
struct ImageNineDirtyInstance {
    std::vector<graphikos::painter::GLRect> dirtyRectsArray = {};
    graphikos::painter::GLPoint rectOutset;

    ImageNineDirtyInstance(const std::vector<graphikos::painter::GLRect>& dirtyRectsArray, graphikos::painter::GLPoint rectOutset);
};

class NLInstanceLayer : public NLLayer {
    std::vector<PictureDirtyInstance> pictureDirtyArray = {};
    std::vector<ImageNineDirtyInstance> imageNineDirtyArray = {};
    graphikos::painter::GLRect getDirtyRectFromData(const SkMatrix& parentMatrix) override;

public:
    enum DimensionConstraints {
        SCALE = 0,          // Default, applies scale to picture
        FIXED = 1,          // Retains the scale of the picture
        FIXED_WITH_RECT = 2 // Picture fits in restrictorRect ? FIXED : SCALE ()
    };

    enum DrawFromType {
        NLPicture = 0,
        ImageNine = 1
    };

    NLInstanceLayer(DrawFromType type, NLLayerProperties* properties, graphikos::painter::GLRect viewPortRect, SkColor layerColor = SK_ColorTRANSPARENT, DimensionConstraints dimConstraints = DimensionConstraints::SCALE);

    void onDataChange() override;
    void setInstanceData(std::shared_ptr<NLPictureRecorder> pictureData, SkIRect centerRect = SkIRect(), float selectionOffset = 0, graphikos::painter::GLPoint rectOutset = graphikos::painter::GLPoint(0, 0));
    void emptyInstanceData();
    bool onDraw(SkCanvas* canvas, NLDeferredDetails* dd, SkMatrix totalMatrix = SkMatrix(), bool applyContentScale = true) override;
    bool doesFitInsideRestrictorRect(const PositionData& positionData, const SkMatrix& matrix);

    int getInstanceCount();

    // DrawFromType::NLPicture
    bool isWithinInstance(const graphikos::painter::GLPoint& point, std::string positionId, const SkMatrix& matrix);
    void changeTransformForInstance(const std::string& id, float scale, float rotate);

    int getPositionIndexFromPoint(const graphikos::painter::GLPoint& point, const SkMatrix& matrix);
    int getPositionIndexFromId(std::string positionId);
    std::string getPositionIdFromIndex(size_t index);
    PositionData getPositionDataAtIndex(size_t index);

    void addInstancePoint(const graphikos::painter::GLPoint& point, const graphikos::painter::GLPoint& offset = graphikos::painter::GLPoint(0, 0), std::string positionId = "", graphikos::painter::GLRect restrictorRect = graphikos::painter::GLRect(), graphikos::painter::GLRect cullRect = graphikos::painter::GLRect(), float scale = 1.0f, float rotate = 0.0f);
    bool deleteInstance(size_t index);
    void translateInstance(size_t index, const graphikos::painter::GLPoint& value);
    void clearInstances();
    std::vector<graphikos::painter::GLPoint> getAllInstances(bool considerOffset = false);

    graphikos::painter::GLRect getPictureCullRect();

    // DrawFromType::ImageNine
    void addInstanceRect(graphikos::painter::GLRect imageRect);
    graphikos::painter::GLRect getRenderedRect(std::string positionId, const SkMatrix& matrix);

private:
    DimensionConstraints dimConstraints = DimensionConstraints::SCALE;
    float selectionOffset = 0;
    DrawFromType type;

    // DrawFromType::NLPicture
    std::shared_ptr<NLPictureRecorder> nlPicture;
    std::vector<PositionData> positionDataArray = {};

    // DrawFromType::ImageNine
    sk_sp<SkImage> imageNine;
    std::vector<graphikos::painter::GLRect> rectsArray;
    graphikos::painter::GLPoint rectOutset;
    SkIRect centerRect;
    SkMatrix getMatrixToApply(const PositionData& positionData, const graphikos::painter::GLRect& instanceRect, const SkMatrix& totalMatrix, bool applyContentScale = true);
    bool shouldPreventInstanceRender(PositionData positionData, const SkMatrix& matrix);
    graphikos::painter::GLRect getRenderedRect(const PositionData& positionData, const SkMatrix& matrix);
};

#endif
