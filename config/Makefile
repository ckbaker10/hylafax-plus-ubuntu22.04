#!smake
#	$Id: Makefile.in 886 2008-10-13 04:32:54Z faxguy $
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

SRCDIR	= ${DEPTH}/${TOPSRCDIR}/config
VPATH	= .././config

CONFIGFILES=class1 \
	class1.0 \
	class2 \
	class2.0 \
	class2.1 \
	skel \
	\
	att-dataport-2 \
	att-dataport-2.0 \
	att-dataport \
	att-dpexpress-2 \
	cirrus \
	conexant-1.0 \
	digi \
	digi-2 \
	digi-20 \
	davicom-2 \
	dsi-scout+ \
	e-tech \
	eicon \
	eicon-2 \
    elsa-microlink-56k-basic-2.0 \
	everex-2496d \
	exar \
	gvc-288 \
	gvc-288-2 \
	hayes \
	iaxmodem \
	i537ep \
	intel-400e \
	ip568x \
	linux-isdn-1 \
	linux-isdn-2 \
	lucent \
	lucent-isa \
	lucent-mt-2 \
	lucent-mt-20 \
	lucent-mt-21 \
	lucent-mt-10 \
	mainpine-10 \
	mainpine-2 \
	mainpine-20 \
	mainpine-21 \
	moto-288 \
	mt-1432 \
	nuvo-voyager \
	ppi-pm14400fxmt \
	ppi-pm14400fxsa \
	prometheus \
	rc144ac \
	rc144ac-1 \
	rc288dpi \
	rc288dpi-1 \
	rc32acl \
	rc32acl-1 \
	rockwell-k56 \
	rockwell-rc \
	silabs \
	silabs-10 \
	t38modem \
	telebit-t3000 \
    telebit-qblazer \
	telebit-wb \
	topic \
	tricom2842 \
	uds-fastalk \
    umc92144 \
	umc9624\
	usr-2.0 \
	usr-rts \
    usr-xon \
	zyxel-1496e \
	zyxel-1496e-1 \
	zyxel-1496e-2.0 \
	zyxel-2864 \
	sierra
TARGETS=

default all::
	@${MAKE} targets

targets: ${TARGETS}

include ${COMMONRULES}

PUTSERVER=${INSTALL} -idb ${PRODUCT}.sw.server

install: default ${CONFIGFILES}
	for i in ${CONFIGFILES}; do \
	    ${PUTSERVER} -root ${INSTALLROOT} -F ${SPOOL}/config -m 444 -src ${SRCDIR}/$$i -O $$i; \
	done

uninstall::
	for i in ${CONFIGFILES}; do \
	    ${RM} -f ${SPOOL}/config/$$i; \
	done
