#! smake
#	$Id: Makefile.in 959 2009-12-04 04:55:53Z faxguy $
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
SRCDIR	= ${DEPTH}/${TOPSRCDIR}/faxd
VPATH	= .././faxd
DSOSUF	= so

C++FILES=ClassModem.c++ \
	FaxModem.c++ \
	Class0.c++ \
	Class1.c++ \
	Class10.c++ \
	Class1Ersatz.c++ \
	Class1Poll.c++ \
	Class1Recv.c++ \
	Class1Send.c++ \
	Class2.c++ \
	Class20.c++ \
	Class21.c++ \
	Class2Ersatz.c++ \
	Class2Poll.c++ \
	Class2Recv.c++ \
	Class2Send.c++ \
	CopyQuality.c++ \
	JobControl.c++ \
	DestInfo.c++ \
	FaxAcctInfo.c++ \
	FaxFont.c++ \
	FaxItem.c++ \
	FaxMachineInfo.c++ \
	FaxMachineLog.c++ \
	FaxPoll.c++ \
	FaxRecv.c++ \
	FaxRequest.c++ \
	FaxSend.c++ \
	HylaClient.c++ \
	itufaxicc.c++ \
	sslfax.c++ \
	ModemServer.c++ \
	FaxServer.c++ \
	G3Decoder.c++ \
	G3Encoder.c++ \
	MemoryDecoder.c++ \
	Getty.c++ \
	GettySysV.c++ \
	HDLCFrame.c++ \
	Job.c++ \
	Modem.c++ \
	ModemConfig.c++ \
    NSF.c++ \
	PCFFont.c++ \
	QLink.c++ \
	ServerConfig.c++ \
	TagLine.c++ \
	Trigger.c++ \
	TriggerRef.c++ \
	UUCPLock.c++ \
	faxApp.c++ \
	faxGettyApp.c++ \
	faxQueueApp.c++ \
	faxSendApp.c++ \
	sslfaxproxy.c++ \
	sslfaxproxytest.c++ \
	tagtest.c++ \
	tsitest.c++ \
	pageSendApp.c++
MODEM_OBJS=ClassModem.o \
	FaxModem.o \
	Class0.o \
	Class1.o \
	Class10.o \
	Class1Ersatz.o \
	Class1Poll.o \
	Class1Recv.o \
	Class1Send.o \
	Class2.o \
	Class20.o \
	Class21.o \
	Class2Ersatz.o \
	Class2Poll.o \
	Class2Recv.o \
	Class2Send.o \
	CopyQuality.o \
	G3Decoder.o \
	G3Encoder.o \
	MemoryDecoder.o \
	HDLCFrame.o \
	itufaxicc.o \
	sslfax.o \
	ModemConfig.o \
    NSF.o \
	FaxFont.o \
	PCFFont.o \
	TagLine.o
SERVER_OBJS=faxApp.o \
	\
	FaxItem.o \
	FaxRequest.o \
	\
	FaxAcctInfo.o \
	FaxMachineInfo.o \
	FaxMachineLog.o \
	FaxPoll.o \
	FaxRecv.o \
	FaxSend.o \
	ModemServer.o \
	FaxServer.o \
	UUCPLock.o \
	ServerConfig.o
FAXQOBJS=JobControl.o \
	DestInfo.o \
	Job.o \
	HylaClient.o \
	Modem.o \
	QLink.o \
	Trigger.o \
	TriggerRef.o \
	\
	faxQueueApp.o
FAXSENDOBJS=  faxSendApp.o
FAXQCLEANOBJS=faxQCleanApp.o
FAXGETTYOBJS= Getty.o GettySysV.o faxGettyApp.o
TARGETS=libfaxserver.${DSO} \
	faxq faxsend faxgetty pagesend faxqclean \
	sslfaxproxy sslfaxproxytest tsitest tagtest cqtest choptest

default all::
	@${MAKE} incdepend
	@${MAKE} targets

targets: $(TARGETS)

