#!/usr/bin/perl -w
#       Copyright (c) 2006 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: cifs_getDirectHosting.pl,v 1.1 2006/11/06 05:31:03 fengmh Exp $"
#
#Function:
#    check self node have set direct hosting or not.
#    check which node can NOT set direct hosting.
#Arguments:
#    $groupNumber
#    $domainName
#    $computerName
#Exit code:
#    0 : executed successfully
#    1 : executed failed
#Output:
#    1st line 
#        yes : have set direct hosting
#         no : have NOT set direct hosting
#    2nd line
#        0 : node 0 have more than 1 windows domain, can NOT set direct hosting
#        1 : node 1 have more than 2 windows domain, can NOT set direct hosting
#     "\n" : direct hosting can be set
#

use strict;
use NS::NsguiCommon;
use NS::CIFSConst;
use NS::CIFSCommon;

my $comm = new NS::NsguiCommon;
my $const = new NS::CIFSConst;
my $cifsCommon = new NS::CIFSCommon;

if(scalar(@ARGV) != 3){
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}

my ($groupNumber, $domainName, $computerName) = @ARGV;

my $whichGroupCannotSet = $cifsCommon->canSetDirectHosting($groupNumber);
print $cifsCommon->getDirectHosting($groupNumber, $domainName, $computerName)."\n";
if(!defined($whichGroupCannotSet) || $whichGroupCannotSet eq "yes") {
    print "\n";
}else {
    print $whichGroupCannotSet."\n";
}
exit 0;
