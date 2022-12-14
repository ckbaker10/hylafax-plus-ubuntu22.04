#!smake
#	$Id: Makefile.in 1125 2012-12-04 04:37:14Z faxguy $
#
# Warning, this file was automatically created by the HylaFAX configure script
#
# HylaFAX Facsimile Software
#
# Copyright (c) 1988-1996 Sam Leffler
# Copyright (c) 1991-1996 Silicon Graphics, Inc.
# HylaFAX is a trademark of Silicon Graphics
# 
# Permission to use, copy, modify, distribute, and sell this software and 
# its documentation for any purpose is hereby granted without fee, provided
# that (i) the above copyright notices and this permission notice appear in
# all copies of the software and related documentation, and (ii) the names of
# Sam Leffler and Silicon Graphics may not be used in any advertising or
# publicity relating to the software without the specific, prior written
# permission of Sam Leffler and Silicon Graphics.
# 
# THE SOFTWARE IS PROVIDED "AS-IS" AND WITHOUT WARRANTY OF ANY KIND, 
# EXPRESS, IMPLIED OR OTHERWISE, INCLUDING WITHOUT LIMITATION, ANY 
# WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.  
# 
# IN NO EVENT SHALL SAM LEFFLER OR SILICON GRAPHICS BE LIABLE FOR
# ANY SPECIAL, INCIDENTAL, INDIRECT OR CONSEQUENTIAL DAMAGES OF ANY KIND,
# OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
# WHETHER OR NOT ADVISED OF THE POSSIBILITY OF DAMAGE, AND ON ANY THEORY OF 
# LIABILITY, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE 
# OF THIS SOFTWARE.
#

#
# VERSION:	7.0.6
# DATE:		Fri Jun 24 19:36:27 UTC 2022
# TARGET:	x86_64-unknown-linux-gnu
# CCOMPILER:	/usr/bin/gcc
# CXXCOMPILER:	/usr/bin/g++
#
DEPTH=..
include ${DEPTH}/defs

SRCDIR	= ${DEPTH}/${TOPSRCDIR}/man

#
# Manual page targets that are installed.
#
# These may be formatted or unformatted versions of the sources
# above.  The transformation is controlled by definitions in the
# system-specific defs files.
#
MANCAPP=cman.apps/hylafax-client.1	\
	cman.apps/edit-faxcover.1	\
	cman.apps/faxalter.1	\
	cman.apps/faxcover.1	\
	cman.apps/faxmail.1	\
	cman.apps/faxrm.1	\
	cman.apps/faxstat.1	\
	cman.apps/sendfax.1	\
	cman.apps/sendpage.1	\
	cman.apps/sgi2fax.1	\
	cman.apps/textfmt.1
MANCFILE=cman.files/pagesizes.4f\
	cman.files/typerules.4f
MANSAPP=sman.apps/cqtest.1m	\
	sman.apps/choptest.1m	\
	sman.apps/dialtest.1m	\
	sman.apps/faxabort.1m	\
	sman.apps/faxaddmodem.1m\
	sman.apps/faxadduser.1m	\
	sman.apps/faxanswer.1m	\
	sman.apps/faxconfig.1m	\
	sman.apps/faxdeluser.1m	\
	sman.apps/faxmodem.1m	\
	sman.apps/faxstate.1m	\
	sman.apps/faxcron.1m	\
	sman.apps/faxfetch.1m	\
	sman.apps/faxmsg.1m	\
	sman.apps/faxgetty.1m	\
	sman.apps/faxinfo.1m	\
	sman.apps/faxq.1m	\
	sman.apps/faxqclean.1m	\
	sman.apps/faxquit.1m	\
	sman.apps/faxlock.1m	\
	sman.apps/faxrcvd.1m	\
	sman.apps/faxsend.1m	\
	sman.apps/faxsetup.1m	\
	sman.apps/faxsetup.linux.1m	\
	sman.apps/faxstate.1m	\
	sman.apps/faxwatch.1m	\
	sman.apps/hfaxd.1m	\
	sman.apps/hylafax.1m	\
	sman.apps/jobcontrol.1m	\
	sman.apps/lockname.1m	\
	sman.apps/mkcover.1m	\
	sman.apps/notify.1m	\
	sman.apps/ondelay.1m	\
	sman.apps/pagesend.1m	\
	sman.apps/pollrcvd.1m	\
	sman.apps/probemodem.1m	\
	sman.apps/ps2fax.1m	\
	sman.apps/pdf2fax.1m	\
	sman.apps/recvstats.1m	\
	sman.apps/tagtest.1m	\
	sman.apps/tiff2fax.1m	\
	sman.apps/tiffcheck.1m	\
	sman.apps/tsitest.1m	\
	sman.apps/typetest.1m	\
	sman.apps/wedged.1m	\
	sman.apps/xferfaxstats.1m
