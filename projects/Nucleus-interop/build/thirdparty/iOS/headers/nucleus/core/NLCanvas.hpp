#pragma once
#include <include/core/SkCanvasVirtualEnforcer.h>
#include <nucleus/core/NLDeferredDetails.hpp>

class NLCanvas : public SkCanvasVirtualEnforcer<SkCanvas> {
public:
    SkCanvas* canvas = nullptr;
    std::shared_ptr<NLDeferredDetails> dd = nullptr;

    NLCanvas(SkCanvas* canvas);
    NLCanvas(SkCanvas* canvas, int maxCount);
    NLCanvas(SkCanvas* canvas, int soAvg, int maxCount);

    NLDeferredDetails* getDeferredDetails();

protected:
    void onFlush();

    void willSave() override;
    SaveLayerStrategy getSaveLayerStrategy(const SaveLayerRec& rec) override;
    // returns true if we should actually perform the saveBehind, or false if we should just save.
    bool onDoSaveBehind(const SkRect*) override;
    void willRestore() override;
    void didRestore() override;

    void didConcat44(const SkM44& mat) override;
    void didSetM44(const SkM44& mat) override;
    void didTranslate(SkScalar x, SkScalar y) override;
    void didScale(SkScalar x, SkScalar y) override;

    void onDrawPaint(const SkPaint& paint) override;
    // void onDrawBehind(const SkPaint&) override; // make zero after android updates
    void onDrawRect(const SkRect& rect, const SkPaint& paint) override;
    void onDrawRRect(const SkRRect& rrect, const SkPaint& paint) override;
    void onDrawDRRect(const SkRRect& outer, const SkRRect& inner, const SkPaint& paint) override;
    void onDrawOval(const SkRect& rect, const SkPaint& paint) override;
    void onDrawArc(const SkRect& rect, SkScalar startAngle, SkScalar sweepAngle,
                   bool useCenter, const SkPaint& paint) override;
    void onDrawPath(const SkPath& path, const SkPaint& paint) override;
    void onDrawRegion(const SkRegion& region, const SkPaint& paint) override;

    void onDrawTextBlob(const SkTextBlob* blob, SkScalar x, SkScalar y, const SkPaint& paint) override;
    void onDrawGlyphRunList(const sktext::GlyphRunList& glyphRunList, const SkPaint& paint) override;
    void onDrawPatch(const SkPoint cubics[12], const SkColor colors[4],
                     const SkPoint texCoords[4], SkBlendMode mode,
                     const SkPaint& paint) override;
    void onDrawPoints(SkCanvas::PointMode mode, size_t count, const SkPoint pts[],
                      const SkPaint& paint) override;

    void onDrawImage2(const SkImage*, SkScalar dx, SkScalar dy, const SkSamplingOptions&,
                      const SkPaint*) override;
    void onDrawImageRect2(const SkImage*, const SkRect& src, const SkRect& dst,
                          const SkSamplingOptions&, const SkPaint*, SrcRectConstraint) override;
    void onDrawImageLattice2(const SkImage*, const Lattice&, const SkRect& dst,
                             SkFilterMode, const SkPaint*) override;
    void onDrawAtlas2(const SkImage*, const SkRSXform[], const SkRect src[],
                      const SkColor[], int count, SkBlendMode, const SkSamplingOptions&,
                      const SkRect* cull, const SkPaint*) override;
    void onDrawEdgeAAImageSet2(const ImageSetEntry imageSet[], int count,
                               const SkPoint dstClips[], const SkMatrix preViewMatrices[],
                               const SkSamplingOptions&, const SkPaint*,
                               SrcRectConstraint) override;
    void onDrawVerticesObject(const SkVertices* vertices, SkBlendMode mode,
                              const SkPaint& paint) override;

    void onDrawAnnotation(const SkRect& rect, const char key[], SkData* value) override;

    void onDrawShadowRec(const SkPath&, const SkDrawShadowRec&) override;

    void onDrawDrawable(SkDrawable* drawable, const SkMatrix* matrix) override;

    void onDrawPicture(const SkPicture* picture, const SkMatrix* matrix,
                       const SkPaint* paint) override;

    void onDrawEdgeAAQuad(const SkRect& rect, const SkPoint clip[4],
                          SkCanvas::QuadAAFlags aaFlags, const SkColor4f& color, SkBlendMode mode) override;

    void onClipRect(const SkRect& rect, SkClipOp op, ClipEdgeStyle edgeStyle) override;
    void onClipRRect(const SkRRect& rrect, SkClipOp op, ClipEdgeStyle edgeStyle) override;
    void onClipPath(const SkPath& path, SkClipOp op, ClipEdgeStyle edgeStyle) override;
    void onClipShader(sk_sp<SkShader>, SkClipOp) override;
    void onClipRegion(const SkRegion& deviceRgn, SkClipOp op) override;
    void onResetClip() override;

    void onDiscard() override;

private:
    void onDrawCall();
    int fixedCounter = 0;
    int flexibleCounter = 0;
    int maxCount = 100;
    int maxCountULimit = 4000;
    int flushTime = 8000;
    int baseSaveLayer_SaveCount = 0;
};
