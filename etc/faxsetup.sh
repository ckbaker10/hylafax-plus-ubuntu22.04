#! /usr/bin/bash
#	$Id: faxsetup.sh.in 1150 2013-02-25 03:51:47Z faxguy $
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
# faxsetup [options]
#
# This script interactively prepares and verifies 
# a HylaFAX client and/or server machine for use.
#
PATH=/bin:/usr/bin:/etc
test -d /usr/ucb  && PATH=$PATH:/usr/ucb		# Sun and others
test -d /usr/bsd  && PATH=$PATH:/usr/bsd		# Silicon Graphics
test -d /usr/5bin && PATH=/usr/5bin:$PATH:/usr/etc	# Sun and others
test -d /usr/sbin && PATH=/usr/sbin:$PATH		# 4.4BSD-derived
test -d /usr/local/bin && PATH=$PATH:/usr/local/bin	# for GNU tools
test -d /usr/gnu/bin && PATH=$PATH:/usr/gnu/bin		# for GNU tools (SCO)

AWK=/usr/bin/mawk			# awk for use below
CAT=/usr/bin/cat			# cat command for use below
CHGRP=/usr/bin/chgrp			# change file group for use below
CHMOD=/usr/bin/chmod			# change file mode for use below
CHOWN=/usr/bin/chown			# change file owner for use below
CP=/usr/bin/cp				# cp command for use below
ECHO=/usr/bin/echo			# echo command for use below
ENCODING=		# encoding style for uuencode/mimencode
FILECMD=/usr/bin/file		# command for determining filetypes
FUSER=/usr/bin/fuser			# fuser command to dump in setup.cache
GREP=/usr/bin/grep			# grep command for use below
LN=/usr/bin/ln				# ln command for use below
LN_S=-s			# ln option for creating a symbolic link
MIMENCODE=mimencode		# mimencode command to dump in setup.cache
MKFIFO=/usr/bin/mkfifo			# FIFO creation program for use below
MV=/usr/bin/mv				# move file for use below
PCL6CMD=pcl6		# pcl6 (GhostPCL) program
OPENSSL=disabled		# openssl program
RMCMD=/usr/bin/rm			# remove file for use below
SCRIPT_SH=/usr/bin/bash		# shell for use below
SED=/usr/bin/sed			# sed for use below
TIFF2PDF=/usr/bin/tiff2pdf		# tiff-to-pdf conversion tool
TTYCMD=/usr/bin/tty			# tty for error output
UUENCODE=uuencode		# uuencode command to dump in setup.cache

FAX=uucp			# identity of the fax user
SERVICES=/etc/services		# location of services database
INETDCONF=/usr/etc/inetd.conf	# default location of inetd configuration file
ALIASES=/usr/lib/aliases	# default location of mail aliases database file
PASSWD=/etc/passwd		# where to go for password entries
PROTOUID=uucp		# user who's uid we use for FAX user
defPROTOUID=3			# use this uid if PROTOUID doesn't exist
GROUP=/etc/group		# where to go for group entries
PROTOGID=uucp		# group who's gid we use for FAX user
defPROTOGID=10			# use this gid if PROTOGID doesn't exist

VERSION="7.0.6"		# configured version
DATE="Fri Jun 24 19:36:27 UTC 2022"			# data software was configured
TARGET="x86_64-unknown-linux-gnu"		# configured target

PATH_AFM=/usr/share/ghostscript/9.55.0/Resource/Init:/usr/share/ghostscript/9.55.0/lib:/usr/share/ghostscript/9.55.0/Resource/Font:/usr/share/ghostscript/fonts:/var/lib/ghostscript/fonts:/usr/share/cups/fonts:/usr/share/ghostscript/fonts:/usr/local/lib/ghostscript/fonts:/usr/share/fonts		# directory for Adobe Font Metric files
DIR_BIN=/usr/local/bin			# directory for client applications
DIR_LIBDATA=/usr/local/lib/fax		# directory for client data files
DIR_LIBEXEC=/usr/local/sbin		# directory where servers are located
DIR_LOCKS=/var/lock	# UUCP locking directory
DIR_MAN=/usr/share/man		# directory for manual pages
DIR_SBIN=/usr/local/sbin			# directory for server applications
DIR_SPOOL=/var/spool/hylafax		# top of fax spooling tree

TIFFBIN=/usr/bin		# TIFF tools
LOCKS=ascii		# UUCP lock type

PATH_GETTY=/sbin/agetty		# pathname for getty program
PATH_SENDMAIL=/usr/sbin/sendmail	# pathname for sendmail
PATH_VGETTY=/bin/vgetty	# pathname for voice getty program
PATH_EGETTY=/bin/egetty	# pathname for external getty program

PS=gs			# default PostScript RIP package
PATH_GSRIP=/usr/bin/gs		# pathname of Ghostscript RIP
PATH_DPSRIP=/usr/local/sbin/ps2fax		# pathname of old IRIX DPS RIP
PATH_IMPRIP=/usr/lib/print/psrip		# pathname of IRIX Impressario RIP

POSIXLY_CORRECT=1; export POSIXLY_CORRECT		# disable GNU extensions

#
# Location of sysv init script
#
DIR_SYSVINIT=/etc/init.d
FAXQ_SERVER=yes
HFAXD_SERVER=yes
HFAXD_SNPP_SERVER=no

#
# These are the configuration parameters written to the
# setup.cache file and read in by all the HylaFAX scripts.
#
# We use the same names used by configure for consistency
# (but some confusion within this script).
#
VARS="SCRIPT_SH
FONTPATH		PATH_AFM
AWK
BIN		DIR_BIN
CAT
CHGRP
CHMOD
CHOWN
CP
DPSRIP		PATH_DPSRIP
ECHO
ENCODING
FAXQ_SERVER
FILECMD
FUSER
GREP
GSRIP		PATH_GSRIP
HFAXD_SERVER
HFAXD_SNPP_SERVER
IMPRIP		PATH_IMPRIP
LIBDATA		DIR_LIBDATA
LIBEXEC		DIR_LIBEXEC
LN
MANDIR		DIR_MAN
MIMENCODE
MKFIFO
MV
OPENSSL
PATH
PATHGETTY	PATH_GETTY
PATHVGETTY	PATH_VGETTY
PATHEGETTY	PATH_EGETTY
PCL6CMD
PSPACKAGE	PS
RM		RMCMD
SBIN		DIR_SBIN
SED
SENDMAIL	PATH_SENDMAIL
SPOOL		DIR_SPOOL
SYSVINIT
TIFF2PDF
TIFFBIN
TARGET
TTYCMD
UUENCODE
UUCP_LOCKDIR	DIR_LOCKS
UUCP_LOCKTYPE	LOCKS"

dumpvals()
{
    echo "$VARS" |
	while read a b; do eval c=\$${b:-$a}; echo "$a='$c'"; done
}

#
# Find the full pathname of an executable;
# supply a default if nothing is found.
#
findAppDef()
{
    app=$1; path=$2; def=$3
    case $app in
    /*) test -x $app && { echo $app; return; };;
    esac
    IFS=:
    for i in $path; do
	test -x $i/$app && { echo $i/$app; return; }
    done
    echo $def
}


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
    $RM $JUNK
    # boom can be called before TMPDIR is set
    if test x$TMPDIR != x; then
	$RM -r $TMPDIR
    fi
    exit 1
}

usage()
{
    cat<<EOF
Usage: faxsetup [options] [host]
Options: [defaults in brackets after descriptions]
  -client		 setup client support
  -server		 setup server support
  -with-PARAM[=ARG]      set configuration PARAM [ARG=yes]

  -help                  print this message
  -quiet                 do not print 'Using ...' messages
  -verbose		 opposite of -quiet
  -nointeractive         assume defaults for all prompts
EOF
}

QUIET=no
INTERACTIVE=yes
AREACODE=000
isServer=no
isClient=no

onClient()
{
    test $isClient = yes
}
onServer()
{
    test $isServer = yes
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
    -*=*)	ac_optarg=`echo "$ac_option" | sed 's/[-_a-zA-Z0-9]*=//'`;;
    *)		ac_optarg=;;
    esac
    case "$ac_option" in
    -with-*|--with-*)
	ac_with=`echo $ac_option|sed -e 's/-*with-//' -e 's/=.*//'`
	# Reject names that are not valid shell variable names.
	if [ -n "`echo $ac_with| sed 's/[-_a-zA-Z0-9]//g'`" ]; then
	    bitch "configure: $ac_with: invalid parameter name."
	    boom
	fi
	ac_with=`echo $ac_with| sed 's/-/_/g'`
	case "$ac_option" in
	*=*)	;;
	*)	ac_optarg=yes;;
	esac
	eval "${ac_with}='$ac_optarg'"
	WITHARGS=yes
	;;
    -client)		isClient=yes;;
    -server)		isServer=yes;;

    -quiet)		QUIET=yes;;
    -nointeractive)	INTERACTIVE=no;;
    -verbose)		QUIET=no;;
    -help)		usage; exit 0;;
    -*)
	bitch "faxsetup: $ac_option: invalid option; use -help for usage."
	boom
	;;
    esac
done

if [ -n "$ac_prev" ]; then
    bitch "faxsetup: missing argument to --`echo $ac_prev | sed 's/_/-/g'`"
    boom
fi

# if nothing specified on command line, default client+server
if [ $isClient = no ] && [ $isServer = no ]; then
    isClient=yes
    isServer=yes
fi