MANSFILE=sman.files/hylafax-server.4f	\
	sman.files/hylafax-config.4f	\
	sman.files/dialrules.4f	\
	sman.files/doneq.4f	\
	sman.files/hosts.hfaxd.4f	\
	sman.files/hylafax-info.4f	\
	sman.files/hylafax-log.4f	\
	sman.files/pagermap.4f	\
	sman.files/recvq.4f	\
	sman.files/sendq.4f	\
	sman.files/hylafax-shutdown.4f	\
	sman.files/status.4f	\
	sman.files/tsi.4f	\
	sman.files/xferfaxlog.4f
TARGETS=cman.apps/Makefile cman.files/Makefile \
	sman.apps/Makefile sman.files/Makefile

#
# System-specific manual page formatting commands should
# apply this sed command to the manual page source before
# handing it to the formatter.  This sets any pathnames
# in the man pages to reflect local conventions.
#
MANSED=${SED}\
	-e 's;\$${SPOOL};${SPOOL};g' \
	-e 's;\$${BIN};${BIN};g' \
	-e 's;\$${SBIN};${SBIN};g' \
	-e 's;\$${TIFFBIN};${TIFFBIN};g' \
	-e 's;\$${LIBDATA};${LIBDATA};g' \
	-e 's;\$${LIBEXEC};${LIBEXEC};g' \
	-e 's;\$${FONTPATH};${FONTPATH};g' \
	-e 's;\$${SENDMAIL};${SENDMAIL};g' \
	-e 's;\$${MANNUM4_5};${MANNUM4_5};g' \
	-e 's;\$${MANNUM1_8};${MANNUM1_8};g'

default all targets:: ${TARGETS}

include ${COMMONRULES}

cman.apps: ${_FORCE}; test -d $@ || ${MKDIR} $@
cman.files: ${_FORCE}; test -d $@ || ${MKDIR} $@
sman.apps: ${_FORCE}; test -d $@ || ${MKDIR} $@
sman.files: ${_FORCE}; test -d $@ || ${MKDIR} $@

