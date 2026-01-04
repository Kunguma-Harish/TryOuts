#ifndef NWTOSHELPER_HPP
#define NWTOSHELPER_HPP

#include <string>
#include <functional>

class NWTOSHelper {
public:
    static void readClipBoardString(void* usrptr, void (*func)(void*, const char*));
    static void writeClipBoardString(const std::string& str);
    static void openFilePanel(std::function<void(std::string)> func);
};

#endif