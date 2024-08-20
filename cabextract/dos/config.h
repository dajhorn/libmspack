/* libmspack/cabextract build configuration for DOS */
#ifndef __DOS__
# error Not building for a DOS target.
#endif

/* mspack/readbits.h */
#define HAVE_LIMITS_H 1

/* mspack/system.h */
#define HAVE_STRING_H 1
#define HAVE_STRINGS_H 1
#define HAVE_MEMCMP 1

/* src/cabinfo.c */
#define HAVE_STDLIB_H 1
#define HAVE_SYS_TYPES_H 1

/* src/cabextract.c */
#define HAVE_CTYPE_H 1
#define HAVE_DIRECT_H 1
#define HAVE_ERRNO_H 1
#define HAVE_FNMATCH_H 1
#define HAVE_IO_H 1
#define HAVE_STDARG_H 1
#define HAVE_SYS_STAT_H 1
#define HAVE_UTIME_H 1
#define HAVE_MKDIR 1
#define HAVE_MKTIME 1
#define HAVE_UTIME 1
#define MKDIR_TAKES_ONE_ARG 1

#define STDC_HEADERS 1
#define __WATCOM_LFN__

#include "version.h"
#include <fcntl.h>
