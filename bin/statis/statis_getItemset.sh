#!/bin/sh
#
#       Copyright (c) 2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: statis_getItemset.sh,v 1.1 2007/09/04 02:12:21 yangxj Exp $"

DISP_YES="yes"
DISP_NO="no"
CONF_FILE=/opt/nec/nsadmin/etc/statistics/common/statis.conf

if [ -f $CONF_FILE ]; then
    . $CONF_FILE
fi

ITEM_NAME="CPU3_Display"
if [ "x${!ITEM_NAME}" = "xyes" ]; then
    echo "$DISP_YES"
else
    echo "$DISP_NO"
fi
exit 0