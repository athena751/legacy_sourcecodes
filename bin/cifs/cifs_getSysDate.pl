#!/usr/bin/perl
#
#       Copyright (c) 2006 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: cifs_getSysDate.pl,v 1.2 2006/05/12 09:25:12 fengmh Exp $"

use strict;
system("/bin/date '+%Y %b %d%n%H:%M:%S'");
exit $?/256;