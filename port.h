/*
 * Warning, this file was automatically created by the HylaFAX configure script
 * VERSION:	 7.0.6
 * DATE:	 Fri Jun 24 19:36:27 UTC 2022
 * TARGET:	 x86_64-unknown-linux-gnu
 * RELEASE:	 5.15.0-48-generic
 * CCOMPILER:	 /usr/bin/gcc-11.2.0
 * CXXCOMPILER:	 /usr/bin/g++-11.2.0
 */
#ifndef _PORT_
#define _PORT_ 1
#ifdef __cplusplus
extern "C" {
#endif
#define CONFIG_TIOCMBISBYREF yes
#define CONFIG_MAXGID 60002
#include <sys/types.h>
#define HAVE_STDINT_H 1
#define HAS_SELECT_H 1
#define fxSIGACTIONHANDLER (sig_t)
#define fxSIGHANDLER (sig_t)
#define HAS_MMAP 1
#define HAS_SYSCONF 1
#define HAS_ULIMIT 1
#define HAS_GETDTABLESIZE 1
#ifndef howmany
#define howmany(x, y)	(((x)+((y)-1))/(y))
#endif
struct sigvec;
extern int sigvec(int, const struct sigvec*, struct sigvec*);
#define HAS_FCHOWN 1
#define HAS_FCHMOD 1
#define HAS_TM_ZONE 1
#define HAS_LOCALE 1
#define HAS_LANGINFO 1
#include <paths.h>
#define HAS_LOGWTMP 1
#define HAS_LOGOUT 1
#define HAS_UTEXIT 1
#define HAS_POSIXSCHED 1
#define RT_PRIORITY 1
#define HAS_CRYPT_H 1
#define TIFFSTRIPBYTECOUNTS uint64_t
#define TIFFVERSION TIFF_VERSION_CLASSIC
#define TIFFHEADER TIFFHeaderClassic
#define tiff_runlen_t uint32_t
#define tiff_offset_t uint64_t
extern const char* HYLAFAX_VERSION_STRING;
#ifdef __cplusplus
}
#endif
#endif
