#!/bin/sh
#
#       Copyright (c) 2006-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) log_printContent.sh,v 1.0 2006/07/05 09:39:49 fengmh Exp"

FILENAME=""
REVERSE="/bin/cat"
if [ $# -ge 2 ]; then
    FILENAME="$2"
    REVERSE="$1"
else
    FILENAME="$1"
fi
export TMPDIR=/var/crash/.nsguiwork
if [ ! -e $TMPDIR ]; then
    mkdir -p $TMPDIR
fi
FILETYPE=$(/usr/bin/file -b "$FILENAME")
FILETYPE=$(echo "$FILETYPE" | /bin/awk '{print $1}')
if [ "x$FILETYPE" = "xgzip" ]; then
    /bin/gzip -c -d "$FILENAME" | "$REVERSE"
    EXITCODE=$?
else
    $REVERSE "$FILENAME"
    EXITCODE=$?
fi
exit $EXITCODE
