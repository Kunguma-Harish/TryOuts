#ifndef __NL_SELECTIONSTRUCTS_H
#define __NL_SELECTIONSTRUCTS_H

#include <iostream>
#include <skia-extension/GLPath.hpp>
#include <vector>

namespace com {
namespace zoho {
namespace shapes {
class Transform;
}
}
}
struct CellDetails {
    int rowIndex = -1;
    int colIndex = -1;
    graphikos::painter::GLPath path;
    std::shared_ptr<com::zoho::shapes::Transform> cellTransform = nullptr;
    graphikos::painter::Matrices currentMatrices;
};

struct SelectedCellDetails {
    std::vector<CellDetails> cellDetails;
    int rowIndex = -1;
    int cellIndex = -1;
};

#endif