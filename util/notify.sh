#! /usr/bin/bash
#    $Id: notify.sh.in 984 2010-02-12 04:45:15Z faxguy $
#
# ============================================
#
# A NOTE ON CUSTOMIZING this script:
#
# You are welcome (even encouraged) to customize this script to suit the
# needs of the deployment.  However, be advised that this script is
# considered part of the package distribution and is subject to being
# overwritten by subsequent upgrades.  Please consider copying this file
# to something like "etc/notify-custom", modifying that copy of the file,
# and then setting "NotifyCmd: etc/notify-custom" in your faxq config
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
#   2004/02/28  Frank Brock
#
# The notify shell now behaves in a manner like faxrcvd.  
# It is now written in shell with a little embedded awk as needed.

. bin/common-functions

#
# notify qfile why jobtime [nextTry]
#
# Return mail to the submitter of a job when notification is needed.
#
if [ $# != 3 ] && [ $# != 4 ]; then
    echo "Usage: $0 qfile why jobtime [nextTry]"
    hfExit 1
fi

#
# If you want to change the presentation of the e-mail notification
# then this is the place to change that.  We put it here, up-front,
# because this is most likely what most customizations will deal with.
#
notify_mail()
{
    MAILSUBJECT="$1"
    MAILTO="$2"

   (echo "MIME-Version: 1.0"
    echo "Content-Type: Multipart/Mixed; Boundary=\"$MIMEBOUNDARY\""
    echo "Content-Transfer-Encoding: 7bit"
    echo "To: $MAILTO"
    echo "From: $FROMADDR"
    (
	header_field='Subject:' &&
	printf '%s' "$header_field" &&
	columns_used="${#header_field}" &&
	rfc2047_encode "$columns_used" "$CHARSET" "$MAILSUBJECT" columns_used
    )
    echo
    echo ""
    echo "This is a multi-part message in MIME format."
    echo ""
    echo "--$MIMEBOUNDARY"
    echo "Mime-Version: 1.0"
    echo "Content-Type: text/plain; charset=$CHARSET"
    echo "Content-Transfer-Encoding: quoted-printable"
    echo ""
    (
    if [ -z "$THISJOBTYPE" ]; then
	printf "$jobtag $DICTTO $number"
    else
	eval printf \"$DICTYOURJOBTO\"
    fi
    if [ "$WHY" = "done" ]; then
	echo "$DICTCOMPLETEDSUCCESSFULLY"
	echo ""
    else
	case "$WHY" in
	    failed)
		printf " $DICTFAILEDBECAUSE\n    "
		echo "$FAXSTATUSMSG";;
	    rejected)
		printf " $DICTREJECTEDBECAUSE\n    "
		echo "$FAXSTATUSMSG";;
	    blocked)
		printf " $DICTDELAYEDBECAUSE\n    "
		echo "$FAXSTATUSMSG"
		echo ""
		echo "$DICTASSOONASPOSSIBLE";;
	    requeued)
		printf " $DICTWASNOTSENT\n    "
		echo "$FAXSTATUSMSG"
		echo ""
		echo "$DICTWILLBERETRIED $NEXT.";;
	    killed|removed)
		echo " $DICTWASDELETED";;
	    timedout)
		echo " $DICTTIMEDOUT";;
	    format_failed)
		echo " $DICTCONVERSION1"
		echo "$DICTCONVERSION2"
		echo ""
		echo "$FAXSTATUSMSG"
		echo ""
		echo "$DICTCONVERSION3";;
	    no_formatter)
		echo " $DICTNOFORMATTER1"
		echo "$DICTNOFORMATTER2";;
	    poll_*)
		printf "$DICTPOLLINGFAILED"
		if [ "$WHY" = "poll_rejected" ] ; then
		    echo "$DICTREMOTEREJECTED"
		elif [ "$WHY" = "poll_no_document" ] ; then
		    echo "$DICTNODOCTOPOLL"
		elif [ "$WHY" = "poll_failed" ] ; then
		    echo "$DICTUNSPECIFIEDPROBLEM"
		fi;;
	    *)
		echo " $DICTUNKNOWNREASON1"
		echo "$DICTUNKNOWNREASON2"
		echo "$DICTUNKNOWNREASON3"
		echo ""
		echo "why: $WHY"
		echo "jobTime: $JTIME"
		echo "nextTry: $NEXT"
		echo  ""
		echo "$DICTUNKNOWNREASON4";;
	esac
	echo ""
	echo "    ---- $DICTUNSENTJOBSTATUS ----"
	echo ""
    fi
    echo "$DICTDESTINATION| $number" | printFormatted $ITEMSIZE
    echo "$DICTSENDER| $sender" | printFormatted $ITEMSIZE
    echo "$DICTMAILADDR| $mailaddr" | printFormatted $ITEMSIZE
    if [ "$jobtype" = "facsimile" ] ; then
	if [ "$npages" -gt 0 ]; then
	    echo "$DICTPAGES| $npages" | printFormatted $ITEMSIZE
	fi
	if [ -n "$faxstatus" ] && [ -n "$dirnum" ]; then
	    echo  "$DICTDIRNUM| $dirnum ($DICTDIRNEXTPAGE)" | printFormatted $ITEMSIZE
	fi
	if [ -n "$csi" ]; then
	    echo "$DICTRECEIVER| $csi" | printFormatted $ITEMSIZE
	fi
        if [ "$RETURNTECHINFO" = "yes" ] && [ "$totdials" -gt 0 ]; then
	    case "$resolution" in
		196) echo "$DICTQUALITY| $DICTFINE" | printFormatted $ITEMSIZE;;
		98) echo "$DICTQUALITY| $DICTNORMAL" | printFormatted $ITEMSIZE;;
		*) echo "$DICTRES| $resolution (lpi)" | printFormatted $ITEMSIZE;;
            esac
            echo "$DICTPAGEWIDTH| $pagewidth (mm)" | printFormatted $ITEMSIZE
            echo "$DICTPAGELENGTH| $pagelength (mm)" | printFormatted $ITEMSIZE
            echo "$DICTSIGNALRATE| $signalrate" | printFormatted $ITEMSIZE
            echo "$DICTDATAFORMAT| $dataformat" | printFormatted $ITEMSIZE
	    if [ -n "$equipment" ]; then
		echo "$DICTREMOTEEQUIPMENT| $equipment" | printFormatted $ITEMSIZE
	    fi
	    if [ -n "$station" ]; then
		echo "$DICTREMOTESTATION| $station" | printFormatted $ITEMSIZE
	    fi
        fi
    fi
    if [ "$RETURNTECHINFO" = "yes" ] ; then
        if [ "$tottries" != "1" ] ; then 
            echo "$DICTDIALOGS| $tottries ($DICTREMOTEEXCHANGES)" | printFormatted $ITEMSIZE
        fi
        if [ "$totdials" != "1" ] ; then 
            echo "$DICTCALLS| $totdials ($DICTTOTALCALLS)" | printFormatted $ITEMSIZE
        fi
	if [ "$ndials" != "0" ]; then
	    echo "$DICTDIALS| $ndials ($DICTFAILEDCALLS)" | printFormatted $ITEMSIZE
	fi
	echo "$DICTMODEM| $modemused" | printFormatted $ITEMSIZE
	if [ -n "$faxstatus" ]; then
	    echo "$DICTSTATUS| $FAXSTATUSMSG" | printFormatted $ITEMSIZE
	fi
        echo "$DICTSUBMITTEDFROM| $client" | printFormatted $ITEMSIZE
        echo "$DICTJOBID| $jobid" | printFormatted $ITEMSIZE
        echo "$DICTGROUPID| $groupid" | printFormatted $ITEMSIZE
	if [ -n "$commid" ]; then
            echo "$DICTCOMMID| c$commid" | printFormatted $ITEMSIZE
	fi
	if [ -n "$JTIME" ]; then
	    printf "\n$DICTPROCESSINGTIME %s.\n" "$JTIME"
	fi
    fi
    if [ "$jobtype" = "facsimile" ]; then
	if [ $nfiles -gt 0 ] && [ "$RETURNTECHINFO" = "yes" ] ; then
	    echo ""
	    echo "    ---- $DICTDOCSSUBMITTED ----"
	    echo ""
            eval echo "$DICTDOCSTEXT1"
            eval echo "$DICTDOCSTEXT2"
            eval echo "$DICTDOCSTEXT3"
            eval echo "$DICTDOCSTEXT4"
            echo ""
            printf "%-20s %8s %s\n" "$DICTFILENAME" "$DICTSIZE" "$DICTTYPE"
            for i in `local_seq 1 $nfiles`; do
                name="files_$i"
                eval filename=`echo "$"$name`
                if [ -f $filename ] ; then
                        set - `wc -c "$filename"`
                    FILESIZE=$1
                    type="filetype_$i"
                    eval filetype=`echo "$"$type`
                    #
                    # Because Ghostscript accepts PDF identically to PostScript
                    # and because HylaFAX has historically handled PDF named as
                    # "postscript" we have to double-check the PostScript filetype.
                    #
                    if [ "$filetype" = "PostScript" ]; then
                        if [ "`fileType $filename`" != "PostScript" ]; then
                            filetype=PDF
                        fi
                    fi
                    printf "%-20s %8d %s\n" "$filename" "$FILESIZE" "$filetype"
                fi
            done
        fi
    elif [ "$jobtype" = "pager" ] && [ "$WHY" != "done" ]; then
        if [ $npins -ne 0 ] ; then
	    echo ""
	    echo "    ---- $DICTUNSENTPAGES ----"
	    echo ""
            for i in `local_seq 1 $npins`; do
                name="files_$i"
                eval pin=`echo "$"$name`
                printf "%15s\n" "$DICTPIN" $pin
            done
        fi
        if [ $nfiles -ne 0 ] && [ -s $files_0 ] ; then
	    echo ""
	    echo "    ---- $DICTMESSAGETEXT ----"
	    echo ""
            cat $files_0
        fi
    fi
    ) | LC_ALL=C $AWK -f bin/qp-encode.awk
    if [ -n "$faxstatus" ] && [ "$RETURNTRANSCRIPT" = "yes" ] ; then
	(
	 # use -e in echo to interpret escape characters in faxstatus
	 echo ""
	 echo "$DICTADDITIONALINFO"
	 echo ""
	 # we need to change the '\n' in the strings to real newlines
	 echo "     $ERRMSG" | sed -e 's/\\n/\n/g'
	 echo ""
	 echo "    ---- $DICTLOGFOLLOWS2 ----"
	 echo ""
	) | LC_ALL=C $AWK -f bin/qp-encode.awk
        COMFILE="log/c$commid"
        if [ -f "$COMFILE" ] ; then
	    echo ""
	    echo "--$MIMEBOUNDARY"
	    echo "Content-Type: text/plain; charset=US-ASCII; name=c$commid"
	    echo "Content-Description: FAX session log"
	    echo "Content-Transfer-Encoding: 7bit"
	    echo "Content-Disposition: inline"
	    echo ""
            # dump the comfile to output except for '-- data' lines
            cat $COMFILE | $SED -e '/-- data/d' \
		-e '/start.*timer/d' -e '/stop.*timer/d'
        else 
	    (
             printf "$DICTNOLOGAVAIL"
             if [ -n "$commid" ] ; then  # non 0 len commid value
                    printf "($DICTCOMMID c$commid)"
             fi
             echo "."
	    ) | LC_ALL=C $AWK -f bin/qp-encode.awk
        fi
    fi
    for type in $RETURNFILETYPE; do 
	if [ $nfiles -gt 0 ] ; then
	    for i in `local_seq 1 $nfiles`; do 
		name="files_$i"
		eval filename=`echo "$"$name`
		if [ -s $filename ] ; then # file is > 0 size
		    ftype="filetype_$i"
		    eval FROMFMT=`echo "$"$ftype`
		    #
		    # Because Ghostscript accepts PDF identically to PostScript
		    # and because HylaFAX has historically handled PDF named as
		    # "postscript" we have to double-check the PostScript filetype.
		    #
		    if [ "$FROMFMT" = "PostScript" ]; then
			if [ "`fileType $filename`" != "PostScript" ]; then
			    FROMFMT=PDF
			fi
		    fi
		    FILEEXTEN="$type"
		    if [ "$FILEEXTEN" = "original" ]; then
			case "$FROMFMT" in
			    "TIFF") FILEEXTEN=tif;;
			    "PostScript") FILEEXTEN=ps;;
			    "PDF") FILEEXTEN=pdf;;
			esac
		    fi
		    MIMETYPE="application/octet-stream"
		    case "$FILEEXTEN" in
			tif) MIMETYPE="image/tiff";;
			ps) MIMETYPE="application/postscript";;
			pdf) MIMETYPE="application/pdf";;
		    esac
		    echo ""
		    echo "--$MIMEBOUNDARY"
		    echo "Content-Type: $MIMETYPE; name=\"$number-$i.$FILEEXTEN\""
		    echo "Content-Description: FAX document"
		    echo "Content-Transfer-Encoding: $ENCODING"
		    echo "Content-Disposition: attachment; filename=\"$number-$i.$FILEEXTEN\""
		    echo ""
		    case "$FILEEXTEN" in
			tif) putTifEncodedImage "$filename" "$FROMFMT";;
			ps) putPsEncodedImage "$filename" "$FROMFMT";;
			pdf) putPdfEncodedImage "$filename" "$FROMFMT";;
			*) encode "$filename";;
		    esac
	        fi
	    done
	fi
    done
    # put out a terminating MIME boundary
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

