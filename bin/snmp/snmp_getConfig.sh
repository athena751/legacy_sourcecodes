#!/bin/sh
#
#       Copyright (c) 2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: snmp_getConfig.sh,v 1.1 2007/09/10 01:10:02 lil Exp $"

DEFAULT=8
CONF_FILE=/opt/nec/nsadmin/etc/properties/snmp.conf

if [ -f $CONF_FILE ]; then
    . $CONF_FILE
fi

KEY_NAME="COMMUNITY_MAX"
if [ "x${!KEY_NAME}" = "x" ]; then
    echo "$DEFAULT"
else
    echo "${!KEY_NAME}"
fi
exit 0
