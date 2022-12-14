#! /usr/bin/bash
#	$Id: faxrcvd.sh.in 1083 2012-02-06 17:34:27Z faxguy $
#
# ============================================
#
# A NOTE ON CUSTOMIZING this script:
#
# You are welcome (even encouraged) to customize this script to suit the
# needs of the deployment.  However, be advised that this script is
# considered part of the package distribution and is subject to being
# overwritten by subsequent upgrades.  Please consider copying this file
# to something like "etc/faxrcvd-custom", modifying that copy of the file,
# and then setting "FaxRcvdCmd: etc/faxrcvd-custom" in your modem config
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
# faxrcvd file devID commID error-msg
#
if [ $# -lt 4 ]; then
    echo "Usage: $0 file devID commID error-msg [ callID-1 [ callID-2 [ ... [ callID-n ] ] ] ]"
    hfExit 1
fi

#
# If you want to change the presentation of the e-mail notification
# then this is the place to change that.  We put it here, up-front,
# because this is most likely what most customizations will deal with.
#
faxrcvd_mail()
{
    MAILTYPE="$1"
    MAILTO="$2"
    MAILCCTO="$3"
    MAILBCCTO="$4"

   (echo "Mime-Version: 1.0"
    echo "Content-Type: Multipart/Mixed; Boundary=\"$MIMEBOUNDARY\""
    echo "Content-Transfer-Encoding: 7bit"
    echo "To: $MAILTO"
    if [ -n "$MAILCCTO" ]; then echo "Cc: $MAILCCTO"; fi
    if [ -n "$MAILBCCTO" ]; then echo "Bcc: $MAILBCCTO"; fi
    printf "From: "
    printf "$DICTRECEIVEAGENT" | LANG=C $AWK -f bin/rfc2047-encode.awk -v charset="$CHARSET"
    echo " <$FROMADDR>"
    printf "Subject: "
    (
    if [ -f "$FILE" ]; then
	eval echo "$DICTRECEIVEDFROM";
    else
	eval echo "$DICTNOTRECEIVED";
    fi
    ) | LANG=C $AWK -f bin/rfc2047-encode.awk -v charset="$CHARSET"; echo
    echo ""
    echo "--$MIMEBOUNDARY"
    echo "Content-Type: text/plain; charset=$CHARSET"
    echo "Content-Transfer-Encoding: quoted-printable"
    echo ""
    (
    if [ -f $FILE ]; then
	case "$MAILTYPE" in
	    faxmaster)
		echo "$FILE (ftp://$HOSTNAME:$PORT/$FILE):";;
	esac
	faxInfo $FILE
	echo "$DICTRECEIVEDON| $DEVICE" | printFormatted $INFOSIZE
	if [ -z "$MSG" ]; then
	    case "$MAILTYPE" in
		user)
		    echo "$DICTCOMMID| c$COMMID" | printFormatted $INFOSIZE
		    ;;
		faxmaster)
		    echo "$DICTCOMMID| c$COMMID (ftp://$HOSTNAME:$PORT/log/c$COMMID)" | printFormatted $INFOSIZE
		    if [ -f $FILE ] && [ -n "$SENDTO" ]; then
			echo ""
			eval echo "$DICTDISPATCHEDTO"
		    fi
		    ;;
	    esac
	fi
    else
	eval echo "$DICTATTEMPTEDFAXFAILED"
    fi
    ) | LANG=C $AWK -f bin/qp-encode.awk
    if [ "$MSG" ] || [ ! -f $FILE ]; then
	(
	 echo ""
	 echo "$DICTMSGINTRO"
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
	    $SED -e '/-- data/d' \
		 -e '/start.*timer/d' -e '/stop.*timer/d' \
		 log/c$COMMID
	elif [ -n "$COMMID" ]; then
	    ( echo "$DICTNOLOGAVAIL ($DICTCOMMID c$COMMID)." ) | LANG=C $AWK -f bin/qp-encode.awk
	else
	    ( echo "$DICTNOLOGAVAIL." ) | LANG=C $AWK -f bin/qp-encode.awk
	fi
    fi
    if [ -f $FILE ]; then
	if [ "$MAILTYPE" = "user" ] && [ "$FILETYPE" != "none" ]; then
	    for type in $FILETYPE; do
		echo ""
		echo "--$MIMEBOUNDARY"
		if [ "$type" = "tif" ]; then
		    echo "Content-Type: image/tiff; name=\"$FILENAME.tif\""
		    echo "Content-Description: FAX document"
		    echo "Content-Transfer-Encoding: $ENCODING"
		    echo "Content-Disposition: attachment; filename=\"$FILENAME.tif\""
		    echo ""
		    # This is useful because the majority of TIFF viewers won't
		    # be able to read JBIG compressed TIFF files, while
		    # G4 (MMR) is a much older and supported format.
		    if ($TIFFINFO $FILE | grep "JBIG" > /dev/null) then
			$TIFFCP -c g4 $FILE $FILE.g4.tif
			encode $FILE.g4.tif
			$RM -f $FILE.g4.tif 2>$ERRORSTO
		    else
			encode $FILE
		    fi
		elif [ "$type" = "pdf" ]; then
		    echo "Content-Type: application/pdf; name=\"$FILENAME.pdf\""
		    echo "Content-Description: FAX document"
		    echo "Content-Transfer-Encoding: $ENCODING"
		    echo "Content-Disposition: attachment; filename=\"$FILENAME.pdf\""
		    echo ""
		    $TIFF2PDF -o $FILE.pdf $FILE
		    encode $FILE.pdf
		    $RM -f $FILE.pdf 2>$ERRORSTO
		else #  default as Postscript
		    echo "Content-Type: application/postscript; name=\"$FILENAME.ps\""
		    echo "Content-Description: FAX document"
		    echo "Content-Transfer-Encoding: 7bit"
		    echo "Content-Disposition: attachment; filename=\"$FILENAME.ps\""
		    echo ""
		    $TIFF2PS -a $FILE 2>$ERRORSTO
		fi
	    done
	fi
    fi
    echo ""
    echo "--$MIMEBOUNDARY--"
   ) 2>$ERRORSTO | $SENDMAIL -f$FROMADDR -oi -t
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
FROMADDR=fax
TIFFINFO=$TIFFBIN/tiffinfo
TIFFCP=$TIFFBIN/tiffcp
NOTIFY_FAXMASTER=always
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
# Note that non-ASCII filetypes require an encoder.
# pdf requires tiff2ps and tiff2pdf
#
FILETYPE=ps
SENDTO=