# need to parse out the command line here.  some may be needed
# in the FaxNotify.
QFILE=$1
WHY=$2
JTIME=$3
NEXT=${4:-'??:??'}

# These settings may not be present in setup.cache if user upgraded and
# didn't re-run faxsetup; we set them before calling setup.cache for
# backward compatibility.
ENCODING=base64
MIMENCODE=mimencode
TIFF2PDF=bin/tiff2pdf
TTYCMD=tty
CHARSET=UTF-8		# this really gets set in dictionary

. etc/setup.cache

local_seq() {
	if [ $1 -gt $2 ]; then
		return
	fi
	COUNT=$1
	while [ $COUNT -le $2 ]
	do
		echo $COUNT
		COUNT=`expr $COUNT + 1`

	done
}

INFO=$SBIN/faxinfo
TIFFINFO=$TIFFBIN/tiffinfo
FAX2PS=$TIFFBIN/fax2ps
TIFF2PS=$TIFFBIN/tiff2ps
PS2PDF=ps2pdf
PDF2PS=pdf2ps
PS2FAX=bin/ps2fax
PDF2FAX=bin/pdf2fax
TOADDR=FaxMaster
FROMADDR=fax
NOTIFY_FAXMASTER=never
RETURNFILETYPE=
MIMEBOUNDARY="NextPart$$"
RETURNTECHINFO=yes

