#! smake
#	$Id: Makefile.in 777 2008-01-31 02:26:36Z faxguy $
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

SRCDIR	= ${DEPTH}/${TOPSRCDIR}/hfaxd
VPATH	= .././hfaxd
FAXDSRCDIR= ${DEPTH}/${TOPSRCDIR}/faxd

C++FILES=Admin.c++ \
	FIFO.c++ \
	FileCache.c++ \
	FileSystem.c++ \
	FileTransfer.c++ \
	HylaFAXServer.c++ \
	Jobs.c++ \
	Login.c++ \
	Parser.c++ \
	RecvQueue.c++ \
	Status.c++ \
	Trigger.c++ \
	User.c++ \
	\
	SuperServer.c++ \
	InetFaxServer.c++ \
	SNPPServer.c++ \
	UnixFaxServer.c++ \
	\
	main.c++
LC++DEFS=-DSNPP_SUPPORT=1
LC++INCS= -I${FAXDSRCDIR} ${ZLIBINC}
TARGETS	= hfaxd

default all::
	@${MAKE} incdepend
	@${MAKE} targets

targets: $(TARGETS)

include ${COMMONRULES}

hfaxd: ${OBJECTS} FaxRequest.o FaxItem.o ${LIBS}
	${C++F} -o $@ ${OBJECTS} FaxRequest.o FaxItem.o ${LDFLAGS}

#
# Private versions are built so that we do not need
# to link against the libfaxserver archive; this
# avoids lots of problems on systems that do not have
# support for DSOs (there would be many undefined
# symbols that could only be resolved by bloating
# the contents of the archive).
#
FaxRequest.o: ${FAXDSRCDIR}/FaxRequest.c++
	${C++F} -c ${C++FILE} -I${DEPTH}/faxd ${FAXDSRCDIR}/FaxRequest.c++
FaxItem.o: ${FAXDSRCDIR}/FaxItem.c++
	${C++F} -c ${C++FILE} ${FAXDSRCDIR}/FaxItem.c++

HylaFAXServer.o: 
incdepend:

install: default
	${INSTALL} -root ${INSTALLROOT} -F ${LIBEXEC} -u root -m 755 \
	    -idb ${PRODUCT}.sw.server -O hfaxd
	${INSTALL} -root ${INSTALLROOT} -F ${LIBDATA} -m 644 -idb ${PRODUCT}.sw.server \
	    -idb "config(noupdate)" -src ${SRCDIR}/hfaxd.conf -O hfaxd.conf

uninstall::
	${RM} -f ${LIBEXEC}/hfaxd
	${RM} -f ${LIBDATA}/hfaxd.conf
