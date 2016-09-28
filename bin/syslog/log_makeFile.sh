#!/bin/sh
#
#       Copyright (c) 2003-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: log_makeFile.sh,v 1.35 2008/03/22 04:59:51 yangxj Exp $"
usage()
{
    /bin/echo "$0 -f path -l logType -I id [-p|-a|-r|-c category pattern|-e user pattern|-v|-C matchNo|-i|-E encoding|-d]"  1>& 2
}

function checkDiskLeftRoom(){
    local pre=$1
    local searchOrNot=${pre:-$SEARCHSWITCH}
    local concat_size=0
    if [ "x$searchOrNot" = "xoff" ]; then
        if [ "x$LOGTYPE" != "xftpLog" -a "x$LOGTYPE" != "xhttpLog" ]; then
            concat_size=$(/home/nsadmin/bin/log_getFileList.pl "$LOGTYPE" "$FILENAME" $REVERSE | xargs -0 -n1 ls -l | awk 'BEGIN{sum=0;}{sum=sum+$5}END{printf("%d", sum)}')
        else
            concat_size=$(/home/nsadmin/bin/log_getFileList.pl "$LOGTYPE" "$FILENAME" $REVERSE | xargs -0 -n1 /home/nsadmin/bin/log_printContent.sh | /bin/awk '{printf("%s\r\n",$0)}' | wc -c)
        fi
    else
        concat_size=$(/home/nsadmin/bin/log_getFileList.pl "$LOGTYPE" "$FILENAME" $REVERSE | xargs -0 -n1 /home/nsadmin/bin/log_printContent.sh |$ALLSH | $CATEGORYSH "$CATEGORYPATTERN" | $USERSH "$USERPATTERN" | /bin/awk '{printf("%s\r\n",$0)}' | wc -c)
    fi
    local diskLeftRoom=$(df -B 1 /var/crash | grep /var/crash | awk '{print $4;}')
    local compareResult=`awk -v concat="$concat_size" -v leftRoom="$diskLeftRoom" -v threshold="$CapacityThresholdSize" 'BEGIN{if((leftRoom-(concat*2))<(threshold*1024*1024*1024))print "false";}'`
    if [ "$compareResult" = "false" ]; then
        echo 1
        return 1
    fi
    echo 0
    return 0
}

function getINode(){
    local inodes
    inodes="$(/home/nsadmin/bin/log_getFileList.pl "$LOGTYPE" "$FILENAME" $REVERSE | xargs -0 -n1 ls -i)"
    echo $inodes
    return 0
}

if [ "$#" -lt "4" ]; then
     usage
     exit 1
fi

args=`/usr/bin/getopt 'afIrcevCilpdE:' $*`
if [ $? != 0 ]; then
        usage
        exit 1
fi

ENCODING_UTF_8="UTF-8"
ENCODING_UTF8_NEC_JP="UTF8-NEC-JP"

FILENAME=""
RMTIME="900"
CLEAN="/home/nsadmin/bin/log_cleanup.sh"
LOG_TYPE_NFS_LOG="nfsLog"

REVERSE="/usr/bin/tac"

CATEGORY=""
CATEGORYPATTERN="/bin/cat"
CATEGORYSH=""

ALLREFER=""
ALLSH="/bin/cat"

USER=""
USERPATTERN="/bin/cat"
USERSH=""

UNMATCH=""

IGNORE=""

LOGTYPE=""
ENCODING=""
NFSPERFORM=""
ISFORDOWN=""

NEED_CONVERT_ENCODING="no"

CapacityThresholdSize=3
propertyFile="/opt/nec/nsadmin/etc/properties/syslog.conf"
if [ -e "$propertyFile" ]; then
    . $propertyFile
fi

for opt in $args
do
         case $opt in
         -a)     ALLREFER="isAll";               shift ;;
         -f)     FILENAME="$2";                  shift 2;;
         -I)     ID=$2                           shift 2;;
         -r)     REVERSE="/bin/cat";             shift ;;
         -p)     NFSPERFORM="true"               shift ;;
         -c)     CATEGORY="/bin/egrep -e $2";    shift 2;;
         -e)     USER="$2";                      shift 2;;
         -v)     UNMATCH="-v";                   shift ;;
         -C)     MATCH_NO="-C$2";                shift 2;;
         -i)     IGNORE="-i";                    shift ;;
         -l)     LOGTYPE=$2                      shift 2;;
         -E)     ENCODING=$2                     shift 2;;
         -d)     ISFORDOWN="true"                shift ;;

         --)     shift;                          break;;
         esac
