#!/usr/bin/perl -w
#
#       Copyright (c) 2006-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: volume_async_operation.pl,v 1.8 2007/07/09 04:52:30 xingyh Exp $"


use strict;

use NS::VolumeCommon;
use NS::VolumeConst;
use NS::NsguiCommon;
use NS::SystemFileCVS;

my $volumeCommon = new NS::VolumeCommon;
my $volumeConst = new NS::VolumeConst;
my $nsguiCommon = new NS::NsguiCommon;
my $fileCommon = new NS::SystemFileCVS;

my $retVal ;
my $success = $volumeConst->SUCCESS_CODE;
my $errFlag = $volumeConst->ERR_FLAG;
my $cmd = shift;
my $isNashead = $nsguiCommon->isNashead();
my $friendIP = $nsguiCommon->getFriendIP();

if(!defined($cmd)){
     $retVal = $volumeConst->ERR_PARAM_WRONG_NUM;
     goto writeResultCode;
}

## wait for creating or extending
my $maxParallelNum = 5;
my $cmd_touch = $volumeConst->CMD_TOUCH;
my $tmpFileFullPath = $volumeConst->PREFFIX_ASYN_VOL_FILE;
my $cmd_ls = $volumeConst->CMD_LS;

while(1) {
	my $parallelNum = `$cmd_ls $tmpFileFullPath* 2>/dev/null | wc -l`;
	chomp($parallelNum);
	if ($parallelNum < $maxParallelNum) {
		system("$cmd_touch $tmpFileFullPath$$");
		last;
	}
	sleep(10);
}

if(defined($friendIP)){
    my $exitVal = $nsguiCommon->isActive($friendIP);
    if($exitVal != 0 ){
        $retVal = $volumeConst->ERR_FRIEND_NODE_DEACTIVE;
        goto writeResultCode;
    }
}

$retVal = $volumeCommon->lockProcess();
if($retVal ne $volumeConst->SUCCESS_CODE){
     goto writeResultCode;
}

$cmd = lc($cmd);
my $volName;
if($cmd eq "create"){
    $retVal = &createFS(@ARGV);
    $volName = $ARGV[1];
}elsif($cmd eq "extend"){
    $retVal = &extendFS(@ARGV);
    $volName  = (split(/\/+/, $ARGV[3]))[3];
}

writeResultCode :
my $exitCode = 1;
if($retVal eq $success){
    $retVal = undef;
    $exitCode = 0;
}
my $retStr = $volumeCommon->modifyAsyncFile($volName, $retVal, "no");
if($retStr ne $success){
	$volumeConst->writeSysLog($volumeConst->ERR_EDIT_TMPFILE);
}

my $unlockCode = $volumeCommon->unlockProcess();
if ($unlockCode ne $success) {
	$volumeConst->writeSysLog($unlockCode);
}

$volumeCommon->delParallelVolFile();

exit $exitCode;

##################sub defination################
### Function : create file system on $mp with lv $lvName;
###Parameter:
###         none
###Return:
###         0x00000000 : all param is valid
###         other error code: some param is invalid
sub createFS(){
    my ($diskList, $volName, $isStriped, $fsType, $repli, $journal, $snapshot, $quota, $noatime, $dmapi, $mp, $usegfs, $codepage, $wpperiod) = @_;
    my $retVal;
    my $succMsg;
    my @args = ();

    my @assignLds = split("," , $diskList);
    foreach(@assignLds){
       $_ =~ s/#/,/g;
    }
    ### process when nv case
    my @lds = ();
    if(!$isNashead){
        push(@args , \@assignLds, "LX" , "0", $friendIP, $volName);
        $retVal = $volumeCommon->createLdsInPools(@args);##value is set in checkDiskOption()
        if($retVal =~ /^\s*0x/){
            return $retVal;
        }
        push(@lds , split(",", $retVal));
    }

    ### create lv
    my $lvName = $volName;
    my $ldPathList = join("," , @lds);
    $retVal = $volumeCommon->createLV($ldPathList , $lvName , $isStriped);
    if($retVal ne $success){
        return $retVal;
    }
    
    $repli = $repli eq "normal" ? undef : $repli;
    $journal = $journal eq "expand" ? $journal : undef;
    ### make file system
    @args = ($fsType , $codepage , $repli);
    push(@args , $journal , "/dev/${lvName}/${lvName}");
    $retVal = $volumeCommon->createFS(@args);
    if($retVal ne $success){
        return $retVal;
    }

    ### mount file system
    $quota   = $quota eq "true" ? "on" : undef;
    $noatime = $noatime eq "true" ? "on" : undef;
    $dmapi   = $dmapi eq "true" ? "on" : undef;
    
    @args = ($fsType , $repli);
    push(@args , $snapshot , $quota , $noatime , undef, $dmapi);
    push(@args , "/dev/${lvName}/${lvName}" , $mp);
    push(@args , 0);## first time mount after file system has been created.
    push(@args , undef , $usegfs, $wpperiod);
    $retVal = $volumeCommon->mountFS(@args);
    if($retVal ne $success){
        return $retVal;
    }

    ### set auth for mount point 
    $retVal = $volumeCommon->setAuth($mp , $fsType);
    if(($retVal ne $volumeConst->AUTH_SET_SUCCESS) && ($retVal ne $volumeConst->REGION_NOT_EXIST)){
        return $retVal;
    }

    return $success;
}

###Function : extend the file system on $mp with the supplied ld
###Parameter:
###         $diskList
###         $mp
###         $isStriped
###Return:
###         0x00000000 : all param is valid
###         other error code: some param is invalid
sub extendFS(){
    my ($diskList , $mp, $isStriped, $lvPath) = @_;
    my $succMsg;
    my @lds = ();
    my $volName  = (split(/\/+/, $lvPath))[3];
    
    my @assignLds = split("," , $diskList);
    foreach(@assignLds){
       $_ =~ s/#/,/g;
    }
    if(!$isNashead){
        my @args = ();
        push(@args , \@assignLds, "LX" , "0", $friendIP, $volName);
        $retVal = $volumeCommon->createLdsInPools(@args);##value is set in checkDiskOption()
        if($retVal =~ /^\s*0x/){
            return $retVal;
        }
        push(@lds , split(",", $retVal));
    }

    ### extend lv
    my $ldPathList = join("," , @lds);
    $retVal = $volumeCommon->extendLV($ldPathList , $lvPath, $isStriped);
    if($retVal ne $success){
        return $retVal;
    }

    ### extend file system
    my $cmd_xfs_growfs = $volumeConst->CMD_XFS_GROWFS;
    $retVal =system($cmd_xfs_growfs , $mp);
    if($retVal != 0){
        return $volumeConst->ERR_EXECUTE_XFS_GROWFS;
    }
    return $success;
}


################################################