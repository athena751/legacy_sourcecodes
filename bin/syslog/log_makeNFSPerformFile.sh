#!/bin/sh
#
#       Copyright (c) 2003-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: log_makeNFSPerformFile.sh,v 1.11 2008/03/21 06:18:54 yangxj Exp $"


usage() 
{
        /bin/echo "$0 -f path  -I id [-h client|-m export|-d date|-t time|-r|-a|-c category pattern|-e user pattern|-v|-C matchNo|-i] -l logType"  1>& 2
}

if [ $# = 0 ]; then
	usage
	exit 1
fi

args=`/usr/bin/getopt 'afI:rcevCil:hmdt' $*`
if [ $? != 0 ]; then
        usage
        exit 1
fi

REVERSE="";
FILENAME=""
ALLREFER=""
USER=""
CLIENT=""
EXPORT=""
DATE=""
TIME=""

CapacityThresholdSize=3
propertyFile="/opt/nec/nsadmin/etc/properties/syslog.conf"
if [ -e "$propertyFile" ]; then
    . $propertyFile
fi

for opt in $args
do
         case $opt in
         -f)     FILENAME="$2";   	 shift 2;;
         -a)     ALLREFER="isAll";   shift ;;
         -r)     REVERSE="-r";  	 shift ;;
         -e)     USER="$2";	 		 shift 2;;
         -h)     CLIENT=$2           shift 2;;
         -m)     EXPORT=$2           shift 2;;
         -d)     DATE=$2             shift 2;;
         -t)     TIME=$2             shift 2;;
         -I)     ID=$2               shift 2;;
         --)              	   		 break;;
         esac
done
if [ $# == 0 ]; then
	usage
	exit 1
fi
if [ "x$FILENAME" = "x" ]; then
    	usage
    	exit 1
fi

if [ "x$ID" = "x" ]; then
    	usage
    	exit 1
fi

PARAM=$*
CMD="/usr/sbin/nfspfminfo2"
if [ "x$CLIENT" != "x" ]; then
    CMD="$CMD -c $CLIENT"
fi
if [ "x$EXPORT" != "x" ]; then
    CMD="$CMD -e $EXPORT"
fi  
CMD="$CMD -f $FILENAME"
TMPDATE=`/bin/date '+%k%M%S'`
TMPDATE=`/bin/echo $TMPDATE | sed 's/ //'`
RETVAL=$?
if [ $RETVAL -ne 0 ]; then
	exit $RETVAL
fi
TEMPFILE="NFSPerform""___""$TMPDATE.$$.log"
TEMPFILE=`/bin/mktemp "$TEMPFILE.XXXXXX"`
RETVAL=$?
if [ $RETVAL -ne 0 ]; then
    exit $RETVAL
fi
/bin/rm -f $TEMPFILE
MKFILE="/$TEMPFILE"
TMPDIR="/var/crash/.nsguiwork/logview/$ID/NFSPerform"

`/bin/mkdir -p $TMPDIR`
chmod -R 777 $TMPDIR

CMD="$CMD -w $TMPDIR$MKFILE"
if [ "x$DATE" != "x" ]; then
    CMD="$CMD -d $DATE"
fi 
if [ "x$TIME" != "x" ]; then
    CMD="$CMD -t $TIME"
fi 

diskLeftRoom=$(df -B 1 /var/crash | grep /var/crash | awk '{print $4;}')
concat_size=$(ls -l "$FILENAME" | awk 'BEGIN{sum=0;}{sum=sum+$5}END{printf("%d", sum)}')
compareResult=`awk -v concat="$concat_size" -v leftRoom="$diskLeftRoom" -v threshold="$CapacityThresholdSize" 'BEGIN{if((leftRoom-(concat*2))<(threshold*1024*1024*1024))print "false";}'`
if [ "$compareResult" = "false" ]; then
    /bin/echo "DiskIsFull"
    exit 0
fi

`$CMD >&/dev/null`
RETVAL=$?
if [ $RETVAL -ne 0 ]; then
    rm -rf $TMPDIR$MKFILE
	exit $RETVAL
fi
if [ "x$USER" != "x" ]; then
    if [ "x$REVERSE" != "x" ]; then
        /home/nsadmin/bin/log_makeFile.sh -f $TMPDIR$MKFILE  -I $ID -e "$USER" -r -p $PARAM 
    else
        /home/nsadmin/bin/log_makeFile.sh -f $TMPDIR$MKFILE -I $ID -e "$USER" -p $PARAM     
    fi
else
    if [ "x$REVERSE" != "x" ]; then
        /home/nsadmin/bin/log_makeFile.sh -f $TMPDIR$MKFILE -I $ID -r -p $PARAM 
    else
        /home/nsadmin/bin/log_makeFile.sh -f $TMPDIR$MKFILE -I $ID -p $PARAM     
    fi
fi

RETVAL=$?

rm -rf $TMPDIR$MKFILE

exit $RETVAL
