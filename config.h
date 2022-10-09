/*	$Id: config.h.in 1082 2012-01-31 00:58:35Z faxguy $ */
/*
 * Copyright (c) 1990-1996 Sam Leffler
 * Copyright (c) 1991-1996 Silicon Graphics, Inc.
 * HylaFAX is a trademark of Silicon Graphics
 *
 * Permission to use, copy, modify, distribute, and sell this software and 
 * its documentation for any purpose is hereby granted without fee, provided
 * that (i) the above copyright notices and this permission notice appear in
 * all copies of the software and related documentation, and (ii) the names of
 * Sam Leffler and Silicon Graphics may not be used in any advertising or
 * publicity relating to the software without the specific, prior written
 * permission of Sam Leffler and Silicon Graphics.
 * 
 * THE SOFTWARE IS PROVIDED "AS-IS" AND WITHOUT WARRANTY OF ANY KIND, 
 * EXPRESS, IMPLIED OR OTHERWISE, INCLUDING WITHOUT LIMITATION, ANY 
 * WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.  
 * 
 * IN NO EVENT SHALL SAM LEFFLER OR SILICON GRAPHICS BE LIABLE FOR
 * ANY SPECIAL, INCIDENTAL, INDIRECT OR CONSEQUENTIAL DAMAGES OF ANY KIND,
 * OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
 * WHETHER OR NOT ADVISED OF THE POSSIBILITY OF DAMAGE, AND ON ANY THEORY OF 
 * LIABILITY, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE 
 * OF THIS SOFTWARE.
 */

/*
 * Warning, this file was automatically created by the HylaFAX configure script
 *
 * VERSION:	7.0.6
 * DATE:	Fri Jun 24 19:36:27 UTC 2022
 * TARGET:	x86_64-unknown-linux-gnu
 * CCOMPILER:	/usr/bin/gcc
 * CXXCOMPILER:	/usr/bin/g++
 */
#ifndef _CONFIG_
#define	_CONFIG_
#include "port.h"

/*
 * HylaFAX version number string
 */
#define HYLAFAX_VERSION HYLAFAX_VERSION_STRING

#define	FAX_SPOOLDIR	"/var/spool/hylafax"	/* pathname to top of spooling area */
#define FAX_CLIENTBIN	"/usr/local/bin"		/* place for client apps */
#define FAX_LIBEXEC	"/usr/local/sbin"	/* place for lib executables */
#define	FAX_LIBDATA	"/usr/local/lib/fax"	/* place for lib data files */

/*
 * Client-server configuration definitions.
 *
 * There are currently 2 possible transport methods: INET
 * (TCP/IP sockets), and Unix (Unix-domain sockets).
 * The latter has some limitations but may be useful to folks
 * not working in a network environment.
 *
 * NB: The Unix-domain support is unfinished.
 */
#define	FAX_USER	"uucp"	/* account name of the ``fax user'' */
#define	FAX_SERVICE	"hylafax"	/* client-server service name */
#define	FAX_PROTONAME	"tcp"		/* protocol used by client+server */
#define	FAX_DEFPORT	4559		/* port to use if service is unknown */
#define	FAX_DEFHOST	"localhost"	/* default host for inet-service */
#define	FAX_DEFUNIX	"/tmp/hyla.unix"/* default Unix-domain socket */

#ifndef CONFIG_INETTRANSPORT
#define	CONFIG_INETTRANSPORT	1	/* support for TCP/IP sockets */
#endif
#ifndef CONFIG_UNIXTRANSPORT
#define	CONFIG_UNIXTRANSPORT	0	/* support for Unix domain sockets */
#endif

#define	FAX_TYPERULES	"typerules"	/* file type and conversion rules */
#define	FAX_DIALRULES	"dialrules"	/* client dialstring conversion rules */
#define	FAX_PAGESIZES	"pagesizes"	/* page size database */
#define	FAX_COVER	"faxcover.ps"	/* prototype cover sheet file */

/*
 * System-wide configuration files for client applications (and
 * the hfaxd process) are located in the LIBDATA directory.  Apps
 * look first for FAX_SYSCONF, possibly followed by an
 * application-specific configuration file (e.g. sendfax.conf),
 * followed by a per-user configuration file located (by default)
 * in the user's home directory (~).  This multi-level scheme
 * is intended to simplify both site and user customization.
 */
#define	FAX_SYSCONF	FAX_LIBDATA "/hyla.conf"
#define	FAX_USERCONF	"~/.hylarc"	/* per-user configuration file */

/*
 * Server configuration definitions.
 *
 * The master spooling directory is broken up into several
 * subdirectories to isolate information that should be
 * protected (e.g. documents) and to minimize the number
 * of files in a single directory (e.g. the send queue).
 */
