#! /usr/bin/bash
#	$Id: pollrcvd.sh.in 984 2010-02-12 04:45:15Z faxguy $
#
# ============================================
#
# A NOTE ON CUSTOMIZING this script:
#
# You are welcome (even encouraged) to customize this script to suit the
# needs of the deployment.  However, be advised that this script is
# considered part of the package distribution and is subject to being
# overwritten by subsequent upgrades.  Please consider copying this file
# to something like "etc/pollrcvd-custom", modifying that copy of the file,
# and then setting "PollRcvdCmd: etc/pollrcvd-custom" in your modem config
# file to prevent your customizations from being overwritten during an
# upgrade process.
#
# ============================================
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

. bin/common-functions

#
# pollrcvd mailaddr faxfile devID commID error-msg
#
if [ $# != 5 ]
then
    echo "Usage: $0 mailaddr faxfile devID commID error-msg"
    hfExit 1
fi

#
# If you want to change the presentation of the e-mail notification
# then this is the place to change that.  We put it here, up-front,
# because this is most likely what most customizations will deal with.
#
pollrcvd_mail()
{
    MAILTO="$1"
    ATTACHFILE="$2"
    CCTO="$3"
    BCCTO="$4"

   (echo "Mime-Version: 1.0"
    echo "Content-Type: Multipart/Mixed; Boundary=\"$MIMEBOUNDARY\""
    echo "Content-Transfer-Encoding: 7bit"
    echo "To: $MAILTO"
    if [ -n "$CCTO" ]; then echo "Cc: $CCTO"; fi
    printf "From: "
    printf "$DICTRECEIVEAGENT" | LANG=C $AWK -f bin/rfc2047-encode.awk -v charset="$CHARSET"
    echo " <$FROMADDR>"
    printf "Subject: "
    ( eval echo "$DICTRETRIEVEDFROM" ) | LANG=C $AWK -f bin/rfc2047-encode.awk -v charset="$CHARSET"; echo
    echo ""
    echo "--$MIMEBOUNDARY"
    echo "Content-Type: text/plain; charset=$CHARSET"
    echo "Content-Transfer-Encoding: quoted-printable"
    echo ""
    (
     echo "$FILE (ftp://$HOSTNAME:$PORT/$FILE):";
     faxInfo $FILE
     echo "$DICTRECEIVEDON| $DEVICE" | printFormatted $INFOSIZE
     if [ -z "$MSG" ]; then
	echo "$DICTCOMMID| c$COMMID (ftp://$HOSTNAME:$PORT/log/c$COMMID)" | printFormatted $INFOSIZE
     fi
     if [ "$ATTACHFILE" != "yes" ] || [ ! -f $FILE ]; then
	if [ -n "$MAILADDR" ]; then
	    echo ""
	    eval echo "$DICTPOLLDISPATCHTO"
	fi
     fi
    ) | LANG=C $AWK -f bin/qp-encode.awk
    if [ "$MSG" ]; then
	(
	 echo ""
	 if [ -f $FILE ]; then
	    echo "$DICTMSGINTRO"
	 else
	    eval echo "$DICTATTEMPTEDPOLLFAILED"
	 fi
	 echo ""
	 echo "    $ERRMSG"
	 echo ""
	 echo "$DICTLOGFOLLOWS"
	 echo ""
	) | LANG=C $AWK -f bin/qp-encode.awk
	if [ -f log/c$COMMID ]; then
	    echo ""
	    echo "--$MIMEBOUNDARY"
	    echo "Content-Type: text/plain; charset=US-ASCII; name=c$COMMID"
	    echo "Content-Description: FAX session log"
	    echo "Content-Transfer-Encoding: 7bit"
	    echo "Content-Disposition: inline"
	    echo ""
	    sed -e '/-- data/d' \
		-e '/start.*timer/d' -e '/stop.*timer/d' \
		log/c$COMMID
	elif [ -n "$COMMID" ]; then
	    ( echo "$DICTNOLOGAVAIL ($DICTCOMMID c$COMMID)." ) | LANG=C $AWK -f bin/qp-encode.awk
	else
	    ( echo "$DICTNOLOGAVAIL." ) | LANG=C $AWK -f bin/qp-encode.awk
	fi
    fi
    if [ "$ATTACHFILE" = "yes" ] && [ -f $FILE ]; then
	for type in $FILETYPE; do
	    echo ""
	    echo "--$MIMEBOUNDARY"
	    if [ "$type" = "tif" ]; then
		echo "Content-Type: image/tiff; name=\"$FILENAME.tif\""
		echo "Content-Description: FAX document"
		echo "Content-Transfer-Encoding: $ENCODING"
		echo "Content-Disposition: attachment; filename=\"$FILENAME.tif\""
		echo ""
		encode $FILE
	    elif [ "$type" = "pdf" ]; then
		echo "Content-Type: application/pdf; name=\"c$COMMID.pdf\""
		echo "Content-Description: FAX document"
		echo "Content-Transfer-Encoding: $ENCODING"
		echo "Content-Disposition: attachment; filename=\"c$COMMID.pdf\""
		echo ""
		$TIFF2PDF -o $FILE.pdf $FILE
		encode $FILE.pdf
		$RM -f $FILE.pdf 2>$ERRORSTO   
	    elif [ "$type" = "ps" ]; then
		echo "Content-Type: application/postscript; name=\"$FILENAME.ps\""
		echo "Content-Description: FAX document"
		echo "Content-Transfer-Encoding: 7bit"
		echo "Content-Disposition: attachment; filename=\"$FILENAME.ps\""
		echo ""
		$TIFF2PS -a $FILE 2>$ERRORSTO
	    fi
	done
    fi
    echo ""
    echo "--$MIMEBOUNDARY--"
   ) 2>$ERRORSTO | $SENDMAIL -ffax -oi "$MAILTO" "$CCTO" "$BCCTO"
}

test -f etc/setup.cache || {
    SPOOL=`pwd`
    cat<<EOF

FATAL ERROR: $SPOOL/etc/setup.cache is missing!

The file $SPOOL/etc/setup.cache is not present.  This
probably means the machine has not been setup using the faxsetup(8C)
command.  Read the documentation on setting up HylaFAX before you
startup a server system.

EOF
    hfExit 1
}

# These settings may not be present in setup.cache if user upgraded and
# didn't re-run faxsetup; we set them before calling setup.cache for
# backward compatibility.
ENCODING=base64
MIMENCODE=mimencode
TIFF2PDF=bin/tiff2pdf
TTYCMD=tty
CHARSET=UTF-8		# this really gets set in dictionary

. etc/setup.cache

INFO=$SBIN/faxinfo
FAX2PS=$TIFFBIN/fax2ps
TIFF2PS=$TIFFBIN/tiff2ps
TOADDR=FaxMaster
TIFFINFO=$TIFFBIN/tiffinfo
FROMADDR=fax
MIMEBOUNDARY="NextPart$$"

# 
# Redirect errors to a tty, if possible, rather than
# dev-nulling them or allowing them to creep into
# the mail.
# 
if $TTYCMD >/dev/null 2>&1; then
    ERRORSTO=`$TTYCMD`
else
    ERRORSTO=/dev/null
fi

#
# Permit various types of attachment types: ps, tif, pdf
# Note that non-ASCII filetypes require metamail.
# pdf requires tiff2ps and tiff2pdf
# 
FILETYPE=ps

#
# There is no good portable way to find out the fully qualified
# domain name (FQDN) of the host or the TCP port for the hylafax
# service so we fudge here.  Folks may want to tailor this to
# their needs; e.g. add a domain or use localhost so the loopback
# interface is used.
#
HOSTNAME=`hostname`                     # XXX no good way to find FQDN
PORT=4559                               # XXX no good way to lookup service

MAILADDR="$1"
FILE="$2"
DEVICE="$3"
COMMID="$4"
MSG="$5"

FILENAME=`echo $FILE | $SED -e 's/\.tif//' -e 's/recvq\///'`

SetupPrivateTmp

if [ -f $FILE ]; then
    SENDER="`$INFO $FILE | $AWK -F: '/Sender/ { print $2 }' 2>/dev/null`"
fi
if [ -f etc/PollDispatch ]; then
    . etc/PollDispatch       # NB: PollDispatch allows customization
fi
# 
# Fetch language settings (after FaxDispatch for customization of $LANG).
# 
. bin/dictionary
if [ -f etc/FaxDictionary ]; then
    . etc/FaxDictionary
fi

#
# Customize error message.
#
ERRNUM=`echo $MSG | sed 's/.*{\([^}]*\)}$/\1/g'`
if [ "$ERRNUM" != "$MSG" ]; then
    eval ERRMSG="$"`echo $ERRNUM`
    if [ -z "$ERRMSG" ]; then
	ERRMSG="$MSG"
    fi
else
    ERRNUM=
    ERRMSG="$MSG"
fi

setInfoSize $FILE

if [ "$TOADDR" != "$MAILADDR" ]; then # don't send FaxMaster duplicate
    pollrcvd_mail "$TOADDR" "no" "" ""
fi
if [ -n "$MAILADDR" ] && [ -f $FILE ]; then
    pollrcvd_mail "$MAILADDR" "yes" "$CCTO" "$BCCTO"
fi
