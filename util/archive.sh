#! /usr/bin/bash

#
# This script is called by faxqclean to archive the job
#

# ============================================
#
# A NOTE ON CUSTOMIZING this script:
#
# You are welcome (even encouraged) to customize this script to suit the
# needs of the deployment.  However, be advised that this script is
# considered part of the package distribution and is subject to being
# overwritten by subsequent upgrades.  Please consider copying this file
# to something like "etc/archive-custom", modifying that copy of the file,
# and then specifying the "-s etc/archive-custom" option in your invocation
# of faxqclean in order to prevent your customizations from being
# overwritten during an upgrade process.
#
# ============================================

JOBID=$1
ARCHIVETO=archive/$JOBID
FILETYPES="^!postscript:|^!tiff:|^!pcl:|^!pdf:|^!data:"
QFILE=doneq/q$JOBID
COMMLOGS=`find log -type f -name "c*"  -print | xargs -n50  grep -l "SEND FAX: JOB $JOBID"`
DOCS=`grep -E $FILETYPES $QFILE | sed 's/.*://g'`
NUMBER=`grep "^number:" $QFILE | sed 's/^number://g'`

#
# Apply customizations.  All customizable variables should
# be set to their non-customized defaults prior to this.
# 
if [ -f etc/FaxArchive ]; then
    . etc/FaxArchive
fi

#
# Default archiving is to create a directory in the archive directory 
# named as the job number, move the q file and the doc files into it, and 
# copy the associated logs and info file there, also.
#

mkdir $ARCHIVETO
mv $QFILE $ARCHIVETO
for log in $COMMLOGS; do cp $log $ARCHIVETO; done
for doc in $DOCS; do cp $doc $ARCHIVETO; done
if [ -r info/$NUMBER ]; then cp info/$NUMBER $ARCHIVETO; fi
