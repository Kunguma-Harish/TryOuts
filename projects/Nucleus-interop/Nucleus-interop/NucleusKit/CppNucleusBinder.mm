//
//  CppNucleusBinder.mm
//  Nucleus-interop
//
//  Created by kunguma-14252 on 15/04/25.
//

#include "CppNucleusBinder.hpp"

CppNucleusBinder::CppNucleusBinder(int value) {
    this->value = value;
}

int CppNucleusBinder::getValue() {
    return this->value;
}