case $WHY in
    failed|requeued|poll_rejected|poll_no_document|poll_failed)
	RETURNTRANSCRIPT=yes;;
    *)
	RETURNTRANSCRIPT=no;;
esac
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

adjustNotifyFaxMaster()
{
#  Determine what NOTIFY_FAXMASTER should be set to based
#  on the current value of NOTIFY_FAXMASTER and on other
#  attributes set about this notification.
#  NOTIFY_FAXMASTER can be set to
#    yes - send everything
#    no - send nothing
#    errors - send only failed type faxes that are not from busy, no answer or no carrier
#    always - send everything
#    never - send nothing
#
# known $WHY values we can test to set NOTIFY_FAXMASTER are
# "done" "failed" "rejected" "blocked" "requeued" "removed" "killed" "timedout"
# "format_failed" "no_formatter" "poll_rejected" "poll_no_document" "poll_failed"
    case $NOTIFY_FAXMASTER in
        never|no) NOTIFY_FAXMASTER=no;;
        always|yes) NOTIFY_FAXMASTER=yes;;
        errors) 
            case $WHY in
                timedout|rejected|format_failed|no_formatter|poll_rejected|poll_no_document)
		    NOTIFY_FAXMASTER=yes;;
		"done"|blocked|removed|killed)
		    NOTIFY_FAXMASTER=no;;
                *)
                    if (match "$faxstatus" "Busy signal") || (match "$faxstatus" "No answer") || (match "$faxstatus" "No carrier"); then
                        NOTIFY_FAXMASTER=no
                    else 
                        NOTIFY_FAXMASTER=yes
                    fi;;
            esac;;
        *) NOTIFY_FAXMASTER=no;;
    esac
}

