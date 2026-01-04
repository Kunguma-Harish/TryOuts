#pragma once

#include <skia-extension/GLPoint.hpp>
#include <src/core/SkMatrixPriv.h>

namespace graphikos {
namespace painter {
struct Matrices {
    SkMatrix scaleAndTranslateMatrix;
    SkMatrix rotationAndFlipMatrix;
    SkMatrix postMatrix;
    SkMatrix postScaleAndTranslateMatrix;
    SkMatrix postRotationAndFlipMatrix;
    SkMatrix flipMatrix;
    bool editMatrix = false;

    Matrices() {
        scaleAndTranslateMatrix.setIdentity();
        rotationAndFlipMatrix.setIdentity();
        postMatrix.setIdentity();
        postScaleAndTranslateMatrix.setIdentity();
        postRotationAndFlipMatrix.setIdentity();
        flipMatrix.setIdentity();
    }
    Matrices(const SkMatrix& scaleAndTranslate, const SkMatrix& rotationAndFlip, const SkMatrix& postMatrix = SkMatrix()) {
        this->scaleAndTranslateMatrix = scaleAndTranslate;
        this->rotationAndFlipMatrix = rotationAndFlip;
        this->postMatrix = postMatrix;
    }
    SkMatrix getResultantMatrix() const {
        SkMatrix matrix = SkMatrix::Concat(this->rotationAndFlipMatrix, this->scaleAndTranslateMatrix);
        matrix.postConcat(this->postMatrix);
        return matrix;
    }
    Matrices Concat(const Matrices& matrices) {
        SkMatrix scaleTrans = SkMatrix::Concat(this->scaleAndTranslateMatrix, matrices.scaleAndTranslateMatrix);
        SkMatrix rotationFlip = SkMatrix::Concat(this->rotationAndFlipMatrix, matrices.rotationAndFlipMatrix);
        return Matrices(scaleTrans, rotationFlip);
    }
    GLPoint getScale() const {
        SkMatrix matrix;
        matrix.setScale(this->scaleAndTranslateMatrix.getScaleX(), this->scaleAndTranslateMatrix.getScaleY());
        matrix.postScale(this->postMatrix.getScaleX(), this->postMatrix.getScaleY());
        return GLPoint(matrix.getScaleX(), matrix.getScaleY());
    }
    bool isIdentity() const {
        return this->scaleAndTranslateMatrix.isIdentity() && this->rotationAndFlipMatrix.isIdentity() && this->postMatrix.isIdentity();
    }
    void setIdentity() {
        this->scaleAndTranslateMatrix.setIdentity();
        this->rotationAndFlipMatrix.setIdentity();
        this->postMatrix.setIdentity();
        this->postScaleAndTranslateMatrix.setIdentity();
        this->postRotationAndFlipMatrix.setIdentity();
        this->flipMatrix.setIdentity();
    }
    void* writeToMemory(size_t* size) const {
        *size = 2 * SkMatrixPriv::kMaxFlattenSize;
        void* buffer = malloc(2 * SkMatrixPriv::kMaxFlattenSize);
        auto it = ((char*)buffer) + SkMatrixPriv::kMaxFlattenSize;
        SkMatrixPriv::WriteToMemory(this->scaleAndTranslateMatrix, buffer);
        SkMatrixPriv::WriteToMemory(this->rotationAndFlipMatrix, it);
        return buffer;
    }
    size_t readFromMemory(void* buffer, size_t size) {
        auto it = ((char*)buffer) + size / 2;
        SkMatrixPriv::ReadFromMemory(&this->scaleAndTranslateMatrix, buffer, size / 2);
        SkMatrixPriv::ReadFromMemory(&this->rotationAndFlipMatrix, it, size / 2);
        return 2 * SkMatrixPriv::kMaxFlattenSize;
    }
};
}
}