#ifndef __NL_IIMAGEPROCESSLISTENER_H
#define __NL_IIMAGEPROCESSLISTENER_H
#include <iostream>

namespace graphikos {
namespace nucleus {
class IImageProcessListener {
    public:
        virtual void onImageReceived(std::string imageId, const uint8_t* bytes, size_t bytes_len) = 0;
        virtual void onAllImageReceived() = 0;
};
}
}

#endif
