#! /usr/bin/bash
#    $Id: common-functions.sh.in 1159 2013-05-11 21:05:30Z faxguy $

#
# This holds various functions that are common to the
# various bin scripts.
#

#
# Produce mailable encoding for binary files.
#
encode()
{
    if [ ! -f "$1" ]; then
	return	# encode what?
    fi
    if [ -x "$MIMENCODE" ]; then
	$MIMENCODE < $1 2>$ERRORSTO
    elif [ -x "$UUENCODE" ]; then
	if [ "$ENCODING" = "base64" ]; then
	    $UUENCODE -m $1 ==== | $GREP -v "====$" 2>$ERRORSTO
	else
	    $UUENCODE $1 $1 2>$ERRORSTO
	fi
    else
	# Do not use "-x" for backward compatibility; even if it fails
	# this is last chance to encode data, so there's nothing to lose.
	$MIMENCODE < $1 2>$ERRORSTO
    fi
}

#
# For getting all of the "faxinfo" items to line up.  As the CallID tags
# can be customized we must take unmodified faxinfo output into account.
#
setInfoSize()
{
    INFOSIZE=`$INFO -n $1 | $SED 's/:.*//g' | $SED q | $AWK 'BEGIN {L=0} length>L {L=length} END {print L}'`
    for ITEM in DICTSENDER DICTPAGES DICTQUALITY DICTSIZE DICTRECEIVED \
		DICTTIMETORECV DICTSIGNALRATE DICTDATAFORMAT DICTERRCORRECT \
		DICTCALLID1 DICTCALLID2 DICTCALLID3 DICTCALLID4 DICTCALLID \
		DICTCALLID6 DICTCALLID7 DICTRECEIVEDON DICTCOMMID; do
	THISLEN="`eval echo \\\""$"$ITEM\\\" | $AWK 'BEGIN {L=0} length>L {L=length} END {print L}' | $SED 's/ //g'`"
	if [ $THISLEN -gt $INFOSIZE ]; then INFOSIZE=$THISLEN; fi
    done
}

#
# For getting all of the notify job items to line up.
#
setItemSize()
{
    ITEMSIZE=0
    for ITEM in DICTDESTINATION DICTJOBID DICTGROUPID DICTSENDER DICTMAILADDR \
		DICTCOMMID DICTMODEM DICTSUBMITTEDFROM DICTPAGEWIDTH \
		DICTPAGELENGTH DICTRES DICTSTATUS DICTDIALOGS DICTDIALS \
		DICTCALLS DICTPAGES DICTATTEMPTS DICTDIRNUM DICTRECEIVER DICTQUALITY \
		DICTPAGEWIDTH DICTPAGELENGTH DICTDATAFORMAT DICTREMOTEEQUIPMENT \
		DICTREMOTESTATION DICTSIGNALRATE; do
	THISLEN="`eval echo \\\""$"$ITEM\\\" | $AWK 'BEGIN {L=0} length>L {L=length} END {print L}' | $SED 's/ //g'`"
	if [ $THISLEN -gt $ITEMSIZE ]; then ITEMSIZE=$THISLEN; fi
    done
}

faxInfo()
{
    $INFO -n $1 | $SED -e 's/^ *//g' \
		-e "s/^ *Sender:/$DICTSENDER:/" \
		-e "s/^Pages:/$DICTPAGES:/" \
		-e "s/^Quality:/$DICTQUALITY:/" \
		-e "s/^Page:/$DICTSIZE:/" \
		-e "s/^Received:/$DICTRECEIVED:/" \
		-e "s/^TimeToRecv:/$DICTTIMETORECV:/" \
		-e "s/^SignalRate:/$DICTSIGNALRATE:/" \
		-e "s/^DataFormat:/$DICTDATAFORMAT:/" \
		-e "s/^ErrCorrect:/$DICTERRCORRECT:/" \
		-e "s/^CallID1:/$DICTCALLID1:/" \
		-e "s/^CallID2:/$DICTCALLID2:/" \
		-e "s/^CallID3:/$DICTCALLID3:/" \
		-e "s/^CallID4:/$DICTCALLID4:/" \
		-e "s/^CallID5:/$DICTCALLID5:/" \
		-e "s/^CallID6:/$DICTCALLID6:/" \
		-e "s/^CallID7:/$DICTCALLID7:/" \
		-e "s/ Yes$/ $DICTYES/" \
		-e "s/ No$/ $DICTNO/" \
		-e "s/ Normal$/ $DICTNORMAL/" \
		-e "s/ Fine$/ $DICTFINE/" \
		-e 's/:/|/' | \
		printFormatted $INFOSIZE
}

