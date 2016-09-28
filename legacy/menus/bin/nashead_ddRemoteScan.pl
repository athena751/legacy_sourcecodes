#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: nashead_ddRemoteScan.pl,v 1.1 2004/06/02 08:33:12 baiwq Exp $"

use strict;
use NS::NasHeadConst;
use NS::NasHeadCommon;
my $nasHeadCommon = new NS::NasHeadCommon;
my $const = new NS::NasHeadConst;
my $localScan_pl = $const->PL_DDLOCALSCAN_PL;
my $friendIp = shift;
my $home = $ENV{HOME} || "/home/nsadmin";
#execute in friend node
$nasHeadCommon->rshCmd("sudo ${home}/bin/$localScan_pl", $friendIp);

exit 0;