cman.apps/hylafax-client.1::	${SRCDIR}/hylafax-client.1;	${MANCVT}
cman.apps/edit-faxcover.1::	${SRCDIR}/edit-faxcover.1;	${MANCVT}
cman.apps/faxalter.1::	${SRCDIR}/faxalter.1;	${MANCVT}
cman.apps/faxcover.1::	${SRCDIR}/faxcover.1;	${MANCVT}
cman.apps/faxmail.1::	${SRCDIR}/faxmail.1;	${MANCVT}
cman.apps/faxrm.1::	${SRCDIR}/faxrm.1;	${MANCVT}
cman.apps/faxstat.1::	${SRCDIR}/faxstat.1;	${MANCVT}
cman.apps/sendfax.1::	${SRCDIR}/sendfax.1;	${MANCVT}
cman.apps/sendpage.1::	${SRCDIR}/sendpage.1;	${MANCVT}
cman.apps/sgi2fax.1::	${SRCDIR}/sgi2fax.1;	${MANCVT}
cman.apps/textfmt.1::	${SRCDIR}/textfmt.1;	${MANCVT}
cman.files/pagesizes.4f:: ${SRCDIR}/pagesizes.4f; ${MANCVT}
cman.files/typerules.4f:: ${SRCDIR}/typerules.4f; ${MANCVT}
sman.apps/cqtest.1m::	${SRCDIR}/cqtest.1m;	${MANCVT}
sman.apps/choptest.1m::	${SRCDIR}/choptest.1m;	${MANCVT}
sman.apps/dialtest.1m::	${SRCDIR}/dialtest.1m;	${MANCVT}
sman.apps/faxabort.1m::	${SRCDIR}/faxabort.1m;	${MANCVT}
sman.apps/faxaddmodem.1m:: ${SRCDIR}/faxaddmodem.1m; ${MANCVT}
sman.apps/faxadduser.1m::${SRCDIR}/faxadduser.1m;	${MANCVT}
sman.apps/faxanswer.1m::${SRCDIR}/faxanswer.1m;	${MANCVT}
sman.apps/faxconfig.1m::${SRCDIR}/faxconfig.1m;	${MANCVT}
sman.apps/faxcron.1m::	${SRCDIR}/faxcron.1m;	${MANCVT}
sman.apps/faxdeluser.1m::${SRCDIR}/faxdeluser.1m;	${MANCVT}
sman.apps/hfaxd.1m:: ${SRCDIR}/hfaxd.1m;	${MANCVT}
sman.apps/faxfetch.1m::	${SRCDIR}/faxfetch.1m;	${MANCVT}
sman.apps/faxgetty.1m::	${SRCDIR}/faxgetty.1m;	${MANCVT}
sman.apps/faxinfo.1m::	${SRCDIR}/faxinfo.1m;	${MANCVT}
sman.apps/faxmodem.1m::	${SRCDIR}/faxmodem.1m;	${MANCVT}
sman.apps/faxmsg.1m::	${SRCDIR}/faxmsg.1m;	${MANCVT}
sman.apps/faxq.1m::	${SRCDIR}/faxq.1m;	${MANCVT}
sman.apps/faxqclean.1m::${SRCDIR}/faxqclean.1m;	${MANCVT}
sman.apps/faxquit.1m::	${SRCDIR}/faxquit.1m;	${MANCVT}
sman.apps/faxlock.1m::	${SRCDIR}/faxlock.1m;	${MANCVT}
sman.apps/faxrcvd.1m::	${SRCDIR}/faxrcvd.1m;	${MANCVT}
sman.apps/faxsend.1m::	${SRCDIR}/faxsend.1m;	${MANCVT}
sman.apps/faxsetup.1m::	${SRCDIR}/faxsetup.1m;	${MANCVT}
sman.apps/faxsetup.linux.1m::	${SRCDIR}/faxsetup.linux.1m;	${MANCVT}
sman.apps/faxstate.1m::${SRCDIR}/faxstate.1m;	${MANCVT}
sman.apps/faxwatch.1m::${SRCDIR}/faxwatch.1m;	${MANCVT}
sman.apps/hylafax.1m::	${SRCDIR}/hylafax.1m;	${MANCVT}
sman.apps/jobcontrol.1m::	${SRCDIR}/jobcontrol.1m;	${MANCVT}
sman.apps/lockname.1m::	${SRCDIR}/lockname.1m;	${MANCVT}
sman.apps/mkcover.1m::	${SRCDIR}/mkcover.1m;	${MANCVT}
sman.apps/ondelay.1m::	${SRCDIR}/ondelay.1m;	${MANCVT}
sman.apps/notify.1m::	${SRCDIR}/notify.1m;	${MANCVT}
sman.apps/pagesend.1m::	${SRCDIR}/pagesend.1m;	${MANCVT}
sman.apps/pollrcvd.1m::	${SRCDIR}/pollrcvd.1m;	${MANCVT}
sman.apps/probemodem.1m::	${SRCDIR}/probemodem.1m;	${MANCVT}
sman.apps/ps2fax.1m::	${SRCDIR}/ps2fax.1m;	${MANCVT}
sman.apps/pdf2fax.1m::	${SRCDIR}/pdf2fax.1m;	${MANCVT}
sman.apps/recvstats.1m:: ${SRCDIR}/recvstats.1m; ${MANCVT}
sman.apps/tagtest.1m::	${SRCDIR}/tagtest.1m;	${MANCVT}
sman.apps/tiff2fax.1m::	${SRCDIR}/tiff2fax.1m;	${MANCVT}
sman.apps/tiffcheck.1m::${SRCDIR}/tiffcheck.1m;	${MANCVT}
sman.apps/tsitest.1m::	${SRCDIR}/tsitest.1m;	${MANCVT}
sman.apps/typetest.1m::	${SRCDIR}/typetest.1m;	${MANCVT}
sman.apps/wedged.1m::	${SRCDIR}/wedged.1m;	${MANCVT}
sman.apps/xferfaxstats.1m:: ${SRCDIR}/xferfaxstats.1m; ${MANCVT}
sman.files/hylafax-server.4f::	${SRCDIR}/hylafax-server.4f;	${MANCVT}
sman.files/hylafax-config.4f::	${SRCDIR}/hylafax-config.4f;	${MANCVT}
sman.files/doneq.4f::	${SRCDIR}/doneq.4f;	${MANCVT}
sman.files/dialrules.4f:: ${SRCDIR}/dialrules.4f; ${MANCVT}
sman.files/hosts.hfaxd.4f::	${SRCDIR}/hosts.hfaxd.4f;	${MANCVT}
sman.files/hylafax-info.4f::	${SRCDIR}/hylafax-info.4f;	${MANCVT}
sman.files/hylafax-log.4f::	${SRCDIR}/hylafax-log.4f;	${MANCVT}
sman.files/pagermap.4f::${SRCDIR}/pagermap.4f;	${MANCVT}
sman.files/recvq.4f::	${SRCDIR}/recvq.4f;	${MANCVT}
sman.files/sendq.4f::	${SRCDIR}/sendq.4f;	${MANCVT}
sman.files/hylafax-shutdown.4f::${SRCDIR}/hylafax-shutdown.4f;	${MANCVT}
sman.files/status.4f::	${SRCDIR}/status.4f;	${MANCVT}
sman.files/tsi.4f::	${SRCDIR}/tsi.4f;	${MANCVT}
sman.files/xferfaxlog.4f::	${SRCDIR}/xferfaxlog.4f;	${MANCVT}

