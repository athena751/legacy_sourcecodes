#!/usr/bin/perl -w
#       Copyright (c) 2004 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: log_kill_nfspfminfo2_process.pl,v 1.1 2005/01/24 08:46:54 baiwq Exp $"

use strict;

`/usr/bin/killall nfspfminfo2`;

exit 0;