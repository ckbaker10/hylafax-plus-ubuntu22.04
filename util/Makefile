#! smake
#	$Id: Makefile.in 1087 2012-02-29 23:07:23Z faxguy $
#
# Warning, this file was automatically created by the HylaFAX configure script
#
# HylaFAX Facsimile Software
#
# Copyright (c) 1990-1996 Sam Leffler
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

LIBVERSION	= 7.0.6
SRCDIR	= ${DEPTH}/${TOPSRCDIR}/util
VPATH	= .././util
DSOSUF	= so

C++FILES=Array.c++ \
	BoolArray.c++ \
	Dictionary.c++ \
	Obj.c++ \
	PageSize.c++ \
	RE.c++ \
	REArray.c++ \
	REDict.c++ \
	StackBuffer.c++ \
	Str.c++ \
	StrArray.c++ \
	StrDict.c++ \
	\
	Dispatcher.c++ \
	IOHandler.c++ \
	Sys.c++ \
	SystemLog.c++ \
	Timeout.c++ \
	Fatal.c++ \
	\
	AtSyntax.c++ \
	DialRules.c++ \
	FmtTime.c++ \
	Sequence.c++ \
	TimeOfDay.c++ \
	FaxDB.c++ \
	FaxHostID.c++ \
	TextFormat.c++ \
	\
	Class2Params.c++ \
	FaxParams.c++ \
	FaxClient.c++ \
	FaxConfig.c++ \
	FaxRecvInfo.c++ \
	FaxSendInfo.c++ \
	JobExt.c++ \
	CallID.c++ \
	ModemExt.c++ \
	SendFaxJob.c++ \
	SendFaxClient.c++ \
	TypeRules.c++ \
	Transport.c++ \
	InetTransport.c++ \
	UnixTransport.c++ \
	\
	SNPPClient.c++ \
	SNPPJob.c++

CFILES= cvtfacility.c fxassert.c
TARGETS=libfaxutil.${DSO} faxmsg faxmodem faxadduser faxconfig faxdeluser \
    faxstate faxinfo faxfetch faxwatch textfmt dialtest typetest tiffcheck

LC++INCS=${ZLIBINC}			# for FaxClient.c++

default all::
	@${MAKE} incdepend
	@${MAKE} targets

targets: $(TARGETS)

include ${COMMONRULES}

libfaxutil.a: ${OBJECTS}
	@rm -f $@;
	@echo "${AR} ${AROPTS} $@ ${OBJECTS}"; \
	    ${AR} ${AROPTS} $@ ${OBJECTS} ${C++FILT}
	${RANLIB} $@
../util/libfaxutil.a: libfaxutil.a

faxmsg: ${SRCDIR}/faxmsg.c ${LIBS}
	${CCF} -o $@ ${SRCDIR}/faxmsg.c ${LDFLAGS}
faxstate: ${SRCDIR}/faxstate.c ${LIBS}
	${CCF} -o $@ ${SRCDIR}/faxstate.c ${LDFLAGS}
faxmodem: ${SRCDIR}/faxmodem.c ${LIBS}
	${CCF} -o $@ ${SRCDIR}/faxmodem.c ${LDFLAGS}
faxadduser: ${SRCDIR}/faxadduser.c ${LIBS}
	${CCF} -o $@ ${SRCDIR}/faxadduser.c ${LDFLAGS}
faxconfig: ${SRCDIR}/faxconfig.c ${LIBS}
	${CCF} -o $@ ${SRCDIR}/faxconfig.c ${LDFLAGS}
faxdeluser: ${SRCDIR}/faxdeluser.c ${LIBS}
	${CCF} -o $@ ${SRCDIR}/faxdeluser.c ${LDFLAGS}
tiffcheck.o: ${SRCDIR}/tiffcheck.c++
	${C++F} -c ${C++FILE} ${SRCDIR}/tiffcheck.c++
tiffcheck: tiffcheck.o ${LIBS}
	${C++F} -o $@ tiffcheck.o ${LDFLAGS}
textfmt.o: ${SRCDIR}/textfmt.c++
	${C++F} -c ${C++FILE} ${SRCDIR}/textfmt.c++
textfmt: textfmt.o ${LIBS}
	${C++F} -o $@ textfmt.o ${LDFLAGS}
dialtest.o: ${SRCDIR}/dialtest.c++
	${C++F} -c ${C++FILE} ${SRCDIR}/dialtest.c++
dialtest: dialtest.o ${LIBS}
	${C++F} -o $@ dialtest.o ${LDFLAGS}
typetest.o: ${SRCDIR}/typetest.c++
	${C++F} -c ${C++FILE} ${SRCDIR}/typetest.c++
