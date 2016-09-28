#!/usr/bin/perl -w
#       Copyright (c) 2004-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: cifs_setShareAccessLog.pl,v 1.4 2007/06/28 01:42:30 fengmh Exp $"

#Function: 
    #set the acccess log info of the share to smb.conf.%L file;
#Arguments: 
    #$groupNumber       : the group number 0 or 1
    #$domainName        : the domain Name
    #$computerName      : the computer Name
    #$shareName         : the share name
    #$alogEnable        : the value of alog enable
    #$successLoggingItems: the success logging items
    #$errorLoggingItems: the error logging items
#exit code:
    #0:succeed 
    #1:failed
#output:
    #none
    
use strict;
use NS::NsguiCommon;
use NS::CIFSConst;
use NS::CIFSCommon;
use NS::ConfCommon;
use NS::CodeConvert;

my $comm       = new NS::NsguiCommon;
my $const      = new NS::CIFSConst;
my $cifsCommon = new NS::CIFSCommon;
my $confCommon = new NS::ConfCommon;
my $cvs        = new NS::SystemFileCVS;
my $codeConvert = new NS::CodeConvert;

if(scalar(@ARGV)!=7){
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}

my ($groupNumber, $domainName, $computerName, $shareName, 
    $alogEnable, $successLoggingItems, $errorLoggingItems) = @ARGV;

my $expGroupEncoding = $cifsCommon->getExpGroupEncoding($groupNumber, $domainName, $computerName);
if(!defined($expGroupEncoding)) {
    print STDERR $const->ERRMSG_GETEXPORTGROUP."\n";
    $comm->writeErrMsg($const->ERRCODE_GETEXPORTGROUP,__FILE__,__LINE__+1);
    exit 1;
}
$shareName = $codeConvert->changeUTF8Encoding($shareName, $expGroupEncoding, $codeConvert->ENCODING_UTF8_NEC_JP);
if(!defined($shareName)) {
    print STDERR $const->ERRMSG_CHANGEENCODING."\n";
    $comm->writeErrMsg($const->ERRCODE_CHANGEENCODING,__FILE__,__LINE__+1);
    exit 1;
}

my $cmd_syncwrite_o = $cvs->COMMAND_NSGUI_SYNCWRITE_O;

my $smb_conf_File = $cifsCommon->getSmbFileName($groupNumber, $domainName, $computerName);
if($cvs->checkout($smb_conf_File)!=0){
    $comm->writeErrMsg($const->ERRCODE_FAILED_TO_CHECK_OUT_SMB_CONF_FILE,__FILE__,__LINE__+1);
    exit 1;
}

my $smbContent  = $cifsCommon->getSmbContent($groupNumber, $domainName, $computerName);

if ($alogEnable eq "no"){
    $confCommon->setKeyValue("alog enable",                  "no", $shareName, $smbContent);
    $confCommon->setKeyValue("alog logging read write flag", "no", $shareName, $smbContent);
    $confCommon->deleteKey("alog logging success with tid",        $shareName, $smbContent);
    $confCommon->deleteKey("alog logging error with tid",          $shareName, $smbContent);
}else{
    my $successCmd = "";
    my $errorCmd = "";
    if ($successLoggingItems eq "COLLECTALL"){
        $successCmd = "COLLECTALL";
    }else{
        $successCmd = $cifsCommon->getSMBCmd($successLoggingItems,"share");
    }
    if ($errorLoggingItems eq "COLLECTALL"){
        $errorCmd = "COLLECTALL";
    }else{
        $errorCmd = $cifsCommon->getSMBCmd($errorLoggingItems,"share");
    }
    my $readWriteFlag = $cifsCommon->getExecuserspace($alogEnable, $successCmd, $errorCmd);
    
    $confCommon->setKeyValue("alog enable",                   "yes",           $shareName, $smbContent);
    if ($successCmd eq ""){
        $confCommon->deleteKey("alog logging success with tid",                $shareName, $smbContent);
    }else{
        $confCommon->setKeyValue("alog logging success with tid", $successCmd, $shareName, $smbContent);    
    }
    if($errorCmd eq ""){
        $confCommon->deleteKey("alog logging error with tid",                  $shareName, $smbContent);
    }else{
        $confCommon->setKeyValue("alog logging error with tid",   $errorCmd,   $shareName, $smbContent);
    }
    $confCommon->setKeyValue("alog logging read write flag",  $readWriteFlag,  $shareName, $smbContent);   
}

open(WRITE,"|${cmd_syncwrite_o} ${smb_conf_File}");
print WRITE @$smbContent;
if(!close(WRITE)) {
     $cvs->rollback($smb_conf_File);
     print STDERR "The $smb_conf_File can not be written! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
     exit 1;
}

if($cvs->checkin($smb_conf_File)!=0){
    $cvs->rollback($smb_conf_File);
    $comm->writeErrMsg($const->ERRCODE_FAILED_TO_CHECK_IN_SMB_CONF_FILE,__FILE__,__LINE__+1);
    exit 1;
}

system("/home/nsadmin/bin/ns_nascifsstart.sh");

$cifsCommon->writeGUILogInfo($groupNumber, $domainName, $computerName);

exit 0;