setCustomValues()
{
    #
    # Apply customizations.  All customizable variables should
    # be set to their non-customized defaults prior to this.
    #
    if [ -f etc/FaxNotify ]; then
        # source notify preferences
        . etc/FaxNotify
    fi

    #
    # Language settings...
    #
    . bin/dictionary
    if [ -f etc/FaxDictionary ]; then
	. etc/FaxDictionary
    fi

    #
    #  Customize error message.
    #
    if [ -n "$errorcode" ]; then
	eval ERRMSG="$"`echo $errorcode`
	if [ -z "$ERRMSG" ]; then
	    ERRMSG="$faxstatus"
	fi
    else
	ERRMSG="$faxstatus"
    fi

    setItemSize
}

fileType()
# determine the type of file passed using the unix 'file' command
# with the '-i' option (mime type output)
{
    FILENAME=$1
    if [ -f "$FILENAME" ] ; then
	FILETYPE=`file $FILENAME`
        if (match "$FILETYPE" "postscript") ; then 
            echo "PostScript"
        elif (match "$FILETYPE" "tiff") ; then 
            echo "TIFF"
        elif (match "$FILETYPE" "pdf") ; then 
            echo "PDF"
        else
            echo "$DICTUNKNOWNDOCTYPE"
        fi
    else
        echo "$DICTNOFILEEXISTS"
    fi
}