#
# Descriptor usage:
# 1: ???
# 2: messages that should be seen even if we're in the background.
# 3: [stdout from test runs]
# 4: verbose-style messages (Using ...)
# 5: setup.cache file
#
if [ $QUIET = yes ]; then
    exec 4>/dev/null			# chuck messages
else
    exec 4>&1				# messages go to stdout
fi

Note()
{
    echo "$@" 1>&4
}

capture()
{
    (eval "set -x; $*") > /dev/null 2>&1
    return
}  

Note ""
Note "Setup program for HylaFAX (tm) $VERSION."
Note ""
Note "Created for $TARGET on $DATE."
Note ""

CPU=`expr $TARGET : '\([^\-]*\)'` || CPU=unknown
VENDOR=`expr $TARGET : '[^\-]*-\([^\-]*\)'` || VENDOR=unknown
OS=`expr $TARGET : '[^\-]*-[^\-]*-\([a-zA-Z]*\).*'` || OS=unknown
RELEASE=`(uname -r) 2>/dev/null` || RELEASE=unknown

#
# Read in any site, target, vendor, os, or os-release
# specific setup work.  Note that we read stuff here
# so that configuration parameters can be altered.  We
# use some pre-defined function names below to provide
# hooks for other actions.
#

#
# Hooks for additional client+server checks
#
otherBasicServerChecks()
{
    true
}
otherBasicClientChecks()
{
    true
}
#
# Hook for adding stuff to setup.modem
#
dumpOtherModemFuncs()
{
    true
}

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
	cat<<-'EOF'
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
	cat<<-'EOF'
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
	cat<<-'EOF'
	prompt()
	{
	    echo "$*"
	}
	EOF
    }
fi

if onServer; then
    #
    # Setup the password file manipulation functions according
    # to whether we have System-V style support through the
    # passmgmt program, or BSD style support through the chpass
    # program, or for SCO boxes through pwconv, or SVR4 style support
    # through useradd. If none are found, we setup functions that
    # will cause us to abort if we need to munge the password file.
    #
    # NB: some systems override these function definitions through
    #     per-os faxsetup files
    #
    if [ -f /bin/passmgmt ] || [ -f /usr/sbin/passmgmt ]; then
	addPasswd()
	{
	    passmgmt -o -a -c 'Facsimile Agent' -h $4 -u $2 -g $3 $1
	}
	deletePasswd()
	{
	    passmgmt -d $1
	}
	modifyPasswd()
	{
	    passmgmt -m -h $4 -u $2 -o -g $3 $1
	}
	lockPasswd()
	{
	    passwd -l $1
	}
    elif [ -f /usr/bin/chpass ]; then
	addPasswd()
	{
	    chpass -a "$1:*:$2:$3::0:0:Facsimile Agent:$4:"
	}
	modifyPasswd()
	{
	    chpass -a "$1:*:$2:$3::0:0:Facsimile Agent:$4:"
	}
	lockPasswd()
	{
	    return 0				# entries are always locked
	}
    elif [ -f /etc/pwconv ]; then	# could be a SCO box
	addPasswd()
	{
	    echo "${1}:NOLOGIN:${2}:${3}:Facsimile Agent:${4}:/bin/false" >> ${PASSWD}
	    /etc/pwconv
	}
	lockPasswd()
	{
	    return 0				# entries are always locked
	}
	modifyPasswd()
	{
	    OLD_HOME=`grep "^${1}:" ${PASSWD} | awk -F: '{print $6}'`
	    ed - $PASSWD <<_EOF
g~^$1:~s~${OLD_HOME}~$4~
w
q
_EOF
	}
    elif [ -f /usr/sbin/useradd ] || [ -f /etc/useradd ]; then
	addPasswd()
	{
	    useradd -c 'Facsimile Agent' -d $4 -u $2 -o -g $3 $1
	}
	deletePasswd()
	{
	    userdel $1
	}
	modifyPasswd()
	{
	    usermod -m -d $4 -u $2 -o -g $3 $1
	}
	lockPasswd()
	{
	    passwd -l $1
	}
    else
	addPasswd()
	{
	    cat >&2 <<EOF

FATAL ERROR: I don't know how to add a passwd entry!

You will have to create the password entry manually using the following info:

Login Name: $1
Password:   *
Uid:        $2
Gid:        $3
Full Name:  Facsimile Agent
Home Dir:   $4

EOF
	    boom
	}
	modifyPasswd()
	{
	    cat >&2 <<EOF

FATAL ERROR: I don't know how to modify a passwd entry!

You will have to update the password entry manually using the following info:

Login Name: $1
Password:   *
Uid:        $2
Gid:        $3
Full Name:  Facsimile Agent
Home Dir:   $4

EOF
	    boom
	}
    fi

    #
    # Functions required by faxaddmodem.
    #
    case $TARGET in
    *-sunos*|*-linux*|*-ultrix*|*-hpux*|*-freebsd*|*-netbsd*|*-sysv5*)
	dumpTTYFuncs()
	{
	    cat<<'EOF'
	    ttyPort()
	    {
		expr $1 : 'tty\(.*\)'
	    }
	    ttyLocks()
	    {
		echo $UUCP_LOCKDIR/LCK..`expr /$1 : '.*/\(.*\)'`
	    }
	    ttyAliases()
	    {
		if [ -z "`echo $1 | grep "^/"`" ]; then printf "/dev/"; fi
		echo $1
	    }
	    ttyDev()
	    {
		if [ -z "`echo $1 | grep "^/"`" ]; then printf "/dev/"; fi
		echo $1
	    }
	    checkPort()
	    {
		 return
	    }
EOF
	}
	;;
    *-svr4*|*-sysv4*|*-solaris*)
	dumpTTYFuncs()
	{
	    cat<<'EOF'
	    ttyPort()
	    {
		port=`expr $1 : 'term\/\(.*\)' \| $1`		# Usual
		port=`expr $port : 'cua\/\(.*\)' \| $port`	# Solaris
		port=`expr $port : 'tty\(.*\)' \| $port`	# Old-style
		echo $port
	    }
	    ttyLocks()
	    {
		devs=$1
		locks="$UUCP_LOCKDIR/`$SVR4UULCKN /dev/$devs`" || {
		    echo "Sorry, I cannot determine the UUCP lock file name for $devs"
		    exit 1
		}
		echo $locks
	    }
	    ttyAliases()
	    {
		if [ -z "`echo $1 | grep "^/"`" ]; then printf "/dev/"; fi
		echo $1
	    }
	    ttyDev()
	    {
		if [ -z "`echo $1 | grep "^/"`" ]; then printf "/dev/"; fi
		echo $1
	    }
	    checkPort()
	    {
		 return
	    }
EOF
	}
	;;
    *)
	dumpTTYFuncs()
	{
	    Note ""
	    Note "Beware, I am guessing the tty naming conventions for your system."
	    cat<<'EOF'
	    ttyPort()
	    {
		expr $1 : 'tty\(.*\)'
	    }
	    ttyLocks()
	    {
		echo $UUCP_LOCKDIR/LCK..`expr /$1 : '.*/\(.*\)'`
	    }
	    ttyAliases()
	    {
		if [ -z "`echo $1 | grep "^/"`" ]; then printf "/dev/"; fi
		echo $1
	    }
	    ttyDev()
	    {
		if [ -z "`echo $1 | grep "^/"`" ]; then printf "/dev/"; fi
		echo $1
	    }
	    checkPort()
	    {
		 return
	    }
EOF
	}
	;;
    esac

    case $TARGET in
    *-*bsd*)
	dumpSTTYFuncs()
	{
	    cat<<EOF
	    ttyStty()
	    {
		echo $STTYCMD -f \$tdev
	    }
	    ttySpeeds()
	    {
		speeds=
		if [ -z "\$SPEED" ]; then
		    for s in 38400 19200 9600 4800 2400 1200; do
			$STTYCMD -f \$tdev \$s </dev/null >/dev/null 2>&1 && speeds="\$speeds \$s"
		    done
		fi
		echo \$speeds
	    }
EOF
	}
	;;
    *)
	dumpSTTYFuncs()
	{
	    cat<<EOF
	    ttyStty()
	    {
		echo $STTYCMD
	    }
	    ttySpeeds()
	    {
		speeds=
		if [ -z "\$SPEED" ]; then
		    for s in 38400 19200 9600 4800 2400 1200; do
			onDev $STTYCMD \$s </dev/null >/dev/null 2>&1 && speeds="\$speeds \$s"
		    done
		fi
		echo \$speeds
	    }
EOF
	}
	;;
    esac

    machdepPasswdWork()
    {
	true
    }

    #
    # Default values for new scheduler config files
    #
    defaultLogFacility=daemon
    defaultCountryCode=1
    defaultAreaCode=$AREACODE
    defaultLongDistancePrefix=1
    defaultInternationalPrefix=011
    defaultDialStringRules=\"etc/dialrules\"
    defaultServerTracing=1
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
    defaultNotifyCmd=\"bin/notify\"
    defaultUUCPLockDir=\"$DIR_LOCKS\"
    defaultUUCPLockTimeout=30
    defaultUUCPLockType=\"$LOCKS\"
fi

CONFIG_FILES=
if [ -f $DIR_SBIN/faxsetup.local ]; then
    . $DIR_SBIN/faxsetup.local
    CONFIG_FILES="$CONFIG_FILES $DIR_SBIN/faxsetup.local"
elif [ -f $DIR_SBIN/faxsetup.${CPU}-${VENDOR}-${OS}${RELEASE} ]; then
    . $DIR_SBIN/faxsetup.${CPU}-${VENDOR}-${OS}${RELEASE}
    CONFIG_FILES="$CONFIG_FILES $DIR_SBIN/faxsetup.${CPU}-${VENDOR}-${OS}${RELEASE}"