#
# There is no good portable way to find out the fully qualified
# domain name (FQDN) of the host or the TCP port for the hylafax
# service so we fudge here.  Folks may want to tailor this to
# their needs; e.g. add a domain or use localhost so the loopback
# interface is used.
#
HOSTNAME=`hostname`			# XXX no good way to find FQDN
PORT=4559				# XXX no good way to lookup service

FILE="$1"; shift;
DEVICE="$1"; shift;
COMMID="$1"; shift;
MSG="$1"; shift;
COUNT=1
while [ $# -ge 1 ]; do
    # The eval has $1 set yet, and this forces a variable-to-variable
    # assignment, allowing us to not need to do escaping
    eval CALLID$COUNT='$1'
    shift
    COUNT=`expr $COUNT + 1`
done
CIDNUMBER="$CALLID1"
CIDNAME="$CALLID2"

FILENAME=`echo $FILE | $SED -e 's/\.tif//' -e 's/recvq\///'`
SENDER="`$INFO $FILE | $SED -n 's/ *Sender: //p' 2>$ERRORSTO`"
SUBADDR="`$INFO $FILE | $SED -n 's/ *SubAddr: //p' 2>$ERRORSTO`"

SetupPrivateTmp

if [ ! -f $FILE ] && [ -z "$MSG" ]; then
    MSG="unknown problem, file unavailable"
fi

#
# Apply customizations.  All customizable variables should
# be set to their non-customized defaults prior to this.
#
if [ -f etc/FaxDispatch ]; then
    . etc/FaxDispatch		# NB: FaxDispatch sets SENDTO
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

# Convert TIFF file format/compression from JBIG to MMR (G4) if admin
# requested for it in FaxDispatch.
# The TIFF JBIG file as saved by HylaFAX is REPLACED with a MMR (G4) version.
if [ "$RECV_DATA_CONVERSION" = "JBIG:MMR" ]; then
    if ($TIFFINFO $FILE | grep "JBIG" > /dev/null) then
	$RM -f $FILE.g4
	$TIFFCP -c g4 $FILE $FILE.g4
	if [ $? = 0 -a -s $FILE.g4 ]; then
	    # Using 'cp' and then 'rm' (instead of 'mv') preserves
	    # owner/mode of the original file (at least on Linux)
	    #cp -p $FILE $FILE.jbig.tif
	    cp $FILE.g4 $FILE
	fi
	$RM -f $FILE.g4
    fi
fi

#
# Don't send FaxMaster duplicates, and FaxMaster may not even
# want a message at all, depending on NOTIFY_FAXMASTER.
#
case $NOTIFY_FAXMASTER$MSG in
    never*)		NOTIFY_FAXMASTER=no;;
    errors)		NOTIFY_FAXMASTER=no;;
    *)		NOTIFY_FAXMASTER=yes;;
esac
if [ "$NOTIFY_FAXMASTER" != "no" ]; then
    if [ ! -f $FILE ] || [ "$TOADDR" != "$SENDTO" ]; then
	faxrcvd_mail "faxmaster" "$TOADDR" "" ""
    fi
fi
if [ -n "$SENDTO" ] && [ -f $FILE ]; then
    for toeml in $SENDTO; do
	faxrcvd_mail "user" "$toeml" "$CCTO" "$BCCTO"
    done
fi
