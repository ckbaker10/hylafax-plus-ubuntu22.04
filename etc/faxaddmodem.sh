#! /usr/bin/bash
#	$Id: faxaddmodem.sh.in 924 2009-05-25 15:49:16Z faxguy $
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
#

#
# faxaddmodem [tty]
#
# This script interactively configures a HylaFAX server
# from keyboard input on a standard terminal.  There may
# be some system dependencies in here; hard to say with
# this mountain of shell code!
#
SPOOL=/var/spool/hylafax
DIR_LIBDATA=/usr/local/lib/fax

die()
{
    kill -1 $$			# use kill so trap handler is called
}

INTERACTIVE=yes
SKELFILE=
SPEED=
DOFUSER=no
TTY=
while [ x"$1" != x"" ] ; do
    case $1 in
    -s)	    SPEED=$2; shift;;
    -nointeractive)	INTERACTIVE=no;;
    -skel=*)		SKELFILE="`echo $1 | sed 's/^-skel=//'`";;
    -f)     DOFUSER=yes;;
    -*)	    echo "Usage: $0 [-s SPEED] [-f] [-nointeractive] [-skel=proto_file] [ttyname]"; exit 1;;
    *)	    TTY=$1;;
    esac
    shift
done

# Test selected modem speed against a list of known standards

if [ "$SPEED" != "" ] && [ "$SPEED" != 38400 ] && [ "$SPEED" != 19200 ] \
   && [ "$SPEED" != 9600 ] && [ "$SPEED" != 4800 ] && [ "$SPEED" != 2400 ] \
   && [ "$SPEED" != 1200 ]; then
   cat<<EOF

Warning, you have selected a DTE-DCE communication rate ($SPEED) that
differs from known standards. $SPEED may not work correctly for sending
and receiving facsimile: check your modem manual to make sure that
$SPEED is acceptable.

EOF
fi

#
# Older versions put setup.cache and setup.modem in the spool/etc directory,
# but for security purposes in preventing uucp from getting root privileges
# this script now looks for those files in $DIR_LIBDATA and normally the
# files will be hard linked between the two locations.  The following logic
# is to accommodate upgrades where the files are only in the spool/etc
# directory.
#
if [ -e $SPOOL/etc/setup.cache ] && [ ! -e $DIR_LIBDATA/setup.cache ]; then
    ln $SPOOL/etc/setup.cache $DIR_LIBDATA/setup.cache || ln -s $SPOOL/etc/setup.cache $DIR_LIBDATA/setup.cache
fi
if [ -e $SPOOL/etc/setup.modem ] && [ ! -e $DIR_LIBDATA/setup.modem ]; then
    ln $SPOOL/etc/setup.modem $DIR_LIBDATA/setup.modem || ln -s $SPOOL/etc/setup.modem $DIR_LIBDATA/setup.modem
fi

test -f $DIR_LIBDATA/setup.cache || {
    cat<<EOF

FATAL ERROR: $DIR_LIBDATA/setup.cache is missing!

The file $DIR_LIBDATA/setup.cache is not present.  This
probably means the machine has not been setup using the faxsetup(8C)
command.  Read the documentation on setting up HylaFAX before you
startup a server system.

EOF
    exit 1
}
. $DIR_LIBDATA/setup.cache	# common configuration stuff
. $DIR_LIBDATA/setup.modem	# modem-specific stuff

#
# Deduce the effective user id:
#   1. POSIX-style, the id program
#   2. the old whoami program
#   3. last gasp, check if we have write permission on /dev
#
euid=`id|$SED -e 's/.*uid=[0-9]*(\([^)]*\)).*/\1/'`
test -z "$euid" && euid=`(whoami) 2>/dev/null`
test -z "$euid" && test -w /dev && euid=root
if [ "$euid" != "root" ]; then
    echo "Sorry, but you must run this script as the super-user!"
    exit 1
fi

# security
o="`umask`"
umask 077
TMPDIR=`(mktemp -d /tmp/.faxaddmodem.XXXXXX) 2>/dev/null`
umask "$o"
if test X$TMPDIR = X; then
    echo "Failed to create temporary directory.  Cannot continue."
    exit 1
fi

SH=$SCRIPT_SH			# shell for use below
CPATH=$SPOOL/etc/config		# prefix of configuration file
OUT=$TMPDIR/faxaddmodem.sh$$	# temp file in which modem output is recorded
SVR4UULCKN=$LIBEXEC/lockname	# SVR4 UUCP lock name construction program
ONDELAY=$LIBEXEC/ondelay	# prgm to open devices blocking on carrier
CAT="$CAT -u"			# something to do unbuffered reads and writes
FAX=uucp			# identity of the fax user
GROUP=/etc/group		# where to go for group entries
PROTOGID=uucp		# group who's gid we use for FAX user
defPROTOGID=10			# use this gid if PROTOGID doesn't exist
MODEMCONFIG=$SPOOL/config	# location of prototype modem config files
RMCMD="$RM -f"			# forced removal

#
# Build a list of config files in a portable way for grepping...
#

cd $MODEMCONFIG
CONFIG_LIST=""
for file in *; do
  if [ -f "$file" ]; then
    CONFIG_LIST="$CONFIG_LIST $file"
  fi
done

#
# Prompt the user for a string that can not be null.
#
promptForNonNullStringParameter()
{
    x=""
    while [ -z "$x" ]; do
	prompt "$2 [$1]?";
	if [ "$INTERACTIVE" != "no" ]; then
	    read x
	else
	    echo
	    x=
	fi
	if [ "$x" ]; then
	    # strip leading and trailing white space
	    x=`echo "$x" | $SED -e 's/^[ 	]*//' -e 's/[ 	]*$//'`
	else
	    x="$1"
	fi
    done
    param="$x"
}

#
# Prompt the user for a string that can be null.
#
promptForStringParameter()
{
    prompt "$2 [$1]?";
    if [ "$INTERACTIVE" != "no" ]; then
	read x
    else
	echo
	x=
    fi
    if [ "$x" ]; then
	# strip leading and trailing white space
	x=`echo "$x" | $SED -e 's/^[ 	]*//' -e 's/[ 	]*$//'`
    else
	x="$1"
    fi
    param="$x"
}

#
# Prompt the user for a numeric value.
#
promptForNumericParameter()
{
    x=""
    while [ -z "$x" ]; do
	prompt "$2 [$1]?";
	if [ "$INTERACTIVE" != "no" ]; then
	    read x
	else
	    echo
	    x=
	fi
	if [ "$x" ]; then
	    # strip leading and trailing white space
	    x=`echo "$x" | $SED -e 's/^[ 	]*//' -e 's/[ 	]*$//'`
	    match=`expr "$x" : "\([0-9]*\)"`
	    if [ "$match" != "$x" ]; then
		echo ""
		echo "This must be entirely numeric; please correct it."
		echo ""
		x="";
	    fi
	else
	    x="$1"
	fi
    done
    param="$x"
}

#
# Prompt the user for a C-style numeric value.
#
promptForCStyleNumericParameter()
{
    x=""
    while [ -z "$x" ]; do
	prompt "$2 [$1]?";
	if [ "$INTERACTIVE" != "no" ]; then
	    read x
	else
	    echo
	    x=
	fi
	if [ "$x" ]; then
	    # strip leading and trailing white space and C-style 0x prefix
	    x=`echo "$x" | $SED -e 's/^[ 	]*//' -e 's/[ 	]*$//'`
	    match=`expr "$x" : "\([0-9]*\)" \| "$x" : "\(0x[0-9a-fA-F]*\)"`
	    if [ "$match" != "$x" ]; then
		echo ""
		echo "This must be entirely numeric; please correct it."
		echo ""
		x="";
	    fi
	else
	    x="$1"
	fi
    done
    param="$x"
}

#
# Prompt the user for a boolean value.
#
promptForBooleanParameter()
{
    x=""
    while [ -z "$x" ]; do
	prompt "$2 [$1]?";
	if [ "$INTERACTIVE" != "no" ]; then
	    read x
	else
	    echo
	    x=
	fi
	if [ "$x" ]; then
	    # strip leading and trailing white space
	    x=`echo "$x" | $SED -e 's/^[ 	]*//' -e 's/[ 	]*$//'`
	    case "$x" in
	    n|no|off)	x=no;;
	    y|yes|on)	x=yes;;
	    *)
cat <<EOF

"$x" is not a valid boolean parameter setting;
use one of: "yes", "on", "no", or "off".
EOF
		x="";;
	    esac
	else
	    x="$1"
	fi
    done
    param="$x"
}

faxGID=`$GREP "^$PROTOGID:" $GROUP | cut -d: -f3`
if [ -z "$faxGID" ]; then faxGID=$defPROTOGID; fi

DEVPATH="/dev/"
if [ -n "`echo $TTY | grep "^/"`" ]; then
    DEVPATH=""