typetest: typetest.o ${LIBS}
	${C++F} -o $@ typetest.o ${LDFLAGS}
faxinfo.o: ${SRCDIR}/faxinfo.c++
	${C++F} -c ${C++FILE} ${SRCDIR}/faxinfo.c++
faxinfo: faxinfo.o ${LIBS}
	${C++F} -o $@ faxinfo.o ${LDFLAGS}
faxwatch.o: ${SRCDIR}/faxwatch.c++
	${C++F} -c ${C++FILE} ${SRCDIR}/faxwatch.c++
faxwatch: faxwatch.o ${LIBS}
	${C++F} -o $@ faxwatch.o ${LDFLAGS}
faxfetch: faxfetch.o ${LIBS}
	${C++F} -o $@ faxfetch.o ${LDFLAGS}

LDIRT=	checkat
checkat.o: ${SRCDIR}/checkat.c++
	${C++F} -c ${C++FILE} ${SRCDIR}/checkat.c++
checkat: checkat.o ${LIBS}
	${C++F} -o $@ checkat.o ${LDFLAGS}

PUTCLIENT	= ${INSTALL} -idb ${PRODUCT}.sw.client
PUTSERVER	= ${INSTALL} -idb ${PRODUCT}.sw.server
PUTSERV		= ${PUTSERVER} -m 755
PUTSUPD		= ${PUTSERVER} -root ${INSTALLROOT} -F ${SPOOL}/bin -idb "config(update)"
PUTSUPDDICT	= ${PUTSERVER} -root ${INSTALLROOT} -F ${SPOOL}/bin/dict -idb "config(update)"
PUTSBIN		= ${PUTSERVER} -root ${INSTALLROOT} -F ${SBIN}

installClient: default
	${PUTCLIENT} -root ${INSTALLROOT} -F ${LIBEXEC} -m 755 -O textfmt
	${PUTCLIENT} -root ${INSTALLROOT} -F ${LIBDATA} -m 444 -O pagesizes
	${PUTCLIENT} -root ${INSTALLROOT} -F ${LIBDATA} -m 444 -src ${SRCDIR}/typerules -O typerules

install: installClient
	${PUTSBIN} -m 755 -O faxmsg faxadduser faxconfig faxdeluser faxmodem \
	    faxstate faxfetch faxwatch faxinfo tiffcheck
	${PUTSBIN} -idb ${PRODUCT}.sw.server \
	    -ln ${SBIN}/faxmsg -O faxabort faxanswer faxquit faxlock
	${PUTSBIN} -m 755 -O dialtest typetest
	${PUTSBIN} -m 755 -src xferfaxstats.sh -O xferfaxstats
	${PUTSBIN} -m 755 -src recvstats.sh -O recvstats
	${PUTSBIN} -m 755 -idb "config(update)" -src faxcron.sh -O faxcron
	${PUTSUPD} -m 755 -src ps2fax.gs.sh -O ps2fax.gs
	${PUTSUPD} -m 755 -src ps2fax.dps.sh -O ps2fax.dps
	${PUTSUPD} -m 755 -src ps2fax.imp.sh -O ps2fax.imp
	${PUTSUPD} -m 755 -src pdf2fax.gs.sh -O pdf2fax.gs
	${PUTSUPD} -m 755 -src pcl2fax.sh -O pcl2fax
	${PUTSUPD} -m 755 -src tiff2fax.sh -O tiff2fax
	${PUTSUPD} -m 755 -src tiff2pdf.sh -O tiff2pdf
	${PUTSUPD} -m 755 -src notify.sh -O notify
	${PUTSUPD} -m 755 -src archive.sh -O archive
	${PUTSUPD} -m 755 -src common-functions.sh -O common-functions
	${PUTSUPD} -m 755 -src faxrcvd.sh -O faxrcvd
	${PUTSUPD} -m 755 -src genfontmap.ps -O genfontmap.ps
	${PUTSUPD} -m 755 -src pollrcvd.sh -O pollrcvd
	${PUTSUPD} -m 755 -src mkcover.sh -O mkcover
	${PUTSUPD} -m 755 -src wedged.sh -O wedged
	${PUTSUPD} -m 755 -src qp-encode.awk -O qp-encode.awk
	${PUTSUPD} -m 755 -src rfc2047-encode.awk -O rfc2047-encode.awk
	${PUTSUPD} -m 755 -src auto-rotate.ps -O auto-rotate.ps
	${PUTSUPD} -m 755 -src dictionary.sh -O dictionary
	${PUTSUPDDICT} -m 644 -src dict-de -O de
	${PUTSUPDDICT} -m 644 -src dict-en -O en
	${PUTSUPDDICT} -m 644 -src dict-es -O es
	${PUTSUPDDICT} -m 644 -src dict-fr -O fr
	${PUTSUPDDICT} -m 644 -src dict-he -O he
	${PUTSUPDDICT} -m 644 -src dict-it -O it
	${PUTSUPDDICT} -m 644 -src dict-nl_BE -O nl_BE
	${PUTSUPDDICT} -m 644 -src dict-pl -O pl
	${PUTSUPDDICT} -m 644 -src dict-pt -O pt
	${PUTSUPDDICT} -m 644 -src dict-pt_BR -O pt_BR
	${PUTSUPDDICT} -m 644 -src dict-ro -O ro
	${PUTSUPDDICT} -m 644 -src dict-ru -O ru
	${PUTSUPDDICT} -m 644 -src dict-sr -O sr
	${PUTSUPDDICT} -m 644 -src dict-tr -O tr
	${PUTSUPDDICT} -m 644 -src dict-uk -O uk
	${PUTSUPDDICT} -m 644 -src dict-zh -O zh
	${PUTSERVER} -root ${INSTALLROOT} -F ${SPOOL}/etc -m 444 -idb "config(update)" \
	    -src ${SRCDIR}/dpsprinter.ps -O dpsprinter.ps
	${PUTSERVER} -root ${INSTALLROOT} -F ${SPOOL}/etc -idb "config(suggest)" \
	    -m 444 -src ${SRCDIR}/cover.templ -O cover.templ

