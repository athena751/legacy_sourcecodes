#!/bin/sh
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) lvm_getavailabledisk.sh,v 1.2 2002/08/06 06:23:41 hj Exp"

DEVTABLE=/proc/hmd/devtable

CHECKING=""
if [ $# = 0 ]; then
	CHECKING=`cat $DEVTABLE | awk '
        $NF ~ /READY/ {
                last = split($1, hmd, "/");
                if (hmd[last] >= 16) {
                        print hmd[last];
                }
        }'`
else
	CHECKING=$*
fi

echo $CHECKING | awk '
{
	for (hmd = 1; hmd <= NF; ++hmd) {
		print $hmd
		if ($hmd + 0 < 16) {
                        printf("%s:\n", $hmd);
			continue;
                }
		pvdisplay=sprintf("/sbin/pvdisplay --colon /dev/hmd/%s 2>/dev/null", $hmd);
		status=system(pvdisplay) 
	}
}' | 
awk -F: '
NF > 2 {
	last = split($1, hmd, "/");
	printf("%s:%s\n", hmd[last], $2);
}'