putPdfEncodedImage()
# Convert the source file from the CONVERTFROM type into a pdf file and 
# then do a mimeEndode of the file
{
    SOURCEFILE=$1
    CONVERTFROM=$2
    OUTFILE="tmp/conv2pdf$$.out" ;
    if [ "$CONVERTFROM" = "PDF" ] ; then
        encode "$SOURCEFILE"
        return # all done here
    elif [ "$CONVERTFROM" = "TIFF" ] ; then
        CONVERTCMD="$TIFF2PDF -o $OUTFILE $SOURCEFILE" 
    elif [ "$CONVERTFROM" = "PostScript" ] ; then
        local PAPERSIZE=letter
        case "${pagewidth}x${pagelength}" in
            1728x364|2592x364|3456x364) PAPERSIZE=legal;;
            2432x*|3648x*|4864x*) PAPERSIZE=a3;;
            *x296|*x297) PAPERSIZE=a4;;
            *x364) PAPERSIZE=jisb4;;
        esac
        local OPTIONS="-sPAPERSIZE=$PAPERSIZE -dOptimize=true -dEmbedAllFonts=true"
        CONVERTCMD="$PS2PDF $OPTIONS $SOURCEFILE $OUTFILE" 
    else
        return # unknow convert from format
    fi
    $CONVERTCMD > $ERRORSTO 2>&1
    encode "$OUTFILE"
    $RM -f $OUTFILE > $ERRORSTO 2>&1
}

putPsEncodedImage()
# Convert the source file from the CONVERTFROM type into a ps file and 
# then do a mimeEndode of the file
{
    SOURCEFILE=$1
    CONVERTFROM=$2
    OUTFILE="tmp/conv2ps$$.out" ;
    if [ "$CONVERTFROM" = "PostScript" ] ; then
        encode "$SOURCEFILE"
        return # all done here
    elif [ "$CONVERTFROM" = "TIFF" ] ; then
        #  tiff2ps -a for all pages, 
        CONVERTCMD="$TIFF2PS -a  $SOURCEFILE > $OUTFILE" 
    elif [ "$CONVERTFROM" = "PDF" ] ; then
        CONVERTCMD="$PDF2PS $SOURCEFILE $OUTFILE" 
    else
        return # unknow convert from format
    fi
    $CONVERTCMD > $ERRORSTO 2>&1
    encode "$OUTFILE"
    $RM -f $OUTFILE > $ERRORSTO 2>&1
}

putTifEncodedImage()
# Convert the source file from the CONVERTFROM type into a tif file and 
# then do a mimeEndode of the file
{
    SOURCEFILE=$1
    CONVERTFROM=$2
    OUTFILE="tmp/conv2tif$$.out" ;
    if [ $CONVERTFROM = "TIFF" ] ; then 
        encode "$SOURCEFILE"
        return # all done here
    elif [ $CONVERTFROM = "PDF" ] ; then 
        CONVERTCMD="$PDF2FAX -r $resolution -o $OUTFILE $SOURCEFILE" 
    elif [ $CONVERTFROM = "PostScript" ] ; then 
        CONVERTCMD="$PS2FAX -r $resolution -o $OUTFILE $SOURCEFILE" 
    else
        return # unknow convert from format
    fi
    $CONVERTCMD > $ERRORSTO 2>&1
    encode "$OUTFILE"
    $RM -f $OUTFILE > $ERRORSTO 2>&1
}

