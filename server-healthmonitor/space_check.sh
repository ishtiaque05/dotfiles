#!/bin/sh

echo "*********************************************************************"
echo "**************************** SPACE CHECK ****************************"
echo "*********************************************************************"
HOSTNAME=`hostname|tr "[:lower:]" "[:upper:]"`
# Vlomun groups that should be ignored
#/dev/mapper/VG01-LV02  /data04


#this command and column position should vary according to platform
BDF_OUTPUT=`df -Ph |grep -v /data04`
#BDF_OUTPUT=`bdf`
ALARM_TH=30

echo "------------------------- Alarm Using Threshold $ALARM_TH ---------------------------------"
echo "MACHINE:`hostname`"
echo "SCRIPT:DISK_SPACE"
echo "DBNAME:"
echo "START_DBA_ALERT:"
OUTPUT=`echo "$BDF_OUTPUT"|awk 'NR>1 { print $5$6}'|awk -F'%' '{ if($1>='"$ALARM_TH"') { print $2" "$1"%" } }'`
echo "$OUTPUT"
echo "END_DBA_ALERT:"
echo "------------------------------------------------------------------------------------"


