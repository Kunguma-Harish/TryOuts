#pragma once

#include <string>
#include <vector>
#include <optional>

#include <include/patch/PictureUtil.h>

class DeferredDetails : public SkDeferredDetails {

    static const int DD_DRAWING_STATE;
    static const int DD_TRAVERSAL_STATE;

private:
    /**
     * we use this variable to count shapes when we are in traversal mode
     * >=0 is an indicator that we are in traversal mode
     * -1 is an indicator that we are in drawing mode
     */
    long traversalCount = DD_DRAWING_STATE;
    /**
     * we use this variable too count shapes when we are in drawing mode
     */
    long drawnCount = 0;

    int max_count;

public:
    bool outsideBoundsPresent = false;
    int outerItrIndex = 0;
    std::vector<int> outerIndices;

    std::optional<int> customPlaybackIndex;

    bool isStartOrEnd();

    void clearAll();
    DeferredDetails(int soavg_time = 27, int max_count = 30);

    /**
     * @brief Get permit for rendering and marks state
     * @return true can proceed with rendering, marks state as drawing
     * @return false stop and wait for your turn, marks state as traversal
     */
    bool getPermit();

    /**
     * @brief Returns whether the current shapeobject is already drawn or not
     * and also increments the counter. @todo move this functionality separately
     * @return true
     * @return false
     */
    bool isDrawn();

    /**
     * @brief Increment internal shape counters based on state
     */
    void increaseShapeCount();

    /**
     * @brief Returns if the current state is drawing or traversal
     * @return true if traversalCount == -1
     * @return false if traversalCount >= 0
     */
    bool isDrawingState();
    bool checkTimeLimit(std::string s);
};