LDIRT=	cman.apps cman.files sman.apps sman.files

cman.apps/Makefile: ${DEPTH}/defs cman.apps ${MANCAPP}
	${RM} -f cman.apps/Makefile
	(${ECHO} '#!smake';						\
	 ${ECHO} 'DEPTH=../..';						\
	 ${ECHO} 'include $${DEPTH}/defs';\
	 ${ECHO} 'install:';						\
	 (cd cman.apps; for i in *.1; do				\
	    f=${MANCAPPNAME};						\
	    ${ECHO} '	$${INSTALL} -m 444 -root $${INSTALLROOT} -F $${MAN}/$${MANAPPS}	\
		-idb $${PRODUCT}.man.client -src' "$$i" '-O' "$$f";	\
	 done);								\
	${ECHO};							\
	${ECHO} 'uninstall:';						\
	 (cd cman.apps; for i in *.1; do				\
	    f=${MANCAPPNAME};						\
	    ${ECHO} '	$${RM} -f $${MAN}/$${MANAPPS}/'"$$f";		\
	 done)								\
	)>cman.apps/Makefile
cman.files/Makefile: ${DEPTH}/defs cman.files ${MANCFILE}
	${RM} -f cman.files/Makefile
	(${ECHO} '#!smake';						\
	 ${ECHO} 'DEPTH=../..';						\
	 ${ECHO} 'include $${DEPTH}/defs';\
	 ${ECHO} 'install:';						\
	 (cd cman.files; for i in *.4f; do				\
	    f=${MANCFILENAME};						\
	    ${ECHO} '	$${INSTALL} -m 444 -root $${INSTALLROOT} -F $${MAN}/$${MANFILES}	\
		-idb $${PRODUCT}.man.client -src' "$$i" '-O' "$$f";	\
	 done);								\
	 ${ECHO};							\
	 ${ECHO} 'uninstall:';						\
	 (cd cman.files; for i in *.4f; do				\
	    f=${MANCFILENAME};						\
	    ${ECHO} '	$${RM} -f $${MAN}/$${MANFILES}/'"$$f";		\
	 done)								\
	)>cman.files/Makefile
