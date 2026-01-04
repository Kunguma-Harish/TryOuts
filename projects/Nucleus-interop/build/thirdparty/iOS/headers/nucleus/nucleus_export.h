
#ifndef NUCLEUS_EXPORT_H
#define NUCLEUS_EXPORT_H

#ifdef NUCLEUS_STATIC_DEFINE
#  define NUCLEUS_EXPORT
#  define NUCLEUS_NO_EXPORT
#else
#  ifndef NUCLEUS_EXPORT
#    ifdef nucleus_EXPORTS
        /* We are building this library */
#      define NUCLEUS_EXPORT 
#    else
        /* We are using this library */
#      define NUCLEUS_EXPORT 
#    endif
#  endif

#  ifndef NUCLEUS_NO_EXPORT
#    define NUCLEUS_NO_EXPORT 
#  endif
#endif

#ifndef NUCLEUS_DEPRECATED
#  define NUCLEUS_DEPRECATED __attribute__ ((__deprecated__))
#endif

#ifndef NUCLEUS_DEPRECATED_EXPORT
#  define NUCLEUS_DEPRECATED_EXPORT NUCLEUS_EXPORT NUCLEUS_DEPRECATED
#endif

#ifndef NUCLEUS_DEPRECATED_NO_EXPORT
#  define NUCLEUS_DEPRECATED_NO_EXPORT NUCLEUS_NO_EXPORT NUCLEUS_DEPRECATED
#endif

/* NOLINTNEXTLINE(readability-avoid-unconditional-preprocessor-if) */
#if 0 /* DEFINE_NO_DEPRECATED */
#  ifndef NUCLEUS_NO_DEPRECATED
#    define NUCLEUS_NO_DEPRECATED
#  endif
#endif

#endif /* NUCLEUS_EXPORT_H */
