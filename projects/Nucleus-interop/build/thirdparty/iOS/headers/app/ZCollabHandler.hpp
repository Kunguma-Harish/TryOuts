#ifndef __NL_ZCOLLABHANDLER_H
#define __NL_ZCOLLABHANDLER_H
#include <filesystem>

#include <app/ZSelectionHandler.hpp>
#include <app/util/GCUtil.hpp>
namespace google {
namespace protobuf {
template <typename T>
class RepeatedPtrField;
}
}
class ZCollabHandler {
public:
    std::map<std::string, std::string> selectedShapeAndName;
    struct CollabDetail {
        std::string id;
        graphikos::painter::GLPoint pos;
        std::string name;
        SkColor color;
    };

    enum PivotPoint {
        TOPLEFT = 0,
        TOPRIGHT = 1,
        BOTTOMLEFT = 2,
        BOTTOMRIGHT = 3
    };
    ZCollabHandler() {
        //createDefaultValues();
        selectionHandler = new ZSelectionHandler();
        Bbox = createDefaultBbox();
        defaultCursorWithName = createDefaultCursor();
    }
    ZSelectionHandler* getSelectionHandler() { return selectionHandler; }
    void selectShape(std::string shapeId, SkColor color, std::string name);
    void unSelectShape(std::string shapeId);
    void clearShapes();
    com::zoho::shapes::ShapeObject* getBbox() { return Bbox; }

    void renderBboxWithColor(std::vector<SelectedShape> selectedShapes);
    void addCollabCursors(CollabDetail detail);
    void removeCollabDetail(std::string id);
    void clearCollabDetail();
    void updateShapeFill(com::zoho::shapes::Fill* fill, SkColor color);
    void renderCollabbBox(com::zoho::shapes::ShapeObject* bBoxShape, SelectedShape shape);
    void renderCollabCursors(SkCanvas* canvas, SkMatrix scaleMatrix);
    graphikos::painter::LineSegment getTopLineDetails(com::zoho::shapes::Transform mergedTransform);
    com::zoho::shapes::ShapeObject* createDefaultBbox();
    std::shared_ptr<com::zoho::shapes::ShapeObject> createDefaultCursor();

    // void createDefaultValues() {
    //     CollabDetail cb;
    //     cb.color = SK_ColorBLUE;
    //     cb.id = "1234";
    //     cb.pos = graphikos::painter::GLPoint({600, 200});
    //     cb.name = "abcdefghi";
    //     collabDetails.push_back(cb);
    // }

    void updateBboxValues(com::zoho::shapes::ShapeObject* shapeobject, SkColor color);
    void drawCursorWithName(SkCanvas* canvas, CollabDetail detail);

    ~ZCollabHandler();

private:
    com::zoho::shapes::ShapeObject* Bbox;
    std::shared_ptr<com::zoho::shapes::ShapeObject> defaultCursorWithName;
    ZSelectionHandler* selectionHandler;
    std::vector<CollabDetail> collabDetails;
};

#endif
