#! /usr/bin/bash
#	$Id: ps2fax.dps.sh.in 750 2008-01-09 06:40:36Z faxguy $
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
# Convert PostScript to facsimile using DPS-based RIP for IRIX.
#
# ps2fax [-o output] [-l pagelength] [-w pagewidth]
#	[-r resolution] [-m maxpages] [-*] [file ...]
#
# We need to process the arguments to extract the input
# files so that we can prepend a prologue file that defines
# LaserWriter-specific stuff as well as to insert and error
# handler that generates ASCII diagnostic messages when
# a problem is encountered in the interpreter.
#
# NB: this shell script is assumed to be run from the
#     top of the spooling hierarchy -- s.t. the etc directory
#     is present.

test -f etc/setup.cache || {
    SPOOL=`pwd`
    cat<<EOF

FATAL ERROR: $SPOOL/etc/setup.cache is missing!

The file $SPOOL/etc/setup.cache is not present.  This
probably means the machine has not been setup using the faxsetup(8C)
command.  Read the documentation on setting up HylaFAX before you
startup a server system.

EOF
    exit 1
}
. etc/setup.cache

PS=$DPSRIP

jobid=
fil=
opt=
while test $# != 0
do case "$1" in
    -i)	shift; jobid=$1 ;;
    -o)	shift; opt="$opt -o $1" ;;
    -l)	shift; opt="$opt -l $1" ;;
    -w)	shift; opt="$opt -w $1" ;;
    -r)	shift; opt="$opt -r $1" ;;
    -m) shift;;				# NB: not implemented
    -*)	opt="$opt $1" ;;
    *)	fil="$fil $1" ;;
    esac
    shift
done
test -z "$fil" && fil="-"		# read from stdin

test -x $PS || {
    cat<<EOF

The DPS-based PostScript RIP does not exist on the server machine
or is not located at the expected location:

    $PS

This indicates that you do not have hylafax.sw.dpsrip installed on
the system or that it is installed in a nonstandard location.  This
must be corrected before a PostScript document can be transmitted.

EOF
    exit 254;				# cause document to be rejected
}

#
# The sed work fixes bug in Windows-generated
# PostScript that causes certain international
# character marks to be placed incorrectly.
#
#    | $SED -e 's/yAscent Ascent def/yAscent 0 def/g' \
#
# NB: unfortunately it appears to break valid PostScript;
#     so it's been disabled.
#

#
# Apply customizations such as watermarking.   
#
if [ -f etc/FaxModify ]; then
    . etc/FaxModify
fi

$CAT etc/dpsprinter.ps $fil | $PS $opt
if [ $? -eq 2 ]; then
    OS=`uname -r`
    if expr $OS \>= 6.2 >/dev/null; then
	cat<<EOF

The DPS-based PostScript RIP is a COFF executable and cannot be used
under IRIX $OS.  You must use a different RIP such as hylafax.sw.gsrip
which is based on the freely distributed Ghostscript software distribution.

EOF
	exit 254;			# cause document to be rejected
    fi
fi
