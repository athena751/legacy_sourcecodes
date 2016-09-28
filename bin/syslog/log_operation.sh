#!/bin/sh
#
#       Copyright (c) 2003-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: log_operation.sh,v 1.14 2008/03/22 07:30:45 yangxj Exp $"


usage()
{
        /bin/echo "$0 -f file -h ipaddr -I id [-d]" 1>& 2
}

if [ $# = 0 ]; then
        usage
        exit 1
fi

FILE=""
ADDR=""
DIRECTDOWN="no"

args=`/usr/bin/getopt 'fdI:h' $*`
if [ $? != 0 ]; then
        usage
        exit 1
fi

for opt in $args
do
         case $opt in
         -f)     FILE="$2";                      shift 2;;
         -h)     ADDR=$2;		         shift 2;;
         -I)     ID=$2                           shift 2;;
         -d)     DIRECTDOWN="yes"                shift;;
         --)     shift;                          break;;
         esac
done

if [ $# != "0" ]; then
        usage
        exit 1
fi

if [ "x$FILE" = "x" ]; then
	usage
	exit 1
fi
if [ "x$ID" = "x" ]; then
	usage
	exit 1
fi

#Constant

PAGE_DIR="/var/crash/.nsguiwork/logview/$ID/"
propertyFile="/opt/nec/nsadmin/etc/properties/syslog.conf"

if [ "x$ADDR" != "x" ]; then
    /bin/rm -rf $PAGE_DIR
    FILE_SIZE=$(sudo -u nsgui /usr/bin/rsh $ADDR ls -l $FILE | awk '{print $5}')
    diskLeftRoom=$(df -B 1 /var/crash | grep /var/crash | awk '{print $4;}')
    CapacityThresholdSize=3
    if [ -e "$propertyFile" ]; then
        . $propertyFile
    fi
    local diskCompareResult=`awk -v fileSize="$FILE_SIZE" -v availableRoom="$diskLeftRoom" -v threshold="$CapacityThresholdSize" 'BEGIN{if((availableRoom-(fileSize*2))<(threshold*1024*1024*1024))print "false";}'`
    if [ "$diskCompareResult" = "false" ]; then
        sudo -u nsgui /usr/bin/rsh $ADDR sudo /bin/rm -rf "$FILE"
        /bin/echo "DiskIsFull"
        exit 0
    fi
    /bin/mkdir -p $PAGE_DIR
    /bin/chmod 777 $PAGE_DIR
    sudo -u nsgui /usr/bin/rcp -p $ADDR:"$FILE" $PAGE_DIR
    RETVAL=$?
    sudo -u nsgui /usr/bin/rsh $ADDR sudo /bin/rm -rf "$FILE"
    if [ $RETVAL != 0 ]; then
        /bin/rm -rf "$FILE"
    	exit 1
    fi
fi
TOTALLINES=0
if [ "$DIRECTDOWN" = "no" ]; then
    TOTALLINES=$(cat $FILE | wc -l)
fi
/bin/echo $FILE
/bin/echo $TOTALLINES

if [ "x$ADDR" != "x" ]; then
    RMTIME="900"
    CLEAN_OPTIONS="-t $RMTIME -f $FILE"
    /home/nsadmin/bin/log_cleanup.sh $CLEAN_OPTIONS >&/dev/null &
fi

exit 0