fi

while [ -z "$TTY" ] || [ ! -c $DEVPATH$TTY ]; do
    test "$TTY" != "" && echo "$DEVPATH$TTY is not a terminal device." 1>&2
    if [ "$INTERACTIVE" = "no" ]; then exit 1; fi
    prompt "Serial port that modem is connected to [$TTY]?"; read TTY
done

JUNK="$OUT"
trap "$RMCMD \$JUNK; $RMCMD -r $TMPDIR; exit 1" 1 2 15

if [ ! -d $UUCP_LOCKDIR ]; then
    cat<<EOF

The UUCP lock file directory, $UUCP_LOCKDIR, does not appear
to exist or be a directory.  This must be corrected before you
can use this script to setup a modem for use.  Rerun the faxsetup
command to correct this problem.

EOF
    die
fi

PORT=`ttyPort $TTY`			# shortened tty port name
LOCKX=`ttyLocks $TTY`			# UUCP lock file names
DEVS=`ttyAliases $TTY`			# all TTY aliases
tdev=`ttyDev $TTY`			# TTY device to use for communication
DEVID="`echo $TTY | tr '/' '_'`"	# HylaFAX device identifier
CONFIG=$CPATH.$DEVID			# HylaFAX configuration filename

#
# Check that device is not currently being used.
#
for x in $LOCKX; do
    if [ -f $x ]; then
	echo "Sorry, the device is currently in use by another program."
	die
    fi
done

#
# Look for old/conflicting configuration stuff.
#
OLDCONFIG= OLDFIFO=			# set by checkPort
checkPort $TTY

#
# Lock the device for later use when deducing the modem type.
#
JUNK="$JUNK $LOCKX"

LOCKSTR=`expr "         $$" : '.*\(..........\)'`
# lock the device by all of its names
for x in $LOCKX; do
    echo "$LOCKSTR" > $x
done

if [ "$DOFUSER" = "yes" ]; then
    # zap any gettys or other users
    if [ ! -f $FUSER ]; then
	cat<<EOF
Hmm, there does not appear to be an fuser command on your machine.
This means that I am unable to ensure that all processes using the
modem have been killed.  I will keep going, but beware that you may
have competition for the modem.
EOF
    else $FUSER -k $DEVS >/dev/null 2>&1
    fi
fi

cat<<EOF

Ok, time to setup a configuration file for the modem.  The manual
page config(5F) may be useful during this process.  Also be aware
that at any time you can safely interrupt this procedure.

EOF

#
# Configuration parameters specific to server operation
# (as opposed to that of the fax modem).  The required
# parameters are *always* emitted in the final created
# configuration file; otherwise parameters are emitted
# only if the configured value differs from the default
# value known to be used by the server.
#
# NB: the order of some parameters is important; e.g.
#     FAXNumber must be after AreaCode and CountryCode.
#
RequiredServerParameters="
    CountryCode
    AreaCode
    FAXNumber
    LongDistancePrefix
    InternationalPrefix
    DialStringRules
    ServerTracing
    SessionTracing
    RecvFileMode
    LogFileMode
    DeviceMode
    RingsBeforeAnswer
    SpeakerVolume
    GettyArgs
"
#
# Some of these things are also modem-dependent.  It's a
# hard call whether to treat them as server-related and
# propagate them to a new config file or to treat them as
# modem-specific and taken them from the prototype modem
# configuration file.
#
OptionalServerParameters="
    LocalIdentifier
    LogFacility
    ClocalAsRoot
    PriorityScheduling
    TagLineFont
    TagLineFormat
    QualifyTSI

    AdaptiveAnswer
    AnswerRotary
    AnswerBias
    NoCarrierRetrys

    PercentGoodLines
    MaxConsecutiveBadLines

    MaxRecvPages

    JobReqBusy
    JobReqNoCarrier
    JobReqNoAnswer
    JobReqNoFConn
    JobReqDataConn
    JobReqProto
    JobReqOther
    PollModemWait
    PollLockWait
    LockDataCalls
    LockVoiceCalls

    FaxRcvdCmd
    NotifyCmd
    PollRcvdCmd

    RingData
    RingFax
    RingVoice

    UUCPLockDir
    UUCPLockTimeout
    UUCPLockType

    PagerMaxMsgLength

    IXOService
    IXODeviceID
    IXOMaxUnknown
    IXOIDProbe
    IXOIDTimeout
    IXOLoginRetries
    IXOLoginTimeout
    IXOGATimeout
    IXOXmitRetries
    IXOXmitTimeout
    IXOAckTimeout
"
ServerParameters="$RequiredServerParameters $OptionalServerParameters"
#
# Default values for server configuration parameters.
#
defaultFAXNumber=\"\"
defaultLocalIdentifier=\"\"
defaultAreaCode=\"\"
defaultCountryCode=\"\"
defaultLongDistancePrefix=\"\"
defaultInternationalPrefix=\"\"
defaultDialStringRules=\"\"
defaultServerTracing=1
defaultSessionTracing=0xFFF
defaultRecvFileMode=0600
defaultLogFileMode=0600
defaultDeviceMode=0600
defaultRingsBeforeAnswer=0
defaultSpeakerVolume=quiet
defaultGettyArgs=\"\"
defaultQualifyTSI=\"\"
defaultJobReqBusy=180
defaultJobReqNoCarrier=300
defaultJobReqNoAnswer=300
defaultJobReqNoFConn=300
defaultJobReqDataConn=300
defaultJobReqProto=60
defaultJobReqOther=300
defaultPollModemWait=30
defaultPollLockWait=30
defaultTagLineFont=\"\"
defaultTagLineFormat="\"From %%n|%c|Page %%P of %%T\""
defaultPercentGoodLines=95
defaultMaxConsecutiveBadLines=5
defaultMaxRecvPages=1000
defaultLogFacility=daemon
defaultClocalAsRoot=\"\"
defaultPriorityScheduling=\"\"
defaultAdaptiveAnswer=\"\"
defaultAnswerRotary=\"\"
defaultAnswerBias=\"\"
defaultFaxRcvdCmd=\"\"
defaultNoCarrierRetrys=\"\"
defaultNotifyCmd=\"bin/notify\"
defaultPollRcvdCmd=\"\"
defaultRingData=\"\"
defaultRingFax=\"\"
defaultRingVoice=\"\"
defaultUUCPLockDir=\"$UUCP_LOCKDIR\"
defaultUUCPLockTimeout=30
defaultUUCPLockType=\"$UUCP_LOCKTYPE\"
defaultLockDataCalls=Yes
defaultLockVoiceCalls=Yes
defaultPagerMaxMsgLength=\"\"
defaultIXOService=\"\"
defaultIXODeviceID=\"\"
defaultIXOMaxUnknown=\"\"
defaultIXOIDProbe=\"\"
defaultIXOIDTimeout=\"\"
defaultIXOLoginRetries=\"\"
defaultIXOLoginTimeout=\"\"
defaultIXOGATimeout=\"\"
defaultIXOXmitRetries=\"\"
defaultIXOXmitTimeout=\"\"
defaultIXOAckTimeout=\"\"

#
# Initialize server parameters from the defaults.
#
setupServerParameters()
{
    for i in $ServerParameters; do
	eval $i=\$default$i
    done
}

#
# Get server config values from an existing config file.
#
getServerParameters()
{
    eval `$SED -e 's/[ 	]*#.*$//' \
	-e "s;\([^:]*\):[ 	]*\(.*\);\1='\2';" $1`
}

#
# Echo the configuration lines for those server parameters
# whose value is different from the default value.  Note
# that we handle the case where there is embedded whitespace
# by enclosing the parameter value in quotes.
#
echoServerSedCommands()
{
    (for i in $RequiredServerParameters; do
	eval echo \"$i:\$$i:\"
     done
     for i in $OptionalServerParameters; do
	eval echo \"$i:\$$i:\$default$i\"
     done) | $AWK -F: '
function p(tag, value)
{
    tabs = substr("\t\t\t", 1, 3-int((length(tag)+1)/8));
    if (match(value, "^[^\"].*[ ]") == 0)
	printf "%s:%s%s\\\n", tag, tabs, value
    else
	printf "%s:%s\"%s\"\\\n", tag, tabs, value
}
BEGIN	{ printf "/^#.*BEGIN-SERVER/,/^#.*END-SERVER/c\\\n" }
$2 != $3{ p($1, $2) }
END	{ printf "#\n" }'	# terminate input text to ``c'' command
}

#
# Compile a table of configuration parameters prompts into
# a shell program that can be ``eval'd'' to prompt the user
# for changes to the current parameter settings.
#
compilePrompts()
{
    $AWK -F'[	]+' '
function p(t)
{
    printf "promptFor%sParameter \"$%s\" \"%s\";%s=\"$param\"\n", t, $2, $3, $2
}
$1 == "#"	{ p("Numeric"); next }
$1 == "C#"	{ p("CStyleNumeric"); next }
$1 == "S"	{ p("String"); next }
$1 == "NNS"	{ p("NonNullString"); next }
$1 == "B"	{ p("Boolean"); next }
		{ printf "promptFor%s\n", $1 }
'
}

