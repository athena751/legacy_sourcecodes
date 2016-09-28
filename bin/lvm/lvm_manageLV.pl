#!/usr/bin/perl -w
#
#       Copyright (c) 2005-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: lvm_manageLV.pl,v 1.5 2008/04/19 14:50:35 xingyh Exp $"

## Function:
##     delete lv
##
## Parameters:
##     $lvName	    -- manage this lv
##     $diskPath	-- lv's ld list.
##                     eg.  /dev/ld16,/dev/ld17
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
use NS::SystemFileCVS;
use NS::FilesystemConst;
use NS::ReplicationConst;
use NS::ReplicationCommon;

my $nsguiCommon = new NS::NsguiCommon;
my $volumeCommon = new NS::VolumeCommon;
my $volumeConst  = new NS::VolumeConst;
my $fileCommon = new NS::SystemFileCVS;
my $filesystemConst = new NS::FilesystemConst;
my $repliConst  = new NS::ReplicationConst;
my $repliCommon = new NS::ReplicationCommon;

if(scalar(@ARGV) != 1 && scalar(@ARGV) != 2){
     $volumeConst->printErrMsg($volumeConst->ERR_PARAM_WRONG_NUM);
     exit 1;
}
my $lvName = shift;
my $diskPath = shift;

my $lvPath = "/dev/$lvName/$lvName";
if(!defined($diskPath)){
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
}

my @lds = split("," , $diskPath);
### check in partner node
my $friendIP = $nsguiCommon->getFriendIP();
if(defined($friendIP)){
    my $exitVal = $nsguiCommon->isActive($friendIP);
    if($exitVal != 0 ){
        $volumeConst->printErrMsg($volumeConst->ERR_FRIEND_NODE_DEACTIVE);
        exit 1;
    }
}
my $retVal = 0;
my $cmd_cat = $volumeConst->CMD_CAT;
my $cfstabPath = $volumeCommon->getCfstabFile();
if(defined($friendIP)){
    my $partnerCfstab = $volumeConst->FILE_CFSTAB_NODE1;
    if($cfstabPath eq $volumeConst->FILE_CFSTAB_NODE1){
        $partnerCfstab = $volumeConst->FILE_CFSTAB_NODE0;
    }
    my ($exitCode, $cfstabContent) = $nsguiCommon->rshCmdWithSTDOUT("sudo ${cmd_cat} ${partnerCfstab} 2>/dev/null", $friendIP);
    if (!defined($exitCode)) { ## failed to execute rsh command
        $volumeConst->printErrMsg($volumeConst->ERR_GETINFO_PARTNER);    
        exit 1;
    }

    if (($exitCode == 0) && (grep(/^\s*${lvPath}\s+/,@$cfstabContent)>0)){### cat command won't be failed
        $volumeConst->printErrMsg($volumeConst->ERR_LV_PARTNER_USED);    
        exit 1;
    }
}

if(defined($friendIP) && $lvName !~ /^NV_LVM_/){
    my $cmd_vgpaircheck = $repliConst->CMD_VGPAIRCHECK;
    
    my $retVal  = $nsguiCommon->rshCmd("sudo $cmd_vgpaircheck -s $lvName 2>/dev/null", $friendIP);
    my $cmdErr = defined($retVal) && ($retVal != 0) && ($retVal != 1);
    if (!defined($retVal) || $cmdErr) { ## failed to execute rsh command
        $repliConst->printErrMsg($repliConst->ERR_EXECUTE_VGPAIRCHECK_PARTNER);    
        exit 1;
    }

    if ($retVal == 0){### pair create in partner node
        $repliConst->printErrMsg($repliConst->ERR_IS_PAIRED);    
        exit 1;
    }
}

my $vgassign = $volumeCommon->getVg_assignFile();
if(defined($friendIP)){
    my $partnerVgassign = ($vgassign eq $volumeConst->FILE_ASSIGN_NODE1) ? $volumeConst->FILE_ASSIGN_NODE0 : $volumeConst->FILE_ASSIGN_NODE1;
    my $cmd_checkout = $filesystemConst->CMD_CHECKOUT;
    my $cmd_checkin = $filesystemConst->CMD_CHECKIN;
    my $cmd_rollback = $filesystemConst->CMD_ROLLBACK; 
                       
    if ($nsguiCommon->rshCmd("sudo $cmd_checkout $partnerVgassign", $friendIP)!=0
       || $nsguiCommon->syncFileFromOther($partnerVgassign, $friendIP)!=0){
        $nsguiCommon->rshCmd("sudo $cmd_rollback $partnerVgassign", $friendIP);             
        $volumeConst->printErrMsg($volumeConst->ERR_EDIT_VG_ASSIGN);            
        exit 1;
    } 
    my $cmd_rm = $volumeConst->CMD_RM;
    
    $retVal = $volumeCommon->modifyFile("delete" , $partnerVgassign , $lvName , 0);
    if($retVal != 0){
        $nsguiCommon->rshCmd("sudo $cmd_rollback $partnerVgassign", $friendIP);  
        $volumeConst->printErrMsg($volumeConst->ERR_EDIT_VG_ASSIGN);    
        system("$cmd_rm -f $partnerVgassign >&/dev/null");  
        exit 1;
    }

    if($nsguiCommon->syncFileToOther($partnerVgassign, $friendIP)!=0
       || $nsguiCommon->rshCmd("sudo $cmd_checkin $partnerVgassign", $friendIP)!=0){
        $nsguiCommon->rshCmd("sudo $cmd_rollback $partnerVgassign", $friendIP);  
        $volumeConst->printErrMsg($volumeConst->ERR_EDIT_VG_ASSIGN);  
        system("$cmd_rm -f $partnerVgassign >&/dev/null");  
        exit 1;
    }
    system("$cmd_rm -f $partnerVgassign >&/dev/null");
}

if($fileCommon->checkout($vgassign)!= 0){
    $volumeConst->printErrMsg($volumeConst->ERR_EDIT_VG_ASSIGN);    
    exit 1;
}
$retVal = $volumeCommon->modifyFile("add" , $vgassign , $lvName , 0, "$lvName @lds");
if($retVal != 0){
    $fileCommon->rollback($vgassign);
    $volumeConst->printErrMsg($volumeConst->ERR_EDIT_VG_ASSIGN);    
    exit 1;
}
if($fileCommon->checkin($vgassign)!= 0){
    $fileCommon->rollback($vgassign);
    $volumeConst->printErrMsg($volumeConst->ERR_EDIT_VG_ASSIGN);    
    exit 1;
}

## inactive the lv in this node and active it in partner node
my $cmd_vgtakein = $volumeConst->CMD_VGTAKEIN;
my $cmd_vgscan2 = $volumeConst->CMD_VGSCAN2;
system("$cmd_vgscan2 >&/dev/null");
$retVal = system("$cmd_vgtakein -gn -ay $lvName >&/dev/null");
if($retVal != 0){
    $volumeConst->printErrMsg($volumeConst->ERR_EXECUTE_VGTAKEIN);    
    exit 1;
}

exit(0);

