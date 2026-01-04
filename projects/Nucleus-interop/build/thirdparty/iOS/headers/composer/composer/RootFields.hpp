#ifndef _ROOTFIELD_H
#define _ROOTFIELD_H

#include <string>
#include <unordered_map>

class RootField {
public:
    static const std::unordered_map<std::string, char> fieldsMap;

    static char findNumber(std::string fieldName);
    static bool isRootField(std::string fieldName);
};

#endif