elif [ -f $DIR_SBIN/faxsetup.${VENDOR}-${OS}${RELEASE} ]; then
    . $DIR_SBIN/faxsetup.${VENDOR}-${OS}${RELEASE}
    CONFIG_FILES="$CONFIG_FILES $DIR_SBIN/faxsetup.${VENDOR}-${OS}${RELEASE}"
elif [ -f $DIR_SBIN/faxsetup.${CPU}-${VENDOR}-${OS} ]; then
    . $DIR_SBIN/faxsetup.${CPU}-${VENDOR}-${OS}
    CONFIG_FILES="$CONFIG_FILES $DIR_SBIN/faxsetup.${CPU}-${VENDOR}-${OS}"
elif [ -f $DIR_SBIN/faxsetup.${VENDOR}-${OS} ]; then
    . $DIR_SBIN/faxsetup.${VENDOR}-${OS}
    CONFIG_FILES="$CONFIG_FILES $DIR_SBIN/faxsetup.${VENDOR}-${OS}"
elif [ -f $DIR_SBIN/faxsetup.${CPU}-${VENDOR} ]; then
    . $DIR_SBIN/faxsetup.${CPU}-${VENDOR}
    CONFIG_FILES="$CONFIG_FILES $DIR_SBIN/faxsetup.${CPU}-${VENDOR}"
elif [ -f $DIR_SBIN/faxsetup.${VENDOR} ]; then
    . $DIR_SBIN/faxsetup.${VENDOR}
    CONFIG_FILES="$CONFIG_FILES $DIR_SBIN/faxsetup.${VENDOR}"
elif [ -f $DIR_SBIN/faxsetup.${OS} ]; then
    . $DIR_SBIN/faxsetup.${OS}
    CONFIG_FILES="$CONFIG_FILES $DIR_SBIN/faxsetup.${OS}"
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

#
# Flush cached values if something was specified on the
# command line 
#
if onServer; then
    REASON=
    if [ $WITHARGS = yes ]; then 
	REASON="of command line parameters"
    elif [ "$CONFIG_FILES" ]; then
	REASON=`find $CONFIG_FILES -newer $DIR_LIBDATA/setup.cache -print 2>/dev/null`
	test "$REASON" && REASON="$REASON has been updated"
    fi
    if [ "$REASON" ] && [ -f $DIR_LIBDATA/setup.cache ]; then
       Note "Flushing cached parameters because $REASON."
       Note ""
       rm -f  $DIR_LIBDATA/setup.cache
    fi
    if [ -f  $DIR_LIBDATA/setup.cache ]; then
	Note "Reading cached parameters from  $DIR_LIBDATA/setup.cache."
	Note ""
	.  $DIR_LIBDATA/setup.cache
    fi
fi

#
# Double-check these settings...
#
if [ ! -x "$TIFF2PDF" ] || [ "$TIFF2PDF" = "bin/tiff2pdf" ]; then
    TIFF2PDF=`findAppDef tiff2pdf $PATH bin/tiff2pdf`
    if [ "$TIFF2PDF" != "bin/tiff2pdf" ]; then
	test -x "$TIFF2PDF" && Note "Found converter: $TIFF2PDF"
    fi
fi
if [ "$OPENSSL" != "disabled" ]; then
    test -x "$OPENSSL" || {
	OPENSSL=`findAppDef openssl $PATH openssl`
	test -x "$OPENSSL" && Note "Found openssl: $OPENSSL"
    }
fi
test -x "$PCL6CMD" || {
    PCL6CMD=`findAppDef pcl6 $PATH pcl6`
    test -x "$PCL6CMD" && Note "Found PCL converter: $PCL6CMD"
}
test -x "$MIMENCODE" || {
    MIMENCODE=`findAppDef mimencode $PATH mimencode`
    test -x "$MIMENCODE" || {
	MIMENCODE=`findAppDef base64-encode $PATH base64-encode`
	test -x "$MIMENCODE" || {
	    MIMENCODE=`findAppDef base64 $PATH base64`
	}
    }
    test -x "$MIMENCODE" && Note "Found encoder: $MIMENCODE"
}
test -x "$UUENCODE" || {
    UUENCODE=`findAppDef uuencode $PATH uuencode`
    test -x "$UUENCODE" || {
	UUENCODE=`findAppDef gmime-uuencode $PATH gmime-uuencode`
    }
    test -x "$UUENCODE" && Note "Found encoder: $UUENCODE"
}
if [ -x "$MIMENCODE" ]; then
    if [ "$ENCODING" != "base64" ]; then
	ENCODING=base64
	Note "Looks like $MIMENCODE supports base64 encoding."
    fi
elif [ -x "$UUENCODE" ]; then
    if capture "$UUENCODE -m $PASSWD foo"; then
	if [ "$ENCODING" != "base64" ]; then
	    ENCODING=base64
	    Note "Looks like $UUENCODE supports base64 encoding."
	fi
    else
	if [ "$ENCODING" != "x-uuencode" ]; then
	    ENCODING=x-uuencode
	    Note "Looks like $UUENCODE does not support base64 encoding."
	fi
    fi
fi

RM="$RMCMD -f"				# remove file for use below

#
# Deduce the effective user id:
#   1. Refer to the $EUID environment variable
#   2. POSIX-style, the id program
#   3. the old whoami program
#   4. last gasp, check if we have write permission on /dev
#
unset euid
test -z "$EUID" && EUID=`id |$SED -e 's/.*uid=\([^(]*\).*/\1/'`
[ "$EUID" = "0" ] && euid=root
test -z "$euid" && euid=`(whoami) 2>/dev/null`
test -z "$euid" && test -w /dev && euid=root
if [ "$euid" != "root" ]; then
    bitch "Sorry, but you must run this script as the super-user!"
    boom
fi

onClient && Note "Checking system for proper client configuration."
onServer && Note "Checking system for proper server configuration."

#
# Verify configuration parameters are correct.
#

dirMisConfigured()
{
   cat >&2 <<EOF

FATAL ERROR: $1 does not exist or is not a directory!

The directory $1 does not exist or this file is not a directory.  If
the HylaFAX software is not yet installed you must do so before running
this script.  If the software is installed but is configured for use in
a different location than this script expects then the software will not
function correctly.

EOF
   boom
}

#
# Check basic spooling area setup.
#
if onServer; then
    test -d $DIR_SPOOL || {
	cat >&2 <<-EOF

	FATAL ERROR: $DIR_SPOOL does not exist or is not a directory!

	The HylaFAX spooling area $DIR_SPOOL does not exist or this file is
	not a directory.  If the HylaFAX software is not yet installed you
	must do so before running this script.  If the software is installed
	but is configured for use in a different location than this script
	expects then you may override the default pathname by running this
	script with a -with-DIR_SPOOL option; e.g.

	faxsetup -with-DIR_SPOOL=/var/spool/someplace_unexpected

	EOF
	boom
    }
    cd $DIR_SPOOL
    DIRS="archive bin client config dev docq doneq etc info log\
	pollq recvq sendq status tmp"
    for i in $DIRS; do
	test -d $i || dirMisConfigured $DIR_SPOOL/$i
    done
    #
    # XXX should check permission and ownership of sensitive dirs
    #

    # Setup TMPDIR before anything can trap and rm it
    o="`umask`"
    umask 077
    TMPDIR=`(mktemp -d /tmp/.faxsetup.XXXXXX) 2>/dev/null`
    umask "$o"
    if test x$TMPDIR = x; then
	echo "Failed to create temporary directory.  Cannot continue."
	exit 1
    fi

    JUNK="$DIR_LIBDATA/setup.tmp"
    trap "$RM \$JUNK; $RM -r \$TMPDIR; exit 1" 1 2 15

    exec 5>$DIR_LIBDATA/setup.tmp
    echo '# Warning, this file was automatically generated by faxsetup' >&5
    echo '# on' `date` "for ${USER:-$euid}" >&5
fi

#
# Basic client installation.
#
if onClient; then
    test -d $DIR_BIN	 || dirMisConfigured $DIR_BIN
    for file in sendfax sendpage faxstat faxalter faxcover faxmail faxrm; do
	test -x $DIR_BIN/$file || {
	    cat >&2 <<EOF

FATAL ERROR: $DIR_BIN/$file is not an executable program!

The file $DIR_BIN/$file does not exist or this file is not
an executable program.  If the HylaFAX software is not yet installed you
must do so before running this script.  If the software is installed but
is configured for use in a different location than this script expects
then the software will not function correctly.

EOF
	   boom
	}
    done
    test -d $DIR_LIBDATA || dirMisConfigured $DIR_LIBDATA
    for file in pagesizes faxcover.ps typerules; do
	test -f $DIR_LIBDATA/$file || {
	    cat >&2 <<EOF

FATAL ERROR: $DIR_LIBDATA/$file does not exist!

The file $DIR_LIBDATA/$file does not exist.  If the HylaFAX
software is not yet installed you must do so before running this script.
If the software is installed but is configured for use in a different
location than this script expects then the software will not function
correctly.

EOF
	   boom
	}
    done
    test -d $DIR_LIBEXEC || dirMisConfigured $DIR_LIBEXEC
    for file in textfmt; do
	test -f $DIR_LIBEXEC/$file || {
	    cat >&2 <<EOF

FATAL ERROR: $DIR_LIBEXEC/$file does not exist!

The file $DIR_LIBEXEC/$file does not exist.  If the HylaFAX
software is not yet installed you must do so before running this script.
If the software is installed but is configured for use in a different
location than this script expects then the software will not function
correctly.

EOF
	   boom
	}
    done

    otherBasicClientChecks
