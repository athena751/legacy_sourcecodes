#!/usr/bin/perl
#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: mapd_getludblist.pl,v 1.2301 2005/08/23 08:07:30 liq Exp $"

use strict;

my @content = `sudo /usr/bin/ludb_mnt list 2>/dev/null`;
if ($? != 0) {
    exit 0;
}

foreach(@content) {
    if ($_ !~ /^\s*$/) {
        print $_;
    }
}
exit 0;