#ifndef __NL_FITCONTROLLER_H
#define __NL_FITCONTROLLER_H

#include <vector>
#include <skia-extension/GLRect.hpp>
#include <app/ZSelectionHandler.hpp>
#include <nucleus/util/FitToScreenUtil.hpp>

class NLFitController {
public:
    virtual void fitShapesToVisibleArea(graphikos::painter::GLRect rect, graphikos::common::FitToScreenUtil::FitType, bool needAnimation = false, bool alwaysFit = false, float fitRatio = 0);
    void fitToPath(graphikos::painter::GLPath path, bool needAnimation = false, bool maintainScale = false, bool alwaysFit = false, float fitRatio = 0);
    virtual void fitShapes(const std::vector<std::string>& shapeIds, bool needAnimation = false, bool maintainScale = false, bool fitContainer = false, bool alwaysFit = false);
    virtual void fitSelectedShapes(std::vector<SelectedShape> shapes, bool needAnimation = false, bool maintainScale = false, bool fitContainer = false, bool alwaysFit = false, float fitRatio = 0);
};

#endif