include ${COMMONRULES}

libfaxserver.a: ${SERVER_OBJS} ${MODEM_OBJS}
	${AR} ${AROPTS} libfaxserver.a $?
	${RANLIB} libfaxserver.a

include ${SRCDIR}/Makefile.LINUXdso

LDIRT	= hash.h mkhash

hash.h:	mkhash
	rm -f hash.h; ./mkhash > hash.h
mkhash:	${SRCDIR}/mkhash.c
	${CCF} -o mkhash ${SRCDIR}/mkhash.c

faxQueueApp.o FaxRecv.o:
incdepend: hash.h

faxq:	${FAXQOBJS} libfaxserver.${DSO} ${LIBS}
	${C++F} -o $@ ${FAXQOBJS} ${LIBFAXSERVER} ${LDFLAGS}
faxsend: ${FAXSENDOBJS} libfaxserver.${DSO} ${LIBS}
	${C++F} -o $@ ${FAXSENDOBJS} ${LIBFAXSERVER} ${LDFLAGS}
faxgetty: ${FAXGETTYOBJS} libfaxserver.${DSO} ${LIBS}
	${C++F} -o $@ ${FAXGETTYOBJS} ${LIBFAXSERVER} ${LDFLAGS}
faxqclean: ${FAXQCLEANOBJS} libfaxserver.${DSO} ${LIBS}
	${C++F} -o $@ ${FAXQCLEANOBJS} ${LIBFAXSERVER} ${LDFLAGS}

PAGESENDOBJS=\
	pageSendApp.o
pagesend:${PAGESENDOBJS} libfaxserver.${DSO} ${LIBS}
	${C++F} -o $@ ${PAGESENDOBJS} ${LIBFAXSERVER} ${LDFLAGS}

sslfaxproxy: sslfaxproxy.o libfaxserver.${DSO} ${LIBS}
	${C++F} -o $@ sslfaxproxy.o ${LIBFAXSERVER} ${LDFLAGS}
sslfaxproxytest: sslfaxproxytest.o libfaxserver.${DSO} ${LIBS}
	${C++F} -o $@ sslfaxproxytest.o ${LIBFAXSERVER} ${LDFLAGS}
tagtest: tagtest.o libfaxserver.${DSO} ${LIBS}
	${C++F} -o $@ tagtest.o ${LIBFAXSERVER} ${LDFLAGS}
cqtest:	cqtest.o libfaxserver.${DSO} ${LIBS}
	${C++F} -o $@ cqtest.o ${LIBFAXSERVER} ${LDFLAGS}
choptest: choptest.o libfaxserver.${DSO} ${LIBS}
	${C++F} -o $@ choptest.o ${LIBFAXSERVER} ${LDFLAGS}
tsitest: tsitest.o libfaxserver.${DSO} ${LIBS}
	${C++F} -o $@ tsitest.o ${LIBFAXSERVER} ${LDFLAGS}
trigtest: trigtest.o libfaxserver.${DSO} ${LIBS}
	${C++F} -o $@ trigtest.o ${LIBFAXSERVER} ${LDFLAGS}

PUTSERV=${INSTALL} -idb ${PRODUCT}.sw.server

install: default
	${PUTSERV} -root ${INSTALLROOT} -F ${SBIN} -m 755 -O faxq faxqclean
	${PUTSERV} -root ${INSTALLROOT} -F ${LIBEXEC} -m 755 -O faxgetty faxsend pagesend
	${PUTSERV} -root ${INSTALLROOT} -F ${SBIN} -m 755 -O tsitest tagtest cqtest choptest

uninstall::
	${RM} -f ${SBIN}/faxq ${SBIN}/faxqclean
	${RM} -f ${LIBEXEC}/faxgetty ${LIBEXEC}/faxsend ${LIBEXEC}/pagesend
	${RM} -f ${SBIN}/tsitest ${SBIN}/tagtest ${SBIN}/cqtest ${SBIN}/choptest
