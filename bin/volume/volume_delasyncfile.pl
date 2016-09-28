#!/usr/bin/perl -w
#
#       Copyright (c) 2006-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: volume_delasyncfile.pl,v 1.7 2008/04/25 05:38:11 pizb Exp $"
use strict;
use NS::VolumeCommon;
use NS::VolumeConst;
use NS::SystemFileCVS;
use NS::NsguiCommon;

my $nsguiCommon = new NS::NsguiCommon;
my $volumeCommon = new NS::VolumeCommon;
my $volumeConst = new NS::VolumeConst;
my $fileCommon = new NS::SystemFileCVS;

if (scalar(@ARGV) != 0 && scalar(@ARGV) != 1) {
    $volumeConst->printErrMsg($volumeConst->ERR_PARAM_WRONG_NUM);
    exit 1;               
}

my $cmd_rm = $volumeConst->CMD_RM;
my $tmpFile = $volumeConst->FILE_ASYNC_TMP;
if (scalar(@ARGV) == 0) {
    system("$cmd_rm -f $tmpFile >&/dev/null");
    exit 0;
}

my $volName = shift;

## lock file for edit nas_fsbatch.tmp
my $retVal = $volumeCommon->lockFile();
if ($retVal ne $volumeConst->SUCCESS_CODE) {
    $volumeConst->printErrMsg($retVal);
    exit 1;
}

## checkout nas_fsbatch.tmp
if($fileCommon->checkout($tmpFile) != 0 ){
    $volumeCommon->unlockFile();                
    $volumeConst->printErrMsg($volumeConst->ERR_EDIT_TMPFILE);
    exit 1;
}
## delete the async volume which specified by $volName from nas_fsbatch.tmp 
$retVal = $volumeCommon->delAsyncVolFromFile($volName, $tmpFile);
if($retVal ne $volumeConst->SUCCESS_CODE){
    $fileCommon->rollback($tmpFile);
    $volumeCommon->unlockFile();  
    $volumeConst->printErrMsg($volumeConst->ERR_EDIT_TMPFILE);
    exit 1;
}

## checkin nas_fsbatch.tmp
if($fileCommon->checkin($tmpFile) != 0){
    $fileCommon->rollback($tmpFile);
    $volumeCommon->unlockFile();  
    $volumeConst->printErrMsg($volumeConst->ERR_EDIT_TMPFILE);
    exit 1;
}

## unlock file for edit nas_fsbatch.tmp
$nsguiCommon->deleteEmptyFile( $tmpFile );
$volumeCommon->unlockFile();

exit 0; 