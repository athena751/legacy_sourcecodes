#!/bin/sh
#
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#)$Id:  log_printContent.sh,v 1.0 2006/07/05 09:39:49 fengmh Exp"

FILENAME="$1"
FILETYPE=$(/usr/bin/file -b "$FILENAME")
FILETYPE=$(echo "$FILETYPE" | /bin/awk '{print $1}')
if [ "x$FILETYPE" = "xgzip" ]; then
    /bin/gzip -l $FILENAME | awk 'END{print $2}'
else
    ls -l $FILENAME | awk '{print $5}'
fi
exit 0
