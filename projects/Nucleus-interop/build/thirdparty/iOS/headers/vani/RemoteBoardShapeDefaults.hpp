#ifndef __NL_REMOTEBOARDSHAPEDEFAULTS_H
#define __NL_REMOTEBOARDSHAPEDEFAULTS_H

#include <app/BBoxConstants.hpp>
#include <vani/data/VaniDataController.hpp>

namespace asset {
enum class Type;
};

namespace com {
namespace zoho {
namespace shapes {
class ShapeObject;
class Fill;
}
}
}

namespace google {
namespace protobuf {
template <typename T>
class RepeatedPtrField;
}
}

namespace Show {
enum GeometryField_ShapeGeometryType : int;
enum GeometryField_PresetShapeGeometry : int;
}

class RemoteBoardShapeDefaults {
public:
    NLDataController* dataController;
    RemoteBoardShapeDefaults(NLDataController* _dataController) {
        dataController = _dataController;
    };

    std::shared_ptr<com::zoho::shapes::ShapeObject> getShapeDefault(asset::Type type);

    std::shared_ptr<com::zoho::shapes::ShapeObject> line(bool isConnector);
    void listStyles();
    std::shared_ptr<com::zoho::shapes::ShapeObject> groupshape();
    std::shared_ptr<com::zoho::shapes::ShapeObject> text();
    void paragraph(); // TODO
    std::shared_ptr<com::zoho::shapes::ShapeObject> bulletted();
    std::shared_ptr<com::zoho::shapes::ShapeObject> numbered();
    std::shared_ptr<com::zoho::shapes::ShapeObject> selectable();
    std::shared_ptr<com::zoho::shapes::ShapeObject> picture();
    std::shared_ptr<com::zoho::shapes::ShapeObject> pen();
    std::shared_ptr<com::zoho::shapes::ShapeObject> highlighter();
    std::shared_ptr<com::zoho::shapes::ShapeObject> sketch();
    std::shared_ptr<com::zoho::shapes::ShapeObject> shape();
    std::shared_ptr<com::zoho::shapes::ShapeObject> connector();
    std::shared_ptr<com::zoho::shapes::ShapeObject> frame();

    std::shared_ptr<com::zoho::shapes::ShapeObject> getDrawShapeData(asset::Type _shapeDrawType, com::zoho::shapes::ShapeNodeType shapeObjType, Show::GeometryField_ShapeGeometryType shapeGeoType, asset::Type drawToolType, Show::GeometryField_PresetShapeGeometry action, std::vector<float> drawToolColor, float strokeWidth, asset::Type formatType, asset::phTypeEnum phType);
    void getObjectDefaults(asset::Type _shapeDrawType, com::zoho::shapes::ShapeNodeType shapeObjType, Show::GeometryField_ShapeGeometryType shapeGeoType, asset::Type drawToolType, Show::GeometryField_PresetShapeGeometry action, std::vector<float> drawToolColor, float strokeWidth, asset::Type formatType, com::zoho::shapes::ShapeObject* drawData);

    void getRBShapeData(com::zoho::shapes::ShapeObject& data);
    void applyDefaultTextColorSize(com::zoho::shapes::ShapeObject& data);

private:
    std::shared_ptr<com::zoho::shapes::ShapeObject> getConnectorDefaults(bool isConnector);
    std::shared_ptr<com::zoho::shapes::Fill> getShapeColorObject();
    std::shared_ptr<com::zoho::shapes::Fill> shapeCurrentColor();
    std::shared_ptr<com::zoho::shapes::Fill> shapeDefaultFillObj();
};

#endif