match()
#  look for substring in fullsting.  substring can be a regular expression or plain string
#  if the substring is found anywhere in the full string, true(0) is returned.
{
    FULLSTR="$1"
    SUBSTR="$2"
    echo "$FULLSTR" | $GREP -i "$SUBSTR" > /dev/null 2>&1
    if [ $? -eq 0 ] ; then
        return 0
    else
        return 1
    fi
}

##########
##  MAIN
##########

SetupPrivateTmp

#  exports used for debug tracing
#export -f putTifEncodedImage
#export -f putPdfEncodedImage
#export -f parseQfile
#export -f match
# sh -x

# we parse the q file fisrt in case any of the varialbe setting 
# operations may want to know about the details of the fax
parseQfile  

#process the FaxNotify script after parse q file in case the admin wants to 
# set any values based on what is in the q file
setCustomValues 

# adjust faxmaster notify based on some rules and what is found 
# possibly in the q file.
adjustNotifyFaxMaster 

THISJOBTYPE=""
if [ -z "$jobtag" ] ; then
    THISJOBTYPE=`eval echo "$"DICT$jobtype`
    jobtag="`eval echo $DICTJOB`"
fi
if [ "$doneop" = "default" ] ; then
    doneop="remove"
fi
if [ "$jobtype" = "pager" ] ; then
    number=$pagernum
fi
DESTINATION="$receiver"
if [ -n "$receiver" ] && [ -n "$company" ]; then
    DESTINATION="$receiver $DICTAT "
fi
DESTINATION="$DESTINATION$company"
if [ -n "$DESTINATION" ]; then
    DESTINATION="$DESTINATION ($number)"
else
    DESTINATION="$number"
fi
if [ -z "$faxstatus" ] ; then # 0 string len
    FAXSTATUSMSG="<$DICTNOREASON>"
else
    # we need to change the '\n' in the strings to real newlines
    FAXSTATUSMSG=`echo "$ERRMSG" | sed -e 's/\\n/\n/g'`
fi
case "$WHY" in
    "done")
	notify_mail "$jobtag $DICTTO $DESTINATION $DICTCOMPLETED" "$mailaddr";;
    failed)
	notify_mail "$jobtag $DICTTO $DESTINATION $DICTFAILED" "$mailaddr";;
    rejected)
	notify_mail "$jobtag $DICTTO $DESTINATION $DICTFAILED" "$mailaddr";;
    blocked)
	notify_mail "$jobtag $DICTTO $DESTINATION $DICTBLOCKED" "$mailaddr";;
    requeued)
	notify_mail "$jobtag $DICTTO $DESTINATION $DICTREQUEUED" "$mailaddr";;
    removed|killed)
	notify_mail "$jobtag $DICTTO $DESTINATION $DICTREMOVEDFROMQUEUE" "$mailaddr";;
    timedout)
	notify_mail "$jobtag $DICTTO $DESTINATION $DICTFAILED" "$mailaddr";;
    format_failed)
	notify_mail "$jobtag to $DESTINATION $DICTFAILED" "$mailaddr";;
    no_formatter)
	notify_mail "$jobtag $DICTTO $DESTINATION $DICTFAILED" "$mailaddr";;
    poll_*)
	notify_mail "$DICTNOTICEABOUT $jobtag" "$mailaddr";;
    *)
	notify_mail "$DICTNOTICEABOUT $jobtag" "$mailaddr";;
esac
if [ "$NOTIFY_FAXMASTER" = "yes" ]; then
    # make sure that FAXMASTER gets all information in email by forcing some RETURN values
    # and then reset them later
    origRETURNTRANSCRIPT=$RETURNTRANSCRIPT
    origRETURNTECHINFO=$RETURNTECHINFO
    origRETURNFILETYPE=$RETURNFILETYPE
    RETURNTRANSCRIPT="yes"
    RETURNTECHINFO="yes"
    RETURNFILETYPE=""
    if [ -z "$jobtag" ] ; then
	jobtag="$jobtype job $jobid"
    fi
    notify_mail "$jobtag to $number $WHY" "$TOADDR"
    RETURNTRANSCRIPT=$origRETURNTRANSCRIPT
    RETURNTECHINFO=$origRETURNTECHINFO
    RETURNFILETYPE=$origRETURNFILETYPE
fi
