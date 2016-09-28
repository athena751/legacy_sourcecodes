#!/usr/bin/perl -w
#       Copyright (c) 2004-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: cifs_getShareAccessLog.pl,v 1.4 2007/06/28 01:44:06 fengmh Exp $"

#Function: 
    #get the acccess log info of the share from smb.conf.%L file;
#Arguments: 
    #$groupNumber       : the group number 0 or 1
    #$domainName        : the domain Name
    #$computerName      : the computer Name
    #$shareName         : the share name
#exit code:
    #0:succeed 
    #1:failed
#output:
    #alogEnable=yes|no
    #successLoggingItems=XXX:XXX...
    #errorLoggingItems=XXX:XXX...

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
my $codeConvert = new NS::CodeConvert;

if(scalar(@ARGV)!=4){
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}

my ($groupNumber, $domainName, $computerName, $shareName) = @ARGV;

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


my $smbContent  = $cifsCommon->getSmbContent($groupNumber, $domainName, $computerName);

my $alogEnable  = $confCommon->getKeyValue("alog enable",                   $shareName, $smbContent);
my $alogSuccess = $confCommon->getKeyValue("alog logging success with tid", $shareName, $smbContent);
my $alogError   = $confCommon->getKeyValue("alog logging error with tid",   $shareName, $smbContent);
my $shareExist       = $cifsCommon->isShareNameUsed($groupNumber, $domainName, $computerName, $shareName);

defined($alogEnable)  or $alogEnable  = "";
defined($alogSuccess) or $alogSuccess = "";
defined($alogError)   or $alogError   = "";
defined($shareExist)       or $shareExist       = "";

$alogEnable = $cifsCommon->convertBoolean($alogEnable, "no");
$shareExist= $cifsCommon->convertBoolean($shareExist,  "no");

my $successLoggingItems = $cifsCommon->getLoggingItems($alogSuccess, "share");
my $errorLoggingItems   = $cifsCommon->getLoggingItems($alogError,   "share");

my @successSmbCmd = split(/\s+/, $alogSuccess);
my @errorSmbCmd   = split(/\s+/, $alogError);
my $isAllSuccess  = (grep(/^COLLECTALL$/, @successSmbCmd) > 0);
my $isAllError    = (grep(/^COLLECTALL$/, @errorSmbCmd)   > 0);

if ($isAllSuccess){
    if (!$isAllError && $errorLoggingItems ne ""){
        $successLoggingItems = $cifsCommon->getAllItems();
    }else{
        $successLoggingItems = "COLLECTALL";
    }
}

if ($isAllError){
    if (!$isAllSuccess && $successLoggingItems ne ""){
        $errorLoggingItems = $cifsCommon->getAllItems();
    }else{
        $errorLoggingItems = "COLLECTALL";
    }
}

print "alogEnable=$alogEnable\n";
print "successLoggingItems=$successLoggingItems\n";
print "errorLoggingItems=$errorLoggingItems\n";
print "shareExist=$shareExist\n";

exit 0;



