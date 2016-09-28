#!/usr/bin/perl -w
#
#       Copyright (c) 2005-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: filesystem_move.pl,v 1.11 2007/09/12 12:47:23 liy Exp $"

use strict;
use Getopt::Long;
use NS::FilesystemCommon;
use NS::FilesystemConst;
use NS::VolumeCommon;
use NS::VolumeConst;
use NS::NsguiCommon;
use NS::SystemFileCVS;

my $fsCommon = new NS::FilesystemCommon;
my $fsConst = new NS::FilesystemConst;
my $volCommon = new NS::VolumeCommon;
my $volConst = new NS::VolumeConst;
my $nsguiCommon = new NS::NsguiCommon;
my $fileCommon = new NS::SystemFileCVS;


my ($srcmp, $desmp, $option, $fstype, $encoding);
my $cmd_syncwrite_o = $fileCommon->COMMAND_NSGUI_SYNCWRITE_O;

my $result = GetOptions ('s=s' => \$srcmp,
                         'd=s' => \$desmp,
                         'o=s' => \$option,
                         't=s' => \$fstype,
                         'e=s' => \$encoding);

if(!$result
   || !defined($srcmp)
   || !defined($desmp)
   || !defined($option)
   || !defined($fstype)
   || !defined($encoding)){
    $fsConst->printErrMsg($fsConst->ERR_PARAM_NUM);
    exit 1;
}

## get the partner node's IP
my $friendIp = $nsguiCommon->getFriendIP();
if(!defined($friendIp)
  || $nsguiCommon->isActive($friendIp) !=0 ) {
    $volConst->printErrMsg($volConst->ERR_FRIEND_NODE_DEACTIVE);
    exit 1;
}

## check whether the source mountpoint is mounted
my $retVal = $volCommon->hasMounted($srcmp);
if ($retVal =~ /^0x108000/) {
    $volConst->printErrMsg($retVal);
    exit 1;
}

## $mp is unmount
if ($retVal == 1) {
    $volConst->printErrMsg($volConst->ERR_FS_UMOUNTED);
    exit 1;
}

my $mpArray = $fsCommon->getSubMountList($srcmp);
if ($mpArray =~ /^0x108000/) {
    $volConst->printErrMsg($mpArray);
    exit 1;
}
my $len = scalar(@$mpArray);
my $lastsubmp = $$mpArray[$len-1]->[1]; 

## check whether the last sub of source mountpoint is mounted
$retVal = $volCommon->hasMounted($lastsubmp);
if ($retVal =~ /^0x108000/) {
    $volConst->printErrMsg($retVal);
    exit 1;
}

## $mp is unmount
if ($retVal == 1) {
    $volConst->printErrMsg($volConst->ERR_FS_UMOUNTED);
    exit 1;
}

my $src_cfstab = $volCommon->getCfstabFile();
my $nodeNo = $nsguiCommon->getMyNodeNo();
my $des_cfstab = ($nodeNo == 0)? $volConst->FILE_CFSTAB_NODE1 : $volConst->FILE_CFSTAB_NODE0;

my $cmd_checkout = $fsConst->CMD_CHECKOUT;
my $cmd_checkin = $fsConst->CMD_CHECKIN;
my $cmd_rollback = $fsConst->CMD_ROLLBACK;
my $cmd_rm = $volConst->CMD_RM;

## checkout cfstab
if ($fileCommon->checkout($src_cfstab)!= 0 
   || $nsguiCommon->rshCmd("sudo $cmd_checkout $des_cfstab", $friendIp)!=0
   || $nsguiCommon->syncFileFromOther($des_cfstab, $friendIp)!=0 ) {
    $fileCommon->rollback($src_cfstab);
    $nsguiCommon->rshCmd("sudo $cmd_rollback $des_cfstab", $friendIp);
    $fsConst->printErrMsg($fsConst->ERR_CHECKOUT_CFSTAB);
    exit 1;    
}

my $cmd_ims_domain = $volConst->CMD_IMS_DOMAIN;
my $cmd_vol = $volConst->CMD_VOL;
my $ims_conf = $volCommon->getImsConfFile();
my $des_ims_conf = ($nodeNo == 0)? $volConst->FILE_IMS_CONF_NODE1 : $volConst->FILE_IMS_CONF_NODE0;
my @hasMovedFS = ();

for (my $i=$len-1; $i>=0; $i--) {
    my $curlv = $$mpArray[$i]->[0];
    my $curmp = $$mpArray[$i]->[1];
    my $hasPsid = 0;
	if(&umount($curmp, \$hasPsid) == 1 ) {
	    system("$cmd_rm -f $des_cfstab >&/dev/null");
        exit 1;
	}

    ## move logical volume
    if($fsCommon->lvmMove($curlv, $friendIp)!=0) {
        system($cmd_vol, "mount", $curmp);
        if($hasPsid == 1) {
            system($cmd_ims_domain, "-A", $curmp, "-f", "-c", $ims_conf);
        }
        $fsConst->printErrMsg($fsConst->ERR_LVM_MOVE);
        &finalize();
        system("$cmd_rm -f $des_cfstab >&/dev/null");
        exit 1;
    }
    my $cur_desmp = $curmp;
    $cur_desmp =~ s/$srcmp/$desmp/;
    push(@hasMovedFS, [$curlv, $cur_desmp]);
}

