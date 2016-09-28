#!/usr/bin/perl -w
#       Copyright (c) 2004-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: cifs_deleteShare.pl,v 1.5 2007/06/28 01:44:06 fengmh Exp $"

#Function: 
    #save the content in the temp file into smb.conf.%L and exec [/bin/nascifsstart] 
#Arguments: 
    #$groupNumber       : the group number 0 or 1
    #$domainName        : the domain Name
    #$computerName      : the computer Name
    #$shareName         : the share name
#exit code:
    #0:succeed 
    #1:failed

use strict;
use NS::SystemFileCVS;
use NS::CIFSConst;
use NS::CIFSCommon;
use NS::NsguiCommon;
use NS::ConfCommon;
use NS::CodeConvert;

my $comm  = new NS::NsguiCommon;
my $cvs = new NS::SystemFileCVS;
my $const = new NS::CIFSConst;
my $cifsCommon = new NS::CIFSCommon;
my $confCommon = new NS::ConfCommon;
my $codeConvert = new NS::CodeConvert;

if(scalar(@ARGV)!=4){
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}

my $groupNumber = shift;
my $domainName = shift;
my $computerName = shift;
my $shareName = shift;

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

my $smb_conf_File = $cifsCommon->getSmbFileName($groupNumber, $domainName, $computerName);
my $cmd_syncwrite_o = $cvs->COMMAND_NSGUI_SYNCWRITE_O;

if($cvs->checkout($smb_conf_File)!=0){
    $comm->writeErrMsg($const->ERRCODE_FAILED_TO_CHECK_OUT_SMB_CONF_FILE,__FILE__,__LINE__+1);
    exit 1;    
}

open(FILE,"$smb_conf_File");
my @fileContent = <FILE>;
close(FILE);

$confCommon->deleteSection($shareName,\@fileContent);

open(WRITE, "|${cmd_syncwrite_o} ${smb_conf_File}");
print WRITE @fileContent;
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