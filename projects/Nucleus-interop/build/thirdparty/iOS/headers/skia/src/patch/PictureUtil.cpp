#include <include/patch/PictureUtil.h>
#include <iostream>
#include <numeric>
#include <src/core/SkBigPicture.h>
#include <include/gpu/GrDirectContext.h>
// Expected flush time of single batch of draw calls.
#define EXPECTED_FLUSH_TIME 8000

// the threshold for draw calls is determined by dividing the dd->max_count by
// PRE_SAVE_LAYER_DIVISOR_THRESHOLD will be flushed if dd->flexibleCounter is greater than threshold
// when creating the first/lowest layer using saveLayer
#define PRE_SAVE_LAYER_DIVISOR_THRESHOLD 4

// will be flushed if dd->fixedCounter is greater than POST_RESTORE_LAYER_MAX_COUNT_THRESHOLD when
// restoring the first/lowest layer
#define POST_RESTORE_LAYER_MAX_COUNT_THRESHOLD 30
#define SHOULD_CONTINUE(dd) (dd && dd->checkTimeLimit())
int PictureUtil::restoreIndex = -1;

/*
    Working of PictureUtil::ContinueDeferredPlayback:
    - Here in PictureUtil::ContinueDeferredPlayback, we playback all records(drawcalls) in given
   SkPicture object.
    - It works in deferred manner. i.e) It playbacks the records until a specific time interval
   (dd->soavg_time) and returns whether the SkPicture is playbacked completely or not.
    - It maintains its state in dd (SkDeferredDetails). It uses the data in dd to continue to
   playback which is paused due to time limit (dd->soavg_time) exceeding.

    - Here while performing playback, we do in between flush (to avoid longer flush time at last
   after finishing playback)
    - Variables in dd (SkDeferredDetails) associated with in between flush :
    -   SkDeferredDetails::fixedCounter : It counts the number of drawCalls executed on baseLayer.
   It has a 'fixed' upperlimit `POST_RESTORE_LAYER_MAX_COUNT_THRESHOLD`
    -   SkDeferredDetails::flexibleCounter : It counts the number of drawCalls executed without any
   layer. It has a 'flexible' upperlimit dd->max_count
    -   SkDeferredDetails::max_count : It tells size of batch of drawcalls that is flushed after
   executing. Its value changes dynamically and depends on the previous flush time. It's value is
   adjusted such that the flush time is equal to EXPECTED_FLUSH_TIME.
    -   SkDeferredDetails::saveAndSaveLayerCounter : Creation and Restoring of Base layer is
   dertermined by counting the save, saveLayer and restore records after base layer's SaveLayer. It
   stores the count of save and SaveLayer.

    - In between flushing is done if any one of below conditions met
    -   if flexible_counter is greater than max_count
    -   if baseLayer is created and flexible_counter is greater than quarter of max_count i.e)
   max_count divided by PRE_SAVE_LAYER_DIVISOR_THRESHOLD
    -   if baseLayer is restored and fixed_counter is greater than
   POST_RESTORE_LAYER_MAX_COUNT_THRESHOLD
    - The max_count value is not updated when flushing after base layer is created or restored
*/

