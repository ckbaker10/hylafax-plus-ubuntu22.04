#! /usr/bin/bash
#	$Id: probemodem.sh.in 924 2009-05-25 15:49:16Z faxguy $
#
# Warning, this file was automatically created by the HylaFAX configure script
#
# HylaFAX Facsimile Software
#
# Copyright (c) 1993-1996 Sam Leffler
# Copyright (c) 1993-1996 Silicon Graphics, Inc.
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
# security
NOCLOBBER_ON="set -o noclobber"
NOCLOBBER_OFF="set +o noclobber"

#
# probemodem [tty]
#
# This script probes a modem attached to a serial line and
# reports the results of certain commands.
#
SPOOL=/var/spool/hylafax
SBIN=/usr/local/sbin
DIR_LIBDATA=/usr/local/lib/fax

die()
{
    kill -1 $$			# use kill so trap handler is called
}

ATCMD=
DOFUSER=no
OS=
SPEED=
TTY=
while [ x"$1" != x"" ] ; do
    case $1 in
    -c)     ATCMD=$2; shift;;
    -f)     DOFUSER=yes;;
    -os)    OS=$2; shift;;
    -s)	    SPEED=$2; shift;;
    -*)	    echo "Usage: $0 [-f] [-c AT_COMMAND] [-os OS] [-s SPEED] [ttyname]"; exit 1;;
    *)	    TTY=$1;;
    esac
    shift
done

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

#
# Run faxsetup to setup & verify the target machine if
# never done before.  We then source the output that has
# all the target-specific configuration information.
#
test -f $DIR_LIBDATA/setup.cache || {
    echo ""
    echo "Running faxsetup to setup your system for fax service.  This will"
    echo "only happen once; though you may also run faxsetup independently."
    echo ""

    $SBIN/faxsetup -server
}
. $DIR_LIBDATA/setup.cache	# common configuration stuff
. $DIR_LIBDATA/setup.modem	# modem-specific stuff

o="`umask`"
umask 077
TMPDIR=`(mktemp -d /tmp/.probemodem.XXXXXX) 2>/dev/null`
umask "$o"
if test X$TMPDIR = X; then
    echo "Failed to create temporary directory.  Cannot continue."
    exit 1
fi

SH=$SCRIPT_SH			# shell for use below
OUT=$TMPDIR/probemodem$$	# temp file in which modem output is recorded
SVR4UULCKN=$LIBEXEC/lockname	# SVR4 UUCP lock name construction program
ONDELAY=$LIBEXEC/ondelay	# prgm to open devices blocking on carrier
CAT="$CAT -u"			# something to do unbuffered reads and writes

DEVPATH="/dev/"
if [ -n "`echo $TTY | grep "^/"`" ]; then
    DEVPATH=""
fi

while [ -z "$TTY" ] || [ ! -c $DEVPATH$TTY ]; do
    if [ "$TTY" != "" ]; then
	echo "$DEVPATH$TTY is not a terminal device."
    fi
    prompt "Serial port that modem is connected to [$TTY]?"; read TTY
done

if [ ! -d $UUCP_LOCKDIR ]; then
    cat<<EOF

The UUCP lock file directory, $UUCP_LOCKDIR, does not appear
to exist or be a directory.  This must be corrected before you
can use this script to setup a modem for use.  Rerun the faxsetup
command to correct this problem.

EOF
    die
fi

LOCKX=`ttyLocks $TTY`			# UUCP lock file names
DEVS=`ttyAliases $TTY`			# all TTY aliases
tdev=`ttyDev $TTY`			# TTY device to use for communication

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
# Lock the device for later use when deducing the modem type.
#
JUNK="$LOCKX $OUT"
trap "/usr/bin/rm -f $JUNK; /usr/bin/rm -fr $TMPDIR; exit 1" 1 2 15

LOCKSTR=`expr "         $$" : '.*\(..........\)'`
# lock the device by all of its names
for x in $LOCKX; do
    echo "$LOCKSTR" > $x
done

# zap any gettys or other users
if [ x"$DOFUSER" != x"no" ]; then
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

Now we are going to probe the tty port.  This takes a few seconds,
so be patient.  Note that if you do not have the modem cabled to
the port, or the modem is turned off, this may hang (just go and
cable up the modem or turn it on, or whatever).
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
esac

