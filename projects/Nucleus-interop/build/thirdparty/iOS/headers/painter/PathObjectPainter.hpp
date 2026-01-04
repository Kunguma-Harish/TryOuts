#pragma once

#include <skia-extension/GLPoint.hpp>

namespace com {
namespace zoho {
namespace shapes {
class PathObject;
}
}
}

namespace google {
namespace protobuf {
template <typename T>
class RepeatedPtrField;
}
}

namespace graphikos {
namespace painter {
class PathObjectPainter {
private:
    com::zoho::shapes::PathObject* pathObject = nullptr;

public:
    com::zoho::shapes::PathObject* getPathObject() {
        return this->pathObject;
    }
    PathObjectPainter(com::zoho::shapes::PathObject* _pathObject);
    float getCornerRadius();
    float maximumCornerRadius(GLPoint* fromPoint, GLPoint* viaPoint, GLPoint* toPoint, bool prevNodeHasRadius, bool nextNodeHasRadius, bool prevNodeSelected, bool nextNodeSelected);

    GLPoint getCoordinates(google::protobuf::RepeatedPtrField<com::zoho::shapes::PathObject>* pathObjects, SkMatrix scaleMatrix);
    static GLPoint GetControl2(google::protobuf::RepeatedPtrField<com::zoho::shapes::PathObject>* pathObjects, int index, SkMatrix scaleMatrix);
    static GLPoint GetControlPointForSQCPathObject(google::protobuf::RepeatedPtrField<com::zoho::shapes::PathObject>* pathObjects, int index, SkMatrix scaleMatrix);

    static int GetPrevCornerRadiusNodeIndex(google::protobuf::RepeatedPtrField<com::zoho::shapes::PathObject>* pathObjects, int currentIndex);
    static com::zoho::shapes::PathObject* GetPrevCornerRadiusNode(google::protobuf::RepeatedPtrField<com::zoho::shapes::PathObject>* pathObjects, int currentIndex);

    static int GetNextCornerRadiusIndex(google::protobuf::RepeatedPtrField<com::zoho::shapes::PathObject>* pathObjects, int currentIndex);
    static com::zoho::shapes::PathObject* GetNextCornerRadiusNode(google::protobuf::RepeatedPtrField<com::zoho::shapes::PathObject>* pathObjects, int currentIndex);

    static bool DoesPrevNodeHaveCornerRadius(google::protobuf::RepeatedPtrField<com::zoho::shapes::PathObject>* pathObjects, int currentNodeIndex);
    static bool DoesNextNodeHaveCornerRadius(google::protobuf::RepeatedPtrField<com::zoho::shapes::PathObject>* pathObjects, int currentNodeIndex);
};
}
}