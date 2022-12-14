#! /usr/bin/bash
#
# This file is considered part of the software distribution,
# and any changes made to it may get overwritten in a    
# subsequent upgrade or reinstallation.  Instead of making
# changes here, directly, consider copying the entire
# default MIMEConverters directory to a custom location, i.e. 
# /usr/local/sbin/faxmail.custom, set MIMEConverters in     
# hyla.conf to point there, and make changes there instead.
#

. /usr/local/lib/fax/setup.cache

$TIFFBIN/tiff2ps -a "$1"

exit