if [ -x ${ONDELAY} ]; then
    onDev() {
	if [ "$1" = "-c" ]; then
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
	if [ "$1" = "-c" ]; then
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
    trap "/usr/bin/rm -f \$JUNK; /usr/bin/rm -fr $TMPDIR; kill $nagpid \$catpid; exit 1" 1 2 15

    if [ x"$ATCMD" != x"" ]; then
	SendToModem "$ATCMD"
    else
	SendToModem "AT+FCLASS=?" 		# ask for class support
    fi

    exec 3>&2 2> /dev/null	# Mute stderr against child death
    kill $nagpid
    wait $nagpid		# Really waits its end
    exec 2>&3 3>&-		# Restore stderr

    trap "/usr/bin/rm -f \$JUNK; /usr/bin/rm -fr $TMPDIR; test \"\$catpid\" && kill \$catpid; exit 1" 1 2 15
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

Try()
{
    TRYCOMMAND=$*
    sleep 1					# wait for previous kill
    case $TARGET in    
    *-linux*)	;;
    *)	onDev $STTY 0; sleep 1	;;		# reset the modem (hopefully)
    esac
    onDev -c "$STTY clocal && exec $CAT $tdev"	# start listening for output
    sleep 1
    onDev $STTY -echo -icrnl -ixon -ixoff -isig eof '"^A"' clocal $SPEED
    sleep 1
    if [ "$ATSTR" != "" ]; then
	printf "$ATSTR\r\r" >$tdev; sleep 1;
    fi
    for i in $TRYCOMMAND; do
	printf "$i\r\r" >$tdev; sleep 1;
    done
    kill -9 $catpid; catpid=
    sleep 1
    # NB: [*&\\$] must have the "$" last for AIX (yech)
    pat=`echo "$i"|$SED -e 's/[*&\\$]/\\\\&/g'`	# escape regex metacharacters
    RESPONSE=`tr -ds '\015' '\012' < $OUT | $SED -n "/$pat/{n;s/ *$//;p;q;}"`
    RESULT=`tr -ds '\015' '\012' < $OUT | $SED -n '$p'`

    printf "$*	RESULT = \"$RESULT\"	RESPONSE = \"$RESPONSE\"\n"
}

TryClass2dot0Commands()
{
    Try "AT+FCLASS=?";	Try "AT+FCLASS?"
    Try "AT+FCLASS=0";	Try "AT+FCLASS=1";	Try "$ATSTR"
    Try "AT+FCLASS?"

    Try "AT+FJU=?";	Try "AT+FJU?"

    Try "AT+FDR=?"
    Try "AT+FDT=?"
    Try "AT+FIP=?"

    Try "AT+FAA=?";	Try "AT+FAA?"
    Try "AT+FAP=?";	Try "AT+FAP?"
			Try "AT+FBS?"	# NB: +FBS is a read-only parameter
    Try "AT+FBO=?";	Try "AT+FBO?"
    Try "AT+FBU=?";	Try "AT+FBU?"
    Try "AT+FCC=?";	Try "AT+FCC?"
    Try "AT+FCQ=?";	Try "AT+FCQ?"
    Try "AT+FCR=?";	Try "AT+FCR?"
    Try "AT+FCS=?";	Try "AT+FCS?"
    Try "AT+FCT=?";	Try "AT+FCT?"
    Try "AT+FEA=?";	Try "AT+FEA?"
    Try "AT+FFC=?";	Try "AT+FFC?"
    Try "AT+FFD=?";	Try "AT+FFD?"
			Try "AT+FHS?"	# +FHS is read-only
    Try "AT+FIE=?";	Try "AT+FIE?"
    Try "AT+FIS=?";	Try "AT+FIS?"
    Try "AT+FIT=?";	Try "AT+FIT?"
    Try "AT+FLI=?";	Try "AT+FLI?"
    Try "AT+FLO=?";	Try "AT+FLO?"
    Try "AT+FLP=?";	Try "AT+FLP?"
			Try "AT+FMI?"
			Try "AT+FMM?"
			Try "AT+FMR?"
    Try "AT+FMS=?";	Try "AT+FMS?"
    Try "AT+FNR=?";	Try "AT+FNR?"
    Try "AT+FNS=?";	Try "AT+FNS?"
    Try "AT+FPA=?";	Try "AT+FPA?"
    Try "AT+FPI=?";	Try "AT+FPI?"
    Try "AT+FPP=?";	Try "AT+FPP?"
    Try "AT+FPR=?";	Try "AT+FPR?"
    Try "AT+FPS=?";	Try "AT+FPS?"
    Try "AT+FPW=?";	Try "AT+FPW?"
    Try "AT+FRQ=?";	Try "AT+FRQ?"
    Try "AT+FRY=?";	Try "AT+FRY?"
    Try "AT+FSA=?";	Try "AT+FSA?"
    Try "AT+FSP=?";	Try "AT+FSP?"
    Try "AT+IFC=?";	Try "AT+IFC?"
    Try "AT+IPR=?";	Try "AT+IPR?"

    # NB: put this last since it resets to Class 0 on some modems
    Try "AT+FKS=?"
}

