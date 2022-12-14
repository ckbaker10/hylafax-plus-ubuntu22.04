#!smake
#	$Id: Makefile.in 959 2009-12-04 04:55:53Z faxguy $
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
# Warning, this file was automatically created by the HylaFAX configure script
#
# VERSION:	7.0.6
# DATE:		Fri Jun 24 19:36:27 UTC 2022
# TARGET:	x86_64-unknown-linux-gnu
# CCOMPILER:	/usr/bin/gcc
# CXXCOMPILER:	/usr/bin/g++
#
COMMONPREF=fax
DEPTH	= .

include defs

SRCDIR	= ${TOPSRCDIR}/${DEPTH}

DIRS=	util \
	faxalter \
	faxcover \
	faxd \
	faxmail \
	faxrm \
	faxstat \
	hfaxd \
	sendfax \
	sendpage \
	\
	config \
	etc \
	man

DSODIRS	= util faxd

TARGETS=hylafax

default all ${TARGETS}:
	@${MAKE} -f ${MAKEFILE} dirs

include rules

dirs::
	${ECHO} "= "port; cd port; ${MAKE}  ||  exit $?;
	@if [ "no" = yes ]; then \
	    ${ECHO} "= "regex; cd regex; ${MAKE}  ||  exit $?; \
	else \
	    true; \
	fi
	@for i in ${DIRS}; do \
	    (${ECHO} "= "$$i; cd $$i; ${MAKE})  ||  exit $?; \
	done
	@if [ "no" = yes ]; then \
	    ${ECHO} "= "sgi2fax; cd sgi2fax; ${MAKE}  ||  exit $?; \
	else \
	    true; \
	fi
	@if [ "no" = yes ]; then \
	    ${ECHO} "= "dps; cd dps; ${MAKE}  ||  exit $?; \
	else \
	    true; \
	fi
	@if [ "no" = yes ]; then \
	    ${ECHO} "= "imp; cd imp; ${MAKE}  ||  exit $?; \
	else \
	    true; \
	fi
	@if [ "no" = yes ]; then \
	    ${ECHO} "= "gs; cd gs; ${MAKE}  ||  exit $?; \
	else \
	    true; \
	fi
	@${ECHO} "= "pkg; cd pkg; ${MAKE}  ||  exit $?
depend::
	${ECHO} "= "port; cd port; ${MAKE} depend;
	@if [ "no" = yes ]; then \
	    ${ECHO} "= "regex; cd regex; ${MAKE} depend; \
	else \
	    true; \
	fi
	@for i in ${DIRS}; do \
	    (${ECHO} "= "$$i; cd $$i; ${MAKE} depend); \
	done
	@if [ "no" = yes ]; then \
	    ${ECHO} "= "sgi2fax; cd sgi2fax; ${MAKE} depend; \
	else \
	    true; \
	fi
clean::
	${ECHO} "= "port; cd port; ${MAKE} clean;
	@if [ "no" = yes ]; then \
	    ${ECHO} "= "regex; cd regex; ${MAKE} clean; \
	else \
	    true; \
	fi
	@for i in ${DIRS}; do \
	    (${ECHO} "= "$$i; cd $$i; ${MAKE} clean); \
	done
	@if [ "no" = yes ]; then \
	    ${ECHO} "= "sgi2fax; cd sgi2fax; ${MAKE} clean; \
	else \
	    true; \
	fi
	@if [ "LINUX" != no ]; then \
	    for i in ${DSODIRS}; do \
		(${ECHO} "= "$$i; cd $$i; ${MAKE} cleanDSO); \
	    done; \
	else \
	    true; \
	fi
	@if [ "no" = yes ]; then \
	    ${ECHO} "= "dps; cd dps; ${MAKE} clean; \
	else \
	    true; \
	fi
	@if [ "no" = yes ]; then \
	    ${ECHO} "= "imp; cd imp; ${MAKE} clean; \
	else \
	    true; \
	fi
	@if [ "no" = yes ]; then \
	    ${ECHO} "= "gs; cd gs; ${MAKE} clean; \
	else \
	    true; \
	fi
	@${ECHO} "= "pkg; cd pkg; ${MAKE} clean