#
# Prompt the user for volume setting.
#
promptForSpeakerVolume()
{
    x=""
    while [ -z "$x" ]; do
	prompt "Modem speaker volume [$SpeakerVolume]?";
	if [ "$INTERACTIVE" != "no" ]; then
	    read x
	else
	    echo
	    x=
	fi
	if [ "$x" != "" ]; then
	    # strip leading and trailing white space
	    x=`echo "$x" | $SED -e 's/^[ 	]*//' -e 's/[ 	]*$//'`
	    case "$x" in
	    [oO]*)	x=off;;
	    [lL]*)	x=low;;
	    [qQ]*)	x=quiet;;
	    [mM]*)	x=medium;;
	    [hH]*)	x=high;;
	    *)
cat <<EOF

"$x" is not a valid speaker volume setting; use one
of: "off", "low", "quiet", "medium", and "high".

EOF
		x="";;
	    esac
	else
	    x="$SpeakerVolume"
	fi
    done
    SpeakerVolume="$x"
}

#
# Verify that the fax number, area code, and country
# code jibe.  Perhaps this is too specific to the USA?
#
checkFaxNumber()
{
    pat="[\"]*+$CountryCode[-. ]*$AreaCode[-. ]*[0-9][- .0-9]*[\"]*"
    match=`expr "$FAXNumber" : "\($pat\)"`
    if [ "$match" != "$FAXNumber" ]; then
	cat<<EOF

Your facsimile phone number ($FAXNumber) does not agree with your
country code ($CountryCode) or area code ($AreaCode).  The number
should be a fully qualified international dialing number of the form:

    +$CountryCode $AreaCode <local phone number>

Spaces, hyphens, and periods can be included for legibility.  For example,

    +$CountryCode.$AreaCode.555.1212

is a possible phone number (using your country and area codes).
EOF
	ok=no;
    fi
}

#
# Verify that a number is octal and if not, add a prefixing "0".
#
checkOctalNumber()
{
    param=$1
    if [ "`expr "$param" : '\(.\)'`" != 0 ]; then
	param="0${param}"
	return 0
    else
	return 1
    fi
}

checkForLocalFile()
{
    f="`echo $1 | $SED 's/\"//g'`"
    if [ ! -f $SPOOL/$f ]; then
	cat<<EOF

Warning, the $2 file,

    $SPOOL/$f

does not exist, or is not a plain file.  This file must
reside in the $SPOOL directory tree.
EOF
	ok=no;
    fi
}

#
# Print the current server configuration parameters.
#
printServerConfig()
{
    (for i in $ServerParameters; do
	eval echo \"$i:\$$i:\$default$i\"
    done) | $AWK -F: '
function p(tag, value)
{
    tabs = substr("\t\t\t", 1, 3-int((length(tag)+1)/8));
    printf "%s:%s%s\n", tag, tabs, value
}
BEGIN	{ printf "\nThe non-default server configuration parameters are:\n\n" }
$2 != $3{ p($1, $2) }
END	{ printf "\n" }'
}

setupServerParameters
SCHEDCONFIG=$CPATH
if [ -f $SCHEDCONFIG ]; then
    echo "Reading scheduler config file $SCHEDCONFIG."
    echo ""
    getServerParameters $SCHEDCONFIG
fi
if [ -f $CONFIG ] || [ -z "$OLDCONFIG" ]; then
    OLDCONFIG=$CONFIG
fi
if [ -f $OLDCONFIG ]; then
    echo "Hey, there is an existing config file $OLDCONFIG..."
    getServerParameters $OLDCONFIG
    ok="skip"				# skip prompting first time through
else
    echo "No existing configuration, let's do this from scratch."
    echo ""
    if [ -n "$SKELFILE" ]; then
	getServerParameters "$SKELFILE" # get from specified skeletal file
    else
	getServerParameters $MODEMCONFIG/skel # get from skeletal file
    fi
    ok="prompt"				# prompt for parameters
fi

CHECK="`$GREP "AreaCode:" $SPOOL/etc/config | sed 's/.*:[	 ]*//g'`"
if [ -n "$CHECK" ]; then
    AreaCode="$CHECK"
fi
CHECK="`$GREP "CountryCode:" $SPOOL/etc/config | sed 's/.*:[	 ]*//g'`"
if [ -n "$CHECK" ]; then
    CountryCode="$CHECK"
fi
if [ -z "$FAXNumber" ]; then
    FAXNumber="+$CountryCode $AreaCode 555-1212"
fi

isOK()
{
    x="$1"
    test -z "$x" || test "$x" = y || test "$x" = yes
}
isNotOK()
{
    x="$1"
    test -n "$x" && test "$x" != y && test "$x" != yes
}

#
# Prompt user for server-related configuration parameters
# and do consistency checking on what we get.
#
PROMPTS=$TMPDIR/faxpr$$
JUNK="$JUNK $PROMPTS"
while isNotOK $ok; do
    if [ "$ok" != skip ]; then
	test -f $PROMPTS || compilePrompts>$PROMPTS<<EOF
#	CountryCode		Country code
#	AreaCode		Area code
NNS	FAXNumber		Phone number of fax modem
S	LocalIdentifier		Local identification string (for TSI/CIG)
#	LongDistancePrefix	Long distance dialing prefix
#	InternationalPrefix	International dialing prefix
NNS	DialStringRules		Dial string rules file (relative to $SPOOL)
C#	ServerTracing		Tracing during normal server operation
C#	SessionTracing		Tracing during send and receive sessions
#	RecvFileMode		Protection mode for received facsimile
#	LogFileMode		Protection mode for session logs
#	DeviceMode		Protection mode for $TTY
#	RingsBeforeAnswer	Rings to wait before answering
SpeakerVolume
S	GettyArgs		Command line arguments to getty program
S	QualifyTSI		\
	Pathname of TSI access control list file (relative to $SPOOL)
S	TagLineFont		Tag line font file (relative to $SPOOL)
S	TagLineFormat		Tag line format string
C#	UUCPLockTimeout		\
	Time before purging a stale UUCP lock file (secs)
B	LockDataCalls		Hold UUCP lockfile during inbound data calls
B	LockVoiceCalls		Hold UUCP lockfile during inbound voice calls
#	PercentGoodLines	\
	Percent good lines to accept during copy quality checking
#	MaxConsecutiveBadLines	\
	Max consecutive bad lines to accept during copy quality checking
#	MaxRecvPages		\
	Max number of pages to accept in a received facsimile
S	LogFacility		Syslog facility name for ServerTracing messages
B	ClocalAsRoot		Set UID to 0 to manipulate CLOCAL
B	PriorityScheduling	Use available priority job scheduling mechanism
EOF
	. $PROMPTS
    fi
    checkOctalNumber $RecvFileMode &&	RecvFileMode=$param
    checkOctalNumber $LogFileMode &&	LogFileMode=$param
    checkOctalNumber $DeviceMode &&	DeviceMode=$param
    checkForLocalFile $DialStringRules "dial string rules"
    checkFaxNumber;
    if [ "$TagLineFont" != "" ] && [ "$TagLineFont" != '""' ]; then
	checkForLocalFile $TagLineFont "tag line font";
    fi
    printServerConfig; prompt "Are these ok [yes]?";
    if [ "$INTERACTIVE" != "no" ]; then
	read ok
    else
	echo
	ok=
    fi
done

#
# We've got all the server-related parameters, now for the modem ones.
#

cat<<EOF

Now we are going to probe the tty port to figure out the type
of modem that is attached.  This takes a few seconds, so be patient.
Note that if you do not have the modem cabled to the port, or the
modem is turned off, this may hang (just go and cable up the modem
or turn it on, or whatever).
EOF

case $TARGET in
*-sunos*)
    #
    # Sun systems have a command for manipulating software
    # carrier on a terminal line.  Set or reset carrier
    # according to the type of tty device being used.
    #
    case $TTY in
    tty*) ttysoftcar -y $TTY >/dev/null 2>&1;;
    cua*) ttysoftcar -n $TTY >/dev/null 2>&1;;
    esac
    ;;
esac

if [ -x ${ONDELAY} ]; then
    onDev() {
	if [ "$1" = -c ]; then
	    shift; catpid=`${ONDELAY} $tdev $SH -c "$* >$OUT" & echo $!`
	else
	    ${ONDELAY} $tdev $SH -c "$*"
	fi
    }
else
cat<<'EOF'

