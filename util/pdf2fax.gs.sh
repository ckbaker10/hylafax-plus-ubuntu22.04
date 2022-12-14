#! /usr/bin/bash
#	$Id: pdf2fax.gs.sh.in 993 2010-04-27 02:15:27Z faxguy $
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
# Convert PDF to facsimile using Ghostscript.
#
# pdf2fax [-o output] [-l pagelength] [-w pagewidth]
#	[-r resolution] [-m maxpages] [-*] [file ...]
#
# We need to process the arguments to extract the input
# files so that we can prepend a prologue file that sets
# up a non-interactive environment.
#
# NB: this shell script is assumed to be run from the
#     top of the spooling hierarchy -- s.t. the etc directory
#     is present.
#

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
. bin/common-functions

PS=$GSRIP

jobid=
files=
out=pdf.fax		# default output filename
pagewidth=1728		# standard fax width
pagelength=297		# default to A4 
vres=98			# default to low res
device=			# to know if it was never specified
unlimitedlength=no	# default to fixed length-pages
color=no		# default to monochrome-only
opt=
df=

while test $# != 0
do
    case "$1" in
    -i)	shift; jobid="$1" ;;
    -o)	shift; out="$1" ;;
    -w) shift; pagewidth="$1"; opt="$opt -w $1" ;;
    -l) shift; pagelength="$1"; opt="$opt -l $1" ;;
    -r) shift; vres="$1"; opt="$opt -r $1" ;;
    -m) shift;;				# NB: not implemented
    -U) unlimitedlength=yes; opt="$opt $1" ;;
    -1) device=tiffg3; opt="$opt $1"; df="g3:1d" ;;
    -2) ($PS -h | grep tiffg32d >/dev/null 2>&1) \
	    && { device=tiffg32d; } \
	    || { device=tiffg3; }
	opt="$opt $1"; df="g3:2d" ;;
    -3) ($PS -h | grep tiffg4 >/dev/null 2>&1) \
	    && { device=tiffg4; } \
	    || { device=tiffg3; }
	opt="$opt $1"; df=g4
	;;
    -color) ($PS -h | grep tiff24nc >/dev/null 2>&1) \
	    && { color=yes; }
	;;
    -*)	;;
    *)	files="$files $1" ;;
    esac
    shift
done

if [ -z "$device" ]; then
    if [ "$color" = "yes" ]; then
	device=tiff24nc
    else
	device=tiffg3;
    fi
fi

gs2fax pdf

exit 0
