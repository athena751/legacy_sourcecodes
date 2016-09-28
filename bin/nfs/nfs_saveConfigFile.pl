#!/usr/bin/perl -w
#       Copyright (c) 2004 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: nfs_saveConfigFile.pl,v 1.5 2005/08/26 11:44:26 wangzf Exp $"

#Function: 
    #copy temp file to target file
#Arguments: 
    #$tmpFileName          : the tmp file
    #$targetFileName       : the target file
#exit code:
    #0:succeed 
    #1:failed

use strict;
use NS::SystemFileCVS;
use NS::NFSConst;
use NS::NsguiCommon;
my $comm  = new NS::NsguiCommon;
my $cvs = new NS::SystemFileCVS;
my $const = new NS::NFSConst;

if(scalar(@ARGV)!=3){
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}

my ($group,$tmpFileName,$targetFileName) = @ARGV;

my $cmd_syncwrite_m = $cvs->COMMAND_NSGUI_SYNCWRITE_M;

#if group equals my node number, save the content to file fileName
my $filePath;
if($targetFileName =~ /([^\/]+)$/){
    $filePath = $`;
}
if(defined($filePath) && $filePath ne ''){
    system("mkdir -p ${filePath}");
    if($? != 0){
        $comm->writeErrMsg($const->ERRCODE_FAILED_TO_CREATE_TARGET_FILE,__FILE__,__LINE__+1);
        exit 1;
    }
}
if($cvs->checkout($targetFileName)!=0){
    $comm->writeErrMsg($const->ERRCODE_FAILED_TO_CREATE_TARGET_FILE,__FILE__,__LINE__+1);
    exit 1;    
}
if(system("${cmd_syncwrite_m} ${tmpFileName} ${targetFileName}")!=0) {
    system("rm -f ${tmpFileName}");
    $cvs->rollback($targetFileName);
    $comm->writeErrMsg($const->ERRCODE_FAILED_TO_CREATE_TARGET_FILE,__FILE__,__LINE__+1);
    exit 1;
}
my $cmd = $const->SCRIPT_EXPORTNAS_G;
if(system("${cmd} ${group} ${targetFileName} 2>/dev/null") != 0){
    system("rm -f ${tmpFileName}");
    $cvs->rollback($targetFileName);
    $comm->writeErrMsg($const->ERRCODE_FAILED_TO_RUN_EXPORTNAS,__FILE__,__LINE__+1);
    exit 1;
}
if($cvs->checkin($targetFileName)!=0){
    system("rm -f ${tmpFileName}");
    $comm->writeErrMsg($const->ERRCODE_FAILED_TO_CREATE_TARGET_FILE,__FILE__,__LINE__+1);
    $cvs->rollback($targetFileName);
    exit 1;
}
exit 0;

    

