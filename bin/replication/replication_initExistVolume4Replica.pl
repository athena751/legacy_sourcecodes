#!/usr/bin/perl -w
#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: replication_initExistVolume4Replica.pl,v 1.1 2005/09/15 05:29:22 liyb Exp $"
#######################################################################
#####Reversion history##### 
    ## 2005-07-02     liuyq first create
#######################################################################
use strict;
use NS::ReplicationCommon;
use NS::ReplicationConst;
use NS::VolumeCommon;
use NS::VolumeConst;
use NS::SystemFileCVS;

my $repliConst = new NS::ReplicationConst;
my $repliCommon = new NS::ReplicationCommon;
my $volumeCommon = new NS::VolumeCommon;
my $volumeConst = new NS::VolumeConst;
my $fileCommon   = new NS::SystemFileCVS;

if(scalar(@ARGV) != 2){
    $repliConst->printErrMsg($repliConst->ERR_PARAMETER_COUNT , __FILE__, __LINE__ + 1);
    exit 1; 
}
my ($mp , $format) = @ARGV;
my $mpsOption = $volumeCommon->getMountOptionsFromCfstab();
if(defined($$mpsOption{$volumeConst->ERR_FLAG})){
    $volumeConst->printErrMsg($$mpsOption{$volumeConst->ERR_FLAG});
    exit 1;
}
my $oldOption = $$mpsOption{$mp};
if(!defined($oldOption)){
    $repliConst->printErrMsg($repliConst->ERR_FS_NOT_EXIST_IN_CFSTAB , __FILE__, __LINE__ + 1);
    exit 1;
}

my $access = $$oldOption{"access"};
my $ftype = $$oldOption{"ftype"};
if(($format eq "false") && ($access eq "ro")){
    exit 0;
}
my $cmd = "";
my $ret = 0;
$cmd = $repliConst->CMD_VOL_UMOUNT;
$cmd = "$cmd $mp really-force 2>/dev/null";
$ret = system($cmd);
if($ret != 0){
    $repliConst->printErrMsg($repliConst->ERR_EXECUTE_VOL_UMOUNT , __FILE__, __LINE__ + 1);
    exit 1;
}


if($format eq "true"){
    $cmd = $repliConst->CMD_VOL_FORMAT;
    $cmd = "$cmd $mp 2>/dev/null";
    $ret = system($cmd);
    if($ret != 0){
        $repliConst->printErrMsg($repliConst->ERR_EXECUTE_VOL_FORMAT , __FILE__, __LINE__ + 1);
        exit 1;
    }
}

my $cfstabPath = $volumeCommon->getCfstabFile();
my ($newOption , $newCfstabStr) = ($volumeCommon->generateMountAndCfstabStr(
                   $oldOption->{"lvpath"},
                   $mp,
                   $oldOption->{"ftype"}, 
                   undef,
                   "replic",
                   $oldOption->{"quota"},
                   $oldOption->{"noatime"},
                   $oldOption->{"norecovery"},
                   $oldOption->{"dmapi"}))[1,2];
                   
my $editFile = ($access eq "rw");
if($editFile){
    ## checkout cfstab file
    if($fileCommon->checkout($cfstabPath) != 0 ){
        $repliConst->printErrMsg($repliConst->ERR_EDIT_CFSTAB, __FILE__, __LINE__ + 1);
        exit 1;
    }
}


$cmd = $repliConst->CMD_VOL_MOUNT;
$cmd = "$cmd @$newOption 2>/dev/null";
$ret = system($cmd);
if($ret != 0){
    if($editFile){
        $fileCommon->rollback($cfstabPath);
    }
    $repliConst->printErrMsg($repliConst->ERR_EXECUTE_VOL_MOUNT , __FILE__, __LINE__ + 1);
    exit 1;
}

$ret = $repliCommon->sustain($cfstabPath, $newCfstabStr, $ftype, $mp, $editFile);
if($ret ne $repliConst->SUCCESS){
    if($editFile){
        $fileCommon->checkin($cfstabPath);        
    }

    $repliConst->printErrMsg($ret , __FILE__, __LINE__ + 1);
    exit 1;
}

if($editFile){
    $fileCommon->checkin($cfstabPath);        
}

$repliCommon->activate($mp);

exit 0;