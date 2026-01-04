#ifndef __NL_ZSMARTDISTANCE_H
#define __NL_ZSMARTDISTANCE_H
#include <app/ZSelectionHandler.hpp>
#include <skia-extension/GLPoint.hpp>

class ZSmartDistance {

public:
    std::vector<graphikos::painter::SmartLine> computeSmartDistances(graphikos::painter::ShapeDetails shape, std::vector<SelectedShape> selectedShapes);

private:
    std::vector<graphikos::painter::SmartLine> getSmartLines(graphikos::painter::ShapeDetails targetShape, graphikos::painter::ShapeDetails selectedShape);
    std::vector<graphikos::painter::SmartLine> getContainerSmartLines(graphikos::painter::ShapeDetails targetShape, graphikos::painter::ShapeDetails selectedShape);
};

#endif