The "ondelay" program to open the device without blocking is not
present.  We're going to try to continue without it; let's hope that
the serial port won't block waiting for carrier...
EOF
    onDev() {
	if [ "$1" = -c ]; then
	    shift; catpid=`$SH <$tdev >$tdev -c "$* >$OUT" & echo $!`
	else
	    $SH <$tdev >$tdev -c "$*"
	fi
    }
fi

STTY=`ttyStty $tdev`				# appropriate stty cmd

#
# Send each command in SendString to the modem and collect
# the result in $OUT.  Read this very carefully.  It's got
# a lot of magic in it!
#
SendToModem()
{
    COMMAND=$*
    sleep 1					# wait for previous kill
    case $TARGET in
    *-linux*)	;;
    *)	onDev $STTY 0; sleep 1	;;		# reset the modem (hopefully)
    esac
						# start listening for output
    onDev -c "$STTY clocal && exec $CAT $tdev"; sleep 2
    #
    # NB: eof is set to ^A so that only 1 character is needed
    #     for a pending read on HPUX systems
    #
    onDev $STTY -echo -icrnl -ixon -ixoff -isig eof '"^A"' clocal $SPEED;
	sleep 1
    # NB: merging \r & ATQ0 causes some modems problems
    printf "\r" >$tdev; sleep 1;		# force consistent state
    printf "ATQ0V1E1\r" >$tdev; sleep 1;	# enable echo and result codes
    for i in $COMMAND; do
	printf "$i\r" >$tdev; sleep 1;
    done
    kill -9 $catpid; catpid=
    # NB: [*&\\\\$] must have the "$" last for AIX (yech)
    pat=`echo "$i"|$SED -e 's/[*&\\\\$]/\\\\&/g'` # escape regex metacharacters
    RESPONSE=`tr -ds '\015' '\012' < $OUT | \
	$SED -n "/$pat/{n;s/ *$//;p;q;}"`
}

echo ""
if [ -z "$SPEED" ]; then
    #
    # Probe for the highest speed at which the modem
    # responds to "AT" with "OK".
    #
    printf "Probing for best speed to talk to modem:"
    SPEEDS=`ttySpeeds $tdev`			# set of speeds for auto-bauding
    for SPEED in $SPEEDS
    do
	printf " $SPEED"
	SendToModem AT >/dev/null 2>&1
	sleep 1
	RESULT=`tr -ds '\015' '\012' < $OUT | $SED -n '$p'`
	test "$RESULT" = OK && break;
    done
    if [ "$RESULT" != OK ]; then
	echo ""
	echo "Unable to deduce DTE-DCE speed; check that you are using the"
	echo "correct device and/or that your modem is setup properly.  If"
	echo "all else fails, try the -s option to lock the speed."
	die
    fi
    echo " OK."
else
    echo "Using user-specified $SPEED to talk to modem."
fi
RESULT="";
while [ -z "$RESULT" ]; do
    #
    # This goes in the background while we try to
    # reset the modem.  If something goes wrong, it'll
    # nag the user to check on the problem.
    #
    (trap "exit 1" 1 2 15;
     while true; do
	sleep 10;
	echo ""
	echo "Hmm, something seems to be hung, check your modem eh?"
     done)& nagpid=$!
    trap "$RMCMD \$JUNK; $RMCMD -r $TMPDIR; kill $nagpid \$catpid; exit 1" 1 2 15
    SendToModem "AT+FCLASS=?" 			# ask for class support

    exec 3>&2 2> /dev/null  # Mute stderr against child death
    kill $nagpid
    wait $nagpid            # Really waits its end
    exec 2>&3 3>&-          # Restore stderr

    trap "$RMCMD \$JUNK; $RMCMD -r $TMPDIR; test \"\$catpid\" && kill \$catpid; exit 1" 1 2 15
    sleep 1

    RESULT=`tr -ds '\015' '\012' < $OUT | $SED -n '$p'`
    if [ -z "$RESPONSE" ]; then
	echo ""
	echo "There was no response from the modem.  Perhaps the modem is"
	echo "turned off or the cable between the modem and host is not"
	echo "connected.  Please check the modem and hit a carriage return"
	prompt "when you are ready to try again:"
	read x
    fi
done

ModemType="" Manufacturer="" Model="" ProtoType=skel

#
# Initialize desired flow control scheme
# according to the device name (if it's
# meaningful).  Otherwise, setup to use any
# default flow control defined in the prototype
# configuration file.
#
FlowControl=default
case $TARGET in
*-irix*)
    case $TTY in
    ttym${PORT}) FlowControl=xonxoff;;
    ttyf${PORT}) FlowControl=rtscts;;
    esac
    ;;
esac

#
# Prompt the user for a flow control scheme.
#
promptForFlowControlParameter()
{
    x=""
    while [ -z "$x" ]; do
	prompt "$2 [$1]?";
	if [ "$INTERACTIVE" != "no" ]; then
	    read x
	else
	    echo
	    x=
	fi
	if [ "$x" ]; then
	    # strip leading and trailing white space
	    x=`echo "$x" | $SED -e 's/^[ 	]*//' -e 's/[ 	]*$//'`
	    case "$x" in
	    xon*|XON*)	x=xonxoff;;
	    rts*|RTS*)	x=rtscts;;
	    def*|DEF*)	x=default;;
	    *)
cat <<EOF

"$x" is not a valid flow control parameter setting; use one of:

xonxoff		for software flow control
rtscts		for hardware flow control
default		for whatever is set in a prototype config file

Note that this setting defines the scheme to use when sending
and receiving facsimile.  Many modems do not support hardware
flow control during fax operation though they do support it for
data communication.

EOF
		x="";;
	    esac
	else
	    x="$1"
	fi
    done
    param="$x"
}

getFlowControlConfig()
{
    promptForFlowControlParameter "$FlowControl" "DTE-DCE flow control scheme"
    case "$param" in
    xon*|XON*) FlowControl=XONXOFF;;
    rts*|RTS*) FlowControl=RTSCTS;;
    def*|DEF*) FlowControl=DEFAULT;;
    esac
}

#
# Select a configuration file for a modem based on the
# deduced modem type.  Each routine below sends a set
# of commands to the modem to figure out the modem model
# and manufacturer and then compares them against the
# set of known values in associated config files.
# Note that this is done with a tricky bit of shell
# hacking--generating a case statement that is then
# eval'd with the result being the setup of the
# ProtoType shell variable.
#
configureClass2Modem()
{
    ModemType=Class2
    echo "Hmm, this looks like a Class 2 modem."

    SendToModem "AT+FCLASS=2" "AT+FMFR?"
    Manufacturer=$RESPONSE
    echo "Modem manufacturer is \"$Manufacturer\"."

    SendToModem "AT+FCLASS=2" "AT+FMDL?"
    Model=$RESPONSE
    echo "Modem model is \"$Model\"."

    getFlowControlConfig

    eval `(cd $MODEMCONFIG; \
	$GREP 'CONFIG:[ 	]*CLASS2:' $CONFIG_LIST |\
	$AWK -F: '
	    BEGIN { print "case \"$Manufacturer-$Model-$FlowControl\" in" }
	    FILENAME ~ /^OLD/ { next }
	    FILENAME ~ /^config\./ { next }
	    { print $4 ") ProtoType=" $1 ";;" }
	    END { print "*) ProtoType=class2;;"; print "esac" }
	')`
}

#
# As above, but for Class 2.0/2.1 modems.
# Class 2.1 modems without a prototype also use class2.0.
#
configureClass2dot0Modem()
{
    if [ "$ModemType" = "Class2.1" ]; then
	echo "Hmm, this looks like a Class 2.1 modem."
	MATCHSTR=CLASS2.1
	ATSTR=AT+FCLASS=2.1
	PROTOSTR=class2.1
    else echo "Hmm, this looks like a Class 2.0 modem."
	MATCHSTR=CLASS2.0
	ATSTR=AT+FCLASS=2.0
	PROTOSTR=class2.0
    fi
    #
    SendToModem "$ATSTR" "AT+FMI?"
    # if we get an ERROR revert to ATI
    if [ "$RESPONSE" = "ERROR" ]; then SendToModem "$ATSTR" "ATI"; fi
    Manufacturer=$RESPONSE
    echo "Modem manufacturer is \"$Manufacturer\"."

    SendToModem "$ATSTR" "AT+FMM?"
    Model=$RESPONSE
    echo "Modem model is \"$Model\"."

    getFlowControlConfig

    eval `(cd $MODEMCONFIG; \
	$GREP "CONFIG:[ 	]*$MATCHSTR:" $CONFIG_LIST |\
	$AWK -F: '
	    BEGIN { print "case \"$Manufacturer-$Model-$FlowControl\" in" }
	    FILENAME ~ /^OLD/ { next }
	    FILENAME ~ /^config\./ { next }
	    { print $4 ") ProtoType=" $1 ";;" }
	    END { print "*) ProtoType=$PROTOSTR;;"; print "esac" }
	')`
}

