
#ifndef VANI_EXPORT_H
#define VANI_EXPORT_H

#ifdef VANI_STATIC_DEFINE
#  define VANI_EXPORT
#  define VANI_NO_EXPORT
#else
#  ifndef VANI_EXPORT
#    ifdef vani_EXPORTS
        /* We are building this library */
#      define VANI_EXPORT 
#    else
        /* We are using this library */
#      define VANI_EXPORT 
#    endif
#  endif

#  ifndef VANI_NO_EXPORT
#    define VANI_NO_EXPORT 
#  endif
#endif

#ifndef VANI_DEPRECATED
#  define VANI_DEPRECATED __attribute__ ((__deprecated__))
#endif

#ifndef VANI_DEPRECATED_EXPORT
#  define VANI_DEPRECATED_EXPORT VANI_EXPORT VANI_DEPRECATED
#endif

#ifndef VANI_DEPRECATED_NO_EXPORT
#  define VANI_DEPRECATED_NO_EXPORT VANI_NO_EXPORT VANI_DEPRECATED
#endif

/* NOLINTNEXTLINE(readability-avoid-unconditional-preprocessor-if) */
#if 0 /* DEFINE_NO_DEPRECATED */
#  ifndef VANI_NO_DEPRECATED
#    define VANI_NO_DEPRECATED
#  endif
#endif

#endif /* VANI_EXPORT_H */