sman.apps/Makefile: ${DEPTH}/defs sman.apps ${MANSAPP}
	${RM} -f smap.apps/Makefile
	(${ECHO} '#!smake';						\
	 ${ECHO} 'DEPTH=../..';						\
	 ${ECHO} 'include $${DEPTH}/defs';\
	 ${ECHO} 'install:';						\
	 (cd sman.apps; for i in *.1m; do				\
	    f=${MANSAPPNAME};						\
	    ${ECHO} '	$${INSTALL} -m 444 -root $${INSTALLROOT} -F $${MAN}/$${MANSYS}	\
		-idb $${PRODUCT}.man.server -src' "$$i" '-O' "$$f";	\
	 done);								\
	 ${ECHO};							\
	 ${ECHO} 'uninstall:';						\
	 (cd sman.apps; for i in *.1m; do				\
	    f=${MANSAPPNAME};						\
	    ${ECHO} '	$${RM} -f $${MAN}/$${MANSYS}/'"$$f";		\
	 done)								\
	)>sman.apps/Makefile
sman.files/Makefile: ${DEPTH}/defs sman.files ${MANSFILE}
	${RM} -f sman.files/Makefile
	(${ECHO} '#!smake';						\
	 ${ECHO} 'DEPTH=../..';						\
	 ${ECHO} 'include $${DEPTH}/defs';\
	 ${ECHO} 'install:';						\
	 (cd sman.files; for i in *.4f; do				\
	    f=${MANSFILENAME};						\
	    ${ECHO} '	$${INSTALL} -m 444 -root $${INSTALLROOT} -F $${MAN}/$${MANFILES}	\
		-idb $${PRODUCT}.man.server -src' "$$i" '-O' "$$f";	\
	 done);								\
	 ${ECHO};							\
	 ${ECHO} 'uninstall:';						\
	 (cd sman.files; for i in *.4f; do				\
	    f=${MANSFILENAME};						\
	    ${ECHO} '	$${RM} -f $${MAN}/$${MANFILES}/'"$$f";		\
	 done)								\
	)>sman.files/Makefile

installClientManPages:: cman.apps/Makefile cman.files/Makefile
	-${INSTALL} -m ${DIRMODE} -root ${INSTALLROOT} -dir -idb hylafax.man.client \
	    ${MAN} ${MAN}/${MANAPPS} ${MAN}/${MANFILES}
	cd cman.apps; ${MAKE} install
	cd cman.files; ${MAKE} install

uninstallClientManPages:: cman.apps/Makefile cman.files/Makefile
	cd cman.apps; ${MAKE} uninstall
	cd cman.files; ${MAKE} uninstall

installServerManPages:: sman.apps/Makefile sman.files/Makefile
	-${INSTALL} -m ${DIRMODE} -root ${INSTALLROOT} -dir -idb hylafax.man.server \
	    ${MAN} ${MAN}/${MANSYS} ${MAN}/${MANFILES}
	cd sman.apps; ${MAKE} install
	cd sman.files; ${MAKE} install

uninstallServerManPages:: sman.apps/Makefile sman.files/Makefile
	cd sman.apps; ${MAKE} uninstall
	cd sman.files; ${MAKE} uninstall

installClient: targets installClientManPages
install: installClient installServerManPages
uninstall: uninstallClientManPages uninstallServerManPages