#
# Class 1/1.0 modems are handled a bit differently as
# there may be no commands to obtain the manufacturer
# and model.  Instead we use ATI0 and ATI3 to get the
# product codes and then compare them against the set
# of known values in the config files.
#
configureClass1Modem()
{
    Manufacturer=Unknown Model=Unknown
    if [ "$ModemType" = "Class1" ]; then
	echo "Hmm, this looks like a Class 1 modem."
	MATCHSTR=CLASS1
	PROTOSTR=class1
    else echo "Hmm, this looks like a Class 1.0 modem."
	MATCHSTR=CLASS1.0
	PROTOSTR=class1.0
    fi

    SendToModem "ATI0"; CODE="$RESPONSE"
    echo "Product code (ATI0) is \"$CODE\"."
    SendToModem "ATI3"; INFO="$RESPONSE"
    echo "Other information (ATI3) is \"$INFO\"."

    getFlowControlConfig

    eval `(cd $MODEMCONFIG; $GREP "CONFIG:[ 	]*$MATCHSTR:" $CONFIG_LIST) |\
	$SED 's/:[ 	]*/:/g' |\
	$AWK -F: '
BEGIN	{ proto = "" }
FILENAME ~ /^OLD/ { next }
FILENAME ~ /^config\./ { next }
(C == $4 || (C ~ $4 && $4 ~ /\*/)) && I ~ $5 && F ~ $6 {
	  if (proto != "") {
	      print "echo \"Warning, multiple configuration files exist for this modem,\";"
	      print "echo \"   the file " $1 " is ignored.\";"
	  } else
	      proto = $1 " " $7;
	}
END	{ if (proto == "")
	      proto = "$PROTOSTR"
	  print "ProtoType=" proto
	}
	' C="$CODE" I="$INFO" F="$FlowControl" -`
    echo "Modem manufacturer is \"$Manufacturer\"."
    echo "Modem model is \"$Model\"."
}

giveup()
{
    echo "The result of the AT+FCLASS=? command was:"
    echo ""
    cat $OUT
    cat<<EOF

We were unable to deduce what type of modem you have.  This means that
it did not respond as a Class 1, Class 2, or Class 2.0 modem should.
If you believe that your modem conforms to the Class 1, Class 2, or
Class 2.0 interface specification, then check that the modem is
operating properly and that you can communicate with the modem from the
host.  If your modem is not one of the above types of modems, then this
software does not support it and you will need to write a driver that
supports it.

EOF
    die
}

echo ""
if [ "$RESULT" = "OK" ]; then
    # Looks like a usable fax modem.  Get more information.
    cat<<EOF
About fax classes:

The difference between fax classes has to do with how HylaFAX interacts
with the modem and the fax protocol features that are used when sending
or receiving faxes.  One class isn't inherently better than another;
however, one probably will suit a user's needs better than others.
    
Class 1 relies on HylaFAX to perform the bulk of the fax protocol.
Class 2 relies on the modem to perform the bulk of the fax protocol.
Class 2.0 is similar to Class 2 but may include more features.
Class 1.0 is similar to Class 1 but may add V.34-fax capability.
Class 2.1 is similar to Class 2.0 but adds V.34-fax capability.
      
HylaFAX generally will have more features when using Class 1/1.0 than
when using most modems' Class 2 or Class 2.0 implementations.  Generally
any problems encountered in Class 1/1.0 can be resolved by modifications
to HylaFAX, but usually any problems encountered in Class 2/2.0/2.1 will
require the modem manufacturer to resolve it.

Use Class 1 unless you have a good reason not to.

EOF
    # Here we build up a MODEMCLASSES string and follow
    # (for no real reason) the enumeration in faxd/ClassModem.c++
    # Class 1 = 1; Class 2 = 2; Class 2.0 = 3;
    # Class 1.0 = 4; Class 2.1 = 5; Class 256 = 6

    RESPONSE="`echo $RESPONSE | $SED -e 's/[()]//g' -e 's/256/6/g' \
	-e 's/2\.0/3/g' -e 's/1\.0/4/g' -e 's/2\.1/5/g'`";
    SUPPORT="This modem looks to have support for Class "
    MODEMCLASSES="";
    for CLASS in 1 4 2 3 5; do
	if [ "`echo $RESPONSE | $GREP $CLASS`" != "" ]; then
	    if [ "$MODEMCLASSES" != "" ]; then
		 SUPPORT=`echo $SUPPORT | $SED 's/ and /, /g'`" and ";
	    fi
	    MODEMCLASSES=$MODEMCLASSES$CLASS" ";
	    SUPPORT=$SUPPORT$CLASS
	fi
    done;
    MODEMCLASSES=`echo $MODEMCLASSES | $SED -e 's/3/2.0/g' -e 's/4/1.0/g' -e 's/5/2.1/g' -e 's/ $//g'`
    SUPPORT=`echo $SUPPORT | $SED -e 's/3/2.0/g' -e 's/4/1.0/g' -e 's/5/2.1/g'`.
    if [ "`echo $SUPPORT | $GREP \" \"`" = "" ]; then echo $SUPPORT; fi
    case "$MODEMCLASSES" in
    "")			giveup;;
    "1")		ModemType=Class1; configureClass1Modem;;
    "2")		configureClass2Modem;;
    "2.0")		ModemType=Class2.0; configureClass2dot0Modem;;
    "1.0")		ModemType=Class1.0; configureClass1Modem;;
    "2.1")		ModemType=Class2.1; configureClass2dot0Modem;;
    *)
	DEFAULTCLASS=`echo $MODEMCLASSES | $SED 's/\([^ ]*\).*/\1/g'`
	x=""
	while [ "`echo \" $MODEMCLASSES \" | $GREP \" $x \"`" = "" ]; do
	    echo $SUPPORT
	    prompt "How should it be configured [$DEFAULTCLASS]?";
	    if [ "$INTERACTIVE" != "no" ]; then
		read x
	    else
		echo
		x=
	    fi
	    if [ "$x" = "" ]; then x=$DEFAULTCLASS; fi
	done
	echo ""
	case "$x" in
	"1")		ModemType=Class1; configureClass1Modem;;
	"2")		configureClass2Modem;;
	"2.0")		ModemType=Class2.0; configureClass2dot0Modem;;
	"1.0")		ModemType=Class1.0; configureClass1Modem;;
	"2.1")		ModemType=Class2.1; configureClass2dot0Modem;;
	esac
    esac
else
    giveup
fi

#
# Given a modem type, manufacturer and model, select
# a prototype configuration file to work from.
#
echo ""
echo "Using prototype configuration file $ProtoType..."
proto=$MODEMCONFIG/$ProtoType
if [ ! -f $proto ]; then
    echo "Uh oh, I can't find the prototype file"
    echo ""
    echo "\"$proto\""
    echo ""
    if [ "$ProtoType" != "skel" ]; then
        prompt "Do you want to continue using the skeletal configuration file [yes]?"
	if [ "$INTERACTIVE" != "no" ]; then
	    read x
	else
	    echo
	    x=
	fi
	isOK $x || die
	ProtoType=skel;
	if [ -n "$SKELFILE" ]; then
	    proto="$SKELFILE"
	else
	    proto=$MODEMCONFIG/$ProtoType;
	fi
	if [ ! -f $proto ]; then
	    cat<<EOF

Sigh, the skeletal configuration file is not available either.  There
is nothing that I can do without some kind of prototype config file;
I'm bailing out...
EOF
	    die
	fi
    else
	echo "There is nothing more that I can do; I'm bailing out..."
	die
    fi
fi

#
# Prompt the user for an AT-style command.
#
promptForATCmdParameter()
{
    prompt "$2 [$1]?";
    if [ "$INTERACTIVE" != "no" ]; then
	read x
    else
	echo
	x=
    fi
    if [ "$x" ]; then
	# strip leading and trailing white space, quote marks;
	# redouble any backslashes lost through shell processing
	x=`echo "$x" | $SED \
	    -e 's/^[ 	]*//' \
	    -e 's/[ 	]*$//' \
	    -e 's/\"//g' -e 's/\\\\/&&/g'`
    else
	x="$1"
    fi
    param="$x"
}

#
# Prompt the user for a bit order.
#
promptForBitOrderParameter()
{
    x=""
    while [ -z "$x" ]; do
	prompt "$2 [$1]?";
	if [ "$INTERACTIVE" != "no" ]; then
	    read x
	else
	    echo
	    x=
	fi
	if [ "$x" ]; then
	    # strip leading and trailing white space
	    x=`echo "$x" | $SED -e 's/^[ 	]*//' -e 's/[ 	]*$//'`
	    case "$x" in
	    [lL]*)	x=LSB2MSB;;
	    [mM]*)	x=MSB2LSB;;
	    *)
cat <<EOF

"$x" is not a valid bit order parameter setting; use one of:

