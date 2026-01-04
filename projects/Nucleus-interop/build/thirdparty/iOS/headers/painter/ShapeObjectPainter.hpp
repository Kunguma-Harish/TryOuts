#pragma once

#include <painter/GL_Ptr.h>
#include <skia-extension/GLRect.hpp>
#include <skia-extension/GLRegion.hpp>
#include <painter/ShapePainter.hpp>
#include <painter/TransformPainter.hpp>
#include <painter/ShapeGeometryPainter.hpp>
#include <painter/DrawingContext.hpp>
#include <skia-extension/DeferredDetails.hpp>
#include <painter/SelectionContext.hpp>
#include <skia-extension/util/FnTypes.hpp>
#include <skia-extension/core/types.h>
#include <painter/shapespainter_export.h>
#include <painter/TextBodyPainter.hpp>
#include <include/core/SkPathUtils.h>

#include <string>

class SkCanvas;

namespace com {
namespace zoho {
namespace common {
enum Reaction_ReactionStatus : int;
class Reaction;
}
namespace shapes {
class ShapeObject;
class Locks;
class NonVisualDrawingProps;
class NonVisualProps;
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

using ShapeShouldGoNext = std::function<bool(bool)>;

enum Type {
    CONTAINER = 0,
    SHAPES = 1,
    ANCHOR = 2
};

struct ShapeObjectsDetails {
    GL_Ptr<com::zoho::shapes::ShapeObject> shapeObject;
    Type shapeType;
    GL_Ptr<com::zoho::shapes::Transform> gTrans;
    GL_Ptr<com::zoho::shapes::TextBody> textBody;
    int index;
    GLPath path;
    Matrices currentMatrices;
    GLRect customParentBounds = graphikos::painter::GLRect::MakeNaN();
    GLRect customBounds = graphikos::painter::GLRect::MakeNaN();
    void setshapeObject(com::zoho::shapes::ShapeObject* shapeobject);
    com::zoho::shapes::ShapeObject* getShapeObject();
    void setgTrans(com::zoho::shapes::Transform* transform);
    com::zoho::shapes::Transform* getgTrans();

    ShapeObjectsDetails();
    std::shared_ptr<com::zoho::shapes::ShapeObject> getSharedShape();
    std::shared_ptr<com::zoho::shapes::Transform> getSharedGTrans();
    com::zoho::shapes::Transform getMergedTransform();
    bool operator==(const ShapeObjectsDetails& otherObj) const {
        if (otherObj.shapeObject == this->shapeObject && otherObj.shapeType == this->shapeType && otherObj.gTrans == this->gTrans && otherObj.textBody == this->textBody && otherObj.index == this->index && otherObj.path == this->path) {
            return true;
        } else {
            return false;
        }
    }
    ShapeObjectsDetails(com::zoho::shapes::ShapeObject* shapeObject, Type shapeOrContainer, com::zoho::shapes::Transform* gtrans, int index, GLPath path, Matrices currentMatrices, GLRect customParentBounds, GLRect customBounds = GLRect::MakeNaN());
    ShapeObjectsDetails(GL_Ptr<com::zoho::shapes::ShapeObject> shapeObject, Type shapeOrContainer, GL_Ptr<com::zoho::shapes::Transform> gtrans, int index, GLPath path, Matrices currentMatrices, GLRect customParentBounds, GLRect customBounds = GLRect::MakeNaN());
    ShapeObjectsDetails(com::zoho::shapes::ShapeObject* shapeObject, Type shapeOrContainer, com::zoho::shapes::Transform* gtrans, com::zoho::shapes::TextBody* textBody, int index, GLPath path, Matrices currentMatrices, GLRect customParentBounds, GLRect customBounds = GLRect::MakeNaN());
};

struct ReactionDetails {
    com::zoho::common::Reaction_ReactionStatus reactionStatus;
    graphikos::painter::GLRect reactionRect;
    ReactionDetails();
    ReactionDetails(com::zoho::common::Reaction_ReactionStatus reactionStatus, graphikos::painter::GLRect reactionRect);
};
struct ShapeDetails {
    std::string subType;
    ReactionDetails reactionDetails;
    ShapeObjectsDetails shapeObjectDetail;
    std::vector<ShapeObjectsDetails> parentDetails;
    ShapeDetails();
    ShapeDetails(struct ShapeObjectsDetails shapeDetail);
    ShapeDetails(ShapeObjectsDetails shapeDetail, std::vector<ShapeObjectsDetails> parentDetail);
    ShapeDetails(ShapeObjectsDetails shapeDetail, ShapeObjectsDetails parentDetail);

