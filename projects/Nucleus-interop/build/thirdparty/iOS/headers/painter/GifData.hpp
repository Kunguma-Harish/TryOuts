#ifndef __NL_GIFDATA_H
#define __NL_GIFDATA_H
#include <string>
#include <unordered_map>
#include <chrono>

#include <include/core/SkImage.h>
#include <include/core/SkStream.h>
#include <include/codec/SkCodec.h>



namespace graphikos {
namespace painter {
enum ImgStatus {
    DEFAULT = 0,
    REQUESTED = 1,
    RECEIVED = 2,
    FAILED = 3
};
struct GifData {
    GifData() = default;
    GifData(std::string key, graphikos::painter::ImgStatus status, std::shared_ptr<SkCodec> codec);
    std::string key;
    void restart();
    std::string valueId;
    std::string shapeId;
    int indexOfLastUsedFrame = 0;
    int totalFrames = 0;
    int repetionCount = 0;
    int maxRepetionCount = 0;
    std::vector<SkCodec::FrameInfo> framesInfo;
    std::chrono::time_point<std::chrono::high_resolution_clock> start;
    bool shouldRender = true;
    std::function<void(std::string)> gifStopped;
};
};
};

#endif
