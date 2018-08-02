echo "*********************************************************************"
echo "**************************** MEMORY CHECK ****************************"
echo "*********************************************************************"
HOSTNAME=`hostname|tr "[:lower:]" "[:upper:]"`

#this command and column position should vary according to platform

TOTALMEM=`free -m | head -2 | tail -1| awk '{print $2}'`
TOTALBC=`echo "scale=2;if($TOTALMEM<1024 && $TOTALMEM > 0) print 0;$TOTALMEM/1024"| bc -l`
USEDMEM=`free -m | head -2 | tail -1| awk '{print $3}'`
USEDBC=`echo "scale=2;if($USEDMEM<1024 && $USEDMEM > 0) print 0;$USEDMEM/1024"|bc -l`
FREEMEM=`free -m | head -2 | tail -1| awk '{print $4}'`
FREEBC=`echo "scale=2;if($FREEMEM<1024 && $FREEMEM > 0) print 0;$FREEMEM/1024"|bc -l`
BUFFCACHE=`free -m | head -2 | tail -1| awk '{print $6}'`
BUFFBC=`echo "scale=2;if($BUFFCACHE<1024 && $BUFFCACHE > 0) print 0;$BUFFCACHE/1024"| bc -l`

echo "------------------------- Alarm Using Threshold $ALARM_TH ---------------------------------"
echo "MACHINE:`hostname`"
echo "SCRIPT:MEMORY"
echo "DBNAME:"
echo "START_DBA_ALERT:"
OUTPUT=`echo -e "Total:"${TOTALBC}GB"\nUsed:"${USEDBC}GB"\nFree:"${FREEBC}GB"\nBuffeCache:"${BUFFBC}GB"\n%Free:"$(($FREEMEM * 100 / $TOTALMEM  ))%`
#OUTPUT=`echo -e "Total:"${TOTALBC}GB"\nUsed:"${USEDBC}GB"\nFree:"${FREEBC}GB"\n%Free"$(($FREEMEM * 100 / $TOTALMEM  ))%`
echo "$OUTPUT"
echo "END_DBA_ALERT:"
echo "------------------------------------------------------------------------------------"
