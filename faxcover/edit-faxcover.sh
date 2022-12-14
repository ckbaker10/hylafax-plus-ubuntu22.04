#! /usr/bin/bash
#
#	$Id: edit-faxcover.sh.in 2 2005-11-11 21:32:03Z faxguy $
#
# Warning, this file was automatically created by the HylaFAX configure script
#
# HylaFAX Facsimile Software
#
# Copyright (c) 2003 Multitalents
# Portions Copyright (c) 1990-1996 Sam Leffler
# Portions Copyright (c) 1991-1996 Silicon Graphics, Inc.
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
# edit-faxcover [options]
#
# This script interactively edits the 10 header lines at the top of faxcover.ps
#
PATH=/bin:/usr/bin:/etc
test -d /usr/ucb  && PATH=$PATH:/usr/ucb		# Sun and others
test -d /usr/bsd  && PATH=$PATH:/usr/bsd		# Silicon Graphics
test -d /usr/5bin && PATH=/usr/5bin:$PATH:/usr/etc	# Sun and others
test -d /usr/sbin && PATH=/usr/sbin:$PATH		# 4.4BSD-derived
test -d /usr/local/bin && PATH=$PATH:/usr/local/bin	# for GNU tools

CAT=/usr/bin/cat			# cat command for use below
GREP=/usr/bin/grep			# grep command for use below
SED=/usr/bin/sed			# sed for use below

VERSION="7.0.6"		# configured version
DATE="Fri Jun 24 19:36:27 UTC 2022"			# data software was configured
TARGET="x86_64-unknown-linux-gnu"		# configured target

FAXCOVER=${FAXCOVER:="/usr/local/lib/fax/faxcover.ps"}
QUIET=no
INTERACTIVE=${INTERACTIVE:="yes"}

#
# Error diagnostics that should go to the terminal are
# done with this interface or cat.
#
bitch()
{
    echo "$@" 1>&2
}

#
# This is the preferred interface for
# configure to terminate abnormally.
#
boom()
{
    exit 1
}

usage()
{
    $CAT<<EOF
Usage: edit-faxcover [options]
Options:
  --with-LINEx="string"		set variable LINEx for lines 1 - 10
 Warning null strings will not blank out existing lines.
 Use --with-LINE1=" " to blank out line 1 (actually it'll be a single space)

  --with-FAXCOVER=ARG		Edit some other faxcover.ps file
  --help			print this message
  --nointeractive		do not prompt for input [INTERACTIVE=no]
  --quiet			do not print 'Using ...' messages
  --verbose			opposite of -quiet
EOF
}

#
# Crack command line arguments.  We purposely
# use syntax and options that are compatible
# with GNU autoconf.
#
WITHARGS=no
ac_prev=
for ac_option
do
    if [ -n "$ac_prev" ]; then		# assign the argument to previous option
	eval "$ac_prev=\$ac_option"
	ac_prev=
	continue
    fi
    case "$ac_option" in		# collect optional argument
    -*=*)	ac_optarg=`echo "$ac_option" | $SED 's/[-_a-zA-Z0-9]*=//'`;;
    *)		ac_optarg=;;
    esac
    case "$ac_option" in
    -with-*|--with-*)
	ac_with=`echo $ac_option|$SED -e 's/-*with-//' -e 's/=.*//'`
	# Reject names that are not valid shell variable names.
	if [ -n "`echo $ac_with| $SED 's/[-_a-zA-Z0-9]//g'`" ]; then
	    bitch "configure: $ac_with: invalid parameter name."
	    boom
	fi
	ac_with=`echo $ac_with| $SED 's/-/_/g'`
	case "$ac_option" in
	*=*)	;;
	*)	ac_optarg=yes;;
	esac
	eval "${ac_with}='$ac_optarg'"
	WITHARGS=yes
	;;

    -quiet|--quiet)			QUIET=yes;;
    -verbose|--verbose)			QUIET=no;;
    -nointeractive|--nointeractive)	INTERACTIVE=no;;
    -help|--help)			usage; exit 0;;
    -*)
	bitch "edit-faxcover: $ac_option: invalid option; use -help for usage."
	boom
	;;
    esac
done

if [ -n "$ac_prev" ]; then
    bitch "edit-faxcover: missing argument to --`echo $ac_prev | $SED 's/_/-/g'`"
    boom
fi

#
# Descriptor usage:
# 1: ???
# 2: messages that should be seen even if we're in the background.
# 3: [stdout from test runs]
# 4: verbose-style messages (Using ...)
#
if [ "$QUIET" = yes ]; then
    exec 4>/dev/null			# chuck messages
