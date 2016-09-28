#!/bin/sh
#
#       Copyright (c) 2006-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

dir="/var/crash/.nsguiwork/logview"
if [ ! -e "$dir" ]; then
    exit 0
fi

files=`ls $dir`
for file in $files
do
    for arg in $*
    do
        isused="false"
        if [ "$arg" = "$file" ]; then
            isused="true"
            break
        fi
    done
    if [ "$isused" = "false" ]; then
        rm -rf $dir/$file
    fi
done
exit 0
