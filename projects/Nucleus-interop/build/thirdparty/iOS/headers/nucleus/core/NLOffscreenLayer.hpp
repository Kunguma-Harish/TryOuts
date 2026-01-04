#ifndef __NL_OFFSCREENLAYER_H
#define __NL_OFFSCREENLAYER_H

#include <nucleus/core/layers/NLLayer.hpp>
#include <vector>
#include <queue>

typedef void ImageRequestCallback(std::vector<std::vector<sk_sp<SkImage>>>, int, int);

class Looper;
class DeferredDetails;
class SkSurface;
class NLCanvas;

enum class ImageFormat {
    NOTYPE,
    PNG,
    JPEG,
    BMP
};

struct ImageRequestDetails {
    int width, height;
    bool isAspectRatio;
    std::shared_ptr<NLRenderTree> renderTree;
    std::function<ImageRequestCallback> callback;
    ImageRequestDetails(){};
    ImageRequestDetails(std::shared_ptr<NLRenderTree> renderTree, int width, int height, bool isAspectRatio, std::function<ImageRequestCallback> callback);
};

class NLOffscreenLayer : public NLLayer {

    struct RenderingDetails {
        RenderingDetails(ImageRequestDetails& imgReqDetails, sk_sp<SkSurface> surface, SkMatrix viewMatrix, int rows = 1, int cols = 1);
        ImageRequestDetails imgReqDetails;
        sk_sp<SkSurface> surface;
        std::shared_ptr<NLCanvas> canvas;
        std::vector<std::vector<sk_sp<SkImage>>> tiles;
        size_t currentTile;
        SkMatrix viewMatrix;
    };

    std::queue<ImageRequestDetails> imageRequests;
    bool needToRefresh() override;

    std::shared_ptr<RenderingDetails> renderingDetails;

    // it setup the renderingSettings, then pushes a callback to the looper
    void setupPlayback();

    // it is the callback that will be pushed to looper and it will do the post playback works too
    void continuePlayback();

    SkIRect getTileRect(int row, int col) const;
    sk_sp<SkImage> imageVFlip(sk_sp<SkImage> image) const;

public:
    std::function<void()> continuePlaybackCallback;
    NLOffscreenLayer(NLLayerProperties* properties);

    void onLoop(SkMatrix parentMatrix = SkMatrix()) override;
    void addImageRequest(ImageRequestDetails imgReqDetails);
};
#endif // __NL_OFFSCREENLAYER_H