clobber::
	(cd util; ${MAKE} clobberconfig)
	(cd etc; ${MAKE} clobberconfig)
	(cd faxcover; ${MAKE} clobberconfig)
	(cd faxmail; ${MAKE} clobberconfig)
	${ECHO} "= "port; cd port; ${MAKE} clobberconfig; ${MAKE} clobber;
	@if [ "no" = yes ]; then \
	    ${ECHO} "= "regex; cd regex; ${MAKE} clobber; \
	else \
	    true; \
	fi
	@if [ "LINUX" != no ]; then \
	    for i in ${DSODIRS}; do \
		(${ECHO} "= "$$i; cd $$i; ${MAKE} cleanDSO); \
	    done; \
	else \
	    true; \
	fi
	@for i in ${DIRS}; do \
	    (${ECHO} "= "$$i; cd $$i; ${MAKE} clobber); \
	done
	@if [ "no" = yes ]; then \
	    ${ECHO} "= "sgi2fax; cd sgi2fax; ${MAKE} clobber; \
	else \
	    true; \
	fi
	-${RM} -f Makedepend port.h config.h config.log config.cache
distclean: clobber
	@if [ "no" = yes ]; then \
	    ${ECHO} "= "dps; cd dps; ${MAKE} distclean; \
	else \
	    true; \
	fi
	@if [ "no" = yes ]; then \
	    ${ECHO} "= "imp; cd imp; ${MAKE} distclean; \
	else \
	    true; \
	fi
	@if [ "no" = yes ]; then \
	    ${ECHO} "= "gs; cd gs; ${MAKE} distclean; \
	else \
	    true; \
	fi
	(cd pkg; ${MAKE} distclean)
	-${RM} -f defs rules Makefile

makeClientDirs::
	-${INSTALL} -u ${SYSUSER} -g ${SYSGROUP} -m ${DIRMODE} \
	    -idb hylafax.sw.client -root ${INSTALLROOT} -dir \
	    ${BIN} ${LIBDATA} ${LIBEXEC} ${SBIN}
makeServerDirs::
	-${INSTALL} -u ${SYSUSER} -g ${SYSGROUP} -m ${DIRMODE} \
	    -idb hylafax.sw.server -root ${INSTALLROOT} -dir ${SBIN};
	-${INSTALL} -u ${FAXUSER} -g ${FAXGROUP} -m ${DIRMODE} \
	    -idb hylafax.sw.server -root ${INSTALLROOT} -dir ${SPOOL}
	-${INSTALL} -u ${FAXUSER} -g ${FAXGROUP} -m ${DIRMODE} \
	    -idb hylafax.sw.server -dir \
	    -root ${INSTALLROOT} -F ${SPOOL} bin client config dev etc info log recvq status
	-${INSTALL} -u ${FAXUSER} -g ${FAXGROUP} -m 700 \
	    -idb hylafax.sw.server -dir \
	    -root ${INSTALLROOT} -F ${SPOOL} sendq doneq docq tmp pollq archive
makeDirs: makeClientDirs makeServerDirs

rmDirs::
	-rmdir ${SPOOL}/bin ${SPOOL}/client ${SPOOL}/config ${SPOOL}/dev ${SPOOL}/etc ${SPOOL}/info ${SPOOL}/log ${SPOOL}/recvq ${SPOOL}/status
	-rmdir ${SPOOL}/sendq ${SPOOL}/doneq ${SPOOL}/docq ${SPOOL}/tmp ${SPOOL}/pollq ${SPOOL}/archive
	-rmdir ${SPOOL}

