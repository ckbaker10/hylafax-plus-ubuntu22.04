#! /usr/bin/bash
#	$Id: install.sh.in 559 2007-07-22 06:03:54Z faxguy $
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
# Warning, this file was automatically created by the HylaFAX configure script
#
# VERSION:	7.0.6
# DATE:		Fri Jun 24 19:36:27 UTC 2022
# TARGET:	x86_64-unknown-linux-gnu
#

#
# Shell script to emulate Silicon Graphics install program.
# We emulate the non-standard interface used by install so
# that we can build SGI inst packages on SGI systems.  Note
# that we cannot emulate everything because we don't maintain
# a history of installed software; thus we cannot tell when
# configuration files have been modified and save old copies.
#
# NB: we don't do chown/chmod/chgrp by default; it must be
#     explicitly set on the command line.
#

#
# install [options] files ...
# 
# Options are:
#
# -o		save existing target foo as OLDfoo
# -O		remove existing target foo, if it fails save as OLDfoo
# -m mode	set mode of installed target
# -u uid	set uid of installed target
# -g gid	set gid of installed target
# -root path	set ROOT directory for target pathnames
# -dir		create directories
# -fifo		create FIFO special files
# -ln path	create hard link
# -lns path	create symbolic link
# -src path	source pathname different from target
# -f dir	install files in the target directory ROOT/dir
# -F dir	like -f, but create directories that do not exist
# -v		echo actions
# -idb stuff	specify package and, optionally, do special work
#
preopts=
postopts=
SaveFirst=no
HasSource=yes
RemoveFirst=no
NoUpdate=no
Suggested=no
Updated=no

CMD="/usr/bin/cp"
SRC=
FILES=
DESTDIR=
CHMOD=": /usr/bin/chmod"
CHOWN=": /usr/bin/chown bin:bin"
CHGRP=":"
RM="/usr/bin/rm -f"
MV="/usr/bin/mv -f"
ECHO=/usr/bin/echo
VERBOSE=":"
STRIP="/usr/bin/strip"
CMP=/usr/bin/cmp
objectExists()
{
    return 1
}

TARGETS=
while [ x"$1" != x ]
do
    arg=$1
    case $arg in
    -m)		shift; CHMOD="/usr/bin/chmod $1";;
    -u)		shift; CHOWN="/usr/bin/chown $1";;
    -g)		shift; CHGRP="/usr/bin/chgrp $1";;
    -o)		SaveFirst=yes;;
    -O)		RemoveFirst=yes; SaveFirst=yes;;
    -root)	shift; ROOT=$1;;
    -dir)	CMD="/usr/bin/mkdir -p"; HasSource=no;
		RM=":"; STRIP=":"
		objectExists()
		{
		    test -d $1
		}
		;;
    -fifo)	CMD=/usr/bin/mkfifo; HasSource=no;
		case $CMD in
		*mknod)	postopts="p";;
		esac
		STRIP=":"
		objectExists()
		{
		    #
		    # If -p is not supported then the right thing
		    # should still happen...
		    #
		    test -p $1 >/dev/null 2>&1
		}
		;;
    -ln)	shift; CMD=/usr/bin/ln; SRC="${ROOT}$1"
		STRIP=":"
		;;
    -lns)	shift; CMD=/usr/bin/ln; preopts="-s"; SRC="$1"
		STRIP=":"
		objectExists()
		{
		    #
		    # Some systems support -h to check for a
		    # symbolic link and others -l; one should
		    # do the right thing or both should fail.
		    #
		    (test -h $1 || test -l $1) >/dev/null 2>&1
		}
		;;
    -src)	shift; SRC="$1";;
    -f)		shift; DESTDIR="$1/";;
    -F)		shift; DESTDIR="$1/"
		test -d $ROOT$DESTDIR || /usr/bin/mkdir -p $ROOT$DESTDIR
		;;
    -idb)	shift; opt="$1"
		case "$opt" in
		*config\(update\)*)	Updated=yes;;
		*config\(suggest\)*)	Suggested=yes;;
		*config\(noupdate\)*)	NoUpdate=yes;;
		*nostrip*)		STRIP=":";;
		esac
		;;
    # these are skipped/not handled
    -new|-rawidb|-blk|-chr) shift;;
    -v)		VERBOSE=$ECHO;;
    -*) 	;;
    *)		TARGETS="$TARGETS $arg";;
    esac
    shift
