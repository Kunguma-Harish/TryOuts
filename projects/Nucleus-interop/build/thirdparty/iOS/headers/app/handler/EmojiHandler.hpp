#ifndef __NL_EMOJIHANDLER_H
#define __NL_EMOJIHANDLER_H

#include <skia-extension/util/FnTypes.hpp>
#include <nucleus/interface/IFontShapeListener.hpp>
#include <app/nl_api/CallBacks.hpp>

namespace com {
namespace zoho {
namespace shapes {
class FontShape;
}
}
}

namespace graphikos {
namespace nucleus {
class EmojiHandler : public IFontShapeListener {
private:
    google::protobuf::RepeatedPtrField<com::zoho::shapes::FontShape>* fontShapes = nullptr;
    size_t emojiCount;
    size_t maxEmojiCount;
    bool countingRan;

public:
    EmojiHandler();
    const std::string* fetchEmoji(std::string emojiId);
    void setEmojiCallBack(CallBacks* cbs);
    void onFontShape(google::protobuf::RepeatedPtrField<com::zoho::shapes::FontShape>* fontShapes) override;
};
}
}

#endif