my $cmd_defacl = $volConst->CMD_DEFACL;
my $cmd_chmod = $volConst->CMD_CHMOD;
## modify by xingyh "my $acldir = $volCommon->getFirstNotExistParent($desmp,$friendIp)"
##  - for this method cannot get the friend node 's mountpoint more than 3 grades.
my $acldir = $volCommon->getFirstNotExistParentFromDestNode($desmp,$friendIp);

if($fsCommon->syncDir($srcmp, $desmp, $friendIp)!=0
   || $fsCommon->cfstabMove($srcmp, $desmp)!=0 ) {
    $fsConst->printErrMsg($fsConst->ERR_FILESYSTEM_MOVE);
    &finalize();
    system("$cmd_rm -f $des_cfstab >&/dev/null");
    exit 1;
}

if(defined($acldir)){
    if($fstype eq "sxfsfw") {
        $nsguiCommon->rshCmd("sudo $cmd_defacl -r $acldir", $friendIp);
    }
}else{
    $acldir = $desmp;
}            

$nsguiCommon->syncFileToOther($des_cfstab, $friendIp);
system("$cmd_rm -f $des_cfstab >&/dev/null");
$fileCommon->checkin($src_cfstab); 
$nsguiCommon->rshCmd("sudo $cmd_checkin $des_cfstab", $friendIp);

## mount the mountpoints in partner node
$len = scalar(@hasMovedFS);
for(my $i=$len-1; $i>=0; $i--) {
    my $tmp_mp = $hasMovedFS[$i]->[1];
    if($nsguiCommon->rshCmd("sudo $cmd_vol mount $tmp_mp", $friendIp)!=0) {
        $fsConst->printErrMsg($fsConst->ERR_MOUNT_IN_DESTINATION);        
        exit 1;
    }
    if($fstype eq "sxfsfw") {
        if($nsguiCommon->rshCmd("sudo $cmd_ims_domain -A $tmp_mp -f -c $des_ims_conf", $friendIp)!=0) {
            $fsConst->printErrMsg($fsConst->ERR_LOGIN_PSID_IN_DESTINATION);        
            exit 1;        
        }
    }
    
    ##set rv info for volume license
	$retVal = $volCommon->execDfrvAdd($tmp_mp, $friendIp);
	if ($retVal =~ /^0x108000/) {
	    $volConst->printErrMsg($retVal);
	    exit 1;
	}
}
if($acldir eq $desmp){
    $nsguiCommon->rshCmd("sudo $cmd_chmod 777 $desmp", $friendIp);
}else{
    $volCommon->changeNewDirstoFullRightsModeFromDestNode($acldir, $desmp, $friendIp);
}

exit 0;


################################################################
## Function
##     Umount the specified mountpoint
##
## Parameters
##     $mp: the mountpoint to delete
##
## Return
##     0: success
##     1: failure
sub umount() {
    my $mp = shift;
    my $hasPsid = shift;
    ## if PSID has been login, delete it.
    if($fstype eq "sxfsfw") {
        $$hasPsid = $volCommon->checkPSID($ims_conf, $mp);
        if($$hasPsid =~ /^0x108000/){
            $volConst->printErrMsg($$hasPsid);
            &finalize();
            return 1;
        }

        if($$hasPsid == 1) {
            if(system("$cmd_ims_domain -D $mp -f -c $ims_conf 2>/dev/null")!=0 ) {
                $fsConst->printErrMsg($fsConst->ERR_DELETE_PSID);
                &finalize();
                return 1;
            }
        }
    }
    
    ## Unmount the mountpoint   
    if(system("$cmd_vol umount $mp really-force 2>/dev/null")!=0) {
        if($$hasPsid == 1) {
            system("$cmd_ims_domain -A $mp -f -c $ims_conf 2>/dev/null");
        }
        $volConst->printErrMsg($volConst->ERR_EXECUTE_UMOUNT);
        &finalize();
        return 1;        
    }
    return 0;
}

################################################################
## Function
##     Delete the mountpoint from cfstab when its LV has been
##     moved to partner node. 
##     Check in the cfstab in this node and rollback the cfstab
##     in partner node.
##
## Parameters
##     none
##
## Return
##     none
sub finalize() {
    my $cmd_cat = $volConst->CMD_CAT;
    my @cfstab_content = `$cmd_cat $src_cfstab 2>/dev/null`;
    if(!open(CFSTAB, "| ${cmd_syncwrite_o} $src_cfstab")) {
        $fileCommon->rollback($src_cfstab);
        $nsguiCommon->rshCmd("sudo $cmd_rollback $des_cfstab", $friendIp);
        return;
    }
    OUTLOOP: foreach(@cfstab_content) {
        if(/^\s*(\/dev\/\S+)\s+/) {
           my $cfstab_lv = $1;
           foreach(@hasMovedFS) {
               my $moved_lv = $$_[0];
               if($cfstab_lv eq $moved_lv) {
                   next OUTLOOP;
               }               
           }
        }
        print CFSTAB $_;
    }
    if(!close(CFSTAB)) {
        $fileCommon->rollback($src_cfstab);
        $nsguiCommon->rshCmd("sudo $cmd_rollback $des_cfstab", $friendIp);
        return;
    }
    $fileCommon->checkin($src_cfstab);
    $nsguiCommon->rshCmd("sudo $cmd_rollback $des_cfstab", $friendIp);
    return;
}