#ifndef __NL_CHARDATA_H
#define __NL_CHARDATA_H
#include <string>

class CharData {
public:
    int paraNum = -1;
    int portionNum = -1;
    int chNum = -1;

    std::string toString();
};

#endif