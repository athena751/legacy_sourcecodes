#!/bin/sh
#
#       Copyright (c) 2001-2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: statis_getUsedSizePercentage.sh,v 1.1 2005/10/18 16:21:14 het Exp $"
/bin/df /var/opt/nec/statistics|awk 'END {print $5}'|sed 's/%//'