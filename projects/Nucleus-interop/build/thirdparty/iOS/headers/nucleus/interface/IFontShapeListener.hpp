#ifndef __NL_IFONTSHAPELISTENER_H
#define __NL_IFONTSHAPELISTENER_H

namespace com {
namespace zoho {
namespace shapes {
    class FontShape;
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
namespace nucleus {
class IFontShapeListener {
public:
    /**
     * @brief Called when fontshape is received
     */
    virtual void onFontShape(google::protobuf::RepeatedPtrField<com::zoho::shapes::FontShape>* fontShapes) = 0;
};
}
}

#endif
