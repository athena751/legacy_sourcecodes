#!/bin/sh
#
#       Copyright (c) 2003-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: log_readfile.sh,v 1.9 2008/03/22 04:59:51 yangxj Exp $"

usage()
{
        /bin/echo "$0 -f file -s startLine -l lineLength -t logType -E encoding" 1>& 2
}

if [ $# = 0 ]; then
        usage
        exit 1
fi

args=`/usr/bin/getopt 'f:s:l:t:E' $*`
if [ $? != 0 ]; then
        usage
        exit 1
fi

FILE=""
STARTLINE=0
LINELENGTH=0
LOGTYPE=""
ENCODING=""
ENCODING_UTF_8="UTF-8"
ENCODING_UTF8_NEC_JP="UTF8-NEC-JP"

for opt in $args
do
         case $opt in
         -f)     FILE="$2";                        shift 2;;
         -s)     STARTLINE="$2";                   shift 2;;
         -l)     LINELENGTH="$2";                  shift 2;;
         -t)     LOGTYPE="$2";                     shift 2;;
         -E)     ENCODING="$2";                    shift 2;;
         --)     shift;                            break;;
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

if [ $STARTLINE -eq 0 ]; then
    usage
    exit 1
fi

if [ $LINELENGTH -eq 0 ]; then
    usage
    exit 1
fi

if [ "x$LOGTYPE" = "x" ]; then
    usage
    exit 1
fi

if [ ! -f $FILE ]; then
     /bin/rm -rf $FILE
     exit 1
fi
if [ ! -s $FILE ]; then
     /bin/rm -rf $FILE
     exit 1
fi

if [ $STARTLINE -gt $(/bin/cat $FILE | wc -l) ]; then
    /bin/echo Out of range 1>&2
    exit 1
fi
LINELENGTH="+"$LINELENGTH"p"
/bin/sed -n $STARTLINE,$LINELENGTH $FILE 2>/dev/null
exit 0
