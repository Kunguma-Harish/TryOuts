#ifndef __NL_NLPICTURERECORDER_H
#define __NL_NLPICTURERECORDER_H

// #include <include/patch/PictureUtil.h>
#include <src/core/SkRecords.h>
#include <include/core/SkPictureRecorder.h>
#include <skia-extension/DeferredDetails.hpp>

class SkPicture;
class SkCanvas;
class SkBBoxHierarchy;
class SkBBHFactory;
class SkPictureRecorder;
class SkDeferredDetails;

class NLPictureRecorder {
private:
    std::shared_ptr<SkPictureRecorder> recorder = nullptr;
    sk_sp<SkPicture> picture = nullptr;
public:
    NLPictureRecorder();
    SkCanvas* beginRecording(const SkRect& bounds, sk_sp<SkBBoxHierarchy> bbh = nullptr);
    SkCanvas* beginRecording(const SkRect& bounds, SkBBHFactory* factory);
    void finishRecordingAsPicture();
    void finishRecordingAsPictureWithCull(const SkRect& cullRect);

    sk_sp<SkPicture> getPicture();
    std::shared_ptr<SkPictureRecorder> getRecorder() { return recorder; }
    SkCanvas* getRecordingCanvas();
    bool playback(SkCanvas* canvas, SkDeferredDetails* dd);
    int getCount() { return recorder->getRecordCount(); }
    bool playback(SkCanvas* canvas, SkDeferredDetails* dd, int si, int ei);
    int getWeightedRecordCount(const SkRect& rect, const SkMatrix& matrix, const int& uLimit);
};

#endif
