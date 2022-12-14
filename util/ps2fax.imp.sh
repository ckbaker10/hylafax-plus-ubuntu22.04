#! /usr/bin/bash
#	$Id: ps2fax.imp.sh.in 750 2008-01-09 06:40:36Z faxguy $
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
# Convert PostScript to facsimile using Impressario 2.0-based RIP for IRIX.
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

PS=$IMPRIP
DSO_DIR=$LIBEXEC

pagewidth=1728		# standard fax width
pagelength=297		# default to A4 
vres=98			# default to low res
out=ps.fax		# default output filename

jobid=
fil=
opt=
while test $# != 0
do case "$1" in
    -i)	shift; jobid="$1" ;;
    -o)	shift; out="$1" ;;
    -l)	shift; pagelength="$1" ;;
    -w)	shift; pagewidth="$1" ;;
    -r)	shift; vres="$1" ;;
    -m) shift;;				# NB: not implemented
    -1) ;;
    -2) opt="$opt -o 2d" ;;
    *)	fil="$fil $1" ;;
    esac
    shift
done

test -x $PS || {
    $CAT<<EOF

The Impressario PostScript RIP does not exist on the server machine
or is not located at the expected location:

    $PS

This indicates that you either do not have Impressario installed on
the system or that it is installed in a nonstandard location.

EOF
    exit 254;				# cause document to be rejected
}
test -r $DSO_DIR/fax.so || {
    $CAT<<EOF

The FAX back-end for the Impressario PostScript RIP does not exist
on the server machine or is not located at the expected location:

    $DSO_DIR/fax.so

This indicates the Impressario 2.0 FAX back-end provided for use with
HylaFAX was not installed on the server system (hylafax.sw.imprip).

EOF
    exit 254;				# cause document to be rejected
}

#
# Calculate raster image height based on page length
# and vertical resolution.
#
pageheight=`expr "$pagelength" \* "$vres" \* 10 / 255 2>/dev/null`

#
# Apply customizations such as watermarking.   
#
if [ -f etc/FaxModify ]; then
    . etc/FaxModify
fi

#
# Force temp/scratch files away from the normal place
# in the spooling area in case we are using the RIP on
# a system w/o the rest of Impressario
#
PSRIPTMPDIR=tmp; export PSRIPTMPDIR

exec 2>&1				# capture error messages
$PS -b $DSO_DIR -C fax \
    -X 204 -Y "$vres" \
    -W "$pagewidth" -H "$pageheight" \
    -I etc/dpsprinter.ps \
    -O $out \
    $opt -S \
    $fil