TryClass2Commands()
{
    Try "AT+FCLASS=?";	Try "AT+FCLASS?"
    Try "AT+FCLASS=0";	Try "AT+FCLASS=1";	Try "AT+FCLASS=2"
    Try "AT+FCLASS?"
    Try "AT+FJUNK=?";	Try "AT+FJUNK?"
    Try "AT+FAA=?";	Try "AT+FAA?"
    Try "AT+FAXERR=?";	Try "AT+FAXERR?"
    Try "AT+FBADLIN=?";	Try "AT+FBADLIN?"
    Try "AT+FBADMUL=?";	Try "AT+FBADMUL?"
    Try "AT+FBOR=?";	Try "AT+FBOR?"
    Try "AT+FBUF=?";	Try "AT+FBUF?"
    Try "AT+FBUG=?";	Try "AT+FBUG?"
    Try "AT+FCIG=?";	Try "AT+FCIG?"
    Try "AT+FCQ=?";	Try "AT+FCQ?"
    Try "AT+FCR=?";	Try "AT+FCR?"
    Try "AT+FTBC=?";	Try "AT+FTBC?"
    Try "AT+FDCC=?";	Try "AT+FDCC?"
    Try "AT+FDCS=?";	Try "AT+FDCS?"
    Try "AT+FDIS=?";	Try "AT+FDIS?"
    Try "AT+FDT=?";	Try "AT+FDT?"
    Try "AT+FECM=?";	Try "AT+FECM?"
    Try "AT+FET=?";	Try "AT+FET?"
    Try "AT+FLID=?";	Try "AT+FLID?"
    Try "AT+FLNFC=?";	Try "AT+FLNFC?"
    Try "AT+FLPL=?";	Try "AT+FLPL?"
    Try "AT+FMDL?";	Try "AT+FMFR?"
    Try "AT+FMINSP=?";	Try "AT+FMINSP?"
    Try "AT+FPHCTO=?";	Try "AT+FPHCTO?"
    Try "AT+FPTS=?";	Try "AT+FPTS?"
    Try "AT+FRBC=?";	Try "AT+FRBC?"
    Try "AT+FREL=?";	Try "AT+FREL?"
    Try "AT+FREV?";
    Try "AT+FSPL=?";	Try "AT+FSPL?"
    Try "AT+FTBC=?";	Try "AT+FTBC?"
    Try "AT+FVRFC=?";	Try "AT+FVRFC?"
    Try "AT+FWDFC=?";	Try "AT+FWDFC?"

    # NB: put this last since it resets to Class 0 on some modems
    Try "AT+FK=?"
}

TryClass1Commands()
{
    Try "AT+FCLASS=?";	Try "AT+FCLASS?"
    Try "AT+FCLASS=0";	Try "$ATSTR"
    Try "AT+FCLASS?"
    Try "AT+FJUNK=?";	Try "AT+FJUNK?"
    Try "AT+FAA=?";	Try "AT+FAA?"
    Try "AT+FAE=?";	Try "AT+FAE?"
    Try "AT+FTH=?"
    Try "AT+FRH=?"
    Try "AT+FTM=?"
    Try "AT+FRM=?"
    Try "AT+FTS=?"
    Try "AT+FRS=?"
}

