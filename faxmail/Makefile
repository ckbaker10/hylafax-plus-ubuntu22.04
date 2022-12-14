#! smake
#	$Id: Makefile.in 559 2007-07-22 06:03:54Z faxguy $
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

SRCDIR	= ${DEPTH}/${TOPSRCDIR}/faxmail
VPATH	= .././faxmail

C++FILES= faxmail.c++ MIMEState.c++ MsgFmt.c++
TARGETS	= faxmail

default all::
	@${MAKE} incdepend
	@${MAKE} targets

targets: $(TARGETS)

include ${COMMONRULES}

faxmail: ${OBJECTS} ${LIBS}
	${C++F} -o $@ ${OBJECTS} ${LDFLAGS}

install: default
	${INSTALL} -root ${INSTALLROOT} -F ${BIN} -m 755 -idb ${PRODUCT}.sw.client -O faxmail
	${INSTALL} -root ${INSTALLROOT} -F ${LIBDATA} -m 444 -idb ${PRODUCT}.sw.client \
	    -src ${SRCDIR}/faxmail.ps -O faxmail.ps
	-${INSTALL} -u ${SYSUSER} -g ${SYSGROUP} -m ${DIRMODE} \
	    -idb hylafax.sw.client -root ${INSTALLROOT} -dir ${LIBDATA}/faxmail ${LIBDATA}/faxmail/application ${LIBDATA}/faxmail/image
	${INSTALL} -root ${INSTALLROOT} -F ${LIBDATA}/faxmail/application -m 755 -idb ${PRODUCT}.sw.client \
	    -src ${SRCDIR}/application-pdf.sh -O pdf
	${INSTALL} -root ${INSTALLROOT} -F ${LIBDATA}/faxmail/application -m 755 -idb ${PRODUCT}.sw.client \
	    -src ${SRCDIR}/application-octet-stream.sh -O octet-stream
	${INSTALL} -root ${INSTALLROOT} -F ${LIBDATA}/faxmail/application -m 755 -idb ${PRODUCT}.sw.client \
	    -src ${SRCDIR}/application-binary.sh -O binary
	${INSTALL} -root ${INSTALLROOT} -F ${LIBDATA}/faxmail/image -m 755 -idb ${PRODUCT}.sw.client \
	    -src ${SRCDIR}/image-tiff.sh -O tiff

uninstall::
	${RM} -f ${BIN}/faxmail
	${RM} -f ${LIBDATA}/faxmail.ps
	${RM} -f ${LIBDATA}/faxmail/application/pdf
	${RM} -f ${LIBDATA}/faxmail/application/octet-stream
	${RM} -f ${LIBDATA}/faxmail/application/binary
	${RM} -f ${LIBDATA}/faxmail/image/tiff
	-rmdir ${LIBDATA}/faxmail/application ${LIBDATA}/faxmail/image ${LIBDATA}/faxmail 

#
# These targets are created during the configuration procedure.
#
clobberconfig:
	-${RM} -f application-pdf.sh image-tiff.sh application-octet-stream.sh application-binary.sh

