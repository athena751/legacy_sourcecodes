#! /bin/sh
#
#       Copyright (c) 2002-2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#)$Id: ns_smbpasswd.sh,v 1.3 2002/11/10 09:56:58 baiwq Exp"

if [ -f /etc/rc.d/init.d/nascluster ]; then
        . /etc/rc.d/init.d/nascluster
        if [ "x$NAS_CLUSTER" = "xy" ]; then
                MYGROUP="$NAS_CLUSTER_NODE"
        else
		MYGROUP="0"
	fi
else
	MYGROUP="0"
fi

NAS_CIFS="/etc/group$MYGROUP/nas_cifs"

DIR=`dirname $0`
$DIR/ns_nascifsstart.sh

CMD="/usr/bin/smbpasswd"
exec $CMD $* -G $NAS_CIFS

			        
