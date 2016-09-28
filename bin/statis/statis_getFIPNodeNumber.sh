#!/bin/sh
#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: statis_getFIPNodeNumber.sh,v 1.1 2005/10/20 07:38:53 cuihw Exp $"


ETH0=/etc/rc.d/init.d/nascluster

if [ ! -f $ETH0 ]; then
    echo "0"
    exit 0
fi
    
. $ETH0
echo "$NAS_CLUSTER_NODE"

exit 0