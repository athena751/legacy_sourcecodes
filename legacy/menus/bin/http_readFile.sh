#!/bin/bash

#
#       Copyright (c) 2003 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: http_readFile.sh,v 1.2300 2003/11/24 00:54:36 nsadmin Exp $"

if [ $# -ne 1 ]
then
echo "Parameter error!"
exit 1
fi

filename=$1
if [ -e $filename ]
then
cat $filename
exit 0
else
echo "The $filename is not found."
exit 1
fi
