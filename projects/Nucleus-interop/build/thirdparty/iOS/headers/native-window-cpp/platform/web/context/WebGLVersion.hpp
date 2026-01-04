#ifndef __NL_WEBGLVERSION_H
#define __NL_WEBGLVERSION_H
#include <string>

struct WebGLVersion {
    int openGLMajor = 3;
    int openGLMinor = 2;
    int openGLESMajor = 1;
    int openGLESMinor = 0;
    void init(std::string title);
};
#endif