printFormatted()
{
    $AWK -F\| -v s=$1 'BEGIN { size = s; } { ilen=length($1); printf "%"size-ilen"s%s:%s\n", "",$1,$2 }'
}

#
# Export qfile content to environment
# parseQfile(prefix, filename)
# Both parameters can be omitted. Defaults to no prefix and $QFILE.
#
parseQfile()
{
    # In shell scripts, there are no special characters in hard-quoted
    # strings (quoted with (')). Single-quotes can't even be escaped
    # inside such strings and must be put outside of them. We thus replace
    # (') with ('\'') which terminates the current string, adds a single
    # quote and starts a new string.
    #
    # We no longer escape newlines, because we don't eval
    #
    # print out variable name and value so we can eval it in the shell
    #
    VAR_PREFIX="$1"
    if [ -n "$2" ] ; then
        FILENAME=$2;
    else
        FILENAME=$QFILE;
    fi
    if [ ! -f "$FILENAME" ] ; then
        return # cannot do much more without a file
    fi
    $AWK -F: '
    function p(varname,val)
    {
        gsub(/\047/, "\047\\\047\047", val);
        # mawk sees 047 as decimal 47 rather than octal, so we use the decimal
        # value of the quote character: 39.
        printf "%s%s=%c%s%c\n",var_prefix,varname,39,val,39
        printf "export %s%s\n",var_prefix,varname
    }
    BEGIN {
        var_prefix="'"$VAR_PREFIX"'";
        nfiles = 0;
        npins = 0;
    }
    /^nsf/	{ p("equipment", $3); p("station", $5); next; }
    /^external/    { p("number", $2); next; }      # override unprocessed number
    /^regarding/    { regarding = $0; sub("regarding:", "", regarding); p("regarding", regarding); next; }
    /^jobtag/    { jobtag = $0; sub("jobtag:", "", jobtag); p("jobtag", jobtag); next; }
    # status needs to be used in the shell as faxstatus since status is reserved word
    /^status:/    { status = $0; sub("status:", "", status);
              while ($0 ~ /\\\\$/ && getline > 0) {
                  sub(/\\\\$/, "\\n", status);
                  status = status $0;
              } p("faxstatus", status);
              next;
            }
    /^[!]*post/    { p("files_"++nfiles, $4); p("filetype_"nfiles, "PostScript"); next; }
    /^[!]*tiff/    { p("files_"++nfiles, $4); p("filetype_"nfiles, "TIFF"); next; }
    /^[!]*pdf/    { p("files_"++nfiles, $4); p("filetype_"nfiles, "PDF"); next; }
    /^[!]*pcl/    { p("files_"++nfiles, $4); p("filetype_"nfiles, "PCL"); next; }
    /^page:/    { p("pins_"++npins, $4); next; }
    /^data:/    { p("files_"++nfiles, $4); next; }
    /^poll/        { p("poll", " -p"); next; }
    # Only parse remaining valid lines and allows for colons to appear in the value part
    /^[a-z]+:/     { str = $0; sub($1":", "", str); p($1, str); next; }
    {printf "# Invalid line> %s\n", $0;}
    END { p("nfiles", nfiles); p("npins", npins) } ' $FILENAME > $TMPDIR/qfile-awk.sh
    . $TMPDIR/qfile-awk.sh
}

