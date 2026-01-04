#ifndef __NL_VANISHAPEMODIFIED_H
#define __NL_VANISHAPEMODIFIED_H

#include <app/ZShapeModified.hpp>

namespace com {
namespace zoho {
namespace collaboration {
class DocumentContentOperation_Component_Text;
}
}
}
struct Modification;

class VaniShapeModified : public ZShapeModified {

    std::vector<com::zoho::collaboration::DocumentContentOperation_Component_Text> getTextAsProto(std::vector<Modification> modifications);

public:
    VaniShapeModified(EditorCallBacks* callbacks);
    bool textThrow(TextModifyData textData, std::vector<ShapeData> shapeDatas, std::vector<SelectedShape> selectedShapes, bool autoFit = false) override;
    bool textDirectDataChange(TextModifyData textData, bool triggerDataUpdated = true) override;
    bool tableTextDelete(std::vector<TextModifyData>& textData, std::vector<SelectedShape>& selectedShapes) override;

    void addShapeObject(com::zoho::shapes::ShapeObject* shapeObject, graphikos::painter::GLPoint mousePoint, NLDataController* data) override;
    void addAndModifyShapeObjects(com::zoho::shapes::ShapeObject* shapeObject, graphikos::painter::GLPoint mousePoint, NLDataController* data, std::vector<ShapeData> dependencyShapeData) override;
    void updateDataThroughDelta(std::vector<ModifyData> dataToBeModified, std::vector<ShapeData> dependencyData, graphikos::painter::GLPoint mousePoint = graphikos::painter::GLPoint(), bool isExternalShape = false, bool shapesDuplicated = false, bool fromUI = false, NLDataController* controller = nullptr) override;
};
#endif
