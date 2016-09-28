#!/usr/bin/perl -w
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: ethguard_getInfo.pl,v 1.1 2004/03/02 00:54:11 baiwq Exp $"

use strict;
use NS::EthguardCommon;

my $common = new NS::EthguardCommon;
my $cmd_ethguard_status_log = "/etc/rc.d/init.d/ethguard status_log";
my $exitCode = system("$cmd_ethguard_status_log");
$exitCode = $exitCode >> 8;
print "$exitCode\n";

my $connectionInfo = $common->getConnectionInfo();
print "$connectionInfo\n";

exit 0;