done

# I'll assume install.sh is only used from within HylaFAX Makefiles
ROOT_SH=`echo $0 | sed 's;/port/install.sh;;'`/root.sh
# If we are not root we write commands to root.sh
do_chXXX()
{
#	Check the user id.
	eval `id  |  sed 's/[^a-z0-9=].*//'`
	if [ "${uid:=0}" -ne 0 ]
	then
	        echo "$*" >> ${ROOT_SH}
	else
		eval $*
	fi
}

#
# Install the specified target.
#
install()
{
    src=$1 target=$2
    if [ $RemoveFirst = yes ] && [ -f $target ]; then
	$VERBOSE "$RM $target"
	$RM $target
    fi
    if [ $SaveFirst = yes ] && [ -f $target ]; then
	bf=`echo $src | /usr/bin/sed 's;.*/;;'`
	$VERBOSE "$MV $target $ROOT/$DESTDIR/OLD$bf"
	$MV $target $ROOT/$DESTDIR/OLD$bf
    fi
    if [ -z "$SRC" ] && [ $HasSource = yes ]; then
	$VERBOSE "$CMD $preopts $src $target $postopts"
	$CMD $preopts $f $target $postopts
    elif [ $SaveFirst = no ] && objectExists $target; then
	$VERBOSE "$target exists; not remade"
    else
	$VERBOSE "$CMD $preopts $SRC $target $postopts"
	$CMD $preopts $SRC $target $postopts
    fi
    if [ $? -eq 0 ]; then
	$VERBOSE "$CHOWN $target"
	do_chXXX $CHOWN $target
	if [ "$CHGRP" != ":" ]; then
	    $VERBOSE "$CHGRP $target"
	    do_chXXX $CHGRP $target
	fi
	$VERBOSE "$CHMOD $target"
	do_chXXX $CHMOD $target
	if [ $STRIP != ":" ] && [ -x $ROOT$DESTDIR$f ]; then
	    $STRIP $target >/dev/null 2>&1 || true
	    $VERBOSE "$STRIP $target"
	fi
    fi
}

if [ $Suggested = yes ]; then
    #
    # A suggested file.  If an existing target does
    # not exist, then install it.  Otherwise, install
    # it as target.N if it's different from the current
    # installed target.
    #
    # NB: cannot be used with a special file 'cuz we
    #     use test -f to see if the file exists.
    #
    for f in $TARGETS; do
	t=$ROOT$DESTDIR$f
	if [ -f $t ]; then
	    if [ -z "$SRC" ] && [ $HasSource = yes ]; then
		$CMP -s $f $t || {
		    $ECHO "*** Warning, target has local changes, installing $f as $t.N"
		    install $f $t.N;
		}
	    else
		$CMP -s $SRC $t || {
		    $ECHO "*** Warning, target has local changes, installing $f as $t.N"
		    install $f $t.N
		}
	    fi
	else
	    install $f $t
	fi
    done
elif [ $Updated = yes ]; then
    #
    # A file to be updated.  If an existing target does
    # not exist, then install it.  Otherwise, install
    # it as target and save the old version as target.O
    # if the old version is different from the current
    # installed target.
    #
    # NB: cannot be used with a special file 'cuz we
    #     use test -f to see if the file exists.
    #
    for f in $TARGETS; do
	t=$ROOT$DESTDIR$f
	if [ -f $t ]; then
	    if [ -z "$SRC" ] && [ $HasSource = yes ]; then
		$CMP -s $f $t || $MV $t $t.O
	    else
		$CMP -s $SRC $t || $MV $t $t.O
	    fi
	fi
	install $f $t
    done
elif [ $NoUpdate = yes ]; then
    #
    # A file that is never to be updated; the target
    # is created only if it does not exist.
    #
    # NB: cannot be used with a special file 'cuz we
    #     use test -f to see if the file exists.
    #
    for f in $TARGETS; do
	t=$ROOT$DESTDIR$f
	test -f $t || install $f $t
    done
else
    #
    # Normal case, a target that should be installed
    # with the existing copy, optionally, saved first.
    #
    for f in $TARGETS; do
	install $f $ROOT$DESTDIR$f
    done
fi
