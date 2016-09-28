#!/usr/bin/perl -w
#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: filesystem_checkBeforeMove.pl,v 1.1 2005/06/10 09:41:05 jiangfx Exp $"

use strict;
use NS::FilesystemCommon;
use NS::FilesystemConst;
use NS::VolumeCommon;
use NS::VolumeConst;

my $fsCommon = new NS::FilesystemCommon;
my $fsConst = new NS::FilesystemConst;
my $volCommon = new NS::VolumeCommon;
my $volConst = new NS::VolumeConst;

if(scalar(@ARGV)!=1){
    $fsConst->printErrMsg($fsConst->ERR_PARAM_NUM);
    exit 1;
}
my $mp = shift;

my $mpArray = $fsCommon->getSubMountList($mp);
if ($mpArray =~ /^0x108000/) {
    $volConst->printErrMsg($mpArray);
    exit 1;
}
my ($exportsMP, $importsMP, $errCode) = $volCommon->getReplicationMP();
if (defined($errCode)) {
    $volConst->printErrMsg($errCode);
    exit 1;
}

foreach(@$mpArray) {
    ## check whether this mountpoint has been set original
    my $curmp = $$_[1];

    my $retVal = $volCommon->hasMounted($curmp);
    ## execute command [mount] error
    if ($retVal =~ /^0x108000/) {
        $volConst->printErrMsg($retVal);
        exit 1;
    }
    
    ## $curmp is unmount
    if ($retVal == 1) {
        $volConst->printErrMsg($volConst->ERR_FS_UMOUNTED);
        exit 1;
    }

    if(defined($$exportsMP{$curmp})) {
        $fsConst->printErrMsg($fsConst->ERR_HAS_ORIGINAL);
        exit 1;        
    }
    ## check whether this mountpoint has been set replica
    if(defined($$importsMP{$curmp})) {
        $fsConst->printErrMsg($fsConst->ERR_HAS_REPLICA);
        exit 1;        
    }
    ## check whether this mountpoint has been set snapshot schedule
    my ($scheduleList , $errCode) = $volCommon->getSnapshotScheduleList($curmp);
    if(defined($errCode)){
        $volConst->printErrMsg($errCode);
        exit 1; 
    }
    if(scalar(@$scheduleList) > 0){
        $fsConst->printErrMsg($fsConst->ERR_HAS_SCHEDULE);
        exit 1;   
    }
    ## check whether this mountpoint has been been export by nfs, cifs ,ftp  
    $retVal = $volCommon->isUsedMP($curmp);
    if ($retVal =~ /^0x108000/) {
        $volConst->printErrMsg($retVal);
        exit 1;
    }
    if(1 == $volCommon->isChild($curmp)) {
        my $hasSetAuth = $volCommon->hasSetAuth($curmp);
        if($hasSetAuth =~ /^0x108000/){
            $volConst->printErrMsg($hasSetAuth);
            exit 1;
        }
        if($hasSetAuth){
            $fsConst->printErrMsg($fsConst->ERR_HAS_AUTH);
            exit 1;            
        }
    }  
}

exit 0;