bool PictureUtil::SetupDeferredPlayback(SkPicture* picture,
                                        SkCanvas* canvas,
                                        SkDeferredDetails* dd,
                                        bool indicesPassed,
                                        int si,
                                        int ei) {
    const SkBigPicture* bigpicture = picture->asSkBigPicture();

    const bool useBBH = !canvas->getLocalClipBounds().contains(bigpicture->cullRect());
    const SkBBoxHierarchy* bbh = useBBH ? bigpicture->fBBH.get() : nullptr;

    SkRect query;
    dd->record = bigpicture->fRecord.get();
    query = canvas->getLocalClipBounds();
    dd->bounds = query;
    dd->drawCalls.clear();
    dd->iterator = 0;

    if (indicesPassed) {
        restoreIndex = -1;
        auto pictureInfoStack = populatePictureInfoStack(bigpicture, si, 0);
        for (size_t i = 0; i < pictureInfoStack.size(); i++)
            dd->drawCalls.push_back(pictureInfoStack[i].drawCallIndex);
        for (int i = si; i < ei; i++)  // this can be replaced with iota
            dd->drawCalls.push_back(i);
        if (pictureInfoStack.size()) {
            if (restoreIndex == -1) {
                auto stack = populatePictureInfoStack(bigpicture, bigpicture->fRecord->count(), ei);

                if (restoreIndex != -1) {
                    for (int i = 0; i < getSaveCountFromStack(pictureInfoStack); i++) {
                        dd->drawCalls.push_back(restoreIndex);
                    }
                }
            }
        }
    } else if (bbh) {
        bbh->search(query, &(dd->drawCalls));
    } else {
        dd->drawCalls = std::vector<int>(bigpicture->fRecord->count());
        std::iota(dd->drawCalls.begin(), dd->drawCalls.end(), 0);
    }
    return true;
}

bool PictureUtil::ContinueDeferredPlayback(SkPicture* picture,
                                           SkCanvas* canvas,
                                           SkDeferredDetails* dd,
                                           PlaybackSettings playbackSettings) {
    SkASSERT_RELEASE(dd->startTime.time_since_epoch().count() != 0);

    const SkBigPicture* bigpicture = picture->asSkBigPicture();

    SkRecords::Draw draw(canvas, bigpicture->drawablePicts(), nullptr, bigpicture->drawableCount());

    int totalCount = (int)dd->drawCalls.size();

    for (; dd->iterator < totalCount; dd->iterator++) {
        if (SHOULD_CONTINUE(dd)) {
            bool isBaseRestoreLayer = false, isBaseSaveLayer = false;
            const SkRecords::Type& type =
                    bigpicture->fRecord->fRecords[dd->drawCalls[dd->iterator]].fType;
            if (playbackSettings.flushInBetweenDrawCalls) {
                switch (type) {
                    case SkRecords::Save_Type:
                        if (dd->saveAndSaveLayerCounter > 0) {
                            dd->saveAndSaveLayerCounter++;
                        }
                        break;

                    case SkRecords::SaveLayer_Type:
                        if (dd->saveAndSaveLayerCounter == 0) {  // check if it is first save layer
                            isBaseSaveLayer = true;
                        }
                        dd->saveAndSaveLayerCounter++;

                        break;

                    case SkRecords::Restore_Type:
                        if (dd->saveAndSaveLayerCounter > 0) {
                            dd->saveAndSaveLayerCounter--;
                            if (dd->saveAndSaveLayerCounter == 0) {
                                isBaseRestoreLayer = true;
                            }
                        }
                        break;

                    default:
                        break;
                }
            }
            if (playbackSettings.ignoreSaveLayer && type == SkRecords::SaveLayer_Type) {
                canvas->save();
            } else {
                bigpicture->fRecord->visit(dd->drawCalls[dd->iterator], draw);
            }
            if (playbackSettings.flushInBetweenDrawCalls) {
                if (dd->saveAndSaveLayerCounter > 0) {
                    dd->fixedCounter++;  // it will be increased upto
                                         // POST_RESTORE_LAYER_MAX_COUNT_THRESHOLD
                } else {
                    dd->flexibleCounter++;  // it will be increased upto max_count
                }

                if (dd->flexibleCounter >= dd->max_count ||
                    (isBaseSaveLayer &&
                     dd->flexibleCounter >= dd->max_count / PRE_SAVE_LAYER_DIVISOR_THRESHOLD) ||
                    (isBaseRestoreLayer &&
                     dd->fixedCounter >= POST_RESTORE_LAYER_MAX_COUNT_THRESHOLD)) {
                    dd->flexibleCounter = 0;
                    dd->fixedCounter = 0;
                    auto start = std::chrono::high_resolution_clock::now();
                    canvas->getSurface()->recordingContext()->asDirectContext()->flushAndSubmit(canvas->getSurface(), GrSyncCpu::kYes);
                    long long elapsed = std::chrono::duration_cast<std::chrono::microseconds>(
                                                (std::chrono::high_resolution_clock::now() - start))
                                                .count();
                    if (dd->saveAndSaveLayerCounter == 0 && !isBaseSaveLayer &&
                        !isBaseRestoreLayer) {
                        dd->max_count += (EXPECTED_FLUSH_TIME - elapsed) * 0.01;
                        dd->max_count = dd->max_count < dd->max_count_ulimit ? dd->max_count
                                                                             : dd->max_count_ulimit;
                        dd->max_count = dd->max_count > 0 ? dd->max_count : 1;
                    }
                }
            }
        } else {
            return false;
        }
    }
    if (dd->iterator >= totalCount) {
        dd->clearAll();
        return true;
    }
    SkDEBUGFAIL("UNREACHABLE");
    return true;
}

