#!/bin/sh

#
#       Copyright (c) 2006 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: statis_checkUptime.sh,v 1.1 2006/03/03 05:13:44 pangqr Exp $"

STATIS_BOOTING_FILE=/opt/nec/nsadmin/.statis_booting
UPTIME_FILE=/proc/uptime
UPTIME_UP=3600

if [ ! -f $STATIS_BOOTING_FILE ]; then
    echo -n 0
    exit 0
fi

if [ ! -f $UPTIME_FILE ]; then
    echo -n 1
    exit 1
fi

INTERVAL=$1

UPTIME=$(awk '{print $1;}' $UPTIME_FILE)
STATUS_SAMPLING=$(echo $UPTIME | awk -v interval=$INTERVAL '{if($1<interval) print 1; else print 0;}')
if [ "${STATUS_SAMPLING}x" != "0x" ]; then
    echo -n 1
    exit 0
fi
STATUS_DEL=$(echo $UPTIME | awk -v uptime_up=$UPTIME_UP '{if($1>=uptime_up) print 0; else print 1;}')
if [ "${STATUS_DEL}x" = "0x" ]; then
    rm -rf $STATIS_BOOTING_FILE
fi
echo -n 0
exit 0