else
    exec 4>&1				# messages go to stdout
fi

Note()
{
    echo "$@" 1>&4
}

Note ""
Note "This is a program to edit faxcover.ps"
Note ""
Note "HylaFAX (tm) $VERSION."
Note ""
Note "Created for $TARGET on $DATE."
Note ""

#
# Figure out which brand of echo we have and define prompt
# and printf shell functions accordingly.  Note that we
# assume that if the System V-style echo is not present,
# then the BSD printf program is available.  These functions
# are defined here so that they can be tailored on a per-site,
# etc. basis.
#
if [ `echo foo\\\c`@ = "foo@" ]; then
    # System V-style echo supports \r
    # and \c which is all that we need
    prompt()
    {
       echo "$* \\c"
    }
    printf()
    {
       echo "$*\\c"
    }
    dumpPromptFuncs()
    {
	$CAT<<-'EOF'
	prompt()
	{
	   echo "$* \\c"
	}
	printf()
	{
	   echo "$*\\c"
	}
	EOF
    }
elif [ "`echo -n foo`@" = "foo@" ]; then
    # BSD-style echo; use echo -n to get
    # a line without the trailing newline
    prompt()
    {
       echo -n "$* "
    }
    dumpPromptFuncs()
    {
	$CAT<<-'EOF'
	prompt()
	{
	   echo -n "$* "
	}
	EOF
    }
else
    # something else; do without
    prompt()
    {
	echo "$*"
    }
    dumpPromptFuncs()
    {
	$CAT<<-'EOF'
	prompt()
	{
	echo "$*"
	}
	EOF
    }
fi

#
# Prompt the user for a string that can be null.
#
promptForStringParameter()
{
    prompt "$2 [$1]?"
    OIFS=$IFS
    IFS="
"
    read x
    IFS=$OIFS
    case "$x" in
	" ")	x="" ;;
	"")	x="$1" ;;
	*)	# strip leading and trailing white space
		x=`echo "$x" | $SED -e 's/^[ 	]*//' -e 's/[ 	]*$//'`
		;;
    esac
    param="$x"
}

# ed faxcover.ps search_patern replace_this with_that
ed_faxcover() {
	ed - ${FAXCOVER} <<_EOF
g~^${1} ~s~(${2})~(${3})~
w
q
_EOF
}

printConfig()
{
	$CAT<<EOF

	Faxcover header lines are:

	[1] Line 1:		$LINE1
	[2] Line 2:		$LINE2
	[3] Line 3:		$LINE3
	[4] Line 4:		$LINE4
	[5] Line 5:		$LINE5
	[6] Line 6:		$LINE6
	[7] Line 7:		$LINE7
	[8] Line 8:		$LINE8
	[9] Line 9:		$LINE9
	[10] Line 10:		$LINE10

	Enter a single space to clear an existing line.
EOF
}

promptForParameter()
{
	case $1 in
	1) promptForStringParameter "$LINE1" \
		"Line 1";	LINE1="$param"
	;;
	2) promptForStringParameter "$LINE2" \
		"Line 2";	LINE2="$param"
	;;
	3) promptForStringParameter "$LINE3" \
		"Line 3";	LINE3="$param"
	;;
	4) promptForStringParameter "$LINE4" \
		"Line 4";	LINE4="$param"
	;;
	5) promptForStringParameter "$LINE5" \
		"Line 5";	LINE5="$param"
	;;
	6) promptForStringParameter "$LINE6" \
		"Line 6";	LINE6="$param"
	;;
	7) promptForStringParameter "$LINE7" \
		"Line 7";	LINE7="$param"
	;;
	8) promptForStringParameter "$LINE8" \
		"Line 8";	LINE8="$param"
	;;
	9) promptForStringParameter "$LINE9" \
		"Line 9";	LINE9="$param"
	;;
	10) promptForStringParameter "$LINE10" \
		"Line 10";	LINE10="$param"
	;;
	esac
}

# main()
# sanity check
[ -f ${FAXCOVER} ]  ||  {
	bitch "${FAXCOVER} not found"
	boom
}
[ -w ${FAXCOVER} ]  ||  {
	bitch "No write permissions on ${FAXCOVER}"
	boom
}

ORIG_LINE1="`$GREP '^/orig-line1 ' $FAXCOVER | $SED -e 's~/orig-line1 (~~' \
	-e 's~) def~~'`"
ORIG_LINE2="`$GREP '^/orig-line2 ' $FAXCOVER | $SED -e 's~/orig-line2 (~~' \
	-e 's~) def~~'`"