#define	FAX_ARCHDIR	"archive"	/* subdir for archived jobs */
#define	FAX_BINDIR	"bin"		/* subdir for server helper cmds */
#define	FAX_CLIENTDIR	"client"	/* subdir for client FIFO files */
#define	FAX_DOCDIR	"docq"		/* subdir for documents to send */
#define	FAX_DONEDIR	"doneq"		/* subdir for completed jobs */
#define	FAX_ETCDIR	"etc"		/* subdir for configuration files  */
#define	FAX_INFODIR	"info"		/* subdir for remote machine info */
#define	FAX_LOGDIR	"log"		/* subdir for log files */
#define	FAX_POLLDIR	"pollq"		/* subdir for pollable documents */
#define	FAX_RECVDIR	"recvq"		/* subdir for received facsimiles  */
#define	FAX_SENDDIR	"sendq"		/* subdir for send description files */
#define	FAX_STATUSDIR	"status"	/* subdir for server status files */
#define	FAX_TMPDIR	"tmp"		/* subdir for temp copies of docs */

/*
 * Files that reside in FAX_DOCDIR, FAX_SENDDIR, FAX_RECVDIR,
 * FAX_POLLDIR, and FAX_ARCHDIR are named using sequence number
 * information that is kept in a sequence file in the specific
 * directory (e.g. docq/seqf for document files).
 */
#define	FAX_SEQF	"seqf"		/* sequencing info filename */

/*
 * Job description files that reside in FAX_SENDDIR and
 * FAX_DONEDIR are named using the job identifier and a
 * prefix string (``q'' currently).
 */
#define FAX_QFILEPREF	"q"		/* prefix for job queue file */

/*
 * Configuration files that reside in the spooling area
 * are all named with a ``config'' prefix to uniquely
 * identify them.
 */
#define	FAX_CONFIG	FAX_ETCDIR "/config"

/*
 * Send/recv logging information is written to an xferfaxlog
 * file; currently in an ASCII format designed for processing
 * by programs like awk and perl.
 */
#define	FAX_XFERLOG	FAX_ETCDIR "/xferfaxlog"

/*
 * Client access to services on the server machine is controlled
 * by information in the ``hosts.hfaxd'' file.  This is actually a
 * minsomer; the file has much more information than host names
 * (but it used to only have host-related information).
 */
#define	FAX_PERMFILE	FAX_ETCDIR "/hosts.hfaxd"

/*
 * Server processes write various status information to files
 * that reside in the ``status'' directory.  These files are
 * named, by convention using their device identifier ad an
 * ``info'' suffix (e.g. ttyf2.info).
 */
#define	FAX_INFOSUF	"info"		/* suffix for server info files */

#define	FAX_FIFO	"FIFO"		/* FIFO file for talking to daemon */
#define	MODEM_ANY	"any"		/* any modem acceptable identifier */

/* NB: all times are given in seconds */
#define	FAX_REQBUSY	(3*60)		/* requeue interval on busy answer */
#define	FAX_REQPROTO	(1*60)		/* requeue interval on protocol error */
#define	FAX_REQUEUE	(5*60)		/* requeue interval on other */
#define FAX_RETBUSY	(u_int)-1		/* retry maximum on busy answer */
#define FAX_RETRY	(u_int)-1		/* retry maximum for others */
#define	FAX_RETRIES	3		/* number times to retry send */
#define	FAX_REDIALS	12		/* number times to dial phone */
#define	FAX_TIMEOUT	"now + 3 hours"	/* default job timeout (at syntax) */
#define	FAX_DEFVRES	98	/* default vertical resolution */
					/* default is no email notification */
#define	FAX_DEFNOTIFY	SendFaxJob::no_notice
#define	FAX_DEFPRIORITY	127		/* default job priority */

/*
 * UUCP lock file support exists for both ASCII-style and
 * binary-style files.  The difference refers to whether
 * the process ID's written to the lock file are written
 * in ASCII or binary.  HylaFAX server programs can be
 * configured to use either through the configuration files
 * and there is also support for certain lock file naming
 * conventions required by different systems such as SCO
 * and SVR4.  Consult the documentation for more details.
 */
#define	UUCP_LOCKDIR	"/var/lock" /* directory for UUCP lock files */
#define	UUCP_LOCKTYPE	"ascii"		/* UUCP lock file type */
#define	UUCP_LOCKMODE	0444		/* UUCP lock file creation mode */
#define	UUCP_PIDDIGITS	10		/* # digits to write to lock file */
/*
 * HylaFAX server processes that create UUCP lock files
 * check that the lock file owner exists and if they do
 * not they can be configured to automatically purge the
 * lock file.  This operation is only done for lock files
 * that appear to be orphaned longer than some period of
 * time.  The default value for this interval is 30 seconds
 * but it can be changed through the configuration files.
 * Setting this value to 0 disables this automatic purging
 * of UUCP lock files.
 */
#define	UUCP_LCKTIMEOUT	30		/* UUCP lock auto-expiration (secs) */

/*
 * Default syslog facility.  This value can be redefined
 * through the LogFaclity configuration parameters read
 * by all the server programs.
 */
#define	LOG_FAX		"daemon"	/* logging identity */

/*
 * The pathnames of the getty, vgetty, and egetty programs
 * invoked by faxgetty to handle inbound data and voice
 * calls and for doing adaptive call type deduction.  These
 * parameters are compiled into the binary to avoid possible
 * security problems.
 */
