#!/usr/bin/perl
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: cifs_getScheduleScanUserAndServer.pl,v 1.1 2008/05/09 02:48:15 chenbc Exp $"

use strict;
use NS::ConfCommon;
use NS::ScheduleScanCommon;

my $confCommon = new NS::ConfCommon;
my $ssCommon = new NS::ScheduleScanCommon;

if(scalar(@ARGV) != 3){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}

my ($groupNumber, $domainName, $computerName) = @ARGV;

my $validUserForScheduleScan = "";
my $allowHostForScheduleScan = "";

my $ssFileContent = $ssCommon->getFileContent($groupNumber, $domainName, $computerName);
if(defined($ssFileContent)){
    $validUserForScheduleScan = $confCommon->getKeyValue('valid users', 'global', $ssFileContent);
    $allowHostForScheduleScan = $ssCommon->getScanServer($ssFileContent);
}

defined($validUserForScheduleScan) or $validUserForScheduleScan = "";
defined($allowHostForScheduleScan) or $allowHostForScheduleScan = "";

print "$validUserForScheduleScan\n";
print "$allowHostForScheduleScan\n";

exit 0;