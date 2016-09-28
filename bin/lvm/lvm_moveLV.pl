#!/usr/bin/perl -w
#
#       Copyright (c) 2005-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: lvm_moveLV.pl,v 1.2 2008/04/19 14:53:25 xingyh Exp $"

## Function:
##     move lv to partner node
##
## Parameters:
##     $lvName	    -- lv's name
##  
## Output:
##     STDOUT
##         none
##     STDERR
##         error message and error code
##
## Returns:
##     0 -- success 
##     1 -- failed

use strict;
use NS::NsguiCommon;
use NS::VolumeCommon;
use NS::VolumeConst;
use NS::FilesystemCommon;
use NS::ReplicationCommon;
use NS::ReplicationConst;
    
my $nsguiCommon = new NS::NsguiCommon;
my $volumeCommon = new NS::VolumeCommon;
my $volumeConst  = new NS::VolumeConst;
my $fsCommon = new NS::FilesystemCommon;
my $repliCommon = new NS::ReplicationCommon;
my $repliConst = new NS::ReplicationConst;

if(scalar(@ARGV) != 1){
     $volumeConst->printErrMsg($volumeConst->ERR_PARAM_WRONG_NUM);
     exit 1;
}

my $lvName  = shift;
my $diskPath = "";

my $friendIP = $nsguiCommon->getFriendIP();
if(defined($friendIP)){
    my $exitVal = $nsguiCommon->isActive($friendIP);
    if($exitVal != 0 ){
        $volumeConst->printErrMsg($volumeConst->ERR_FRIEND_NODE_DEACTIVE);
        exit 1;
    }
}else{
    exit 0;
}

my $retVal = $volumeCommon->isLVMounted("/dev/$lvName/$lvName");
if($retVal =~ /^0x108/){
    $volumeConst->printErrMsg($retVal);
    exit 1;
}elsif($retVal == 1){
    $volumeConst->printErrMsg($volumeConst->ERR_LV_MOUNTED);
    exit 1;
}

if($lvName !~ /^NV_LVM_/){
    my $retVgpaircheck = $repliCommon->vgpaircheck($lvName);
    if($retVgpaircheck == 0 ){
        $repliConst->printErrMsg($repliConst->ERR_IS_PAIRED, __FILE__, __LINE__ + 1);
    	exit 1;
    }elsif($retVgpaircheck != 1 ){
        $repliConst->printErrMsg($repliConst->ERR_EXECUTE_VGPAIRCHECK, __FILE__, __LINE__ + 1 );
    	exit 1;
    }
}
my $vgInfo = $volumeCommon->getVgdisplayInfo();
if ((defined($$vgInfo{$volumeConst->ERR_FLAG}))&&($$vgInfo{$volumeConst->ERR_FLAG} ne "")){ 
    $volumeConst->printErrMsg($$vgInfo{$volumeConst->ERR_FLAG});
    exit 1;
}
if (defined($$vgInfo{$lvName})) {
    $diskPath = (split(":", $$vgInfo{$lvName}))[1];
} else {
    $volumeConst->printErrMsg($volumeConst->ERR_LV_NOT_EXIST);
    exit 1;
}

if($fsCommon->lvmMove("/dev/$lvName/$lvName", $friendIP) != 0){
    $volumeConst->printErrMsg($volumeConst->ERR_LV_MOVE);
    exit 1;
}

exit 0;