#
# Produce faxable TIFF (MH, MR, MMR) from a PDF or Postscript file.
#
gs2fax()
{
    #
    # Features and bugs can vary from version to version with Ghostscript.
    # So we need to know what version we're dealing with here.
    #
    GSMAJVER="`$PS -v | $SED q | $SED -e 's/^.*Ghostscript.* \([0-9]*\)\.\([0-9]*\).*/\1/' -e 's/^0*//'`"
    GSMINVER="`$PS -v | $SED q | $SED -e 's/^.*Ghostscript.* \([0-9]*\)\.\([0-9]*\).*/\2/' -e 's/^0*//'`"

    test -z "$files" && files="-"	# read from stdin
    case "${pagewidth}x${pagelength}" in
	1728x280|1728x279|2592x280|2592x279|3456x280|3456x279)	# 279.4mm is actually correct...
	    paper=letter;;
	1728x364|2592x364|3456x364) 
	    paper=legal;;
	*x296|*x297)			# more roundoff problems...
	    paper=a4;;
	*x364)
	    paper=b4;;
	2432x*|3648x*|4864x*)
	    paper=a3;;
	*)
	    echo "$0: Unsupported page size: $pagewidth x $pagelength";
	    exit 254;;			# causes document to be rejected
    esac
    #
    # The image must end up with a pixel width according to T.32 Table 21.
    # Ghostscript contains code to fixate A4 and letter to 1728 pixels
    # when using 196-204 dpi and tiffg3/4.  It supposedly does the same for
    # B4 but not for A3, thus the floats are needed (for A3's benefit).
    # However, this behavior does nothing for US legal as well as the myriad
    # other page sizes (other than A4, US Letter, and B4) that we sometimes
    # see.  So we have to carefully ensure that our formatting will be right.
    #
    # How we go about using Ghostscript to accomplish that requirement can 
    # be tricky, complicated, and sometimes problematic.  Depending on which 
    # Ghostcript version is being used there are various approaches in getting 
    # all pages sized properly.  We generally either use a combination of 
    # -dEPSFitPage and -dPDFFitPage, and for newer Ghostscript versions we can 
    # also use -dAdjustWidth.  These make it so that the image is resized 
    # to fit the page media and prevents page sizing within the documents from 
    # altering the command-line page-size specification.  (In the past 
    # -dFIXEDMEDIA was used for this purpose, but -dFIXEDMEDIA doesn't resize 
    # documents, it just cuts them.)  The benefit to -dAdjustWidth is that it
    # permits TIFFs to be made with pages of varied length (such as mixed letter
    # and legal).
    #
    # We use -dUseCropBox to prevent utilization of the full MediaBox (as they
    # can differ).  Remove this if there is regularly desireable content 
    # outside the CropBox.
    #
    if [ "$GSMAJVER" -eq 8 ] && [ "$GSMINVER" -eq 70 ]; then
	# There's a bug with -dUseCropBox on 8.70 when it finds no MediaBox/CropBox.
	FIXEDWIDTH=""
    else
	FIXEDWIDTH="-dUseCropBox"
    fi
    if [ "$GSMAJVER" -gt 9 ] || [ "$GSMAJVER" -eq 9 ] && [ "$GSMINVER" -ge 4 ]; then
	# We shouldn't need to use the "FitPage" options with AdjustWidth, but if we 
	# don't then some PDFs won't auto-rotate for some unknown reason. (Ghostscript
	# bug?) Unfortunately, with the "FitPage" options there is no possibility for 
	# faxes with pages of mixed lengths.  This will, for example, cause legal-sized
	# pages to be reduced to fit on A4.  As the need for mixed lengths is probably
	# less-common than the need to auto-rotate the problematic PDFs we opt to
	# serve the more common case here by default.  If mixed lengths are 
	# specifically desired then remove the "FitPage" options here and test that 
	# the input PDFs you use do not trip on the auto-rotate problem.
	FIXEDWIDTH="$FIXEDWIDTH -dEPSFitPage -dPDFFitPage -dAdjustWidth=$pagewidth"
    else
	FIXEDWIDTH="$FIXEDWIDTH -dEPSFitPage -dPDFFitPage"
    fi

    case "$paper" in
	a4)
	    case "$pagewidth" in
		2592) hres=313.65;;		# VR_300X300
		3456) hres=418.20;;		# VR_R16
		*) hres=204;;			# everything else, 1728 pixels (should be 209.10)
	    esac;;
	b4)
	    case "$pagewidth" in
		3072) hres=311.97;;		# VR_300X300
		4096) hres=415.95;;		# VR_R16
		*) hres=204;;			# everything else, 2048 pixels (should be 207.98)
	    esac;;
	a3)
	    case "$pagewidth" in
		3648) hres=311.94;;		# VR_300X300
		4864) hres=415.93;;		# VR_R16
		*) hres=207.96;;		# everything else, 2432 pixels
	    esac;;
	*)					# letter, legal
	    case "$pagewidth" in
		2592) hres=304.94;;		# VR_300X300
		3456) hres=406.59;;		# VR_R16
		*) hres=203.29;;		# everything else, 1728 pixels
	    esac;;
    esac

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
    # We must ensure that the entire page is written in a single
    # strip.  This was the default behavior before Ghostscript 8.71.
    # The default changed in the 8.71 release, so now we specify it.
    STRIPSIZE="-dMaxStripSize=0"

    #
    # Sometimes the client supplies documents which has pages which are
    # not all oriented portrait.  Because fax is typically portrait-only,
    # and because we'd prefer to fit as much of the image on the source
    # page onto the faxed page instead of cutting the image off or
    # unnecessarily shrinking the image we use a Ghostscript script
    # in order to automatically rotate the pages to portrait orientation.
    # This feature can be disabled with AUTOROTATE="" in etc/FaxModify and
    # only works for Ghostscript 8 and later.
    #
    if [ "$GSMAJVER" -gt 7 ]; then
	AUTOROTATE="bin/auto-rotate.ps"
    else
	AUTOROTATE=""
    fi

    #
    # Ghostscript's default dithering with the fax drivers is 
    # usually unsatisfactory.  So we have an option to process
    # the image through libtiff's Floyd-Steinberg dithering.
    # This will be a bit more costly on CPU and image preparation
    # time... enable it cautiously.
    #
    # An alternative to libtiff Floyd-Steinberg dithering would
    # be to use a threshold array based stochastic mask within
    # Ghostscript.  However, this alternative may perform less 
    # than ideally on unmodified Ghostscript versions prior to 8.62.
    # See: http://bugs.ghostscript.com/show_bug.cgi?id=689633
    #
    DITHERING=default

    #
    # Apply customizations such as watermarking.
    #
    if [ -f etc/FaxModify ]; then
	. etc/FaxModify
    fi

    if [ "$color" = "yes" ]; then
	# We should prepare a color image - possibly in addition to monochrome.
	# Square resolutions are mandatory per ITU T.30 Table 2 Notes 25 and 34,
	# so we use hres for vertical resolution as well.
	case "$paper" in
	    a4) chres=209.10;;		# 1728 pixels
	    b4) chres=207.98;;		# 2048 pixels
	    a3) chres=207.96;;		# 2432 pixels
	    *)  chres=203.29;;		# 1728 pixels
	esac
	outfile=$out
	if [ "$device" != "tiff24nc" ]; then
	    # Indicates color-only
	    outfile="$out.color"
	fi
	$PS -q -sDEVICE=tiff24nc -dNOPAUSE -dSAFER=true -sPAPERSIZE=$paper \
	    -dBATCH -r$chres\x$chres "-sOutputFile=$outfile" $STRIPSIZE $FIXEDWIDTH $AUTOROTATE $files
	if [ "$device" = "tiff24nc" ]; then
	    $RM -f "$out.color"
	    return
	fi
    else
	$RM -f "$out.color"
    fi
    if [ "$DITHERING" = "gs-stocht" ]; then
	$CAT $files | $PS -q \
	    -sDEVICE=$device \
	    -dNOPAUSE \
	    -dSAFER=true \
	    -sPAPERSIZE=$paper \
	    -dBATCH \
	    -r$hres\x$vres \
	    "-sOutputFile=$out" \
	    $STRIPSIZE \
	    $FIXEDWIDTH \
	    $AUTOROTATE \
	    stocht.ps -c "<< /HalftoneMode 1 >> setuserparams" -
	return
    fi
    if [ "$DITHERING" = "libtiff-fs" ] && ($PS -h | $GREP tiff24nc >/dev/null 2>&1) && \
       [ -x $TIFFBIN/tiff2bw ] && [ -x $TIFFBIN/tiffdither ] && [ -x $TIFFBIN/tiff2ps ] && \
       [ -x $TIFFBIN/tiffsplit ] && [ -x $TIFFBIN/tiffcp ]; then
	$PS -q -sDEVICE=tiff24nc -dNOPAUSE -dSAFER=true -sPAPERSIZE=$paper \
	    -dBATCH -r$hres\x$vres "-sOutputFile=$out.1" $STRIPSIZE $FIXEDWIDTH $AUTOROTATE $files
	# Both tiff2bw and tiffdither only operate on single pages, so...
	mkdir tmpdir.$$
	cd tmpdir.$$
	$TIFFBIN/tiffsplit ../$out.1
	for i in *; do
	    $TIFFBIN/tiff2bw $i $i.2
	    $TIFFBIN/tiffdither $i.2 $i.3
	    $RM -f $i $i.2
	done
	$TIFFBIN/tiffcp * ../$out.2
	$RM -f *
	cd ..
	rmdir tmpdir.$$
	#
	# Unfortunately, this process leaves the image with Photometric of min-is-black, which
	# is opposite from what we need for faxing.  So we have to run it again through gs.
	#
	$TIFFBIN/tiff2ps -a $out.2 > $out.3
	files=$out.3
    else
	DITHERING=default
    fi

    $PS -q \
	-sDEVICE=$device \
	-dNOPAUSE \
	-dSAFER=true \
	-sPAPERSIZE=$paper \
	-dBATCH \
	-r$hres\x$vres \
	"-sOutputFile=$out" \
	$STRIPSIZE \
	$FIXEDWIDTH \
	$AUTOROTATE \
	$files

    if [ "$DITHERING" = "libtiff-fs" ]; then
	$RM -f $out.1 $out.2 $out.3
    fi
    #
    # Double-check the Ghostscript output to make sure it's what we need.
    # This is important, because, for example, if we don't have the 
    # necessary pixel-width then the fax wouldd likely fail.
    #
    CHECK=$SBIN/tiffcheck       # program to check acceptability
    PS2FAX=                     # null to prevent recursion
    TIFFCP=$TIFFBIN/tiffcp      # part of the TIFF distribution
    TIFF2PS=$TIFFBIN/tiff2ps    # ditto
    TIFFINFO=$TIFFBIN/tiffinfo  # ditto
    
    fil=$out

    tiffCheck
}