    bool isParent(ShapeDetails shapedetails);
};

class ShapeObjectPainter {
private:
    com::zoho::shapes::ShapeObject* shapeObject = nullptr;

public:
    bool isHidden();
    SHAPESPAINTER_EXPORT ShapeObjectPainter(com::zoho::shapes::ShapeObject* shapeObject);
    static SHAPESPAINTER_EXPORT bool directShapeSelection;
    bool draw(const DrawingContext& dc, com::zoho::shapes::Properties* gProps = nullptr);
    std::string getShapeId();
    GLRect refreshFrame(std::string parentId, SkMatrix matrix, com::zoho::shapes::Properties* props);
    com::zoho::shapes::ShapeObject* getCompleteShapeObject();

    std::vector<ShapeDetails> getShapeDetails(GLPoint point, const SelectionContext& sc);
    ShapeDetails getShapeDetailsWithinRange(GLRegion region, Matrices matrices, GLRect range, com::zoho::shapes::Transform* gTrans = nullptr, IProvider* provider = nullptr);
    ShapeDetails getShapeDetailsPathWithinRange(GLRegion region, Matrices matrices, GLRect range, com::zoho::shapes::Transform* gTrans = nullptr, IProvider* provider = nullptr);
    ShapeDetails getShapeDetailsById(std::string shapeId, const SelectionContext& sc);
    ShapeDetails getShapeDetailsById(std::string shapeId, const SelectionContext& sc, com::zoho::shapes::Transform* transform);
    std::vector<ShapeDetails> getShapeDetailsByName(std::string shapeName, const SelectionContext& sc);
    com::zoho::shapes::Properties* getProps();
    google::protobuf::RepeatedPtrField<com::zoho::common::Reaction>* getReaction();
    com::zoho::shapes::Transform* getTransform();
    com::zoho::shapes::ShapeGeometry* getGeom();
    com::zoho::shapes::Locks* getLocks();
    GLPath getPropsRange(Matrices matrices, com::zoho::shapes::Transform* gTrans, const GLRect* customParentBounds, const GLRect* customBounds, IProvider* provider, bool computeForChild = false);
    GLPath getTransformedGLPath(Matrices matrices, com::zoho::shapes::Transform* gTrans, IProvider* provider);
    GLPath getFillPath(Matrices matrices, com::zoho::shapes::Transform* gTrans, IProvider* provider);
    GLPath getShapePath(bool withRadius, IProvider* provider, const Matrices& matrices, com::zoho::shapes::Transform* gTrans, bool considerFill = false);
    google::protobuf::RepeatedPtrField<com::zoho::shapes::TextBody> getTextBodies();
    com::zoho::shapes::NonVisualDrawingProps* getNvdprops();
    com::zoho::shapes::NonVisualProps* getNvprops();
    com::zoho::shapes::Properties getShapeObjectProps();

    com::zoho::shapes::Transform getShapeTransform(bool considerShapeDimScale); // for calculating innerbounds - for groupshape

    bool noFill();
    bool noStroke();
    bool isPlaceHolder();
    bool isPicturePlaceHolder();
    bool isTextPlaceHolder();
    bool isTablePlaceHolder();
    bool isEmptyPlaceHolder();
    bool isEmbed();
    bool isMedia();
    bool isFile();
    bool isTextEditableShape();
    bool isShapePropsModifiable();
    bool hasHyperlink();

    static SHAPESPAINTER_EXPORT std::string setReactionRenderTrigger(std::string shapeId) {
        return shapeId;
    }
};
}

namespace util {
class ShapeObjectUtil {
private:
    const com::zoho::shapes::ShapeObject& obj;

public:
    ShapeObjectUtil(const com::zoho::shapes::ShapeObject& _obj);
    bool hasProps() const;
    const com::zoho::shapes::Properties* getProps() const;
};
}
}
