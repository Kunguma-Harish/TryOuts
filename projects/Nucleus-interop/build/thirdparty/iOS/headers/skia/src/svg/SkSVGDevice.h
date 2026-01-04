/*
 * Copyright 2015 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#ifndef SkSVGDevice_DEFINED
#define SkSVGDevice_DEFINED

#include "include/core/SkCanvas.h"
#include "include/core/SkRefCnt.h"
#include "include/core/SkTypes.h"
#include "include/private/base/SkTArray.h"
#include "include/private/base/SkTypeTraits.h"
#include "include/utils/SkParsePath.h"
#include "src/core/SkClipStackDevice.h"

#include <cstddef>
#include <cstdint>
#include <memory>
#include <type_traits>

namespace sktext {
class GlyphRunList;
}

class SkDevice;
class SkBitmap;
class SkBlender;
class SkClipStack;
class SkData;
class SkImage;
class SkMesh;
class SkPaint;
class SkPath;
class SkRRect;
class SkVertices;
class SkXMLWriter;
struct SkISize;
struct SkPoint;
struct SkRect;
struct SkSamplingOptions;

class SkSVGDevice final : public SkClipStackDevice {
public:

    struct SkLayerFilter;
    class SkLayerFilterImpl;
    static sk_sp<SkDevice> Make(const SkISize& size, std::unique_ptr<SkXMLWriter>, uint32_t flags);

    void drawPaint(const SkPaint& paint) override;
    void drawAnnotation(const SkRect& rect, const char key[], SkData* value) override;
    void drawPoints(SkCanvas::PointMode mode, size_t count,
                    const SkPoint[], const SkPaint& paint) override;
    void drawImageRect(const SkImage* image, const SkRect* src, const SkRect& dst,
                       const SkSamplingOptions&, const SkPaint& paint,
                       SkCanvas::SrcRectConstraint constraint) override;
    void drawRect(const SkRect& r, const SkPaint& paint) override;
    void drawOval(const SkRect& oval, const SkPaint& paint) override;
    void drawRRect(const SkRRect& rr, const SkPaint& paint) override;
    void drawPath(const SkPath& path,
                  const SkPaint& paint,
                  bool pathIsMutable = false) override;

    void drawVertices(const SkVertices*, sk_sp<SkBlender>, const SkPaint&, bool) override;
    void drawMesh(const SkMesh&, sk_sp<SkBlender>, const SkPaint&) override;

    //to override saveLayer and restore calls for group filters.
    // sk_sp<SkDevice> createDevice(const CreateInfo&, const SkPaint*) override;
    void onSaveLayer(SkPaint*) override;
    void onLayerRestore() override;

private:
    SkSVGDevice(const SkISize& size, std::unique_ptr<SkXMLWriter>, uint32_t);
    ~SkSVGDevice() override;

    void onDrawGlyphRunList(SkCanvas*, const sktext::GlyphRunList&, const SkPaint& paint) override;

    struct MxCp;
    void drawBitmapCommon(const MxCp&, const SkBitmap& bm, const SkPaint& paint);

    void syncClipStack(const SkClipStack&);

    SkParsePath::PathEncoding pathEncoding() const;

    class AutoElement;
    class ResourceBucket;

    const std::unique_ptr<SkXMLWriter>    fWriter;
    const std::unique_ptr<ResourceBucket> fResourceBucket;
    const uint32_t                        fFlags;

    struct ClipRec {
        std::unique_ptr<AutoElement> fClipPathElem;
        uint32_t                     fGenID;

        static_assert(::sk_is_trivially_relocatable<decltype(fClipPathElem)>::value);

        using sk_is_trivially_relocatable = std::true_type;
    };

    std::unique_ptr<AutoElement> fRootElement;
    skia_private::TArray<ClipRec> fClipStack;
    std::unique_ptr<SkSVGDevice::SkLayerFilterImpl> currentLayerFilter = std::make_unique<SkSVGDevice::SkLayerFilterImpl>(); 
};

struct SkSVGDevice::SkLayerFilter {
    SkPaint* layerPaint;
    SkSVGDevice* layerElement;
    std::string id;
    std::string type;
    bool layerFilterAdded;
    std::shared_ptr<SkLayerFilter> next;
};

class SkSVGDevice::SkLayerFilterImpl : ::SkNoncopyable {
private:
    std::shared_ptr<SkLayerFilter> top = (nullptr);
    int count = 0;
public:
   void push(SkPaint* layerPaint,SkSVGDevice* layerElement, std::string id = "", std::string type = "") {
        std::shared_ptr<SkLayerFilter> newNode =std::make_shared<SkLayerFilter>();
        newNode->layerPaint = layerPaint;
        newNode->layerElement = layerElement;
        this->count += 1;
        newNode->id = id;
        newNode->type=type;
        newNode->layerFilterAdded = false;
        newNode->next = NULL;
        if (this->top == NULL) {
            this->top = newNode;
        } else {
            newNode->next = this->top;
            this->top = newNode;
        }
    }

    void pop() {
        if (this->top != NULL) {
            this->top = this->top->next;
            this->count -= 1;
        }
    }

    std::shared_ptr<SkLayerFilter> read() { return this->top; }

    SkPaint* getPaint() { return this->top->layerPaint; }

    SkSVGDevice* getElement() { return this->top->layerElement; }

    int size() { return this->count; }

    std::string returnId() { return this->top->id; }

    std::string returnType() { return this->top->type; }

    bool isLayerFilterAdded() { return this->top->layerFilterAdded; }

    void addlayerFilter() { this->top->layerFilterAdded = true; }

    
};

#endif // SkSVGDevice_DEFINED