tiffCheck()
{
    CLEARTMP=no
    if [ "$fil" = "$out" ]; then
	CLEARTMP=yes
	fil="$fil.$$.tmp"
	$MV $out $fil
    fi
    #
    # tiffcheck looks over a TIFF document and prints out a string
    # that describes what's needed (if anything) to make the file
    # suitable for transmission with the specified parameters (page
    # width, page length, resolution, encoding).  This string may
    # be followed by explanatory messages that can be returned to
    # the user.  The possible actions are:
    #
    # OK		document is ok
    # REJECT	something is very wrong (e.g. not valid TIFF)
    # REFORMAT	data must be re-encoded
    # REVRES	reformat to change vertical resolution
    # RESIZE	scale or truncate the pages
    # REIMAGE	image is not 1-channel bilevel data
    #
    # Note that these actions may be combined with "+";
    # e.g. REFORMAT+RESIZE.  If we cannnot do the necessary work
    # to prepare the document then we reject it here.
    #
    RESULT=`$CHECK $opt $fil 2>/dev/null`

    ACTIONS=`echo "$RESULT" | $SED 1q`
    case "$ACTIONS" in
    OK)				# no conversion needed
	#
	# 1) We don't use hard links because it screws up faxqclean
	#    logic that assumes the only hard links are used 
	#    temporarily when document files are being created during
	#    the job submission process.
	# 2) We don't use symbolic links because the links get broken
	#    when the source document is shared between jobs and
	#    faxq removes the source document before all jobs complete.
	#
	# If we ever encounter problems where the client submits corrupt
	# TIFF and we need to clean it up before transmission, then we
	# can simply merge OK with REFORMAT.  For now we use $CP instead
	# of $TIFFCP, however, to provide the client some control.
	# The -p is needed or ownership and permissions can be lost.
	#
	$CP -p -f $fil $out
	if [ "$CLEARTMP" = "yes" ]; then $RM -f $fil; fi
	exit 0			# successful conversion
	;;
    *REJECT*)			# document rejected out of hand
	echo "$RESULT" | $SED 1d
	if [ "$CLEARTMP" = "yes" ]; then $RM -f $fil; fi
	exit 254			# reject document
	;;
    REFORMAT)			# only need format conversion (e.g. g4->g3)
	rowsperstrip="-r 9999 "
	if [ -n "`$TIFFINFO $fil | $GREP 'Compression Scheme: ISO JBIG'`" ]; then
	    rowsperstrip=""
	fi
	$TIFFCP -i -c $df -f lsb2msb $rowsperstrip$fil $out

	# libtiff 3.5.7 gives exit status 9 when there are unknown tags...
	exitcode=$?
	if [ "$CLEARTMP" = "yes" ]; then $RM -f $fil; fi
	if [ $exitcode != 0 ] && [ $exitcode != 9 ]; then {
	    $CAT<<EOF
Unexpected failure converting TIFF document; the command

    $TIFFCP -i -c $df -f lsb2msb $rowsperstrip$fil $out

failed with exit status $?.  This conversion was done because:

EOF
	    echo "$RESULT" | $SED 1d; exit 254
	}
	fi
	exit 0
	;;
    #
    # REVRES|REFORMAT+REVRES	adjust vertical resolution (should optimize)
    # *RESIZE			page size must be adjusted (should optimize)
    # *REIMAGE			maybe should reject (XXX)
    #
    *REVRES|*RESIZE|*REIMAGE)
	if [ -z "$PS2FAX" ]; then
	    echo "Unable to format with converters."
	    echo "Preventing recursion."
	    if [ "$CLEARTMP" = "yes" ]; then $RM -f $fil; fi
	    exit 254
	fi
	#
	# Previously we used tiff2ps here instead of tiff2pdf, however, this was problematic
	# with conversion of TIFFs which were not the same size as the target page.  To fix 
	# this it would have required pushing image dimensions to Ghostscript for it to use
	# the -g option, and that would require a lot of converter-script modifications.  It 
	# is easier to simply use tiff2pdf because the PDF output includes the image 
	# dimensions which are then fed to Ghostscript.  (Which would have also been 
	# accomplished with the tiff2ps -2 or -3 options, however, in those cases tiff2ps 
	# resizes the image to fit on the page, and other options, -h and -w, which may not 
	# be available to all tiff2ps versions would have needed to be used.)
	#
	($TIFF2PDF -o $out.$$.pdf $fil; $PDF2FAX -o $out -i "$jobid" $opt $out.$$.pdf && $RM -f $out.$$.pdf) || {
	    $CAT<<EOF
Unexpected failure converting TIFF document; the command

    $TIFF2PDF -o $out.$$.pdf $fil; $PDF2FAX -o $out -i "$jobid" $opt $out.$$.pdf && $RM -f $out.$$.pdf

failed with exit status $?.  This conversion was done because

EOF
	    echo "$RESULT" | $SED 1d; exit 254
	}
	if [ "$CLEARTMP" = "yes" ]; then $RM -f $fil; fi
	exit 0
	;;
    *)				# something went wrong
	echo "Unexpected failure in the TIFF format checker;"
	echo "the output of $CHECK was:"
	echo ""
	echo "$RESULT"
	echo ""
	if [ "$CLEARTMP" = "yes" ]; then $RM -f $fil; fi
	exit 254			# no formatter
	;;
    esac
}