ORIG_LINE3="`$GREP '^/orig-line3 ' $FAXCOVER | $SED -e 's~/orig-line3 (~~' \
	-e 's~) def~~'`"
ORIG_LINE4="`$GREP '^/orig-line4 ' $FAXCOVER | $SED -e 's~/orig-line4 (~~' \
	-e 's~) def~~'`"
ORIG_LINE5="`$GREP '^/orig-line5 ' $FAXCOVER | $SED -e 's~/orig-line5 (~~' \
	-e 's~) def~~'`"
ORIG_LINE6="`$GREP '^/orig-line6 ' $FAXCOVER | $SED -e 's~/orig-line6 (~~' \
	-e 's~) def~~'`"
ORIG_LINE7="`$GREP '^/orig-line7 ' $FAXCOVER | $SED -e 's~/orig-line7 (~~' \
	-e 's~) def~~'`"
ORIG_LINE8="`$GREP '^/orig-line8 ' $FAXCOVER | $SED -e 's~/orig-line8 (~~' \
	-e 's~) def~~'`"
ORIG_LINE9="`$GREP '^/orig-line9 ' $FAXCOVER | $SED -e 's~/orig-line9 (~~' \
	-e 's~) def~~'`"
ORIG_LINE10="`$GREP '^/orig-line10 ' $FAXCOVER | $SED -e 's~/orig-line10 (~~' \
	-e 's~) def~~'`"

LINE1=${LINE1:="$ORIG_LINE1"}
LINE2=${LINE2:="$ORIG_LINE2"}
LINE3=${LINE3:="$ORIG_LINE3"}
LINE4=${LINE4:="$ORIG_LINE4"}
LINE5=${LINE5:="$ORIG_LINE5"}
LINE6=${LINE6:="$ORIG_LINE6"}
LINE7=${LINE7:="$ORIG_LINE7"}
LINE8=${LINE8:="$ORIG_LINE8"}
LINE9=${LINE9:="$ORIG_LINE9"}
LINE10=${LINE10:="$ORIG_LINE10"}

if [ $QUIET = no ]; then
    ok=skip
    while [ "$ok" != y ] && [ "$ok" != yes ]; do
	if [ "$ok" != skip ]; then
	for i in 1 2 3 4 5 6 7 8 9 10; do
	   promptForParameter $i;
	done
	fi
	printConfig
	if [ $INTERACTIVE = no ]; then
	    ok=yes
	else
	    prompt "Are these ok [yes]?"; read ok
	    test -z "$ok" && ok=yes
	    case "$ok" in
	    [1-9]|10)	promptForParameter $ok;;
	    [yY]*|[nN]*)	continue;;
	    ?*)
	    echo ""
	    echo "\"y\", \"yes\", or <RETURN> accepts the displayed parameters."
	    echo "A number lets you change the numbered parameter."
	    echo ""
	    ;;
	    esac
	    ok=skip
	fi
    done
fi

# Replace any lines that have changed
[ "$ORIG_LINE1" = "$LINE1" ]  ||  \
	ed_faxcover /orig-line1 "$ORIG_LINE1" "$LINE1"
[ "$ORIG_LINE2" = "$LINE2" ]  ||  \
	ed_faxcover /orig-line2 "$ORIG_LINE2" "$LINE2"
[ "$ORIG_LINE3" = "$LINE3" ]  ||  \
	ed_faxcover /orig-line3 "$ORIG_LINE3" "$LINE3"
[ "$ORIG_LINE4" = "$LINE4" ]  ||  \
	ed_faxcover /orig-line4 "$ORIG_LINE4" "$LINE4"
[ "$ORIG_LINE5" = "$LINE5" ]  ||  \
	ed_faxcover /orig-line5 "$ORIG_LINE5" "$LINE5"
[ "$ORIG_LINE6" = "$LINE6" ]  ||  \
	ed_faxcover /orig-line6 "$ORIG_LINE6" "$LINE6"
[ "$ORIG_LINE7" = "$LINE7" ]  ||  \
	ed_faxcover /orig-line7 "$ORIG_LINE7" "$LINE7"
[ "$ORIG_LINE8" = "$LINE8" ]  ||  \
	ed_faxcover /orig-line8 "$ORIG_LINE8" "$LINE8"
[ "$ORIG_LINE9" = "$LINE9" ]  ||  \
	ed_faxcover /orig-line9 "$ORIG_LINE9" "$LINE9"
[ "$ORIG_LINE10" = "$LINE10" ]  ||  \
	ed_faxcover /orig-line10 "$ORIG_LINE10" "$LINE10"