fi

#
# Server setup other than the spooling area.
#
if onServer; then
    test -d $DIR_LIBEXEC || dirMisConfigured $DIR_LIBEXEC
    test -d $DIR_SBIN	 || dirMisConfigured $DIR_SBIN
    test -d $DIR_LOCKS   || {
       cat >&2 <<EOF

FATAL ERROR: $DIR_LOCKS does not exist or is not a directory!

The UUCP lockfile directory is not where it is expected or this file
is not a directory.  It is possible to configure the HylaFAX software
to use a directory other than the configured one by setting up the
UUCPLockDir configuration parameter in each configuration file in the
$DIR_SPOOL/etc directory, but this is potentially error-prone.
Your best bet is to either create a symbolic link for the expected
pathname or reconfigure HylaFAX with the correct pathname and build
a new distribution.
EOF
	boom
    }
    test -d $TIFFBIN	|| {
	cat >&2 <<EOF

FATAL ERROR: $TIFFBIN does not exist or is not a directory!

The directory of tools from the TIFF software distribution is not
where it is expected or this file is not a directory.  If you do not
have the TIFF distribution installed on this machine then you must
install it; the homepage for LibTIFF is http://www.remotesensing.org/libtiff/.
Otherwise, if the software is installed in a directory other than
where it is expected you can configure the HylaFAX software to use
an alternate directory by supplying a -with-TIFFBIN option when running
this script; e.g. faxsetup -with-TIFFBIN=someplace_nonstandard.

EOF
	boom
    }
    for file in tiffcp tiff2ps fax2ps tiffinfo; do
	test -x $TIFFBIN/$file	|| {
	    cat >&2 <<EOF

FATAL ERROR: $TIFFBIN/$file does not exist or is not an executable program!

The program $TIFFBIN/$file is not where it is expected or the file
is not executable.  This program is part of the TIFF software
distribution that is required for use with HylaFAX.  If you do not
have the TIFF distribution installed on this machine then you must
install it; the homepage for LibTIFF is http://www.remotesensing.org/libtiff/.
Otherwise, if the software is installed in a directory other than
where it is expected you can configure the HylaFAX software to use
an alternate directory by supplying a -with-TIFFBIN option when running
this script; e.g.  faxsetup -with-TIFFBIN=someplace_nonstandard.

EOF
	    boom
	}
    done

    otherBasicServerChecks
fi

#
# Quick check to see if the manual pages are installed;
# perhaps not even worth the effort.
#
test -d $DIR_MAN || {
    cat >&4 <<EOF


Warning: $DIR_MAN does not exist or is not a directory!

The directory for manual pages does not exist or is not a directory.
If this directory does not exist because the manual pages have not been
installed then you can ignore this message.  Otherwise you may want to
check out what happened to the manual pages.
EOF
}

#
# Utility program parameters.
#
appMisConfigured()
{
   cat >&2 <<EOF

FATAL ERROR: $1 does not exist or is not an executable program!

The file:

    $1

does not exist or this file is not an executable program.  The HylaFAX
software expects this program to exist and be in this location.  If the
program resides in a different location then you must either reconfigure
and rebuild HylaFAX or override the default pathnames in the distributed
software through one of the HylaFAX configuration files (consult the
HylaFAX documentation).

EOF
   boom
}
warnAppMisConfigured()
{
   cat >&2 <<EOF


Warning: $1 does not exist or is not an executable program!

The file:

    $1

does not exist or this file is not an executable program.  The
HylaFAX software optionally uses this program and the fact that
it does not exist on the system is not a fatal error.  If the
program resides in a different location and you do not want to
install a symbolic link for $1 that points to your program
then you must reconfigure and rebuild HylaFAX from source code.
EOF
}

if onServer; then
    #test -x $PATH_GETTY	|| warnAppMisConfigured $PATH_GETTY
    #test -x $PATH_VGETTY	|| warnAppMisConfigured $PATH_VGETTY
    #test -x $PATH_EGETTY	|| warnAppMisConfigured $PATH_EGETTY

    for i in $CAT $CHGRP $CHMOD $CHOWN $CP $ECHO $GREP $LN $MKFIFO $MV \
	$RMCMD $SED $SENDMAIL; do
	test -x $i || appMisConfigured $i
    done

    #
    # Test/verify we know how to create FIFO special files.
    #
    case $MKFIFO in
    *mknod)
	mkfifo()
	{
	    $MKFIFO $1 p
	}
	;;
    *)
	mkfifo()
	{
	    $MKFIFO $1
	}
	;;
    esac
    $RM conffifo; JUNK="$JUNK conffifo"
    if (mkfifo conffifo && test -p conffifo) >/dev/null 2>&1; then
	true
    elif test -r conffifo; then			# NB: not everyone has test -p
	true
    else
	cat >&2 <<EOF

FATAL ERROR: Don't know how to create FIFO special files!

We were unable to create a FIFO special file using the command:

     $MKFIFO conffifo

HylaFAX requires support for FIFO special files and will not function
without this support.  If your system does not have support for FIFO
files then reconfigure it to include support (on some systems this
support is optional and requires recompilation or rebuilding of the
kernel).  If your system does have support for FIFO files but they are
not created using the expected program then you will need to reconfigure
and rebuild HylaFAX from the source distribution or emulate the needed
functionality (possibly by providing a shell script).

EOF
	boom
    fi
fi