bool PictureUtil::DeferredPlayback(SkPicture* picture,
                                   SkCanvas* canvas,
                                   SkDeferredDetails* dd,
                                   bool indicesPassed,
                                   int si,
                                   int ei,
                                   PlaybackSettings playbackSettings) {
    // if picture is not an object of  SkBigPicture class perform normal playback
    if (picture->asSkBigPicture() == nullptr) {
        picture->playback(canvas);
        return true;
    }

    if (dd->drawCalls.size() == 0) {
        PictureUtil::SetupDeferredPlayback(picture, canvas, dd, indicesPassed, si, ei);
    }

    SkASSERT_RELEASE(dd->record == picture->asSkBigPicture()->fRecord.get());
    return PictureUtil::ContinueDeferredPlayback(picture, canvas, dd, playbackSettings);
}

bool SkDeferredDetails::checkTimeLimit() {
    long long duration = std::chrono::duration_cast<std::chrono::milliseconds>(
                                 std::chrono::high_resolution_clock::now() - startTime)
                                 .count();
    if (duration >= soavg_time) {
        return false;
    }
    return true;
}

void SkDeferredDetails::clearAll() {
    this->iterator = 0;
    this->drawCalls.clear();
    this->bounds.setEmpty();
    this->saveAndSaveLayerCounter = 0;
}

void SkDeferredDetails::initTimer() { this->startTime = std::chrono::high_resolution_clock::now(); }

void PictureUtil::playbackIndex(SkPicture* picture,
                                SkCanvas* canvas,
                                int startIndex,
                                int endIndex) {
    const SkBigPicture* bigpicture = picture->asSkBigPicture();
    SkRecords::Draw draw(canvas, bigpicture->drawablePicts(), nullptr, bigpicture->drawableCount());
    int saveAndSaveLayerCounter = 0;
    std::vector<int> saveAndSaveLayerIndex;

    auto pictureInfoStack = populatePictureInfoStack(bigpicture, startIndex);

    if (pictureInfoStack.size()) {
        for (size_t i = 0; i < pictureInfoStack.size(); i++) {
            bigpicture->fRecord->visit(pictureInfoStack[i].drawCallIndex, draw);
        }
    }

    for (int i = startIndex; i < endIndex; i++) {
        bigpicture->fRecord->visit(i, draw);
    }
    saveAndSaveLayerCounter = getSaveCountFromStack(pictureInfoStack);

    while (saveAndSaveLayerCounter > 0) {
        canvas->restore();
        saveAndSaveLayerCounter--;
    }
}

