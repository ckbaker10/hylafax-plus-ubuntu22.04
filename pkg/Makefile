# $Id: Makefile.in 2 2005-11-11 21:32:03Z faxguy $
#
# Warning, this file was automatically created by the HylaFAX configure script
#
# HylaFAX Facsimile Software
#

# VERSION:	7.0.6
# DATE:		Fri Jun 24 19:36:27 UTC 2022
# TARGET:	x86_64-unknown-linux-gnu
# CCOMPILER:	/usr/bin/gcc
# CXXCOMPILER:	/usr/bin/g++
#
DEPTH=..

SRCDIR	= ${DEPTH}/${TOPSRCDIR}/pkg
VPATH	= .././pkg
#
SHELL	= /usr/bin/bash
NULL	=
ECHO	= echo

all default:
	if [ ! -f copyright ]; then \
		cp $(VPATH)/../COPYRIGHT copyright ; \
	fi ; \
	for i in README depend make.links preremove proto.local ; do	\
		[ -f $$i ]  ||  cp $(VPATH)/$$i . ;			\
	done 

BINARIES=\
	../etc/lockname			\
	../etc/ondelay			\
	../faxalter/faxalter		\
	../faxcover/faxcover		\
	../faxd/choptest		\
	../faxd/cqtest			\
	../faxd/faxgetty		\
	../faxd/faxq			\
	../faxd/faxqclean		\
	../faxd/faxsend			\
	../faxd/mkhash			\
	../faxd/pagesend		\
	../faxd/tagtest			\
	../faxd/tsitest			\
	../faxmail/faxmail		\
	../faxrm/faxrm			\
	../faxstat/faxstat		\
	../hfaxd/hfaxd			\
	../sendfax/sendfax		\
	../sendpage/sendpage		\
	../util/dialtest		\
	../util/faxadduser		\
	../util/faxconfig		\
	../util/faxdeluser		\
	../util/faxinfo			\
	../util/faxmodem		\
	../util/faxmsg			\
	../util/faxstate		\
	../util/faxwatch		\
	../util/textfmt			\
	../util/tiffcheck		\
	../util/typetest		\
	${NULL}

package: cproto sproto all
	[ -d HylaFAX ]  &&  /usr/bin/rm -fr HylaFAX ;	\
	${ECHO} stripping the binaries ;		\
	for i in ${BINARIES} ; do			\
		strip ${SRCDIR}/$$i ;			\
	done ;						\
	if [ "@HTML@" = yes ]; then			\
		strip ${SRCDIR}/../html/tools/man2html;	\
		strip ${SRCDIR}/../html/tools/unquote;	\
	fi;						\
	/usr/bin/rm -f pkginfo 2>/dev/null;			\
	/usr/bin/rm -f request 2>/dev/null;			\
	cp cpkginfo pkginfo ;				\
	cp crequest request ;				\
	pkgmk -d `pwd` -f cproto ;			\
	pkgtrans -s `pwd` `pwd`/HylaFAX-client-7.0.6-x86_64.pkg HylaFAX ; \
	/usr/bin/rm -fr HylaFAX ;				\
	/usr/bin/rm -f pkginfo 2>/dev/null;			\
	/usr/bin/rm -f request 2>/dev/null;			\
	cp spkginfo pkginfo ;				\
	cp srequest request ;				\
	pkgmk -d `pwd` -f sproto ;			\
	pkgtrans -s `pwd` `pwd`/HylaFAX-7.0.6-x86_64.pkg HylaFAX

cproto: cproto.stub
	${SHELL} ./make_proto.sh client

sproto: sproto.stub
	${SHELL} ./make_proto.sh server

clean:
	/usr/bin/rm -f cproto sproto
	/usr/bin/rm -fr HylaFAX
	/usr/bin/rm -f HylaFAX-client-7.0.6-x86_64.pkg
	/usr/bin/rm -f HylaFAX-7.0.6-x86_64.pkg
	/usr/bin/rm -f pkginfo
	/usr/bin/rm -f request
	/usr/bin/rm -f core*

clobber distclean: clean
	/usr/bin/rm -f copyright
	/usr/bin/rm -f cpkginfo
	/usr/bin/rm -f cproto.stub
	/usr/bin/rm -f crequest
	/usr/bin/rm -f make_proto.sh
	/usr/bin/rm -f postinstall
	/usr/bin/rm -f postremove
	/usr/bin/rm -f spkginfo
	/usr/bin/rm -f sproto.stub
	/usr/bin/rm -f srequest
	/usr/bin/rm -f Makefile