#
# AWK support.
#
if onServer; then
    test -x $AWK		|| appMisConfigured $AWK
    # awk must support functions and -v
    CheckAwk()
    {
	($1 -v BAR=bar '
    function foo(x) {
    print "GOT" x
    }
    BEGIN { foo(BAR) }
    ' </dev/null | grep GOTbar) >/dev/null 2>&1
	return
    }
    CheckAwk $AWK || {
	cat >&2 <<EOF

FATAL ERROR: $AWK does not support needed functionality!

The following test does not work correctly with the configured awk program.

----------------------------------------------------------
$AWK -v BAR=bar '
function foo(x) {
print "GOT" x
}
BEGIN { foo(BAR) }
' </dev/null | grep GOTbar
----------------------------------------------------------

The HylaFAX software requires an awk program that supports functions and
the -v option for passing parameters from the command line.  The deficiency
of $AWK on your system will cause problems in various parts of the HylaFAX
software.

If you are running an old version of $AWK then get a more up to date
version.  Otherwise you can reconfigure HylaFAX from the source distribution
to force a different awk program to be used or you can, as a last resort,
try altering the shell scripts that are part of HylaFAX that use $AWK.

EOF
	boom
    }
fi

#
# Runtime Fontpath/Fontmap detection
#
if onClient; then
	getGSFonts()
	{
		$PATH_GSRIP -h 2>/dev/null | $AWK -F '[ ]' '
			BEGIN { start = 0; }
			/Search path:/ { start = 1 }
			{
				if (start == 1) {
						if ($1 == "") {
						gsub(" ","")
						gsub("^[.]","")
						gsub("^:","")
						printf "%s", $0
					} else if ($1 != "Search") start = 0
				}
			}	
		'
	}
	# If configure --with-PATH_AFM=<path> was used then we need to include it first.
	RUNTIME_PATH_AFM=$PATH_AFM:`getGSFonts`
	if [ -n "$RUNTIME_PATH_AFM" \
				-a "$RUNTIME_PATH_AFM" != "$PATH_AFM" ]; then 
	    Note ""
	    FONTPATHS=`echo $RUNTIME_PATH_AFM | sed 's/:/ /g'`
	    $PATH_GSRIP -q -sDEVICE=tiffg3 -sFONTPATH="$FONTPATHS" $DIR_SPOOL/bin/genfontmap.ps > $DIR_SPOOL/etc/Fontmap.HylaFAX 2>/dev/null
	    # Ghostscript 8.71 segfaults on that, but produces a valid Fontmap file, so we don't test exit code, but examine the product, instead.
	    {
		#
		# genfontmap.ps really just gives us a copy of Fontmap.GS, and in later Ghostscript versions there
		# are many Fontmap.GS references that are left undefined.  This may work for Ghostscript, but 
		# it does not work for us.  So, we need to do what we can to define them.
		#
		fontmap=$DIR_SPOOL/etc/Fontmap.HylaFAX
		newfontmap=$TMPDIR/Fontmap.HylaFAX.new.$$
		tmpfile=$TMPDIR/fontmap-fixup.$$
		$CP $fontmap $newfontmap
		for fontname in `$CAT $fontmap | $GREP "	/" | $SED -e 's/^[^\/]*\///g' -e 's/ .*//g'`; do 
		    if [ -z "`$GREP "^($fontname)" $fontmap`" ]; then
			# There is a blind reference to this font.  Fix that.
			for fontpath in `$PATH_GSRIP -h | $GREP -A 100 "Search path:" | $GREP " :" | $SED 's/://g'`; do 
			    $GREP -l -d recurse -a "FontDirectory/$fontname known" $fontpath 2>/dev/null; 
			done | $SED q > $tmpfile
			fontfile=`$CAT $tmpfile`
			if [ -n "$fontfile" ]; then
			    echo "($fontname)	($fontfile) ;" >> $newfontmap
		        else
			    echo "Warning: No font file found for \"$fontname\" but the font map includes it."
			fi
		    fi
		done
		$RM -f $tmpfile
		$MV -f $newfontmap $fontmap
	    }
	    if [ -n "`$GREP Courier-Bold $DIR_SPOOL/etc/Fontmap.HylaFAX`" ]; then
		FONTMAP="$DIR_SPOOL/etc"
		Note ""
		Note "Created our own Fontmap file in $DIR_SPOOL/etc."
		Note ""
	    else
		FONTMAP="$RUNTIME_PATH_AFM"
		$RM -f $DIR_SPOOL/etc/Fontmap.HylaFAX
	    fi
	    Note ""
	    Note "Setting Ghostscript font path in $DIR_LIBDATA/hyla.conf."
	    Note ""
	    if [ -f $DIR_LIBDATA/hyla.conf ]; then
		$AWK '!/^FontMap|^FontPath|\/FontPath added by/ { print }' \
			$DIR_LIBDATA/hyla.conf > $DIR_LIBDATA/hyla.conf.tmp
	    fi
	    echo "# FontMap/FontPath added by faxsetup (`date 2>/dev/null`)" \
	                                        >> $DIR_LIBDATA/hyla.conf.tmp
	    echo "FontMap:   $FONTMAP"          >> $DIR_LIBDATA/hyla.conf.tmp
	    echo "FontPath:  $RUNTIME_PATH_AFM" >> $DIR_LIBDATA/hyla.conf.tmp
	    $MV $DIR_LIBDATA/hyla.conf.tmp $DIR_LIBDATA/hyla.conf
	    PATH_AFM=$RUNTIME_PATH_AFM
	fi
fi

#
# Installation of Adobe Font Metric files
#
if onClient; then
    FDIRS=`echo $PATH_AFM | sed "s/:/ /g"`
    MATCH=
    for FDIR in $FDIRS; do
    if [ -d $FDIR ]; then
	cd $FDIR
	if [ -n "`ls | grep '\.afm'`" ] || [ -f Courier ]; then
		MATCH=$FDIR
		break
	fi
#    else
#	cat >&4 <<EOF
#
#
#Warning: $FDIR does not exist or is not a directory!
#
#The directory $FDIR does not exist or this file is not a directory.
#This is the directory where the HylaFAX client applications expect to
#locate font metric information to use in formatting ASCII text for
#submission as facsimile.  Without this information HylaFAX may generate
#illegible facsimile from ASCII text.
#
#EOF
    fi
    done
    if [ -z "$MATCH" ];then
	    cat >&4 <<EOF


Warning: Font metric information files were not found!

The font metric information file for the Courier font was not found in
the $PATH_AFM path.  This means that client HylaFAX applications 
that use this information to format ASCII text for submission as fax will
use incorrect information and generate potentially illegible facsimile.

If font metric information is present on your system in a directory other
than $PATH_AFM then you can setup a symbolic link to the appropriate
directory or you can specify the appropriate pathname in the configuration
file $DIR_LIBDATA/hyla.conf with a line of the form:

FontPath:	someplace_unexpected

EOF
     fi
fi

#
# PostScript RIP support.
#
if onServer; then
    cd $DIR_SPOOL
    case $PS in
    dps)	PATH_PSRIP=$PATH_DPSRIP;;
    imp)	PATH_PSRIP=$PATH_IMPRIP;;
    gs)		PATH_PSRIP=$PATH_GSRIP;;
    esac
    if [ -x "$PATH_PSRIP" ]; then
	if [ $PS = gs ]; then
	    # verify Ghostscript was linked with the tiffg3 device driver
	    $PATH_PSRIP -h 2>&1 | grep tiffg3 >/dev/null 2>&1 || {
		cat >&2 <<EOF

FATAL ERROR: No tiffg3 driver in $PATH_PSRIP.

HylaFAX has been configured to use Ghostscript as the PostScript
imaging program but the output of $PATH_PSRIP -h does not
list the tiffg3 driver as a configured driver (see below).

----------------------------------------------------------
% $PATH_PSRIP -h
EOF
$PATH_PSRIP -h
----------------------------------------------------------
		cat >&2 <<EOF

The tiffg3 driver is required for HylaFAX to operate correctly. 
Consult the documentation for information on building Ghostscript
with the necessary TIFF driver and then rerun faxsetup when a new
Ghostscript has been installed.

EOF
		boom
	    }
	elif [ $PS = dps ]; then
	    JUNK="$JUNK ps.fax"
	    $CAT etc/dpsprinter.ps | $PATH_PSRIP >/dev/null 2>&1
	    if [ $? -eq 2 ]; then
		if expr $RELEASE \>= 6.2 >/dev/null; then
		    cat >&2 <<EOF

FATAL ERROR: No DPS-based RIP available for IRIX $RELEASE!

The DPS-based PostScript RIP is a COFF executable and cannot be used
under IRIX $RELEASE.  You must use a different RIP such as fw_gs.sw.gs
which is found on the SGI Freeware CD-ROM and which is based on the
freely distributed Ghostscript software package.

Once you have installed the Ghostscript distribution rerun faxsetup
with the option -with-PS=gs to override the default setting.

EOF
		    boom
		fi
	    fi
	fi
    elif [ $PS = dps ]; then
	if expr $RELEASE \>= 6.2 >/dev/null; then
	    cat >&2 <<EOF

FATAL ERROR: No DPS-based RIP available for IRIX $RELEASE!

This distribution has been configured to use the DPS-based PostScript
RIP that is only available as a COFF executable.  This program cannot
be used under IRIX $RELEASE.  You must use a different RIP such as the
Ghostscript-based RIP in the fw_gs.sw.gs installation image which is
found on the SGI Freeware CD-ROM.

Once you have installed the Ghostscript distribution rerun faxsetup
with the option -with-PS=gs to override the default setting.

EOF
	    boom
	else
	    appMisConfigured $PATH_PSRIP
	fi
    else
	appMisConfigured $PATH_PSRIP
    fi
    #
    # Force bin/ps2fax and bin/pdf2fax to point to the appropriate scripts.
    #
    Note ""
    Note "Make $DIR_SPOOL/bin/ps2fax a link to $DIR_SPOOL/bin/ps2fax.$PS."
    Note ""
    $RM bin/ps2fax
    $RM bin/pdf2fax
    if [ -n "$LN_S" ]; then
	$LN $LN_S ps2fax.$PS bin/ps2fax;
	if [ $PS = gs ]; then
	    Note ""
	    Note "Make $DIR_SPOOL/bin/pdf2fax a link to $DIR_SPOOL/bin/pdf2fax.$PS."
	    Note ""
	    $LN $LN_S pdf2fax.$PS bin/pdf2fax;
	else
	    Note ""
	    Note "Server-side PDF conversion is not supported on this system."
	    Note ""
	fi
    else
	$LN bin/ps2fax.$PS bin/ps2fax;
	if [ $PS = gs ]; then
	    Note ""
	    Note "Make $DIR_SPOOL/bin/pdf2fax a link to $DIR_SPOOL/bin/pdf2fax.$PS."
	    Note ""
	    $LN bin/pdf2fax.$PS bin/pdf2fax;
	else
	    Note ""
	    Note "Server-side PDF conversion is not supported on this system."
	    Note ""
	fi
    fi
fi

