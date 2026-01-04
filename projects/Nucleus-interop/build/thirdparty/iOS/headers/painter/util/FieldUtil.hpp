#pragma once

/** @file 
  * Helper macros which contains boilerplate code for
  * generating setters and getters
  */

/* 
 * Creates variable with distinct names
 */
#define SP_GEN_FIELD(T, VAR_NAME, DEFAULT_VALUE) \
    T VAR_NAME = DEFAULT_VALUE

/** 
 * Generates setters and getters during preprocesing stage
 * @param T Type of the variable
 * @param VAR_NAME variable name
 * @todo inject doxygen documentation for generating docs
 *       for getters and setters
 */
#define SP_GEN_SG(T, VAR_NAME)           \
    void set_##VAR_NAME(T _##VAR_NAME) { \
        VAR_NAME = _##VAR_NAME;          \
    }                                    \
    T get_##VAR_NAME() {                 \
        return VAR_NAME;                 \
    }
