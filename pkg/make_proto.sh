#! /usr/bin/bash
# $Id: make_proto.sh.in 903 2009-01-10 21:32:00Z faxguy $
#
#	Tim Rice	Wed Sep 24 18:19:04 PDT 1997
#
#	Make prototype
#
#	System utilities used: cat, dirname, grep, mkdir, rm, sed, sort, tr
#
LANG=C export LANG
DIR_BIN=/usr/local/bin
DIR_LIB=/usr/local/lib/fax
DIR_SLIB=/usr/local/sbin
DIR_MAN=/usr/share/man
DIR_SBIN=/usr/local/sbin
DIR_SPOOL=/var/spool/hylafax
DIR_CGI=/var/httpd/cgi-bin
DIR_SYSVINIT=/etc/init.d
DIR_SYSVINITSTART="/etc/init.d/../rc2.d ../rc3.d ../rc4.d ../rc5.d"
DIR_SYSVINITSTOP="/etc/init.d/../rc0.d ../rc1.d ../rc6.d"
MANNUM1_8=8C
MANNUM4_5=5F
MANSCHEME=bsd-source-cat
LMANNUM1_8=`echo ${MANNUM1_8} | tr '[A-Z]' '[a-z]'`
LMANNUM4_5=`echo ${MANNUM4_5} | tr '[A-Z]' '[a-z]'`
TMP_DIR=/tmp/.$$hylafax
TMP_LIST=$$tmp
LIST="${DIR_BIN} ${DIR_LIB} ${DIR_SLIB} ${DIR_MAN} ${DIR_SBIN}"

case $1 in
	client)	PROTOTYPE=cproto
		DO_HTML="no"
			;;
	server)	PROTOTYPE=sproto
		LIST="${LIST} ${DIR_SPOOL}"
		DO_HTML="@HTML@"
		[ -d ${TMP_DIR} ]  &&  {
			rm -fr ${TMP_DIR}  ||  {
				echo "rm -fr ${TMP_DIR} failed"
				exit 1
			}
		}
		(umask 077 ; mkdir ${TMP_DIR})
			;;
	*)	echo "usage: $0 server or client"
		exit 1 ;;
esac

for i in ${LIST}
do
# skip the first one, it's in prototype.stub
	i=`dirname ${i}`
	while [ ${i} != / ]
	do
		echo "d none ${i} ? ? ?" >> ${TMP_LIST}
		i=`dirname ${i}`
	done

done

if [ ${DO_HTML} = yes ]
then
# skip the first one, it's in prototype.stub
	DIR_CGI=`dirname ${DIR_CGI}`
	while [ ${DIR_CGI} != / ]
	do
		grep "d html ${DIR_CGI} ? ? ?" ${TMP_LIST} >/dev/null \
		|| echo "d html ${DIR_CGI} ? ? ?" >> ${TMP_LIST}
		DIR_CGI=`dirname ${DIR_CGI}`
	done
fi

if [ ${PROTOTYPE} = sproto ]
then
	for i in ${DIR_SYSVINITSTART}
	do
		case ${i} in
			/*)	;;
			*)	i=${DIR_SYSVINIT}/${i} ;;
		esac
		mkdir -p ${TMP_DIR}/${i}
		i=`(cd ${TMP_DIR}/${i} ; pwd) | sed "s~${TMP_DIR}~~"`
		rm -fr ${TMP_DIR}/*
		echo "s none ${i}/S97hylafax=/etc/init.d/hylafax" >> ${TMP_LIST}
		while [ ${i} != / ]
		do
			echo "d none ${i} ? ? ?" >> ${TMP_LIST}
			i=`dirname ${i}`
		done
	done
	for i in ${DIR_SYSVINITSTOP}
	do
		case ${i} in
			/*)	;;
			*)	i=${DIR_SYSVINIT}/${i} ;;
		esac
		mkdir -p ${TMP_DIR}/${i}
		i=`(cd ${TMP_DIR}/${i} ; pwd) | sed "s~${TMP_DIR}~~"`
		rm -fr ${TMP_DIR}/*
		echo "s none ${i}/K05hylafax=/etc/init.d/hylafax" >> ${TMP_LIST}
		while [ ${i} != / ]
		do
			echo "d none ${i} ? ? ?" >> ${TMP_LIST}
			i=`dirname ${i}`
		done
	done
	rm -fr ${TMP_DIR}

	echo "f none ${DIR_SYSVINIT}/hylafax=../etc/hylafax 0755 bin bin" >> ${TMP_LIST}
	while [ ${DIR_SYSVINIT} != / ]
	do
		echo "d none ${DIR_SYSVINIT} ? ? ?" >> ${TMP_LIST}
		DIR_SYSVINIT=`dirname ${DIR_SYSVINIT}`
	done

	[ -d /etc/config ]  &&  {
		echo "d none /etc ? ? ?" >> ${TMP_LIST}
		echo "d none /etc/config ? ? ?" >> ${TMP_LIST}
		echo "f none /etc/config/fax=../etc/config.fax 0644 bin bin" >> ${TMP_LIST}
	}
fi

# prototype file
cat >${PROTOTYPE} <<EOF
i copyright
i depend
i pkginfo
i request
i postinstall
i preremove
i postremove
EOF

[ -s preinstall ]  &&  echo "i preinstall" >> ${PROTOTYPE}
[ -s space ]  &&  echo "i space" >> ${PROTOTYPE}

grep -v "^#" proto.local >> ${PROTOTYPE}

sort -u ${TMP_LIST} >> ${PROTOTYPE}

rm ${TMP_LIST}

grep " none " ${PROTOTYPE}.stub >> ${PROTOTYPE}

case ${MANSCHEME} in
# assume if it's compressed, it should end with .Z
	*-compress-strip) grep " man " ${PROTOTYPE}.stub | sed \
		-e "s~\.1=~.1.Z=~" \
		-e "s~\.${MANNUM1_8}=~.1.Z=~" \
		-e "s~\.${MANNUM4_5}=~.4.Z=~" >> ${PROTOTYPE}
		;;
	*) grep " man " ${PROTOTYPE}.stub | sed \
		-e "s~\.${MANNUM1_8}=~.${LMANNUM1_8}=~" \
		-e "s~\.${MANNUM4_5}=~.${LMANNUM4_5}=~" >> ${PROTOTYPE}
		;;
esac

if [ ${DO_HTML} = yes ]
then
	grep " html " ${PROTOTYPE}.stub >> ${PROTOTYPE}
fi