lsb2msb		for x86-style machines
msb2lsb		for other machines

EOF
		x="";;
	    esac
	else
	    x="$1"
	fi
    done
    param="$x"
}

ModemParameters="
    ModemAnswerAnyCmd
    ModemAnswerCmd
    ModemAnswerDataBeginCmd
    ModemAnswerDataCmd
    ModemAnswerFaxBeginCmd
    ModemAnswerFaxCmd
    ModemAnswerResponseTimeout
    ModemAnswerVoiceBeginCmd
    ModemAnswerVoiceCmd
    ModemBaudRateDelay
    ModemClassQueryCmd
    ModemCommaPauseTimeCmd
    ModemDialCmd
    ModemDialResponseTimeout
    ModemEchoOffCmd
    ModemFlowControl
    ModemFrameFillOrder
    ModemHardFlowCmd
    ModemAtCmdDelay
    ModemMfrQueryCmd
    ModemModelQueryCmd
    ModemNoAutoAnswerCmd
    ModemNoFlowCmd
    ModemOnHookCmd
    ModemPageDoneTimeout
    ModemPageStartTimeout
    ModemRate
    ModemRecvFillOrder
    ModemResetCmds
    ModemResetDelay
    ModemResultCodesCmd
    ModemRevQueryCmd
    ModemSendBeginCmd
    ModemSendFillOrder
    ModemSetVolumeCmd
    ModemSetupAACmd
    ModemSetupDCDCmd
    ModemSetupDTRCmd
    ModemSoftFlowCmd
    ModemSoftResetCmd
    ModemSoftResetCmdDelay
    ModemVerboseResultsCmd
    ModemWaitForConnect
    ModemWaitTimeCmd

    FaxT1Timer
    FaxT2Timer
    FaxT4Timer

    Class0Cmd

    PagerSetupCmds
"
Class1Parameters="
    Class1Cmd
    Class1NFLOCmd
    Class1HFLOCmd
    Class1SFLOCmd
    Class1PPMWaitCmd
    Class1ResponseWaitCmd
    Class1TCFWaitCmd
    Class1EOPWaitCmd
    Class1FrameOverhead
    Class1MsgRecvHackCmd
    Class1RecvAbortOK
    Class1RecvIdentTimer
    Class1SwitchingCmd
    Class1TCFMaxNonZero
    Class1TCFMinRun
    Class1TCFRecvTimeout
"
Class2Parameters="
    Class2AbortCmd
    Class2BORCmd
    Class2BUGCmd
    Class2CIGCmd
    Class2CQCmd
    Class2CQQueryCmd
    Class2CRCmd
    Class2Cmd
    Class2DCCCmd
    Class2DCCQueryCmd
    Class2DISCmd
    Class2DDISCmd
    Class2LIDCmd
    Class2NRCmd
    Class2PHCTOCmd
    Class2PIECmd
    Class2PTSCmd
    Class2PTSQueryCmd
    Class2RecvDataTrigger
    Class2RELCmd
    Class2SendRTC
    Class2SPLCmd
    Class2TBCCmd
    Class2XmitWaitForXON
    Class2UseHex
    Class2NFLOCmd
    Class2HFLOCmd
    Class2SFLOCmd
"

#
# Get the default modem parameter values
# from the prototype configuration file.
#
getModemProtoParameters()
{
    eval `$SED -e 's/[ 	]*#.*$//' \
	 -e "s;\([^:]*\):[ 	]*\(.*\);proto\1='\2'\;\1='\2';" $1`
}

#
# Setup the sed commands for crafting the configuration file:
#
echoModemSedCommands()
{
    ModemCmds=""

    (for i in $ModemParameters; do
	eval echo \"$i:\$$i:\$proto$i\"
    done
    case "$ModemType" in
    Class1*)
	for i in $Class1Parameters; do
	    eval echo \"$i:\$$i:\$proto$i\"
	done
	;;
    Class2*)
	for i in $Class2Parameters; do
	    eval echo \"$i:\$$i:\$proto$i\"
	done
	;;
    esac) | $AWK -F: '
function p(tag, value)
{
    if (match(value, "^[^\"].*[ ]") == 0)
	printf "/^%s:/s/\\(:[ 	]*\\).*/\\1%s/\n", tag, value
    else
	printf "/^%s:/s/\\(:[ 	]*\\).*/\\1\"%s\"/\n", tag, value
}
$2 != $3{ p($1, $2) }
END	{ printf "/CONFIG:/d\n" }'
}

#
# Check if the configured flow control scheme is
# consistent with the tty device being used.
#
checkFlowControlAgainstTTY()
{
    case "$ModemFlowControl" in
    xonxoff|XONXOFF)
	if [ "$TTY" = ttyf${PORT} ] && [ -c $DEVPATH\ttym${PORT} ]; then
	    echo ""
	    echo "Warning, the modem is setup to use software flow control,"
	    echo "but the \"$TTY\" device is used with hardware flow control"
	    prompt "Do you want to use \"ttym${PORT}\" instead [yes]?"
	    if [ "$INTERACTIVE" != "no" ]; then
		read x
	    else
		echo
		x=
	    fi
	    if isOK $x; then
		TTY="ttym${PORT}"
		DEVID="`echo $TTY | tr '/' '_'`"
		CONFIG=$CPATH.$DEVID
	    fi
	fi
	;;
    rtscts|RTSCTS)
	if [ "$TTY" = ttym${PORT} ] && [ -c $DEVPATH\ttyf${PORT} ]; then
	    echo ""
	    echo "Warning, the modem is setup to use hardware flow control,"
	    echo "but the \"$TTY\" device does not honor the RTS/CTS signals."
	    prompt "Do you want to use \"ttyf${PORT}\" instead [yes]?"
	    if [ "$INTERACTIVE" != "no" ]; then
		read x
	    else
		echo
		x=
	    fi
	    if isOK $x; then
		TTY="ttyf${PORT}"
		DEVID="`echo $TTY | tr '/' '_'`"
		CONFIG=$CPATH.$DEVID
	    fi
	fi
	;;
    esac
}

#
# Print the current modem-related parameters.
#
printModemConfig()
{
    (for i in $ModemParameters; do
	eval echo \"$i:\$$i:\$proto$i\"
    done
    case "$ModemType" in
    Class1*)
	for i in $Class1Parameters; do
	    eval echo \"$i:\$$i:\$proto$i\"
	done
	;;
    Class2*)
	for i in $Class2Parameters; do
	    eval echo \"$i:\$$i:\$proto$i\"
	done
	;;
    esac) | $AWK -F: '
function p(tag, value)
{
    tabs = substr("\t\t\t", 1, 3-int((length(tag)+1)/8));
    printf "%s:%s%s\n", tag, tabs, value
}
BEGIN	{ printf "\nThe modem configuration parameters are:\n\n" }
$3 != ""{ p($1, $2) }
END	{ printf "\n" }'
}

promptFor()
{
    eval test \"\$proto$2\" && {
	eval promptFor${1}Parameter \"\$$2\" \"$3\";
	eval $2=\"\$param\";
    }
}

#
# Compile a table of configuration parameters prompts into
# a shell program that can be ``eval'd'' to prompt the user
# for changes to the current parameter settings.
#
compileModemPrompts()
{
    $AWK -F'[	]+' '
function p(t)
{
    printf "test -n \"$proto%s\" && { promptFor%sParameter \"$%s\" \"%s\";%s=\"$param\"; }\n", $2, t, $2, $3, $2
}
$1 == "#"	{ p("Numeric"); next }
$1 == "C#"	{ p("CStyleNumeric"); next }
$1 == "S"	{ p("String"); next }
$1 == "NNS"	{ p("NonNullString"); next }
$1 == "BO"	{ p("BitOrder"); next }
$1 == "FC"	{ p("FlowControl"); next }
$1 == "B"	{ p("Boolean"); next }
$1 == "AT"	{ p("ATCmd"); next }
		{ print }
'
}

