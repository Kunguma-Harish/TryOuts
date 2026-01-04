//
//  CxxSkiaRenderer.hpp
//  LanguageMixing
//
//  Created by kunguma-14252 on 01/04/25.
//

#ifndef CxxSkiaRenderer_hpp
#define CxxSkiaRenderer_hpp

#include <stdio.h>
//#include <conio.h>

class CxxSkiaRenderer {
    int a, b;

public:
    CxxSkiaRenderer(int valA, int valB) {
        a = valA;
        b = valB;
    }

    void printVal() {
        printf("a - %d : b - %d\n", a, b);
    }

    int sum() {
        return a + b;
    }

    int diff() {
        return a - b;
    }
};

#endif /* CxxSkiaRenderer_hpp */