std::vector<PictureInfo> PictureUtil::populatePictureInfoStack(const SkBigPicture* picture,
                                                               int endIndex,
                                                               int startIndex) {
    std::vector<PictureInfo> pictureInfoStack;
    int saveAndSaveLayerCounter = 0;

    for (int i = startIndex; i < endIndex; i++) {
        switch (picture->fRecord->fRecords[i].fType) {
            case SkRecords::Save_Type:
                saveAndSaveLayerCounter++;
                push(pictureInfoStack, {i, SkRecords::Save_Type});
                break;

            case SkRecords::SaveLayer_Type:
                saveAndSaveLayerCounter++;
                push(pictureInfoStack, {i, SkRecords::SaveLayer_Type});
                break;

            case SkRecords::Restore_Type:
                if (restoreIndex == -1)
                    restoreIndex = i;  // caches restore drawcall once for reference
                if (saveAndSaveLayerCounter > 0) {
                    saveAndSaveLayerCounter--;
                    pop(pictureInfoStack);
                }
                break;

            case SkRecords::ClipPath_Type:

                //@note this might not be needed

                if (saveAndSaveLayerCounter > 0) {
                    push(pictureInfoStack, {i, SkRecords::ClipPath_Type});
                }
                break;

            case SkRecords::ClipRect_Type:
                //@note this might not be needed
                if (saveAndSaveLayerCounter > 0) {
                    push(pictureInfoStack, {i, SkRecords::ClipRect_Type});
                }
                break;

            default:
                break;
        }
    }
    return pictureInfoStack;
}

void PictureUtil::pop(std::vector<PictureInfo> pictureInfoStack) {
    if (pictureInfoStack.size()) {
        if (pictureInfoStack.back().drawType == SkRecords::Save_Type ||
            pictureInfoStack.back().drawType == SkRecords::SaveLayer_Type) {
            pictureInfoStack.pop_back();
        } else {
            for (int i = pictureInfoStack.size() - 1; i >= 0; i--) {
                if (pictureInfoStack[i].drawType == SkRecords::Save_Type ||
                    pictureInfoStack[i].drawType == SkRecords::SaveLayer_Type) {
                    pictureInfoStack.pop_back();
                    break;
                } else {  // pops back ClipPath, ClipRect
                    pictureInfoStack.pop_back();
                }
            }
        }
    }
}

void PictureUtil::push(std::vector<PictureInfo> pictureInfoStack, PictureInfo info) {
    pictureInfoStack.push_back(info);
}

int PictureUtil::getSaveCountFromStack(std::vector<PictureInfo> pictureInfoStack) {
    int count = 0;
    for (size_t i = 0; i < pictureInfoStack.size(); i++) {
        if (pictureInfoStack[i].drawType == SkRecords::Save_Type ||
            pictureInfoStack[i].drawType == SkRecords::SaveLayer_Type) {
            count++;
        }
    }
    return count;
}

std::map<PictureUtil::RecordCategory, int> PictureUtil::defaultWeights = {
        {RecordCategory::NO_OP_RECORD, 0},
        {RecordCategory::STATE_CHNG_RECORD, 0},
        {RecordCategory::DRAW_RECORD, 2},
        {RecordCategory::CLIP_RECORD, 1},
        {RecordCategory::SAVE_LAYER_RECORD, 20},
        {RecordCategory::SAVE_LAYER_SCALE, 20}};