#
# Build the script that prompts the user to edit the current
# modem configuration parameters.  Note that we can only edit
# parameters that are in the prototype config file; thus all
# the checks to see if the prototype value exists.
#
buildModemPrompts()
{
    compileModemPrompts<<EOF
AT	ModemAnswerCmd		Command for answering the phone
AT	ModemAnswerAnyCmd	Command for answering any type of call
AT	ModemAnswerDataCmd	Command for answering a data call
AT	ModemAnswerFaxCmd	Command for answering a fax call
AT	ModemAnswerVoiceCmd	Command for answering a voice call
AT	ModemAnswerDataBeginCmd	Command for start of a data call
AT	ModemAnswerFaxBeginCmd	Command for start of a fax call
AT	ModemAnswerVoiceBeginCmd	Command for start of a voice call
#	ModemAnswerResponseTimeout	Answer command response timeout (ms)
#	ModemBaudRateDelay	Delay after setting tty baud rate (ms)
AT	ModemClassQueryCmd	Command to query modem services
AT	ModemCommaPauseTimeCmd	\
	Command for setting time to pause for \",\" in dialing string
AT	ModemDialCmd		Command for dialing (%s for number to dial)
#	ModemDialResponseTimeout	Dialing command response timeout (ms)
AT	ModemEchoOffCmd		Command for disabling command echo
FC	ModemFlowControl	DTE-DCE flow control scheme
BO	ModemFrameFillOrder	Bit order for HDLC frames
AT	ModemHardFlowCmd	\
	Command for setting DCE-DTE hardware flow control
#	ModemAtCmdDelay		Delay before sending each modem AT cmd (ms)
AT	ModemMfrQueryCmd	Command for querying modem manufacture
AT	ModemModelQueryCmd	Command for querying modem model
AT	ModemNoAutoAnswerCmd	Command for disabling auto-answer
AT	ModemNoFlowCmd		Command for disabling DCE-DTE flow control
AT	ModemOnHookCmd		Command for placing phone \"on hook\" (hangup)
#	ModemPageDoneTimeout	Page send/receive timeout (ms)
#	ModemPageStartTimeout	Page send/receive timeout (ms)
#	ModemRate		DTE-DCE communication baud rate
BO	ModemRecvFillOrder	\
	Bit order that modem sends received facsimile data
AT	ModemResetCmds		Additional commands for resetting the modem
#	ModemResetDelay		Delay after sending modem reset commands (ms)
AT	ModemResultCodesCmd	Command for enabling result codes
AT	ModemRevQueryCmd	Command for querying modem firmware revision
BO	ModemSendFillOrder	\
	Bit order that modem expects for transmitted facsimile data
AT	ModemSetVolumeCmd	Commands for setting modem speaker volume levels
AT	ModemSetupAACmd		Command for setting up adaptive-answer
AT	ModemSetupDCDCmd	Command for setting up DCD handling
AT	ModemSetupDTRCmd	Command for setting up DTR handling
AT	ModemSoftFlowCmd	\
	Command for setting DCE-DTE software flow control
AT	ModemSoftResetCmd	Command for doing a soft reset
#	ModemSoftResetCmdDelay	Time in ms to pause after a soft reset
AT	ModemVerboseResultsCmd	Command for enabling verbose result codes
B	ModemWaitForConnect	\
	Force server to wait for \"CONNECT\" response on answer
AT	ModemWaitTimeCmd	\
	Command for setting time to wait for carrier when dialing
#	FaxT1Timer		CCITT T.30 T1 timer (ms)
#	FaxT2Timer		CCITT T.30 T2 timer (ms)
#	FaxT4Timer		CCITT T.30 T4 timer (ms)
AT	Class0Cmd		Command to enter Class 0
EOF
    case "$ModemType" in
    Class1*)
	compileModemPrompts<<EOF
AT	Class1Cmd		Command to enter Class 1
AT	Class1NFLOCmd		\
	Command to setup no flow control after switch to Class 1
AT	Class1HFLOCmd		\
	Command to setup hardware flow control after switch to Class 1
AT	Class1SFLOCmd		\
	Command to setup software flow control after switch to Class 1
AT	Class1PPMWaitCmd	\
	Command to stop and wait prior to sending PPM
AT	Class1ResponseWaitCmd	\
	Command to stop and wait prior to looking for the TCF response
AT	Class1TCFWaitCmd	\
	Command to stop and wait prior to sending TCF
AT	Class1EOPWaitCmd	\
	Command to stop and wait prior to sending EOP
#	Class1FrameOverhead	Extra bytes in a received HDLC frame
#	Class1MsgRecvHackCmd	Command to avoid +FCERROR before image data
#	Class1RecvAbortOK	\
	Maximum time to wait for OK after aborting a receive (ms)
#	Class1RecvIdentTimer	\
	Maximum wait for initial identification frame (ms)
#	Class1SwitchingCmd	\
	Command to ensure silence after receiving HDLC and before sending
#	Class1TCFRecvTimeout	Timeout for receiving TCF (ms)
EOF
	;;
    Class2*)
	compileModemPrompts<<EOF
AT	Class2Cmd		Command to enter $ModemType
AT	Class2NFLOCmd	\
	Command to setup no flow control after switch to $ModemType
AT	Class2HFLOCmd	\
	Command to setup hardware flow control after switch to $ModemType
AT	Class2SFLOCmd	\
	Command to setup software flow control after switch to $ModemType
AT	Class2AbortCmd		Command to abort an active session
AT	Class2BORCmd		Command to setup data bit order
AT	Class2BUGCmd		Command to enable HDLC frame tracing
AT	Class2CIGCmd		Command to set polling identifer
AT	Class2CQCmd		Command to setup copy quality parameters
AT	Class2CRCmd		Command to enable receive capability
AT	Class2DCCCmd		Command to set/constrain modem capabilities
AT	Class2DCCQueryCmd	Command to query modem capabilities
AT	Class2DISCmd		Command to set session parameters
AT	Class2LIDCmd		Command to set local identifier string
AT	Class2NRCmd		Command to enable status reporting
AT	Class2PHCTOCmd		Command to set Phase C timeout
AT	Class2PIECmd		Command to disable procedure interrupt handling
AT	Class2RELCmd		Command to receive byte-aligned EOL codes
AT	Class2RecvDataTrigger	Character sent before receiving page data
AT	Class2SPLCmd		Command to set polling request
AT	Class2TBCCmd		Command to enable DTE-DCE stream comm. mode
B	Class2XmitWaitForXON	Wait for XON before sending page data
EOF
	;;
    esac
}

#
# Construct the configuration file.
#
case $ProtoType in
skel|class*)
    # Go through each important parameter (sigh)
    cat<<EOF

There is no prototype configuration file for your modem, so we will
have to fill in the appropriate parameters by hand.  You will need the
manual for how to program your modem to do this task.  In case you are
uncertain of the meaning of a configuration parameter you should
consult the config(5F) manual page for an explanation.

Note that modem commands must be specified exactly as they are to be
sent to the modem.  Note also that quote marks (") will not be displayed
and will automatically be deleted.  You can use this facility to supply
null parameters as "".

Finally, beware that the set of parameters is long.  If you prefer to
use your favorite editor instead of this script you should fill things
in here as best you can and then edit the configuration file

"$CONFIG"

after completing this procedure.

EOF
    ok=no;;
*)  ok=skip;;
esac

getModemProtoParameters $proto
#
# Override any default flow control setting
# in the prototype configuration file.
#
case $FlowControl in
RTS*)	ModemFlowControl=rtscts;;
XON*)	ModemFlowControl=xonxoff;;
esac
rm -f $PROMPTS
while isNotOK $ok; do
    if [ "$ok" != skip ]; then
	test -f $PROMPTS || buildModemPrompts>$PROMPTS
	. $PROMPTS
    fi
    printModemConfig
    case $TARGET in
    *-irix*)	checkFlowControlAgainstTTY;;
    esac
    #
    # XXX not sure what kind of consistency checking that can
    # be done w/o knowing more about the modem...
    #
    prompt "Are these ok [yes]?";
    if [ "$INTERACTIVE" != "no" ]; then
	read ok
    else
	echo
	ok=
    fi
done
TMPSED=$TMPDIR/faxsed$$; JUNK="$JUNK $TMPSED"
(echoServerSedCommands; echoModemSedCommands)>$TMPSED

#
# All done with the prompting; edit up a config file!
#
echo ""
echo "Creating new configuration file $CONFIG..."
JUNK="$JUNK $CONFIG.new"
if $SED -f $TMPSED $proto >$CONFIG.new; then
    if cmp -s $CONFIG.new $CONFIG >/dev/null 2>&1; then
	echo "...nothing appears to have changed; leaving the original file."
	$RMCMD $CONFIG.new
    else
	if [ -f $CONFIG ]; then
	    echo "...saving current file as $CONFIG.sav."
	    mv $CONFIG $CONFIG.sav
	fi
	$MV $CONFIG.new $CONFIG
	$CHOWN $FAX $CONFIG
	$CHGRP $faxGID $CONFIG
	$CHMOD 644 $CONFIG
    fi
else
    echo ""
    echo "*** Sorry, something went wrong building $CONFIG.new."
    echo "*** The original config file is unchanged; I'm terminating before"
    echo "***    I do something stupid."
    echo ""
    die
fi

#
# Create FIFO.<tty> special file and remove any old one.
#
FIFO=$SPOOL/FIFO.$DEVID
test -p $FIFO || {
    prompt "Creating fifo $FIFO for faxgetty..."
    if (mkfifo $FIFO) >/dev/null 2>&1; then
	echo "done."
    elif (mknod $FIFO p) >/dev/null 2>&1; then
	echo "done."
    else
	echo ""
	echo "*** Unable to create fifo \"$FIFO\"; terminating."
	die
    fi
}
$CHOWN $FAX $FIFO; $CHGRP $faxGID $FIFO; $CHMOD 600 $FIFO
if [ "$OLDFIFO" ]; then
    echo "Removing old fifo $OLDFIFO.";
    $RMCMD $OLDFIFO;
