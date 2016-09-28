#! /bin/sh

#
#       Copyright (c) 2003 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: getMachineType.sh,v 1.2301 2004/11/16 01:11:40 liuyq Exp $"

CHECKCMD="/usr/sbin/checknode"

TYPE_IPSAN=100
### needn't to consider ipsan case
###if [ ! -x "$CHECKCMD" ]; then
###	# IP-SAN
###	exit $TYPE_IPSAN
###fi
TYPE=`/usr/sbin/checknode`
RETVAL=$?
if [ "$RETVAL" = "0" ]; then
	# NV
	exit $TYPE
fi
exit `expr $RETVAL + $TYPE_IPSAN`
