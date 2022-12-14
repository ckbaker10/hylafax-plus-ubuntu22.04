#! /usr/bin/bash
#    $Id: dictionary.sh.in 1073 2011-12-13 23:37:07Z faxguy $

case "${NOTIFICATIONLANGUAGE:-${LC_ALL:-${LC_MESSAGES:-${LANG:-}}}}" in
    nl_BE*)
	. bin/dict/nl_BE
	;;
    pl_*)
	. bin/dict/pl
	;;
    fr_*)
	. bin/dict/fr
	;;
    it_*)
	. bin/dict/it
	;;
    pt_BR*)
	. bin/dict/pt_BR
	;;
    pt_*)
	. bin/dict/pt
	;;
    es_*)
	. bin/dict/es
	;;
    de_*)
	. bin/dict/de
	;;
    ro_*)
	. bin/dict/ro
	;;
    ru_*)
	. bin/dict/ru
	;;
    tr_*)
	. bin/dict/tr
	;;
    zh_*|cn_*)
	. bin/dict/zh
	;;
    sr_*)
	. bin/dict/sr
	;;
    uk_*)
	. bin/dict/uk
	;;
    he_*)
	. bin/dict/he
	;;
    *)
	. bin/dict/en
	;;
esac

for variable in \
	DICTRECEIVEAGENT \
	DICTRECEIVEDFROM \
	DICTRETRIEVEDFROM \
	DICTMSGINTRO \
	DICTLOGFOLLOWS \
	DICTLOGFOLLOWS2 \
	DICTNOLOGAVAIL \
	DICTDISPATCHEDTO \
	DICTPOLLDISPATCHTO \
	DICTNOTRECEIVED \
	DICTATTEMPTEDFAXFAILED \
	DICTATTEMPTEDPOLLFAILED \
	DICTFAILEDBECAUSE \
	DICTUNKNOWNDOCTYPE \
	DICTNOFILEEXISTS \
	DICTDESTINATION \
	DICTJOBID \
	DICTGROUPID \
	DICTSENDER \
	DICTMAILADDR \
	DICTMODEM \
	DICTCOMMID \
	DICTSUBMITTEDFROM \
	DICTPAGEWIDTH \
	DICTPAGELENGTH \
	DICTRES \
	DICTNOTHINGAVAIL \
	DICTSTATUS \
	DICTREMOTEEXCHANGES \
	DICTDIALOGS \
	DICTFAILEDCALLS \
	DICTDIALS \
	DICTTOTALCALLS \
	DICTCALLS \
	DICTPAGESTRANSMITTED \
	DICTPAGES \
	DICTTOTALPAGES \
	DICTTOTPAGES \
	DICTATTEMPTSPAGE \
	DICTATTEMPTS \
	DICTDIRNEXTPAGE \
	DICTDIRNUM \
	DICTDOCSSUBMITTED \
	DICTDOCSTEXT1 \
	DICTDOCSTEXT2 \
	DICTDOCSTEXT3 \
	DICTDOCSTEXT4 \
	DICTFILENAME \
	DICTSIZE \
	DICTTYPE \
	DICTUNSENTPAGES \
	DICTUNSENTJOBSTATUS \
	DICTPIN \
	DICTMESSAGETEXT \
	DICTNOREASON \
	DICTYOURJOBTO \
	DICTfacsimile \
	DICTpager \
	DICTJOB \
	DICTAT \
	DICTTO \
	DICTCOMPLETED \
	DICTCOMPLETEDSUCCESSFULLY \
	DICTRECEIVER \
	DICTQUALITY \
	DICTFINE \
	DICTNORMAL \
	DICTSIGNALRATE \
	DICTDATAFORMAT \
	DICTREMOTEEQUIPMENT \
	DICTREMOTESTATION \
	DICTPROCESSINGTIME \
	DICTADDITIONALINFO \
	DICTFAILED \
	DICTREJECTEDBECAUSE \
	DICTBLOCKED \
	DICTDELAYEDBECAUSE \
	DICTASSOONASPOSSIBLE \
	DICTREQUEUED \
	DICTWASNOTSENT \
	DICTWILLBERETRIED \
	DICTREMOVEDFROMQUEUE \
	DICTWASDELETED \
	DICTTIMEDOUT \
	DICTCONVERSION1 \
	DICTCONVERSION2 \
	DICTCONVERSION3 \
	DICTNOFORMATTER1 \
	DICTNOFORMATTER2 \
	DICTNOTICEABOUT \
	DICTPOLLINGFAILED \
	DICTREMOTEREJECTED \
	DICTNODOCTOPOLL \
	DICTUNSPECIFIEDPROBLEM \
	DICTUNKNOWNREASON1 \
	DICTUNKNOWNREASON2 \
	DICTUNKNOWNREASON3 \
	DICTUNKNOWNREASON4 \
	DICTRECEIVEDON \
	DICTPOLLFAILED \
	DICTYES \
	DICTNO \
	DICTRECEIVED \
	DICTTIMETORECV \
	DICTERRCORRECT \
	DICTCALLID1 \
	DICTCALLID2 \
	DICTCALLID3 \
	DICTCALLID4 \
	DICTCALLID5 \
	DICTCALLID6 \
	DICTCALLID7
do
	# Recode the variable's value to the character map as defined by the
	# current locale:
	if eval '${'"$variable"'+:} false'
	then
		# "$variable" denotes an existing variable.
		# Recode it from the character set "$CHARSET" to the
		# character set according to the current locale settings:
		assign_cmd_subst "$variable" \
			'LC_ALL=C printf %s "${'"$variable"'}" | "$@"' \
			iconv -c -f "$CHARSET"
	fi
done
# Let "$CHARSET" reflect the current locale's charset:
CHARSET="$(locale -- charmap)"
if LC_ALL=C expr " $CHARSET" : ' ANSI_X3\.4\>' > /dev/null
then
	CHARSET=US-ASCII
fi