fi

echo "Done setting up the modem configuration."

echo ""

#
# Configuration parameters specific to scheduler operation.
# Required parameters are *always* emitted in the created
# configuration file; optional parameters are emitted
# only if the configured value differs from the default
# value known to be used by the server.
#
# NB: the order of some parameters is important; e.g.
#     DialStringRules must be after AreaCode and CountryCode.
#
RequiredSchedulerParameters="
    LogFacility
    CountryCode
    AreaCode
    LongDistancePrefix
    InternationalPrefix
    DialStringRules
    ServerTracing
"
OptionalSchedulerParameters="
    ContCoverPage
    ContCoverCmd
    MaxConcurrentCalls
    MaxDials
    MaxSendPages
    MaxTries
    ModemGroup
    PostScriptTimeout
    PS2FaxCmd
    SendFaxCmd
    SendPageCmd
    SendUUCPCmd
    SessionTracing
    TimeOfDay
    Use2D
"
defaultContCoverPage=
defaultContCoverCmd=\"bin/mkcover\"
defaultMaxConcurrentCalls=1
defaultMaxDials=12
defaultMaxSendPages=0xffffffff
defaultMaxTries=3
defaultModemGroup=
defaultPostScriptTimeout=180
defaultPS2FaxCmd=\"bin/ps2fax\"
defaultSendFaxCmd=\"bin/faxsend\"
defaultSendPageCmd=\"bin/pagesend\"
defaultSendUUCPCmd=\"bin/uucpsend\"
defaultSessionTracing=0xFFF
defaultTimeOfDay=\"Any\"
defaultUse2D=Yes
#
# NB: these defaults are set above
#
OptionalParameters="
    $OptionalSchedulerParameters
    JobReqOther
    NotifyCmd
    UUCPLockDir
    UUCPLockTimeout
    UUCPLockType
"
SchedulerParameters="
    $RequiredSchedulerParameters
    $OptionalParameters
"
#
# The following parameters are checked to make sure
# they have values consistent with what was just written
# to the modem configuration file.  It is ok for some
# of these to be different, but usually they should be
# the same so if they disagree we prompt the user to
# see if we should propagate the new values from the
# modem config file to the scheduler config file.
#
CheckedParameters="
    LogFacility
    CountryCode
    AreaCode
    LongDistancePrefix
    InternationalPrefix
    DialStringRules
    JobReqOther
    NotifyCmd
    UUCPLockDir
    UUCPLockTimeout
    UUCPLockType
"

#
# Echo the configuration lines for those scheduler parameters
# whose value is different from the default value.  Note
# that we handle the case where there is embedded whitespace
# by enclosing the parameter value in quotes.
#
echoSchedulerParameters()
{
    (for i in $RequiredSchedulerParameters; do
	eval echo \"$i:\$$i:\"
     done
     for i in $OptionalSchedulerParameters; do
	eval echo \"$i:\$$i:\$default$i\"
     done) | $AWK -F: '
function p(tag, value)
{
    tabs = substr("\t\t\t", 1, 3-int((length(tag)+1)/8));
    if (match(value, "^[^\"].*[ ]") == 0)
	printf "%s:%s%s\n", tag, tabs, value
    else
	printf "%s:%s\"%s\"\n", tag, tabs, value
}
$2 != $3{ p($1, $2) }'
}

#
# Print the current server configuration parameters.
#
printSchedulerConfig()
{
    (for i in $SchedulerParameters; do
	eval echo \"$i:\$$i:\$default$i\"
    done) | $AWK -F: '
function p(tag, value)
{
    tabs = substr("\t\t\t", 1, 3-int((length(tag)+1)/8));
    printf "%s:%s%s\n", tag, tabs, value
}
BEGIN	{ printf "\nThe non-default scheduler parameters are:\n\n" }
$2 != $3{ p($1, $2) }
END	{ printf "\n" }'
}

#
# Check the current contents of the scheduler configuration file
# against that parameters just setup for the per-modem config file.
# If anything has changed (e.g. phone number info), then prompt
# the user to update the file.
#
updateConfig=yes
#
# Initialize server parameters from the defaults.
#
for i in $OptionalSchedulerParameters; do
    eval $i=\$default$i
done
if [ -f $SCHEDCONFIG ]; then
    echo "Checking $SCHEDCONFIG for consistency..."
    #
    # Save current settings in variables with a ``modem'' prefix.
    #
    for i in $CheckedParameters; do
	eval modem$i=\$$i
    done
    #
    # Read old configuration file in as the ``current settings''.
    #
    getServerParameters $SCHEDCONFIG
    #
    # Check current parameter settings against ``modem settings''.
    # If inconsistencies are detected in the parameters that should
    # (by default) be kept consistent, then try to propagate the new
    # parameter settings from the modem config file to the scheduler
    # config file.
    #
    ok=yes
    for i in $CheckedParameters; do
	eval test \"\$$i\" != \"\$modem$i\" && { ok=skip; break; }
    done
    if [ $ok != yes ]; then
	echo "...some parameters are different."
	#
	# Move the ``modem settings'' to the current settings
	# and let the user ok them or change them to what they
	# want.  We do this shuffle w/o touching the default
	# settings so that optional parameter handling works
	# (i.e. that only non-default values for optional params
	# are displayed and/or written to the file).
	#
	for i in $CheckedParameters; do
	    eval $i=\$modem$i
	done
    else
	echo "...everything looks ok; leaving existing file unchanged."
	updateConfig=no
    fi
else
    echo "No scheduler configuration file exists, creating one from scratch."
    ok=skip				# got important params above
fi

rm -f $PROMPTS
while isNotOK $ok; do
    if [ "$ok" != skip ]; then
	test -f $PROMPTS || compilePrompts>$PROMPTS<<EOF
#	CountryCode		Country code
#	AreaCode		Area code
#	LongDistancePrefix	Long distance dialing prefix
#	InternationalPrefix	International dialing prefix
NNS	DialStringRules		Dial string rules file (relative to $SPOOL)
C#	ServerTracing		Tracing during normal server operation
C#	SessionTracing		\
	Default tracing during send and receive sessions
S	ContCoverPage		Continuation cover page (relative to $SPOOL)
C#	PostScriptTimeout	\
	Timeout when converting PostScript documents (secs)
C#	MaxConcurrentCalls	\
	Maximum number of concurrent jobs to a destination
S	ModemGroup		Define a group of modems
S	TimeOfDay		Time of day restrictions for outbound jobs
C#	UUCPLockTimeout		\
	Timeout before purging a stale UUCP lock file (secs)
C#	MaxSendPages		Max number of pages to permit in an outbound job
S	LogFacility		Syslog facility name for ServerTracing messages
EOF
	. $PROMPTS
    fi
    checkForLocalFile $DialStringRules "dial string rules"
    printSchedulerConfig; prompt "Are these ok [yes]?";
    if [ "$INTERACTIVE" != "no" ]; then
	read ok
    else
	echo
	ok=
    fi
done

if [ $updateConfig = yes ]; then
    #
    # All done with the prompting; edit up a config file!
    #
    echo ""
    echo "Creating new configuration file $SCHEDCONFIG..."
    JUNK="$JUNK $SCHEDCONFIG.new"
    echoSchedulerParameters >$SCHEDCONFIG.new 2>/dev/null
    if cmp -s $SCHEDCONFIG.new $SCHEDCONFIG >/dev/null 2>&1; then
	echo "...nothing appears to have changed; leaving the original file."
	rm -f $SCHEDCONFIG.new
    elif [ -s $SCHEDCONFIG.new ]; then
	if [ -f $SCHEDCONFIG ]; then
	    echo "...saving current file as $SCHEDCONFIG.sav."
	    $MV $SCHEDCONFIG $SCHEDCONFIG.sav
	fi
	$MV $SCHEDCONFIG.new $SCHEDCONFIG
	$CHOWN $FAX $SCHEDCONFIG
	$CHGRP $faxGID $SCHEDCONFIG
	$CHMOD 644 $SCHEDCONFIG
    else
	echo ""
	echo "*** Sorry, something went wrong building $SCHEDCONFIG.new."
	echo "*** The original config file is unchanged; check your disk space?"
	echo ""
	die
    fi
fi

echo ""
echo "Don't forget to run faxmodem(8C) (if you have a send-only environment)"
echo "or configure init to run faxgetty on $TTY."

exec >/dev/null 2>&1

# cleanup
$RMCMD $JUNK; $RMCMD -r $TMPDIR
exit 0
