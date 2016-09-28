#!/usr/bin/perl -w
#
#       Copyright (c) 2006-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: volume_fsbatch_async.pl,v 1.7 2007/07/09 04:53:11 xingyh Exp $"

use strict;
use NS::VolumeCommon;
use NS::VolumeConst;
use NS::SystemFileCVS;

my $volumeCommon = new NS::VolumeCommon;
my $volumeConst  = new NS::VolumeConst;
my $fileCommon = new NS::SystemFileCVS;
my $success = $volumeConst->SUCCESS_CODE;

foreach(@ARGV){
    if($_ =~ /\(|\)/){
        $_ = "\"".$_."\"";
    }
}
my $script_chkparam = $volumeConst->SCRIPT_VOLUME_ASYNC_CHECKPARAM;
my @retVal = `sudo $script_chkparam @ARGV 2>/dev/null`;
if($? != 0){
    my $index = scalar(@retVal);
    my $errCode = $retVal[$index -1];
    chomp($errCode);
    $volumeConst->printErrMsg($errCode);
    exit 1;
}
my $index = scalar(@retVal);
my $param = $retVal[$index -1];
chomp($param);
my @paramAry = split(/\s+/, $param);
my %hash = ();
$hash{"operation"} = $paramAry[0];
$hash{"resultCode"}= $volumeConst->SUCCESS_CODE;
if($paramAry[0] eq "create"){
    $hash{"disklist"}  = $paramAry[1];
    $hash{"volName"}   = $paramAry[2];
    $hash{"isStriped"} = $paramAry[3];
    $hash{"fsType"}    = $paramAry[4];
    $hash{"repli"}     = $paramAry[5];
    $hash{"journal"}   = $paramAry[6];
    $hash{"snapshot"}  = $paramAry[7];
    $hash{"quota"}     = $paramAry[8];
    $hash{"noatime"}   = $paramAry[9];
    $hash{"dmapi"}     = $paramAry[10];
    $hash{"mp"}        = $paramAry[11];
    $hash{"usegfs"}    = $paramAry[12];
    $hash{"codepage"}  = $paramAry[13];
    $hash{"wpperiod"}  = $paramAry[14];
}elsif($paramAry[0] eq "extend"){
    $hash{"disklist"}  = $paramAry[1];
    $hash{"mp"}        = $paramAry[2];
    $hash{"isStriped"} = $paramAry[3];
    $hash{"volName"}   = (split(/\/+/, $paramAry[4]))[3];
}

my $retStr = $volumeCommon->lockFile();
if( $retStr ne $success){
    $volumeConst->printErrMsg($retStr);
    exit 1;
}
my $tmpFile = $volumeConst->FILE_ASYNC_TMP;
if($fileCommon->checkout($tmpFile) != 0 ){
    $volumeConst->printErrMsg($volumeConst->ERR_EDIT_TMPFILE);
    $volumeCommon->unlockFile();
    exit 1;
}
my $retVal = $volumeCommon->addAsyncVolToFile(\%hash, $tmpFile);
if($retVal ne $success){
    $fileCommon->rollback($tmpFile);
    $volumeConst->printErrMsg($retVal);
    $volumeCommon->unlockFile();
    exit 1;
}
if($fileCommon->checkin($tmpFile) != 0){
    $fileCommon->rollback($tmpFile);
    $volumeConst->printErrMsg($volumeConst->ERR_EDIT_TMPFILE);
    $volumeCommon->unlockFile();
    exit 1;
}
$volumeCommon->unlockFile();

foreach(@paramAry){
    if($_ =~ /\(|\)/){
        $_ = "\"".$_."\"";
    }
}
$param = join(" ", @paramAry);
my $script_operation = $volumeConst->SCRIPT_VOLUME_ASYNC_OPERATION;
my @retAry = `sudo $script_operation $param >&/dev/null &`;
exit 0;