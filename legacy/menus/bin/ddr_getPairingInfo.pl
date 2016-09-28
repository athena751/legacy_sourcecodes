#!/usr/bin/perl
#
#       Copyright (c) 2001-2006 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: ddr_getPairingInfo.pl,v 1.2 2006/07/06 07:18:16 wangzf Exp $"

#Function:      get the pairingInfo list
#Parameters:    account -- the path of cron file , normally is /var/spool/cron/DDR
#               groupNo -- 0 or 1    
#Exit:      0--successful  1--failed
#Output:
#       mv0  rv0 replicate sync 1 0
#       mv0  rv1 separate - 0 0
#       mv1  rv2 - - 1 1
#       ... ...
use strict;
use NS::DdrScheduleCommon;
#check number of the argument
if(scalar(@ARGV)!=2){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}
my ($ddrCronFile,$groupNo) = @ARGV;
my $common = new NS::DdrScheduleCommon;
#get the mv and rv name list
my $mvNameList = $common->getMvNameList($groupNo);
if(!defined($mvNameList)){
    print STDERR $common->error();
    exit 1;
}
#get the status info and sign that means it has or not schedules in cron file
my $schInfo = $common->getDdrScheduleInfo($ddrCronFile);
if(!defined($schInfo)){
    print STDERR $common->error();
    exit 1;
}
my @cronPairing = keys(%$schInfo);

#looped by pairing name such as--"NV_LVM_MV1 NV_LVM_RV1" 
foreach my $currMvName(@$mvNameList){
    my $ldInfo = $common->getLDNameAndArrayName($currMvName);
    if(!defined($ldInfo)){
        next;
    }
    my $mvldinfo = delete($$ldInfo{$currMvName});
    foreach my $currRvName(keys(%$ldInfo)){
        my $hasSch = "false";
        foreach(@cronPairing){
            if($_ eq "$currMvName $currRvName"){
                $hasSch = "true";
                last;
            }
        }
        my $pairingInfo = $common->getPairingStatusInfo($currMvName,$currRvName);
        if(defined($pairingInfo)){
            my $mvandrvusing = "false";
            if($currRvName=~/^\s*NV_RV0_/ || $currRvName=~/^\s*NV_RV1_/
                    || $currRvName=~/^\s*NV_RV2_/){
                $mvandrvusing = "true";
            }
            print "$currMvName $$mvldinfo[0] $$mvldinfo[1] "
                    ,"$currRvName ${$$ldInfo{$currRvName}}[0] ${$$ldInfo{$currRvName}}[1] "
                    ,"$mvandrvusing $$pairingInfo[0] $$pairingInfo[1] $hasSch 0\n";
        }
    }
}

my $allPairs = $common->getAllPairs();
if(!defined($allPairs)) {
    print STDERR $common->error();
    exit 1;
}

LOOP1:foreach my $currentName(@cronPairing){
    foreach(@$allPairs){
        if($currentName eq $_){
            next LOOP1;
        }
    }
    my ($mvName,$rvName) = split(/\s+/,$currentName);  
    print "$mvName - - $rvName - - - - - true 1\n";
}
exit 0;