install: makeDirs
	${INSTALL} -m 444 -root ${INSTALLROOT} -F ${SPOOL} -idb hylafax.sw.server \
	    -src ${SRCDIR}/COPYRIGHT -O COPYRIGHT
	@if [ "no" = yes ]; then \
	    ${ECHO} "= "regex; cd regex; ${MAKE} install  ||  exit 1; \
	else \
	    true; \
	fi
	@for i in ${DIRS}; do \
	    (${ECHO} "= "$$i; cd $$i; ${MAKE} install)  ||  exit 1; \
	done
	@if [ "no" = yes ]; then \
	    ${ECHO} "= "sgi2fax; cd sgi2fax; ${MAKE} install  ||  exit 1; \
	else \
	    true; \
	fi
	@if [ "LINUX" != no ]; then \
	    for i in ${DSODIRS}; do \
		(${ECHO} "= "$$i; cd $$i; ${MAKE} installDSO)  ||  exit 1; \
	    done; \
	else \
	    true; \
	fi
	@${ECHO} "= "etc; cd etc; ${MAKE} installSysVInit;
	@if [ "no" = yes ]; then \
	    ${ECHO} "= "dps; cd dps; ${MAKE} install  ||  exit 1; \
	else \
	    true; \
	fi
	@if [ "no" = yes ]; then \
	    ${ECHO} "= "imp; cd imp; ${MAKE} install  ||  exit 1; \
	else \
	    true; \
	fi
	@if [ "no" = yes ]; then \
	    ${ECHO} "= "gs; cd gs; ${MAKE} install  ||  exit 1; \
	else \
	    true; \
	fi

uninstall: rmDirs
	${RM} -f ${SPOOL}/COPYRIGHT
	@for i in ${DIRS}; do \
	    (${ECHO} "= "$$i; cd $$i; ${MAKE} uninstall)  ||  exit 1; \
	done
	@if [ "no" = yes ]; then \
	    ${ECHO} "= "sgi2fax; cd sgi2fax; ${MAKE} uninstall  ||  exit 1; \
	else \
	    true; \
	fi
	@if [ "LINUX" != no ]; then \
	    for i in ${DSODIRS}; do \
		(${ECHO} "= "$$i; cd $$i; ${MAKE} uninstallDSO)  ||  exit 1; \
	    done; \
	else \
	    true; \
	fi
	@${ECHO} "= "etc; cd etc; ${MAKE} uninstallSysVInit;

CLIENTDIRS=\
	faxalter \
	faxcover \
	faxmail  \
	faxrm  \
	faxstat  \
	sendfax  \
	sendpage

installClient: makeClientDirs
	@for i in ${CLIENTDIRS}; do \
	    (${ECHO} "= "$$i; cd $$i; ${MAKE} install)  ||  exit 1; \
	done
	@if [ "no" = yes ]; then \
	    ${ECHO} "= "sgi2fax; cd sgi2fax; ${MAKE} install  ||  exit 1; \
	else \
	    true; \
	fi
	@for i in etc util man; do \
	    (${ECHO} "= "$$i; cd $$i; ${MAKE} installClient)  ||  exit 1; \
	done
	@if [ "LINUX" != no ]; then \
	    for i in util; do \
		(${ECHO} "= "$$i; cd $$i; ${MAKE} installDSO)  ||  exit 1; \
	    done; \
	else \
	    true; \
	fi

package::
	@${ECHO} "= "pkg; cd pkg; ${MAKE} package

product::
	test -d dist || ${MKDIR} dist
	${RM} -f dist/rawidb
	SRC=`${PWDCMD}` RAWIDB=`${PWDCMD}`/dist/rawidb ${MAKE} install
	${RM} -f dist/idb
	${SORT} -u +4 dist/rawidb > dist/idb
	${GENDIST} -v -dist dist -idb dist/idb -sbase `pwd` -spec ${SRCDIR}/dist/hylafax.spec

dist.inst:
	VERSION="v`cat ${SRCDIR}/VERSION``awk '{print $$3}' ${SRCDIR}/dist/hylafax.alpha`";	\
	rm -f $$VERSION.inst.tar; \
	tar cf $$VERSION.inst.tar \
	    dist/hylafax	\
	    dist/hylafax.idb	\
	    dist/hylafax.sw	\
	    dist/hylafax.html	\
	    dist/hylafax.man

include ${SRCDIR}/distrules
