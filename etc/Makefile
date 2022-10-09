#!smake
#	$Id: Makefile.in 1085 2012-02-14 05:55:32Z faxguy $
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

SRCDIR	= ${DEPTH}/${TOPSRCDIR}/etc
VPATH	= .././etc
DIR_SYSVINIT	= /etc/init.d
DIR_SYSVINITSTART	= ../rc2.d ../rc3.d ../rc4.d ../rc5.d
DIR_SYSVINITSTOP	= ../rc0.d ../rc1.d ../rc6.d
MANNUM4_5		= 5F
MANNUM1_8		= 8C
NAME_SYSVINITSTART	= S97hylafax
NAME_SYSVINITSTOP	= K05hylafax

DIALRULES=dialrules \
	dialrules.sf-ba \
	dialrules-pabx.be \
	dialrules.europe \
	dialrules.ext \
	dialrules.world \
	dialrules.uk
TARGETS	= config.fax hosts.hfaxd xferfaxlog lockname ondelay

default all::
	@${MAKE} targets

targets: ${TARGETS}

include ${COMMONRULES}

hosts.hfaxd:
	${ECHO} "localhost" >hosts.hfaxd
	${ECHO} "127.0.0.1" >>hosts.hfaxd
xferfaxlog:
	${ECHO} >xferfaxlog
config.fax:
	${ECHO} on >config.fax
lockname: ${SRCDIR}/lockname.c
	${CCF} -o $@ ${SRCDIR}/lockname.c
ondelay: ${SRCDIR}/ondelay.c
	${CCF} -o $@ ${SRCDIR}/ondelay.c

PUTSERVER	= ${INSTALL} -idb ${PRODUCT}.sw.server
PUTSAMPLE	= ${PUTSERVER} -u ${FAXUSER} -g ${FAXGROUP} \
		  -idb "config(noupdate)"

install: default
	${PUTSERVER} -root ${INSTALLROOT} -F ${SBIN} -m 755 -src faxaddmodem.sh -O faxaddmodem
	${PUTSERVER} -root ${INSTALLROOT} -F ${SBIN} -m 755 -src faxsetup.sh -O faxsetup
	for i in bsdi irix linux; do \
	    ${PUTSERVER} -root ${INSTALLROOT} -F ${SBIN} -m 755 \
		-src ${SRCDIR}/faxsetup.$$i -O faxsetup.$$i; \
	done
	${PUTSERVER} -root ${INSTALLROOT} -F ${SBIN} -m 755 -src probemodem.sh -O probemodem
	${PUTSAMPLE} -root ${INSTALLROOT} -F ${SPOOL}/etc -m 644 -o xferfaxlog
	${PUTSAMPLE} -root ${INSTALLROOT} -F ${SPOOL}/etc -m 600 -o hosts.hfaxd
	for i in ${DIALRULES}; do \
	    ${PUTSERVER} -root ${INSTALLROOT} -F ${SPOOL}/etc -m 444 -src ${SRCDIR}/$$i \
		-idb "config(update)" -O $$i; \
	done
	${PUTSERVER} -root ${INSTALLROOT} -F ${LIBEXEC} -m 755 -O lockname ondelay
	${PUTSAMPLE} -root ${INSTALLROOT} -F ${SPOOL}/etc -m 644 -idb nostrip \
	    -src ${SRCDIR}/lutRS18.pcf -O lutRS18.pcf
	${PUTSAMPLE} -root ${INSTALLROOT} -F ${SPOOL}/etc -m 644 -idb nostrip \
	    -src ${SRCDIR}/LiberationSans-25.pcf -O LiberationSans-25.pcf

uninstall::
	${RM} -f ${SBIN}/faxaddmodem
	${RM} -f ${SBIN}/faxsetup
	for i in bsdi irix linux; do \
	    ${RM} -f ${SBIN}/faxsetup.$$i; \
	done
	${RM} -f ${SBIN}/probemodem
	${RM} -f ${SPOOL}/etc/xferfaxlog
	${RM} -f ${SPOOL}/etc/hosts.hfaxd
	for i in ${DIALRULES}; do \
	    ${RM} -f ${SPOOL}/etc/$$i; \
	done
	${RM} -f ${LIBEXEC}/lockname ${LIBEXEC}/ondelay
	${RM} -f ${SPOOL}/etc/lutRS18.pcf
	${RM} -f ${SPOOL}/etc/LiberationSans-25.pcf

#
# System V-specific init support.
#
installSysVInit: hylafax
	if [ "yes" = yes ]; then \
	    ${PUTSERVER} -root ${INSTALLROOT} -F ${DIR_SYSVINIT} -m 755 -O hylafax; \
	    echo "checking ${DIR_SYSVINITSTART} directories"; \
	    for i in ${DIR_SYSVINITSTART}; do \
		if test -d ${DIR_SYSVINIT}/$$i; then \
		    ${PUTSERVER} -root ${INSTALLROOT} -F ${DIR_SYSVINIT}/$$i -lns ../`basename ${DIR_SYSVINIT}`/hylafax ${NAME_SYSVINITSTART}; \
		fi; \
	    done; \
	    echo "checking ${DIR_SYSVINITSTOP} directories"; \
	    for i in ${DIR_SYSVINITSTOP}; do \
		if test -d ${DIR_SYSVINIT}/$$i; then \
		    ${PUTSERVER} -root ${INSTALLROOT} -F ${DIR_SYSVINIT}/$$i -lns ../`basename ${DIR_SYSVINIT}`/hylafax ${NAME_SYSVINITSTOP}; \
		fi; \
	    done; \
	else \
	    ${PUTSERVER} -root ${INSTALLROOT} -F ${SBIN} -m 755 hylafax; \
	fi
	if test -d /etc/config; then \
	    ${PUTSERVER} -root ${INSTALLROOT} -F /etc/config -m 644 -src config.fax -O fax; \
	fi

uninstallSysVInit::
	if [ "yes" = yes ]; then \
	    ${RM} -f ${DIR_SYSVINIT}/hylafax; \
	    echo "checking ${DIR_SYSVINITSTART} directories"; \
	    for i in ${DIR_SYSVINITSTART}; do \
		if test -d ${DIR_SYSVINIT}/$$i; then \
		    ${RM} -f ${DIR_SYSVINIT}/$$i/${NAME_SYSVINITSTART}; \
		fi; \
	    done; \
	    echo "checking ${DIR_SYSVINITSTOP} directories"; \
	    for i in ${DIR_SYSVINITSTOP}; do \
		if test -d ${DIR_SYSVINIT}/$$i; then \
		    ${RM} -f ${DIR_SYSVINIT}/$$i/${NAME_SYSVINITSTOP}; \
		fi; \
	    done; \
	else \
	    ${RM} -f ${SBIN}/hylafax; \
	fi
	if test -d /etc/config; then \
	    ${RM} -f /etc/config/fax; \
	fi

installClient: default
	${PUTSERVER} -root ${INSTALLROOT} -F ${SBIN} -m 755 -src faxsetup.sh -O faxsetup
	for i in bsdi irix linux; do \
	    ${PUTSERVER} -root ${INSTALLROOT} -F ${SBIN} -m 755 \
		-src ${SRCDIR}/faxsetup.$$i -O faxsetup.$$i; \
	done

#
# These targets are created during the configuration procedure.
#
clobberconfig:
	-${RM} -f hylafax probemodem.sh faxaddmodem.sh faxsetup.sh faxsetup.linux