done
if [ $# != 0 ]; then
     usage
     exit 1
fi
if [ "x$LOGTYPE" = "x" ]; then
     usage
     exit 1
fi
    if [ "x$LOGTYPE" = "xcifsLog" -a "x$ENCODING" = "xUTF-8" ]; then
    	changeCheck=`/opt/nec/nsadmin/bin/nsgui_needCodeConvert.pl $ENCODING_UTF8_NEC_JP`
    	checkResult=$?
    	if [ $checkResult -eq 0 -a "$changeCheck" = "y" ]; then
    	         NEED_CONVERT_ENCODING="yes"
                 DIR=`expr $FILENAME : '\(\/[^\/]*\/\).*'`
                 if [ "x$DIR" = "x/export/" ]; then
                     FILENAME=`echo "$FILENAME" | /usr/bin/iconv -c -t $ENCODING_UTF8_NEC_JP -f $ENCODING_UTF_8`
                     if [ "x$?" != "x0" ]; then
                         exit 1
                     fi
                 fi
         fi
     fi

if [ "x$FILENAME" = "x" ]; then
     usage
     exit 1
fi

if [ "x$ID" = "x" ]; then
     usage
     exit 1
fi

if [ "x$ALLREFER" = "x" ]; then
    if [ "x$USER" != "x" ]; then
     USER=`/home/nsadmin/bin/log_replace.pl "$USER"`
     USERPATTERN="/bin/egrep  $UNMATCH $MATCH_NO $IGNORE -e $USER"
     USERSH="/bin/sh -c"
    fi
fi
if [ "x$CATEGORY" != "x" ]; then
     CATEGORYPATTERN="$CATEGORY"
     CATEGORYSH="/bin/sh -c"
fi

SEARCHSWITCH="on"
if [ "x$ALLREFER" = "xisAll" -a "x$LOGTYPE" != "xsystemLog" ]; then
    SEARCHSWITCH="off"
fi

TMPDIR="/var/crash/.nsguiwork/logview/$ID"

if [ ! -e $TMPDIR ]; then
    mkdir -p $TMPDIR
    chmod -R 777 $TMPDIR
fi

for LOOP in `/bin/ls $TMPDIR 2>/dev/null`
do
    if [ "$LOOP" != "NFSPerform" ]; then
        /bin/rm -rf $TMPDIR/$LOOP
    fi
done

#use filename

TEMPFILE="$LOGTYPE""___""$$"

TEMPFILE=`/bin/mktemp "$TEMPFILE.XXXXXX"`
RETVAL=$?
if [ $RETVAL != 0 ]; then
     exit $RETVAL
fi
/bin/rm -f $TEMPFILE
DATE=`/bin/date '+%H-%M-%S-%Y%m%d'`

/home/nsadmin/bin/log_getFileList.pl "$LOGTYPE" "$FILENAME" $REVERSE 2>/dev/null 1>&2
if [ $? -ne 0 ]; then
    /bin/echo "false"
    exit 0
fi

TEMPFILE="$TEMPFILE""$DATE.log"

MKFILE="/$TEMPFILE"

BASE_NAME=`/bin/basename "$FILENAME"`

INODE_PRE=$(getINode)
if [ $(checkDiskLeftRoom "off") -eq 0 ]; then
    if [ "${NEED_CONVERT_ENCODING}" = "no" ]; then
        /home/nsadmin/bin/log_getFileList.pl "$LOGTYPE" "$FILENAME" $REVERSE | xargs -0 -n1 /home/nsadmin/bin/log_printContent.sh $REVERSE |$ALLSH | $CATEGORYSH "$CATEGORYPATTERN" | $USERSH "$USERPATTERN" | /bin/awk '{printf("%s\r\n",$0)}' > $TMPDIR$MKFILE
    else
        /home/nsadmin/bin/log_getFileList.pl "$LOGTYPE" "$FILENAME" $REVERSE | xargs -0 -n1 /home/nsadmin/bin/log_printContent.sh $REVERSE |$ALLSH | $CATEGORYSH "$CATEGORYPATTERN" | $USERSH "$USERPATTERN" | /usr/bin/iconv -c -f $ENCODING_UTF8_NEC_JP -t $ENCODING_UTF_8 | /bin/awk '{printf("%s\r\n",$0)}' > $TMPDIR$MKFILE
    fi
    RETVAL=$?
elif [ "x$SEARCHSWITCH" = "xon" -a $(checkDiskLeftRoom) -eq 0 ]; then
    if [ "${NEED_CONVERT_ENCODING}" = "no" ]; then
        /home/nsadmin/bin/log_getFileList.pl "$LOGTYPE" "$FILENAME" $REVERSE | xargs -0 -n1 /home/nsadmin/bin/log_printContent.sh $REVERSE |$ALLSH | $CATEGORYSH "$CATEGORYPATTERN" | $USERSH "$USERPATTERN" | /bin/awk '{printf("%s\r\n",$0)}' > $TMPDIR$MKFILE
    else
        /home/nsadmin/bin/log_getFileList.pl "$LOGTYPE" "$FILENAME" $REVERSE | xargs -0 -n1 /home/nsadmin/bin/log_printContent.sh $REVERSE |$ALLSH | $CATEGORYSH "$CATEGORYPATTERN" | $USERSH "$USERPATTERN" | /usr/bin/iconv -c -f $ENCODING_UTF8_NEC_JP -t $ENCODING_UTF_8 | /bin/awk '{printf("%s\r\n",$0)}' > $TMPDIR$MKFILE
    fi
    RETVAL=$?
else
    /bin/echo "DiskIsFull"
    exit 0
fi
INODE_END=$(getINode)
if [ "x$INODE_PRE" != "x$INODE_END" ]; then
    rm -f $TMPDIR$MKFILE
    INODE_PRE=$(getINode)
    if [ $(checkDiskLeftRoom "off") -eq 0 ]; then
        if [ "${NEED_CONVERT_ENCODING}" = "no" ]; then
            /home/nsadmin/bin/log_getFileList.pl "$LOGTYPE" "$FILENAME" $REVERSE | xargs -0 -n1 /home/nsadmin/bin/log_printContent.sh $REVERSE |$ALLSH | $CATEGORYSH "$CATEGORYPATTERN" | $USERSH "$USERPATTERN" | /bin/awk '{printf("%s\r\n",$0)}' > $TMPDIR$MKFILE
        else
            /home/nsadmin/bin/log_getFileList.pl "$LOGTYPE" "$FILENAME" $REVERSE | xargs -0 -n1 /home/nsadmin/bin/log_printContent.sh $REVERSE |$ALLSH | $CATEGORYSH "$CATEGORYPATTERN" | $USERSH "$USERPATTERN" | /usr/bin/iconv -c -f $ENCODING_UTF8_NEC_JP -t $ENCODING_UTF_8 | /bin/awk '{printf("%s\r\n",$0)}' > $TMPDIR$MKFILE
        fi
        RETVAL=$?
    elif [ "x$SEARCHSWITCH" = "xon" -a $(checkDiskLeftRoom) -eq 0 ]; then
        if [ "${NEED_CONVERT_ENCODING}" = "no" ]; then
            /home/nsadmin/bin/log_getFileList.pl "$LOGTYPE" "$FILENAME" $REVERSE | xargs -0 -n1 /home/nsadmin/bin/log_printContent.sh $REVERSE |$ALLSH | $CATEGORYSH "$CATEGORYPATTERN" | $USERSH "$USERPATTERN" | /bin/awk '{printf("%s\r\n",$0)}' > $TMPDIR$MKFILE
        else
            /home/nsadmin/bin/log_getFileList.pl "$LOGTYPE" "$FILENAME" $REVERSE | xargs -0 -n1 /home/nsadmin/bin/log_printContent.sh $REVERSE |$ALLSH | $CATEGORYSH "$CATEGORYPATTERN" | $USERSH "$USERPATTERN" | /usr/bin/iconv -c -f $ENCODING_UTF8_NEC_JP -t $ENCODING_UTF_8 | /bin/awk '{printf("%s\r\n",$0)}' > $TMPDIR$MKFILE
        fi
        RETVAL=$?
    else
        /bin/echo "DiskIsFull"
        exit 0
    fi
    INODE_END=$(getINode)
    if [ "x$INODE_PRE" != "x$INODE_END" ]; then
        rm -f $TMPDIR$MKFILE
        /bin/echo "rotate"
        exit 0
    fi
fi

CLEAN_OPTIONS="-t $RMTIME -f $TMPDIR$MKFILE"

if [ ! -f $TMPDIR$MKFILE ]; then
     /bin/echo "false"
     exit $RETVAL
fi
if [ ! -s $TMPDIR$MKFILE ]; then
     /bin/rm -rf $TMPDIR$MKFILE
     /bin/echo "false"
     exit $RETVAL
fi

if [ $RETVAL -ne 0 ]; then
    /bin/echo "false"
    /bin/rm -rf $TMPDIR$MKFILE
    exit $RETVAL
fi

/bin/echo "true"
/bin/echo $TMPDIR$MKFILE

if [ "$ISFORDOWN" != "true" ]; then
    /home/nsadmin/bin/log_cleanup.sh $CLEAN_OPTIONS >&/dev/null &
fi
exit 0
