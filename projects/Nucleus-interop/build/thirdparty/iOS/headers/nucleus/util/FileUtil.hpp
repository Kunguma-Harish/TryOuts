#ifndef __NL_FILEUTIL_H
#define __NL_FILEUTIL_H
#include <vector>
#include <iostream>
class FileUtil {
public:
    static std::vector<uint8_t> ReadFromFile(const std::string& filePath);
};

#endif
