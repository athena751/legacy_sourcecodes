#! /bin/sh
#
#       Copyright (c) 2003-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: log_cleanup.sh,v 1.5 2008/03/20 15:36:13 yangxj Exp $"


usage()
{
        /bin/echo "$0 -f path -t time" 1>& 2
}

if [ $# = 0 ]; then
        usage
        exit 1
fi

TARGET_FILE=""
TIME=0
MIN_TIME=0
MAX_TIME=1200
DEFAULT_TIME=900
args=`/usr/bin/getopt 'f:t:' $*`
if [ $? != 0 ]; then
        usage
        exit 1
fi
for opt in $args
do
         case $opt in
         -f)     TARGET_FILE=$2;                 shift 2;;
         -t)     TIME="$2"                       shift 2;;
         --)     shift;                          break;;
         esac
done
if [ "$TIME" -lt "$MIN_TIME" ]; then
	TIME=$DEFALUT_TIME
elif [ "$TIME" -gt "$MAX_TIME" ]; then
	TIME=$DEFAULT_TIME
fi
DIR=`/usr/bin/dirname $TARGET_FILE | sed 's/\/[^\/]*$//'` 
if [ "$DIR" != "/var/crash/.nsguiwork/logview" ]; then
    exit 0
fi

RM="/bin/rm -rf"
/bin/sleep $TIME
$RM $TARGET_FILE
exit 0