TryClass1dot0Commands()
{
    Try "AT+FCLASS=?";	Try "AT+FCLASS?"
    Try "AT+FCLASS=0";	Try "$ATSTR"
    Try "AT+FCLASS?"
    Try "AT+FJUNK=?";	Try "AT+FJUNK?"
    Try "AT+FAA=?";	Try "AT+FAA?"
    Try "AT+FAE=?";	Try "AT+FAE?"
    Try "AT+FTH=?"
    Try "AT+FRH=?"
    Try "AT+FTM=?"
    Try "AT+FRM=?"
    Try "AT+FTS=?"
    Try "AT+FRS=?"
    Try "AT+FAR=?"
    Try "AT+FCL=?"
    Try "AT+FIT=?"
    Try "AT+F34=?"
}

TryCommonCommands()
{
    for i in 0 1 2 3 4 5 6 7 8 9; do
	Try "ATI$i"
    done
}

common()
{
    echo "This looks like a Class $SUPPORT modem."
    echo ""
    TryCommonCommands
}

class1()
{
    echo ""; echo "Class 1 stuff..."; echo ""
    ATSTR="AT+FCLASS=1"
    TryClass1Commands
}

class2()
{
    echo ""; echo "Class 2 stuff..."; echo ""
    TryClass2Commands
}

class2dot0()
{
    echo ""; echo "Class 2.0 stuff..."; echo ""
    ATSTR="AT+FCLASS=2.0"
    TryClass2dot0Commands
}

class1dot0()
{
    echo ""; echo "Class 1.0 stuff..."; echo ""
    ATSTR="AT+FCLASS=1.0"
    TryClass1dot0Commands
}

class2dot1()
{
    echo ""; echo "Class 2.1 stuff..."; echo ""
    ATSTR="AT+FCLASS=2.1"
    TryClass2dot0Commands
}

echo ""
if [ "$ATCMD" != "" ]; then
    echo "The response was: $RESPONSE"
    echo "The result was  : $RESULT"
    # cleanup
    /usr/bin/rm -f $JUNK; /usr/bin/rm -fr $TMPDIR
    exit 0
fi
if [ "$RESULT" = "OK" ]; then
    # Looks like a usable fax modem.  Get more information.
    # Here we build up a MODEMCLASSES string and follow
    # (for no real reason) the enumeration in faxd/ClassModem.c++
    # Class 1 = 1; Class 2 = 2; Class 2.0 = 3;
    # Class 1.0 = 4; Class 2.1 = 5;   

    RESPONSE="`echo $RESPONSE | $SED -e 's/[()]//g' \
	-e 's/2\.0/3/g' -e 's/1\.0/4/g' -e 's/2\.1/5/g'`";
    MODEMCLASSES="";
    for CLASS in 1 2 3 4 5; do
	if [ "`echo $RESPONSE | $GREP $CLASS`" != "" ]; then
	    if [ "$MODEMCLASSES" != "" ]; then
		 SUPPORT=`echo $SUPPORT | $SED 's/ and /, /g'`" and ";
	    fi
	    MODEMCLASSES=$MODEMCLASSES$CLASS" ";
	    SUPPORT=$SUPPORT$CLASS
	fi
    done;
    MODEMCLASSES=`echo $MODEMCLASSES | $SED -e 's/3/2.0/g' -e 's/4/1.0/g' -e 's/5/2.1/g' -e 's/ $//g'`
    SUPPORT=`echo $SUPPORT | $SED -e 's/3/2.0/g' -e 's/4/1.0/g' -e 's/5/2.1/g' -e 's/ $//g'`
    if [ "$MODEMCLASSES" = "" ]; then
	echo "The result of the AT+FCLASS=? command was:"
	echo ""
	cat $OUT
	echo ""
	echo "I don't figure that it's worthwhile to continue..."
	# cleanup
	/usr/bin/rm -f $JUNK; /usr/bin/rm -fr $TMPDIR
	exit 0
    else
	common
	for CLASS in $MODEMCLASSES; do
	    case $CLASS in
	    1)		class1;;
	    2)		class2;;
	    2.0)	class2dot0;;
	    1.0)	class1dot0;;
	    2.1)	class2dot1;;
	    esac
	done;
    fi
else
    echo "This not a Class 1, 2, 2.0, 1.0, or 2.1 modem."
fi

# cleanup
/usr/bin/rm -f $JUNK; /usr/bin/rm -fr $TMPDIR
exit 0