#ifndef _PATH_GETTY
#define	_PATH_GETTY	"/sbin/agetty"	/* getty program for data call */
#endif
#ifndef _PATH_VGETTY
#define	_PATH_VGETTY	"/bin/vgetty"	/* vgetty program for voice call */
#endif
#ifndef _PATH_EGETTY
#define	_PATH_EGETTY	"/bin/egetty"	/* egetty for deducing call type */
#endif

/*
 * The default pathname for the Fontmap(s) file
 * is compiled into util/TextFormat.o but can be overridden
 * through configuration files.
 */
#ifndef _PATH_FONTMAP
#define	_PATH_FONTMAP	"/usr/share/ghostscript/9.55.0/Resource/Init:/usr/share/ghostscript/9.55.0/lib:/usr/share/ghostscript/9.55.0/Resource/Font:/usr/share/ghostscript/fonts:/var/lib/ghostscript/fonts:/usr/share/cups/fonts:/usr/share/ghostscript/fonts:/usr/local/lib/ghostscript/fonts:/usr/share/fonts"	/* location of Fontmap(s) */
#endif

/*
 * The default pathname for the location of the fonts
 * is compiled into util/TextFormat.o but can be overridden
 * through configuration files.
 */
#ifndef _PATH_AFM
#define	_PATH_AFM	"/usr/share/ghostscript/9.55.0/Resource/Init:/usr/share/ghostscript/9.55.0/lib:/usr/share/ghostscript/9.55.0/Resource/Font:/usr/share/ghostscript/fonts:/var/lib/ghostscript/fonts:/usr/share/cups/fonts:/usr/share/ghostscript/fonts:/usr/local/lib/ghostscript/fonts:/usr/share/fonts"	/* location of Fonts */
#endif

/*
 * The following commands are invoked by server processes
 * to do work that might need to be customized.  Typically
 * these ``commands'' are shell scripts, but there's nothing
 * to stop them from being something else.
 *
 * Note that non-absolute pathnames must be given relative
 * to the top of the spooling area.
 */
#define	FAX_NOTIFYCMD	FAX_BINDIR "/notify"	/* cmd to do job notification */
#define	FAX_TRANSCMD	FAX_BINDIR "/transcript"/* cmd to return transcript */
#define	FAX_FAXRCVDCMD	FAX_BINDIR "/faxrcvd"	/* cmd to process a recvd fax */
#define	FAX_POLLRCVDCMD	FAX_BINDIR "/pollrcvd"	/* cmd to process a recvd fax */
#define FAX_PS2FAXCMD	FAX_BINDIR "/ps2fax"	/* cmd to convert postscript */
#define FAX_PDF2FAXCMD	FAX_BINDIR "/pdf2fax"	/* cmd to convert PDF */ 
#define FAX_PCL2FAXCMD	FAX_BINDIR "/pcl2fax"	/* cmd to convert PCL */
#define FAX_TIFF2FAXCMD	FAX_BINDIR "/tiff2fax"	/* cmd to convert TIFF */
#define	FAX_COVERCMD	FAX_BINDIR "/mkcover"	/* cmd to make cont coverpage */
#define	FAX_WEDGEDCMD	FAX_BINDIR "/wedged"	/* cmd to handle wedged modem */

/*
 * SNPP-related client-server definitions.
 */
#define	SNPP_SERVICE	"snpp"		/* Simple Network Pager Protocol */
#define	SNPP_PROTONAME	"tcp"		/* protocol used by client+server */
#define	SNPP_DEFPORT	444		/* port to use if service is unknown */
#define	SNPP_DEFHOST	"localhost"	/* default host for SNPP service */
/* default values for SNPP job scheduling and handling */
#define	SNPP_DEFQUEUE	false		/* default is synchronous delivery */
#define	SNPP_DEFLEVEL	1		/* default service level */
#define	SNPP_DEFRETRIES	3		/* number times to retry send */
#define	SNPP_DEFREDIALS	12		/* number times to dial phone */
#define	SNPP_DEFNOTIFY	"none"		/* default is no email notification */
#define	SNPP_DEFPRIORITY 127		/* default job priority */

/*
 * Sequence numbers are assigned for jobs and documents
 * stored in the fax filesystem.  We no longer constrain these
 * numbers to be 16-bit values.
 */
#define	MAXSEQNUM	999999999
#define	NEXTSEQNUM(x,y)	(((x)+y) % MAXSEQNUM)

/*
 * PAM Authentication
 */
/*#define HAVE_PAM 1*/

/*
 * OpenSSL support
 */
/*#define HAVE_SSL 1*/
/*#define HAVE_FLEXSSL 1*/

/*
 * JBIG library support
 */
#define HAVE_JBIG 1
#define HAVE_JBIGTIFF 1

/*
 * Little JPEG library support
 */
#define HAVE_JPEG 1

/*
 * Little CMS library support
 */
/*#define HAVE_LCMS 1*/
/*#define HAVE_LCMS2 1*/

/*
 * LDAP Authentication
 */
/*#define HAVE_LDAP 1*/

#endif
