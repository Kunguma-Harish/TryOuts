#ifndef __NL_TILERENDERER_H
#define __NL_TILERENDERER_H

#include <nucleus/core/NLDeferredRenderer.hpp>

#include <vector>

class SkSurface;

class NLTileRenderer : public NLDeferredRenderer {
private:
    struct TileRenderingDetails : NLDeferredRenderer::RenderingDetails {
        int row, col;
        bool isLight;
        TileRenderingDetails(int row, int col, bool isLight, sk_sp<SkSurface> surface, SkMatrix totalMatrix) : RenderingDetails(surface, totalMatrix), row(row), col(col), isLight(isLight) {}
    };

    int visibleRows, visibleColumns;
    int rows, columns;

    // Tiles will be shifted according to view matrix
    bool enableShiftTiles;

    // Light tiles will be rendered in the middle of events handling
    bool enableMidRender;

    std::vector<std::vector<sk_sp<SkImage>>> newTiles;
    std::vector<std::vector<int>> tileWeight;
    bool isTilesComplete = true;
    bool checkMatrixChangeEnd;
    std::vector<std::vector<sk_sp<SkImage>>> oldTiles;
    SkMatrix oldMatrixCache;

    std::shared_ptr<TileRenderingDetails> tileRendDet;

    void checkForShiftTiles(SkMatrix renderMatrix);
    void shiftTiles(int dx, int dy);

    void checkForTileRender(SkMatrix renderMatrix, bool allowHeavyTile);
    // should it be included in checkforTileRender function itself ?
    void tileRender(int row, int col);
    void continueTileRender();
    void interruptRendering() override;
    void refreshRect(sk_sp<SkImage> image, SkMatrix transform, FrameType frameType) override;
    void immediateRender(SkMatrix renderMatrix) override;

    void drawTiles(SkCanvas* canvas, std::vector<std::vector<sk_sp<SkImage>>>& tiles, SkMatrix dirtyMatrix);
    SkIRect getTileRect(int row, int col, bool overlapped = true);
    graphikos::painter::GLRect getCachedRect() override;
    bool isTilesDisplayable(std::vector<std::vector<sk_sp<SkImage>>>& tiles);

public:
    NLTileRenderer(NLRenderer* renderer, int visibleRows = 2, int visibleColumns = 2, int rows = 4, int cols = 4, bool enableShiftTiles = true, bool enableMidRender = true);
    void init(bool isDataChanged) override;
    void onLoop(SkMatrix renderMatrix) override;
    void startMatrixChangedTime() override;
    void startResizeTimer() override;
    void render(SkMatrix renderMatrix) override;
    void draw(SkCanvas* canvas, SkMatrix renderMatrix) override;
};

#endif // __NL_TILERENDERER_H
