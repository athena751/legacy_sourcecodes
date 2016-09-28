#!/usr/bin/perl
#copyright (c) 2005-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: nic_createBond.pl,v 1.2 2005/09/06 08:57:02 dengyp Exp"
#
#Function: 
    #Set interface IP,netmask,gateway,MTU;
#Arguments: 
    #$mode
    #$selectedIFs
    #$interval
    #$primaryIF
#exit code:
    #0:succeed 
    #1:failed
#output:
    #null
      
use strict;

use NS::NsguiCommon;
use NS::NicCommon;
my $comm  = new NS::NsguiCommon;
my $nic_common = new NS::NicCommon;

if(scalar(@ARGV) != 4) {
    print "Usage: nic_createBond.pl MODE INTERFACENAMEs INTERVAL PrimaryIF\n";
    exit 1;
}

my $mode = $ARGV[0];
my $selectedIFs = $ARGV[1];
my $interval = $ARGV[2];
my $primaryIF = $ARGV[3];

my $interfaceNames = $nic_common->getNicNames("-a");
if(defined($interfaceNames)) {
    my @interfaces = split(",", $selectedIFs);
    foreach (@interfaces) {
        my $hasSetAlias = $nic_common->hasAlias($_, $interfaceNames);
        if($hasSetAlias eq "yes") {
            print STDERR "selected I/F is alias's base I/F.\n";
            $comm->writeErrMsg($nic_common->BOND_ISALIAS_BASEIF,__FILE__,__LINE__+1);
            exit 1;
        }
    }
}

my $command =$nic_common->CMD_NV_BOND;
my $cmd = "$command create mode=$mode interfaces=$selectedIFs interval=$interval >& /dev/null";
my $exitCode = 0;

if(($mode eq "active-backup") && ($primaryIF ne "")) {
        $cmd = $cmd." primary=$primaryIF";
}
$exitCode = system($cmd)/256;
if($exitCode != 0){
     $comm->writeErrMsg($nic_common->CMD_ERROR,__FILE__,__LINE__+1,"nv_bond_$exitCode"); 
     exit 1;
} 

exit 0;