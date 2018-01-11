ESHOLD_ROOT_PARTITION=85
DETAIL_DISK_USAGE=$(df -h)
MAILTO='ishtiaque05@gmail.com'
echo "sending mail........................"
CURRENT_ROOT_USAGE=$(df / | grep / | awk '{ print $5}' | sed 's/%//g')
if [ "$CURRENT_ROOT_USAGE" -gt "$THRESHOLD_ROOT_PARTITION" ] ; then
   mail -s 'Disk Space Alert' $MAILTO << EOF
Server root partition remaining free space is critically low. Used: $CURRENT_ROOT_USAGE%
Disk Usage:
$DETAIL_DISK_USAGE
EOF
fi
echo "done sending mail..................."
