#!/usr/bin/perl
#
#       Copyright (c) 2006 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: ndmp_getAllInterfaces.pl,v 1.2 2006/10/09 01:26:18 qim Exp $"

use NS::NDMPCommonV4;
my $ndmpCommon = new NS::NDMPCommonV4;
my ($allInterfaces, $allIPs) = $ndmpCommon->getAllInterfaces();
chomp($allInterfaces);
chomp($allIPs);
print $allIPs."\n";
print $allInterfaces."\n";
exit 0;
