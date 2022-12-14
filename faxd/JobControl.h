/*	$Id: JobControl.h 1155 2013-04-26 22:39:33Z faxguy $ */
/*
 * Copyright (c) 1994-1996 Sam Leffler
 * Copyright (c) 1994-1996 Silicon Graphics, Inc.
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
#ifndef _JobControl_
#define	_JobControl_
/*
 * Destination Controls.
 */
#include "FaxConfig.h"
#include "Str.h"
#include "TimeOfDay.h"
#include "Array.h"

/*
 * Destination controls are defined by sets of parameters
 * and a regular expression.  If the canonical destination
 * phone number matches the regex, then associated parameters
 * are used.
 */
class JobControlInfo
  : public FaxConfig
{
private:
    u_long	defined;		// parameters that were defined
    u_int	maxConcurrentCalls;	// max number of parallel calls
    u_int	maxSendPages;		// max pages in a send job
    u_int	maxDials;		// max times to dial the phone
    u_int	maxTries;		// max transmit attempts
    fxStr	rejectNotice;		// if set, reject w/ this notice
    fxStr	modem;			// if set, try with it
    fxStr	proxy;			// if set, proxy-send job there
    fxStr	proxyuser;		// if set, use this as the login username
    fxStr	proxypass;		// if set, use this as the login password
    fxStr	proxymailbox;		// if set, use this as the identity
    fxStr	proxynotification;	// if set, use this as the notification
    fxStr	proxyjobtag;		// if set, use this as the jobtag
    fxStr	proxytaglineformat;	// if set, use this as the taglineformat
    fxStr	proxytsi;		// if set, use this as the tsi
    mode_t	proxylogmode;		// mode for logs retrieved from proxy
    int		proxytries;		// if set, specify the number of tries
    int		proxydials;		// if set, specify the number of dials
    int		proxyreconnects;	// the number of reconnections to make for any job
    TimeOfDay	tod;			// time of day restrictions
    int		usexvres;		// use extended resolution
    int		usecolor;		// use color
    bool	usesslfax;		// use SSL Fax
    u_int	vres;			// use specified resolution
    fxStr	args;			// arguments for subprocesses
    fxStr	pagesize;		// if set, use this page size
    int		priority;		// override submission priority with this
    int		desireddf;		// if set, desireddf value
    int		notify;			// if set, notify value

    // default returned on no match
    static const JobControlInfo defControlInfo;

    friend class JobControl;
public:
    JobControlInfo();
    JobControlInfo(const fxStr& buffer);
    JobControlInfo(const JobControlInfo& other);
    ~JobControlInfo();

    u_int getMaxConcurrentCalls() const;
    u_int getMaxSendPages() const;
    u_int getMaxDials() const;
    u_int getMaxTries() const;
    const fxStr& getRejectNotice() const;
    const fxStr& getModem() const;
    const fxStr& getProxy() const;
    const fxStr& getProxyUser() const;
    const fxStr& getProxyPass() const;
    const fxStr& getProxyMailbox() const;
    const fxStr& getProxyNotification() const;
    const fxStr& getProxyJobTag() const;
    const fxStr& getProxyTagLineFormat() const;
    const fxStr& getProxyTSI() const;
    const mode_t getProxyLogMode() const;
    int getProxyTries() const;
    int getProxyDials() const;
    int getProxyReconnects() const;
    time_t nextTimeToSend(time_t) const;
    int getUseXVRes() const;
    int getUseColor() const;
    bool getUseSSLFax() const;
    u_int getVRes() const;
    int getPriority() const;
    int getDesiredDF() const;
    int getNotify() const;
    bool isNotify(u_int what) const;
    const fxStr& getArgs() const;
    const fxStr& getPageSize() const;

    virtual bool setConfigItem(const char*, const char*);
    virtual void configError(const char*, ...);
    virtual void configTrace(const char*, ...);
};
inline const fxStr& JobControlInfo::getArgs() const	{ return args; }

#endif /* _JobControl_ */