SetupPrivateTmp()
{
    if [ -d "$HYLAFAX_TMPDIR" ]; then
        # Private temp area already created.
        return
    fi

    # Would have liked to use -t, but older mktemp don't support it.
    if [ -z "$TMPDIR" ] || [ ! -w "$TMPDIR" ]; then
        TMPDIR="/tmp"
    fi
    HYLAFAX_TMPDIR=`mktemp -d $TMPDIR/hylafaxtmp-XXXXXXXX 2>/dev/null` || {
        HYLAFAX_TMPDIR="$TMPDIR/hylafaxtmp-$RANDOM-$RANDOM-$RANDOM-$$"
        mkdir -m 0700 "$HYLAFAX_TMPDIR"
    }
    if [ $? != 0 ]
    then
	echo "Couldn't setup private temp area - exiting!" 1>&2
	exit 1
    fi
    # We want any called programs to use our tmp dir.
    TMPDIR=$HYLAFAX_TMPDIR
    export TMPDIR

    trap cleanupExit 0
    trap "hfExit 1" 1 2 15
}

CleanupPrivateTmp ()
{
    if [ -d "$HYLAFAX_TMPDIR" ]
    then
	rm -Rf "$HYLAFAX_TMPDIR"
    fi
}

cleanupExit ()
{
    trap - 0 1 2 15
    CleanupPrivateTmp
}