#
# Find the full pathname of a file
# using the specified test operation.
#
findThing()
{
    t="$1"; app=$2; path=$3;
    case $app in
    /*) eval $t $app && { echo $app; return; };;
    esac
    IFS=:
    for i in $path; do
	eval $t $i/$app && { echo $i/$app; return; }
    done
}

#
# Find the full pathname of an executable.
#
findApp()
{
    findThing "test -x" $1 $2
}

#
# Deal with known alternate locations for system files.
#
PickFile()
{
    for i do
	test -f $i && { echo $i; return; }
    done
    echo $1
}

INETDCONF=`PickFile	$INETDCONF /etc/inetd.conf /etc/inet/inetd.conf`
ALIASES=`PickFile	$ALIASES   /etc/aliases /etc/ucbmail/aliases /etc/mail/aliases /usr/mmdf/table/alias.user /usr/mmdf/table/alias.n /etc/postfix/aliases`
SERVICES=`PickFile	$SERVICES  /etc/inet/services`
test -f /etc/master.passwd	&& PASSWD=/etc/master.passwd

#
# Figure out which brand of echo we have and define
# prompt and printf shell functions accordingly.
# Note that we assume that if the System V-style
# echo is not present, then the BSD printf program
# is available.
#
t=`(printf hello) 2>/dev/null`
if [ "$t" != hello ]; then
    cat >&2 <<EOF

FATAL ERROR: No printf command or emulation!

HylaFAX requires a shell-level program that understands C-style strings
(e.g. "\r") and has a mechanism for printing a string without a trailing
newline character.  The System V echo command and the BSD/POSIX-style
printf command are known to support these functions;  however your system
does not appear to have either of these programs.  If you have a program
hidden somewhere on your system be sure to include it in the search path
used by faxsetup:

    $PATH

and then rerun faxsetup.  Otherwise a printf command is included in the
GNU shell utilities package that can be retrieved by public FTP.

EOF
    boom
fi
if onServer; then
    dumpPromptFuncs >&5
fi

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
	    x=
	    echo
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
	x=
	echo
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
	    x=
	    echo
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
	    x=
	    echo
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
	    x=
	    echo
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

faxUID=`grep "^$PROTOUID:" $PASSWD | cut -d: -f3`
if [ -z "$faxUID" ]; then faxUID=$defPROTOUID; fi
faxGID=`grep "^$PROTOGID:" $GROUP | cut -d: -f3`
if [ -z "$faxGID" ]; then faxGID=$defPROTOGID; fi

#
# Add a fax user to the password file and lock the
# entry so that noone can login as the user.
#
addFaxUser()
{
    emsg1=`addPasswd $FAX $faxUID $faxGID $DIR_SPOOL 2>&1`
    case $? in
    0)  emsg2=`lockPasswd $FAX 2>&1`
	case $? in
	0) echo "Added user \"$FAX\" to $PASSWD.";;
	*) emsg3=`deletePasswd $FAX 2>&1`
	   case $? in
	   0|9) cat <<-EOF

		Failed to add user "$FAX" to $PASSWD because the
		attempt to lock the password failed with:

		"$emsg2"

		Please fix this problem and rerun this script."

		EOF
		;;
	   *)   cat <<-EOF

		You will have to manually edit $PASSWD because
		after successfully adding the new user "$FAX", the
		attempt to lock its password failed with:

		"$emsg2"

		and the attempt to delete the insecure passwd entry failed with:

		"$emsg3"

		To close this security hole, you should add a password
		to the "$FAX" entry in the file $PASSWD, or lock this
		entry with an invalid password.

		EOF
		;;
	    esac
	    boom;;
	esac;;
    9)  # fax was already in $PASSWD, but not found with grep
	;;
    *)  cat <<-EOF

	There was a problem adding user "$FAX" to $PASSWD;
	the command failed with:

	"$emsg1"

	HylaFAX will not work until you have corrected this problem.

	EOF
	boom;;
    esac
}

isOK()
{
    x="$1"
    test -z "$x" || test "$x" = y || test "$x" = yes
}

if onServer; then
    x=`grep "^$FAX:" $PASSWD | cut -d: -f3`
    if [ "$PASSWD" = "/etc/master.passwd" ]; then
	PARAMLOC=9;
    else
	PARAMLOC=6;
    fi
    if [ -z "$x" ]; then
	echo ""
	echo ""
	echo "You do not appear to have a \"$FAX\" user in the password file."
	prompt "HylaFAX needs this to work properly, add it [yes]?"
	if [ "$INTERACTIVE" != "no" ]; then
	    read x
	else
	    x=
	    echo
	fi
	isOK $x && addFaxUser
    fi
    machdepPasswdWork

    #
    # Verify existence, permission and ownership of sensitive files.
    # XXX there are other files too 
    #
    HOSTS=$DIR_SPOOL/etc/hosts.hfaxd
    test -f $HOSTS || {
	cat<<EOF

Warning: $1 does not exist!

The file $1 does not exist or is not a regular file.
This file specifies which clients are permitted to use the HylaFAX
server.  The file will be initialized so that local clients are
provided service.  Consult the HTML documentation and the manual
page hosts.hfaxd(5F) for more information on setting up this file.

EOF
	$RM $HOSTS
	echo "localhost" >$HOSTS
	echo "127.0.0.1" >>$HOSTS
    }
    #
    # Too complicated to check contents:
    # simply force correct protection and ownership
    #
    $CHOWN $faxUID $HOSTS; $CHGRP $faxGID $HOSTS
    $CHMOD 600 $HOSTS
fi

#
# Check for services entries for hylafax and snpp.
#
hasYP=`(ypcat services) 2>/dev/null | $SED -n '$p'` 2>/dev/null
x=`$GREP '^hylafax[ 	]' $SERVICES 2>/dev/null` 2>/dev/null
if [ -z "$x" ]; then
    if [ "$hasYP" ]; then
	x=`ypcat services 2>/dev/null | $GREP '^hylafax[ 	]'` 2>/dev/null
    fi
    if [ -z "$x" ]; then
	ENTRY="hylafax	4559/tcp		# HylaFAX client-server protocol"
	cat<<-EOF


	Warning: No hylafax service entry found!

	No entry was found for the hylafax service in the YP/NIS database
	or in the $SERVICES file.  The software should work properly
	without one (except if you want to start hfaxd from inetd), but you
	will see warning messages whenever you run a HylaFAX client
	application.  If you want to manually add an entry the following
	information should be used:

	$ENTRY

	EOF
	prompt "Should a hylafax entry be added to $SERVICES [yes]?"
	if [ "$INTERACTIVE" != "no" ]; then
	    read x
	else
	    x=
	    echo
	fi
	isOK $x && echo "$ENTRY" >>$SERVICES
    fi
fi
x=`$GREP '^snpp[ 	]' $SERVICES 2>/dev/null` 2>/dev/null
if [ -z "$x" ]; then
    if [ "$hasYP" ]; then
	x=`ypcat services 2>/dev/null | $GREP '^snpp[ 	]'` 2>/dev/null
    fi
    if [ -z "$x" ]; then
	ENTRY="snpp	444/tcp		# Simple Network Paging Protocol"
	cat<<-EOF


	Warning: No snpp service entry found!

	No entry was found for the Simple Network Paging Protocol (SNPP)
	service in the YP/NIS database or in the $SERVICES file.
	The software should work properly without one (except if you want
	to start hfaxd from inetd), but you will see warning messages whenever
	you run the HylaFAX sendpage program.  If you want to manually add
	an entry the following information should be used:

	$ENTRY

	EOF
	prompt "Should an snpp entry be added to $SERVICES [yes]?"
	if [ "$INTERACTIVE" != "no" ]; then
	    read x
	else
	    x=
	    echo
	fi
	isOK $x && echo "$ENTRY" >>$SERVICES
    fi
fi

#
# Check that for servers being started at system boot.
#
if onServer; then
    signalINETD=no
    if [ -f ${DIR_SYSVINIT}/hylafax ]; then
	# started by init at boot time
        if [ $FAXQ_SERVER = no ]; then
            cat <<EOF

Warning faxq will NOT be automatically started on reboot!

EOF
            true
        fi
    fi
    if [ -f $INETDCONF ] && [ $HFAXD_SERVER = no ]; then
	E="hylafax	stream	tcp	nowait	root	$DIR_LIBEXEC/hfaxd	hfaxd -I"
	editInetdConf()
	{
	    ed - $INETDCONF<<EOF
/^hylafax[ 	]*stream[ 	]*tcp/d
a
$E
.
w
q
EOF
	    if [ $? != 0 ]; then
		cat<<EOF

FATAL ERROR: Unable to correct HylaFAX entry in $INETDCONF!

We were unable to edit the $INETDCONF file to correct the entry
for starting up the HylaFAX client-server protocol process.  You
must manually correct this entry so that it reads:

$E

and then rerun faxsetup.

EOF
		boom
	    fi
	}
	eval `$GREP '^hylafax[ 	]*stream[ 	]*tcp' $INETDCONF | \
	    $AWK -F'[ 	]+' '{ print "F=" $6 "; U=" $5 }' 2>/dev/null`
	if [ -z "$F" ] && [ -z "$U" ]; then
	    cat<<EOF


There is no entry for the hylafax service in $INETDCONF.
The HylaFAX client-server protocol process can be setup to run
standalone or started by the inetd program.  A standalone setup
is preferred for performance reasons, especially if hfaxd is to
support multiple protocols (e.g. SNPP); however it may require
manual setup if your operating system does not have a System-V
style init program.

EOF
	    prompt "Should an entry be added to $INETDCONF [no]?";
	    if [ "$INTERACTIVE" != "no" ]; then
		read x
	    else
		x=
		echo
	    fi
	    if [ "$x" = y ] || [ "$x" = yes ]; then
		echo "$E" >>$INETDCONF;
		signalINETD=yes
	    fi
	else
	    if [ "$F" != $DIR_LIBEXEC/hfaxd ]; then
		cat<<EOF


Warning: $INETDCONF is setup wrong!

The $INETDCONF file is setup to start $F
instead of $DIR_LIBEXEC/hfaxd.  You will need to correct
this before client requests to submit jobs will be properly serviced.

EOF
		prompt "Should the entry in $INETDCONF be corrected [yes]?";
		if [ "$INTERACTIVE" != "no" ]; then
		    read x
		else
		    x=
		    echo
		fi
		isOK "$x" && editInetdConf
	    fi
	    if [ "$U" != $FAX ]; then
		cat<<EOF


Warning: $INETDCONF is setup wrong!

Warning, the HylaFAX entry is setup so that $F is run by the
$U user instead of the $FAX user.  This must be corrected
before client requests to submit jobs will be properly serviced.

EOF
		prompt "Should the entry in $INETDCONF be corrected [yes]?";
		if [ "$INTERACTIVE" != "no" ]; then
		    read x
		else
		    x=
		    echo
		fi
		isOK "$x" && editInetdConf
	    fi
	fi
    elif [ ! -f $INETDCONF ] && [ $HFAXD_SERVER = no ]; then
	cat<<EOF


Warning: Don't know how to startup HylaFAX servers!

No $INETDCONF file was found and the System V boot script
that starts up the HylaFAX server processes was also not present.
You will need to manually arrange for the various HylaFAX servers
to be started up on your system when it is booted multi-user. 
Specifically you will need to start the faxq and hfaxd programs and
any faxgetty processes that are to service inbound calls on modems.

EOF
    fi
fi

#
# Check for a FaxMaster entry for sending mail.
#
if onServer; then
    x=`(ypcat -k aliases) 2>/dev/null | $GREP -i '^faxmaster'` 2>/dev/null
    if [ -z "$x" ] && [ -f $ALIASES ]; then
	x=`$GREP -i '^faxmaster' $ALIASES`
    fi
    if [ -z "$x" ]; then
	cat<<-EOF


	There does not appear to be an entry for the FaxMaster either in
	the YP/NIS database or in the $ALIASES file.  The
	FaxMaster is the primary point of contact for HylaFAX problems. 
	The HylaFAX client-server protocol server identifies this alias as
	the place to register complaints and HylaFAX directs automatic mail
	messages to this user when problems are identified on a server
	machine or when the routine server maintainence scripts are run
	(e.g. faxcron).

	EOF
	prompt "Should an entry be added for the FaxMaster to $ALIASES [yes]?"
	if [ "$INTERACTIVE" != "no" ]; then
	    read x
	else
	    x=
	    echo
	fi
	if isOK $x; then
	    promptForNonNullStringParameter "${USER:-root}" \
	       "Users to receive fax-related mail"
	    (echo "# alias for notification messages from HylaFAX servers";
	     echo "FaxMaster: $param") >>$ALIASES
	    if newaliases 2>/dev/null; then
		echo "Rebuilt $ALIASES database."
	    else
		# could be a SCO machine running mmdf
		if test -x /usr/mmdf/table/dbmbuild ; then
		    su mmdf -c "/usr/mmdf/table/dbmbuild"
		else
		    echo "Can not find newaliases to rebuild $ALIASES;"
		    echo "you will have to do it yourself."
		fi
	    fi
	fi
    fi
    FAXMASTER=$x
fi

#
# Generate or update default values for status/any.info
#
if onServer; then
    if [ -r $DIR_SPOOL/status/any.info ]; then
	INFO=`cat $DIR_SPOOL/status/any.info | \
	$GREP -v "HylaFAX version" | $GREP -v "FaxMaster"`
    else INFO=""
    fi
    if [ -d $DIR_SPOOL/status ]; then
	echo "Update $DIR_SPOOL/status/any.info."
	echo "HylaFAX version $VERSION built $DATE for $TARGET" \
	> $DIR_SPOOL/status/any.info
	echo $FAXMASTER >> $DIR_SPOOL/status/any.info
	echo $INFO >> $DIR_SPOOL/status/any.info
    fi
fi

#
# Generate ssl.pem file for SSL Fax if it doesn't exist.
#
if [ -r $DIR_SPOOL/etc/ssl.pem ]; then
    echo "It looks like etc/ssl.pem already exists."
elif [ "$OPENSSL" = "disabled" ]; then
    printf ""	# do nothing, it was disabled in configure (missing libraries, cannot act as server)
elif [ -e "$OPENSSL" ]; then
    prompt "Generate etc/ssl.pem for SSL Fax [yes]?";
    if [ "$INTERACTIVE" != "no" ]; then
	read ok
    else
	ok=
	echo
    fi
    if isOK "$ok"; then
	$OPENSSL req -x509 -nodes -days 9999 -newkey rsa:2048 -keyout $DIR_SPOOL/etc/ssl.pem -out $DIR_SPOOL/etc/ssl.pem
	$CHOWN $faxUID $DIR_SPOOL/etc/ssl.pem; $CHGRP $faxGID $DIR_SPOOL/etc/ssl.pem
    else
	echo "Skipping creation of etc/ssl.pem for SSL Fax."
    fi
else
    echo "Cannot find openssl for creation of etc/ssl.pem for SSL Fax."
fi


#
# Emit shell functions required by faxaddmodem.
#
if onServer; then
    printConfig()
    {
	cat<<EOF

	HylaFAX configuration parameters are:

	[1] Init script starts faxq:		$FAXQ_SERVER
	[2] Init script starts hfaxd		$HFAXD_SERVER
	[3] Start paging protocol:		$HFAXD_SNPP_SERVER
EOF
    }

    promptForParameter()
    {
	case $1 in
	    1) promptForBooleanParameter "$FAXQ_SERVER" \
		"Init script starts faxq";	FAXQ_SERVER="$param"
	    ;;
	    2) promptForBooleanParameter "$HFAXD_SERVER" \
		"Init script starts hfaxd";	HFAXD_SERVER="$param"
	    ;;
	    3) promptForBooleanParameter "$HFAXD_SNPP_SERVER" \
		"Start paging protocol";	HFAXD_SNPP_SERVER="$param"
	    ;;
	esac
    }

    ok=skip
    while [ "$ok" != y ] && [ "$ok" != yes ]; do
	if [ "$ok" != skip ]; then
	    for i in 1 2 3 4 ; do
	       promptForParameter $i;
	    done
	fi
	printConfig
	prompt "Are these ok [yes]?";
	if [ "$INTERACTIVE" != "no" ]; then
	    read ok;
	else
	    ok=y
	    echo
	fi
	test -z "$ok" && ok=yes
	case "$ok" in
	[1-4])	promptForParameter $ok;;
	[yY]*|[nN]*)	continue;;
	?*)
	    echo ""
	    echo "\"y\", \"yes\", or <RETURN> accepts the displayed parameters."
	    echo "A number lets you change the numbered parameter."
	    echo ""
	    ;;
	esac
	ok=skip
    done

    STTYCMD=`findApp stty $PATH`
    (dumpTTYFuncs; dumpSTTYFuncs; dumpOtherModemFuncs)>&5
    $RM $DIR_LIBDATA/setup.modem
    $RM $DIR_SPOOL/etc/setup.modem
    $MV $DIR_LIBDATA/setup.tmp $DIR_LIBDATA/setup.modem
    $CHMOD 444 $DIR_LIBDATA/setup.modem
    $LN $DIR_LIBDATA/setup.modem $DIR_SPOOL/etc/setup.modem || $LN -s $DIR_LIBDATA/setup.modem $DIR_SPOOL/etc/setup.modem

    $RM $DIR_LIBDATA/setup.cache
    $RM $DIR_SPOOL/etc/setup.cache
    (echo '# Warning, this file was automatically generated by faxsetup'
     echo '# on' `date` "for ${USER:-$euid}"
     dumpvals |sort)> $DIR_LIBDATA/setup.cache
    $CHMOD 444 $DIR_LIBDATA/setup.cache
    $LN $DIR_LIBDATA/setup.cache $DIR_SPOOL/etc/setup.cache || $LN -s $DIR_LIBDATA/setup.cache $DIR_SPOOL/etc/setup.cache

    Note ""
    Note "Modem support functions written to $DIR_LIBDATA/setup.modem."
    Note "Configuration parameters written to $DIR_LIBDATA/setup.cache."
fi

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

checkForLocalFile()
{
    f="`echo $1 | $SED 's/\"//g'`"
    if [ ! -f $DIR_SPOOL/$f ]; then
	cat<<EOF

Warning, the $2 file,

    $DIR_SPOOL/$f

does not exist, or is not a plain file.  This file must
reside in the $DIR_SPOOL directory tree.
EOF
	ok=no;
    fi
}

isNotOK()
{
    x="$1"
    test "$x" != y && test "$x" != yes
}

CONFIG=$DIR_SPOOL/etc/config		# faxq config file
if onServer; then
    if [ ! -f $CONFIG ]; then
	for i in $SchedulerParameters; do
	    eval $i=\$default$i
	done
	echo ""
	echo "No scheduler config file exists, creating one from scratch."
	ok=prompt				# prompt for parameters

	PROMPTS=$TMPDIR/faxpr$$
	JUNK="$JUNK $PROMPTS"
	$RM -rf $PROMPTS

	while true; do
	    if [ "$ok" != skip ]; then
		test -f $PROMPTS || (
		${NOCLOBBER_ON}
		> $PROMPTS || boom
		${NOCLOBBER_OFF}
		compilePrompts>$PROMPTS<<EOF
#	CountryCode		Country code
#	AreaCode		Area code
#	LongDistancePrefix	Long distance dialing prefix
#	InternationalPrefix	International dialing prefix
NNS	DialStringRules		Dial string rules file (relative to $DIR_SPOOL)
C#	ServerTracing		Tracing during normal server operation
C#	SessionTracing		\
	Default tracing during send and receive sessions
S	ContCoverPage		Continuation cover page (relative to $DIR_SPOOL)
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
)
		. $PROMPTS
	    fi
	    checkForLocalFile $DialStringRules "dial string rules"
	    printSchedulerConfig; prompt "Are these ok [yes]?";
	    if [ "$INTERACTIVE" != "no" ]; then
		read ok
	    else
		ok=
		echo
	    fi
	    isOK "$ok" && break
	done

	#
	# All done with the prompting; edit up a config file!
	#
	echo ""
	echo "Creating new configuration file $CONFIG..."
	echoSchedulerParameters >$CONFIG 2>/dev/null
	test -s $CONFIG || {
	    JUNK="$JUNK $CONFIG"		# clobber on exit
	    cat<<EOF

FATAL ERROR: Problem writing $CONFIG!

Sorry, something went wrong writing the new scheduler configuration
file.  Check to make sure there is sufficient disk space and rerun
this script.

EOF
	    boom
	}
	$CHOWN $faxUID $CONFIG; $CHGRP $faxGID $CONFIG
	$CHMOD 644 $CONFIG
    fi
fi

#
# Startup/restart server processes.
#
if onServer; then
    echo ""
    echo "Restarting HylaFAX server processes."

    findproc()
    {
	# NB: ps ax should give an error on System V, so we try it first!
	pid="`ps ax 2>/dev/null | $AWK \"\
		/[\/ (]$1[ )]/	{print \\$1;}
		/[\/ ]$1\$/	{print \\$1;}\"`"
	test "$pid" ||
	    pid="`ps -e 2>/dev/null | $AWK \"/ $1[ ]*\$/ {print \\$1;}\"`"
	echo "$pid"
    }

    HFAXD="`findproc hfaxd`"
    if [ "$HFAXD" ]; then
	echo ""
	echo "You seem to be running HylaFAX (there are hfaxd processes)."
	prompt "Is it ok to terminate these processes ($HFAXD) [yes]?";
	if [ "$INTERACTIVE" != "no" ]; then
	    read x
	else
	    x=
	    echo
	fi
	if isOK "$x"; then
	    if [ -x /bin/systemctl ]; then
		echo "Executing '/bin/systemctl stop hylafax-hfaxd'..."
		/bin/systemctl stop hylafax-hfaxd
	    elif kill $HFAXD; then
		echo "Sent a SIGTERM to processes $HFAXD."
	    else
		echo "Unable to send a SIGTERM to processes $HFAXD."
	    fi
	    while true; do
		for delay in 1 1 2 2 5 5; do
		    HFAXD="`findproc hfaxd`"
		    test "$HFAXD" || break
		    sleep $delay
		done
		test -z "$HFAXD" && break
		cat<<EOF

Warning: hfaxd is still running!

Something is hung.  The command

    kill $HFAXD
    
did not terminate the hfaxd processes as expected.
EOF
		prompt "Should we continue to wait [no]?";
		if [ "$INTERACTIVE" != "no" ]; then
		    read x
		else
		    x=
		    echo
		fi
		isNotOK "$x" && break
	    done
	fi
    fi
    FAXQ="`findproc faxq`"
    if [ "$FAXQ" ]; then
	cat<<EOF

You have a HylaFAX scheduler process running.  faxq will be
restarted shortly, as soon as some other work has been completed.
EOF
	prompt "Can I terminate this faxq process ($FAXQ) [yes]?";
	if [ "$INTERACTIVE" != "no" ]; then
	    read x
	else
	    x=
	    echo
	fi
	if isOK "$x"; then
	    if [ -x /bin/systemctl ]; then
		echo "Executing '/bin/systemctl stop hylafax-faxq'..."
		/bin/systemctl stop hylafax-faxq
	    else
		$DIR_SBIN/faxquit >/dev/null 2>&1
	    fi
	    while true; do
		for delay in 1 1 2 2 5 5; do
		    FAXQ="`findproc faxq`"
		    test "$FAXQ" || break
		    sleep $delay
		done
		test -z "$FAXQ" && break
		pids=
		for p in faxsend pagesend; do
		    pids="${pids}`findproc $p`"
		done
		if [ "$pids" ]; then
		    cat<<EOF

Warning: faxq is busy with outbound jobs!

faxq did not terminate in response to the faxquit command because
there are subprocesses actively processing outbound jobs.
EOF
		    prompt "Should we continue to wait [yes]?";
		    if [ "$INTERACTIVE" != "no" ]; then
			read x
		    else
			x=
			echo
		    fi
		    isOK "$x" || break
		else
		    cat<<EOF

Warning: faxq is still running for some reason!

Something is hung, faxq did not terminate in response to the faxquit
command.  There do not appear to be any faxsend or pagesend subprocesses
actively handling outbound jobs so the reason for it running is unknown.
EOF
		    prompt "Should we continue to wait [no]?";
		    if [ "$INTERACTIVE" != "no" ]; then
			read x
		    else
			x=
			echo
		    fi
		    isNotOK "$x" && break
		fi
	    done
	fi
    fi

    if [ "$FAXQ" ] || [ "$HFAXD" ]; then
	cat<<EOF

FATAL ERROR: Old server processes still running!

One or more old server processes are still running.  It is not wise
to start new server processes while old processes are running because
their actions might conflict.  You need to terminate the existing
processes and rerun this script or manually startup the new HylaFAX
server processes.

EOF
	boom
    fi

    if [ "$signalINETD" = yes ]; then
	INETD="`findproc inetd`"
	if [ "$INETD" ]; then
	    if kill -HUP $INETD 2>/dev/null; then
		echo "Sent inetd a SIGHUP so that it re-reads the configuration file."
	    else
		echo "Unable to send inetd a SIGHUP, you may need to do it yourself."
	    fi
	else
	    echo "Strange, you do not seem to have an inetd process running."
	fi
    fi

    prompt "Should I restart the HylaFAX server processes [yes]?";
    if [ "$INTERACTIVE" != "no" ]; then
	read x
    else
	x=
	echo
    fi
    if isOK "$x"; then
	echo ""
	if [ -x /bin/systemctl ]; then
	    echo "Executing '/bin/systemctl start hylafax-faxq'..."
	    /bin/systemctl start hylafax-faxq
	    echo "Executing '/bin/systemctl start hylafax-hfaxd'..."
	    /bin/systemctl start hylafax-hfaxd
	elif [ -x ${DIR_SYSVINIT}/hylafax ]; then
	    echo ${DIR_SYSVINIT}/hylafax start
	    ${DIR_SYSVINIT}/hylafax start
	else
	    echo $DIR_SBIN/faxq; $DIR_SBIN/faxq
	    hfaxdopts=
	    if isOK "$HFAXD_SERVER"; then hfaxdopts="-i hylafax "; fi
	    if isOK "$HFAXD_SNPP_SERVER"; then hfaxdopts="$hfaxdopts\-s snpp"; fi
	    echo "$DIR_SBIN/hfaxd $hfaxdopts"; eval "$DIR_SBIN/hfaxd $hfaxdopts"
	fi
    fi

    DEVS="`cd $DIR_SPOOL/etc; echo config.*`"
    if [ -z "$DEVS" ] || [ "$DEVS" = 'config.*' ]; then
	cat<<EOF

You do not appear to have any modems configured for use.  Modems are
configured for use with HylaFAX with the faxaddmodem(8C) command.
EOF
	prompt "Do you want to run faxaddmodem to configure a modem [yes]?";
	if [ "$INTERACTIVE" != "no" ]; then
	    read x
	else
	    x=no
	    echo
	fi
	while isOK "$x"; do
	     $DIR_SBIN/faxaddmodem
	     prompt "Do you want to run faxaddmodem to configure another modem [yes]?"; read x
	done
	DEVS="`cd $DIR_SPOOL/etc; echo config.*`"
    fi

    if [ -n "$DEVS" ] && [ "$DEVS" != 'config.*' ]; then
	FAXGETTY="`findproc faxgetty`"
	if [ "$FAXGETTY" ]; then
	    cat<<EOF

Looks like you have some faxgetty processes running (PIDs are):

    $FAXGETTY

It is usually a good idea to restart these processes after running
faxsetup; especially if have just installed new software.  If these
processes are being started by init(8C) then sending each of them a
QUIT message with the faxquit command should cause them to be restarted.
EOF
	    prompt "Is it ok to send a QUIT command to each process [yes]?"
	    if [ "$INTERACTIVE" != "no" ]; then
		read x
	    else
		x=
		echo
	    fi
	    if isOK "$x"; then
		for x in $DEVS; do
		    devid="`expr $x : 'config.\(.*\)'`"
		    if [ -w $DIR_SPOOL/FIFO.$devid ]; then
			echo $DIR_SBIN/faxquit $devid
			$DIR_SBIN/faxquit $devid >/dev/null 2>&1
		    fi
		done
	    fi
	else
	    if [ -f /etc/inittab ]; then
		FAXGETTY="`$GREP '[^#].*:respawn:faxgetty.*' /etc/inittab`"
	    elif [ -f /etc/ttys ]; then
		FAXGETTY="`$GREP '[^#].*faxgetty.*' /etc/ttys`"
	    fi
	    if [ "$FAXGETTY" ]; then
		cat<<EOF

You appear to have faxgetty setup to run on some tty lines but no faxgetty
processes were found running.  This might happen if you manually edited the
tty configuration file but did not notify init to re-read the file.

EOF
		prompt "Send init a SIGHUP so that it re-reads its configuration file [yes]?"
		if [ "$INTERACTIVE" != "no" ]; then
		    read x
		else
		    x=
		    echo
		fi
		if isOK "$x"; then
		    init="`findproc init`"
		    if [ "$init" ]; then
			if kill -HUP $init; then
			    echo "Sent init a SIGHUP; the faxgetty processes should be started."
			else
			    echo "Unable to send init a SIGHUP; you may need to do this yourself."
			fi
		    else
			echo "Strange, you do not seem to have an init process running!"
		    fi
		fi
	    else
		cat<<EOF

You do not appear to be using faxgetty to notify the HylaFAX scheduler
about new modems and/or their status.  This means that you must use the
faxmodem program to inform the new faxq process about the modems you
want to have scheduled by HylaFAX.  Beware that if you have modems that
require non-default capabilities specified to faxmodem then you should
read faxmodem(8C) manual page and do this work yourself (since this
script is not intelligent enough to automatically figure out the modem
capabilities and supply the appropriate arguments).

EOF
		prompt "Should I run faxmodem for each configured modem [yes]?"
		if [ "$INTERACTIVE" != "no" ]; then
		    read x
		else
		    x=no
		    echo
		fi
		if isOK "$x"; then
		    for x in $DEVS; do
			devid="`expr $x : 'config.\(.*\)'`"
			if [ -w $DIR_SPOOL/FIFO.$devid ]; then
			    echo $DIR_SBIN/faxmodem $devid
			    $DIR_SBIN/faxmodem $devid >/dev/null 2>&1
			fi
		    done
		fi
	    fi
	fi
    fi
fi

Note ""
Note "Done verifying system setup."

if onServer; then
    $RM $JUNK
    $RM -r $TMPDIR
fi
exit 0
