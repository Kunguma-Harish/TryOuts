#ifndef PictureUtil_DEFINED
#define PictureUtil_DEFINED

#include <include/core/SkSurface.h>
#include <src/core/SkRecordDraw.h>
#include <src/core/SkRecord.h>
#include <chrono>
#include <map>
#include <stack>

namespace SkRecords {
class Draw;
}

struct PictureInfo {
    int drawCallIndex;
    SkRecords::Type drawType;
};

class SK_API SkDeferredDetails {
public:
    const SkRecord* record = nullptr;

    int soavg_time = 27;
    int iterator = 0;

    SkRect bounds = SkRect::MakeEmpty();
    std::vector<int> drawCalls;

    int flexibleCounter = 0;
    int max_count = 30;
    int saveAndSaveLayerCounter = 0;
    int max_count_ulimit = 2000;
    int fixedCounter = 0;
    std::chrono::time_point<std::chrono::high_resolution_clock> startTime;

    bool checkTimeLimit();
    void clearAll();
    void initTimer();
};

class PictureUtil {
public:
    enum class RecordCategory {
        NO_OP_RECORD,
        DRAW_RECORD,
        CLIP_RECORD,
        STATE_CHNG_RECORD,
        SAVE_LAYER_RECORD,
        SAVE_LAYER_SCALE
    };

    struct PlaybackSettings {
        bool ignoreSaveLayer = false;  // Replace saveLayer with save
        bool flushInBetweenDrawCalls = true; // will do flush inbetween drawcalls
        PlaybackSettings() {}
    };

    static std::map<RecordCategory, int> defaultWeights;

    static bool DeferredPlayback(SkPicture* picture,
                                 SkCanvas* canvas,
                                 SkDeferredDetails* dd,
                                 bool indicesPassed = false,
                                 int si = -1,
                                 int ei = -1,
                                 PlaybackSettings playbackSettings = PlaybackSettings());
    static void playbackIndex(SkPicture* picture, SkCanvas* canvas, int startIndex, int endIndex);
    static std::vector<PictureInfo> populatePictureInfoStack(const SkBigPicture* picture,
                                                             int endIndex,
                                                             int startIndex = 0);

    static void pop(std::vector<PictureInfo> pictureInfoStack);

    static void push(std::vector<PictureInfo> pictureInfoStack, PictureInfo info);

    static int getSaveCountFromStack(std::vector<PictureInfo> pictureInfoStack);

    static int getWeightedRecordCount(
            const SkPicture* picture,
            const SkRect& queryRect,
            const SkMatrix& matrix,
            const int& uLimit,
            std::map<RecordCategory, int> weights = std::map<RecordCategory, int>(),
            PlaybackSettings playbackSettings = PlaybackSettings());

private:
    static int restoreIndex;
    static bool SetupDeferredPlayback(SkPicture* picture,
                                      SkCanvas* canvas,
                                      SkDeferredDetails* dd,
                                      bool indicesPassed,
                                      int si,
                                      int ei);
    static bool ContinueDeferredPlayback(SkPicture* picture,
                                         SkCanvas* canvas,
                                         SkDeferredDetails* dd,
                                         PlaybackSettings playbackSettings);
};

#endif
