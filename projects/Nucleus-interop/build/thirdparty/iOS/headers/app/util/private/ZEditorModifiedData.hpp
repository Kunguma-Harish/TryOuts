#ifndef __NL_ZEDITORMODIFIED_H
#define __NL_ZEDITORMODIFIED_H

#include <shapeobject.pb.h>
#include <offset.pb.h>
#include <transform.pb.h>
#include <painter/ShapeObjectPainter.hpp>

namespace com {
namespace zoho {
namespace shapes {
class ShapeObject;
}
}
}

enum Action {
    NONE = 0,
    ADD = 1,
    MODIFY = 2,
    REMOVE = 3
};
enum ModificationType {
    SHAPE_DATA = 0,
    SHAPE_OBJECT = 1
};
struct ShapeData {
    Action action;
    com::zoho::shapes::ShapeObject shapeObject;
    com::zoho::shapes::TextBody textBody;
    std::string id;
    std::string textBodyId;
    com::zoho::shapes::Offset crop;
    std::vector<std::string> removedData;
    ModificationType type = SHAPE_DATA;

    graphikos::painter::ShapeDetails cloneShape;
    int index = -1;
    std::string frameId;
    std::string parentId;
    std::vector<std::string> parentIds;
};

struct Modification {
    Action action;
    int si;
    int ei;
    bool isParaUpdate;
    std::string value;
    std::string oldValue;
    std::string newParaId = "";
    bool doNotExtendProps = false;
};

struct TextModifyData {
    std::vector<Modification> modifications;
    std::string shapeId;
    std::string connectorId;
    std::string tableId;
    com::zoho::shapes::TextBody* textBody;
    bool isImmediateOp = false;
    bool placeCursorAtWordEnd = false;
};
struct EditingTransform {
    com::zoho::shapes::Transform editingTransform;
    com::zoho::shapes::Transform selectedShapeRect;
};
#endif