hfExit ()
{
    cleanupExit
    exit $1
}

assign_cmd_subst()
{
	# Parameters:
	# variablename 'commandline ...' [ positional parameters ...]
	#
	# 'eval' the commandline and assign its standard output data to the
	# given variable (like command substitution), preserving trailing
	# newlines (unlike command substitution).
	#
	# The positional parameters ("$@") are set to the given positional
	# parameters and then the commandline is evaluated in a subshell
	# execution environment.  Its standard output data is assigned to the
	# given variable.
	#
	# Return the exit code of the commandline.

	set false "$@"
	# "$1", if executed, signals an error if and only if it returns with
	# exit code 0.

	if ${2+false} :
	then
		# No parameters have been given:
		printf '%s: %s\n' assign_cmd_subst \
			'Missing variable name.' >&2
		# Signal an error:
		shift; set : "$@"
	elif ! LC_ALL=C expr " $2" : \
		' [[:alpha:]_][[:alnum:]_]*$' > /dev/null
	then
		printf '%s: %s: is not a variable name.\n' \
			assign_cmd_subst "$2" >&2
		# Signal an error:
		shift; set : "$@"
	fi
	if ${3+false} :
	then
		printf '%s: %s\n' assign_cmd_subst \
			'Missing commandline.' >&2
		# Signal an error:
		shift; set : "$@"
	fi
	if "$1"
	then
		# An error occurred.  Fail.
		return 125
	else
		shift
		# "$1" looks like a variable name.
		eval "$1"'="$( ( shift 2; '"$2"' ); ec="$?";' \
			'printf %s .; exit "$ec" )"'
		set "$?" "$1"
		eval "$2"'="${'"$2"'%.}"'
		return "$1"
	fi
}