uninstall::
	${RM} -f ${LIBEXEC}/textfmt
	${RM} -f ${LIBDATA}/pagesizes
	${RM} -f ${LIBDATA}/typerules
	${RM} -f ${SBIN}/faxmsg ${SBIN}/faxadduser ${SBIN}/faxconfig ${SBIN}/faxdeluser \
        ${SBIN}/faxmodem ${SBIN}/faxstate ${SBIN}/faxwatch ${SBIN}/faxfetch ${SBIN}/faxinfo ${SBIN}/tiffcheck
	${RM} -f ${SBIN}/faxabort ${SBIN}/faxanswer ${SBIN}/faxquit ${SBIN}/faxlock
	${RM} -f ${SBIN}/typetest
	${RM} -f ${SBIN}/dialtest
	${RM} -f ${SBIN}/xferfaxstats
	${RM} -f ${SBIN}/recvstats
	${RM} -f ${SBIN}/faxcron
	${RM} -f ${SPOOL}/bin/ps2fax.gs
	${RM} -f ${SPOOL}/bin/ps2fax.dps
	${RM} -f ${SPOOL}/bin/ps2fax.imp
	${RM} -f ${SPOOL}/bin/pdf2fax.gs
	${RM} -f ${SPOOL}/bin/pcl2fax
	${RM} -f ${SPOOL}/bin/tiff2fax
	${RM} -f ${SPOOL}/bin/tiff2pdf
	${RM} -f ${SPOOL}/bin/notify
	${RM} -f ${SPOOL}/bin/archive
	${RM} -f ${SPOOL}/bin/common-functions
	${RM} -f ${SPOOL}/bin/faxrcvd
	${RM} -f ${SPOOL}/bin/genfontmap.ps
	${RM} -f ${SPOOL}/bin/pollrcvd
	${RM} -f ${SPOOL}/bin/mkcover
	${RM} -f ${SPOOL}/bin/wedged
	${RM} -f ${SPOOL}/bin/qp-encode.awk
	${RM} -f ${SPOOL}/bin/rfc2047-encode.awk
	${RM} -f ${SPOOL}/bin/auto-rotate.ps
	${RM} -f ${SPOOL}/etc/dpsprinter.ps
	${RM} -f ${SPOOL}/etc/cover.templ
	${RM} -f ${SPOOL}/bin/dictionary
	${RM} -rf ${SPOOL}/bin/dict

include ${SRCDIR}/Makefile.LINUXdso

#
# These targets are created during the configuration procedure.
#
clobberconfig:
	-${RM} -f pagesizes xferfaxstats.sh recvstats.sh faxcron.sh dictionary.sh \
		faxrcvd.sh mkcover.sh notify.sh pcl2fax.sh pollrcvd.sh \
		ps2fax.dps.sh ps2fax.gs.sh ps2fax.imp.sh tiff2fax.sh tiff2pdf.sh \
		wedged.sh qp-encode.awk rfc2047-encode.awk archive.sh pdf2fax.gs.sh common-functions.sh \
		dict-de dict-en dict-es dict-fr dict-he dict-it dict-nl_BE dict-pl dict-pt dict-pt_BR dict-ru dict-ro dict-sr dict-tr dict-uk dict-zh

