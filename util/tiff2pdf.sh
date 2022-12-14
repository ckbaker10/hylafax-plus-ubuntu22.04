#! /usr/bin/bash
#	$Id: tiff2pdf.sh.in 984 2010-02-12 04:45:15Z faxguy $
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

#  01/03/2004  Frank Brock
#
# Convert TIFF to pdf as needed.
#  the tiff2pdf that is part of ghostscript seems to choke on many tiffs 
#  without a bunch of help.  So, I extracted most of the code here from
#  faxrcvd and dropped it into a script.  So, that section of faxrcvd 
#  could eventually be simplified by also using this script.
#
# tiff2pdf [-o output] file ...
#
# NB: This script converts tiff files to pdf files instead of
#     using the ghostscript tiff2pdf which seems to blow up man times

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

# These settings may not be present in setup.cache if user upgraded and
# didn't re-run faxsetup; we set them before calling setup.cache for
# backward compatibility.
ENCODING=base64
MIMENCODE=mimencode
TTYCMD=tty

. etc/setup.cache

TIFFINFO=$TIFFBIN/tiffinfo
TIFF2PS=$TIFFBIN/tiff2ps
PS2PDF=ps2pdf

if $TTYCMD >/dev/null 2>&1; then
    ERRORSTO=`$TTYCMD`
else
    ERRORSTO=/dev/null
fi

tmpps=tmp/foo$$.ps
out=tmp/foo.pdf				# default output filename
FILE=
opt=
while test $# != 0
do case "$1" in
    -o)	shift; out=$1 ;;
    *)	FILE="$FILE $1" ;;
    esac
    shift
done
test -z "$FILE" && {
    echo "$0: No input file specified."
    exit 255
}

GW=`$TIFFINFO $FILE 2>$ERRORSTO | $GREP "Image Width" | \
    $SED 's/.*Image Width: \([0-9]*\).*/\1/g' | sort -n | $SED -n '$p'`
GL=`$TIFFINFO $FILE 2>$ERRORSTO | $GREP "Image Length" | \
    $SED 's/.*Image Length: \([0-9]*\).*/\1/g' | sort -n | $SED -n '$p'`
RES=`$TIFFINFO $FILE 2>$ERRORSTO | $AWK 'BEGIN {rw0=rl0=0;}
/Resolution:/ { rw=$2; rl=$3; unit=$4;
   if(unit ~ /cm/) { rw *= 2.54; rl *= 2.54; }
   if(rw > rw0) { rw0=rw;}
   if(rl > rl0) { rl0=rl;}}
END { printf "%dx%d", rw0+0.5, rl+0.5;}' 2>$ERRORSTO`
$TIFF2PS -a -O $tmpps $FILE > $ERRORSTO 2>&1     # fax2ps output looks bad
$PS2PDF -g$GW\x$GL -r$RES $tmpps $out > $ERRORSTO 2>&1

$RM -f $tmpps 2>$ERRORSTO