int PictureUtil::getWeightedRecordCount(const SkPicture* picture,
                                        const SkRect& queryRect,
                                        const SkMatrix& matrix,
                                        const int& uLimit,
                                        std::map<RecordCategory, int> weights,
                                        PlaybackSettings playbackSettings) {
    if (uLimit <= 0) return 0;
    if (picture->asSkBigPicture() == nullptr) {
        return picture->approximateOpCount();
    }

    const SkBigPicture* bigpicture = picture->asSkBigPicture();

    const bool useBBH = !queryRect.contains(bigpicture->cullRect());
    const SkBBoxHierarchy* bbh = useBBH ? bigpicture->fBBH.get() : nullptr;

    std::vector<int> drawCalls;
    if (bbh) {
        bbh->search(queryRect, &drawCalls);
    } else {
        drawCalls = std::vector<int>(bigpicture->fRecord->count());
        std::iota(drawCalls.begin(), drawCalls.end(), 0);
    }

    int acc = 0;
    weights.insert(defaultWeights.begin(), defaultWeights.end());

    for (size_t i = 0; i < drawCalls.size() && acc <= uLimit; i++) {
        switch (bigpicture->fRecord->fRecords[i].fType) {
            case SkRecords::NoOp_Type:
            case SkRecords::Restore_Type:
            case SkRecords::Save_Type:
                acc += weights.at(RecordCategory::STATE_CHNG_RECORD);
                break;
            case SkRecords::SaveLayer_Type: {
                if (playbackSettings.ignoreSaveLayer) {
                    acc += weights.at(RecordCategory::STATE_CHNG_RECORD);
                    break;
                }
                SkRecords::SaveLayer* saveLayerRec =
                        (SkRecords::SaveLayer*)bigpicture->fRecord->fRecords[i].fPtr;
                if ((saveLayerRec->paint && saveLayerRec->paint->getImageFilter()) ||
                    saveLayerRec->backdrop) {
                    const SkImageFilter* img = saveLayerRec->backdrop
                                                       ? saveLayerRec->backdrop.get()
                                                       : saveLayerRec->paint->getImageFilter();
                    SkRect bounds = saveLayerRec->bounds ? *saveLayerRec->bounds : queryRect;

                    auto dest = SkRect::Make(img->filterBounds(
                            bounds.roundOut(), matrix, SkImageFilter::kForward_MapDirection));
                    float ratio =
                            (dest.width() * dest.height()) / (bounds.width() * bounds.height());
                    acc += ratio * weights.at(RecordCategory::SAVE_LAYER_SCALE);
                    acc += weights[RecordCategory::SAVE_LAYER_RECORD];
                }
            } break;
            case SkRecords::SaveBehind_Type:  // priv method, not sure what it is..
                acc += weights.at(RecordCategory::SAVE_LAYER_RECORD);
                break;
            // canvas matrix calls
            case SkRecords::SetMatrix_Type:
            case SkRecords::SetM44_Type:
            case SkRecords::Translate_Type:
            case SkRecords::Scale_Type:
            case SkRecords::Concat_Type:
            case SkRecords::Concat44_Type:
                acc += weights.at(RecordCategory::STATE_CHNG_RECORD);
                break;
            // canvas clips
            case SkRecords::ClipPath_Type:
            case SkRecords::ClipRRect_Type:
            case SkRecords::ClipRect_Type:
            case SkRecords::ClipRegion_Type:
            case SkRecords::ClipShader_Type:
            case SkRecords::ResetClip_Type:
                acc += weights.at(RecordCategory::CLIP_RECORD);
                break;
            // canvas draw calls
            case SkRecords::DrawPicture_Type: {
                const SkPicture* childPicture =
                        ((SkRecords::DrawPicture*)bigpicture->fRecord->fRecords[i].fPtr)
                                ->picture.get();
                acc += getWeightedRecordCount(
                        childPicture, queryRect, matrix, uLimit - acc, weights, playbackSettings);
                break;
            }
            case SkRecords::DrawArc_Type:
            case SkRecords::DrawDrawable_Type:
            case SkRecords::DrawImage_Type:
            case SkRecords::DrawImageLattice_Type:
            case SkRecords::DrawImageRect_Type:
            case SkRecords::DrawDRRect_Type:
            case SkRecords::DrawOval_Type:
            case SkRecords::DrawBehind_Type:
            case SkRecords::DrawPaint_Type:
            case SkRecords::DrawPath_Type:
            case SkRecords::DrawPatch_Type:
            case SkRecords::DrawPoints_Type:
            case SkRecords::DrawRRect_Type:
            case SkRecords::DrawRect_Type:
            case SkRecords::DrawRegion_Type:
            case SkRecords::DrawTextBlob_Type:
            case SkRecords::DrawSlug_Type:
            case SkRecords::DrawAtlas_Type:
            case SkRecords::DrawVertices_Type:
            case SkRecords::DrawShadowRec_Type:
            case SkRecords::DrawAnnotation_Type:
            case SkRecords::DrawEdgeAAQuad_Type:
            case SkRecords::DrawEdgeAAImageSet_Type:
                acc += weights.at(RecordCategory::DRAW_RECORD);
                break;
            default:
                SK_ABORT("Unhandled SkRecord Type");
                acc += 0;
        }
    }
    return acc;
}