set_exit_code()
{
	return ${1+"$1"}
}

rfc2047_encode()
{
	# RFC2047-encode a part of a header field value.
	#
	# required parameters:
	#
	# * number of already used columns in the current line,
	#
	# * charset name,
	#
	# * header field value to be encoded,
	#
	# optional parameters:
	#
	# * name of a variable to store the number of already used columns in
	#   the last line.
	#
	# The encoded text is sent to standard output.

	eval "$( rfc2047_encode_2 "$@" )"
} 3>&1

rfc2047_encode_2()
{
	# Caller environment:
	#
	# File descriptor #3: receives the encoded text.
	#
	# File descriptor #1: receives shell commands for the caller
	# environment to be "eval"ed.
	#
	# required parameters:
	#
	# * number of already used columns in the current line,
	#
	# * charset_name,
	#
	# * header field value to be encoded,
	#
	# optional parameters:
	#
	# * name of a variable to store the number of already used columns in
	#   the last line.

	set -u &&
	columns_in_use="${1:?missing number of already used columns}" &&
	charset="${2:?missing non-empty charset name}" &&
	value="${3?missing header field value}" &&
	column_variable="${4-}" &&
	prefix=' =?'"$charset"'?Q?' &&
	suffix='?=' &&
	: $(( columns_in_use += ${#prefix} + ${#suffix} )) &&
	printf '%s' "${prefix}" >&3 &&
	while
		character="${value%"${value#?}"}" &&
		# "$character" is the first (maybe multi-byte) character of
		# "$value".
		${character:+:} false &&
		value="${value#"$character"}"
	do
		(
			# In order to process the individual octets of a single
			# (maybe multi-byte) character, change the locale to
			# the POSIX locale:
			export LC_ALL && LC_ALL=C &&
			encoded_character= && length_of_encoded_character=0 &&
			while
				octet="${character%"${character#?}"}" &&
				${octet:+:} false &&
				character="${character#"$octet"}"
			do
				case "$octet" in
					[[:alnum:]])
						;;
					*)
						octet="$( printf '=%.2X' \
							\'"$octet" )"
						;;
				esac
				encoded_character="${encoded_character}${octet}"
			done &&
			printf '%s\n' "$encoded_character"
		)
	done 3>&- |
	{
		{
			while read -r encoded_character
			do
				length_of_encoded_character="${#encoded_character}" &&
				if test $(( columns_in_use += \
					length_of_encoded_character )) -gt 75
				then
					# Appending the encoded character would
					# make the current line too long.
					#
					# Finish the current encoded word
					# without appending the encoded
					# character, then start in a
					# continuation line a new encoded
					# word beginning with the encoded
					# character.
					columns_in_use=$(( ${#prefix} + \
						length_of_encoded_character + \
						${#suffix} ))
					printf '%s\n%s' "$suffix" "$prefix"
				fi &&
				printf '%s' "$encoded_character"
			done &&
			printf '%s' "$suffix"
		} >&3
		{
			ec="$?"
			if ${column_variable:+:} false
			then
				printf '%s=%s\n' "$column_variable" \
					"$columns_in_use"
			fi
			printf 'set_exit_code %s\n' "$ec"
		} 3>&-
	}
}
