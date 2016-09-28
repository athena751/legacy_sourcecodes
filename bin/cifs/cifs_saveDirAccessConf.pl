#!/usr/bin/perl -w
#       Copyright (c) 2004-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: cifs_saveDirAccessConf.pl,v 1.5 2007/06/28 01:43:22 fengmh Exp $"

#Function: 
    #save the content in the temp file into Dir Access Conf File 
#Arguments: 
    #$groupNumber       : the group number 0 or 1
    #$domainName        : the domain Name
    #$computerName      : the computer Name
    #$tempFile          : the temp file
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
my $nsguiIconv = "/home/nsadmin/bin/nsgui_iconv.pl";

if(scalar(@ARGV)!=4){
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}

my $groupNumber = shift;
my $domainName = shift;
my $computerName = shift;
my $tempFile = shift;

my $cmd_syncwrite_m = $cvs->COMMAND_NSGUI_SYNCWRITE_M;
my $cmd_syncwrite_o = $cvs->COMMAND_NSGUI_SYNCWRITE_O;

my $dirAccessFile = $cifsCommon->getDirAccessConfFileName($groupNumber, $domainName, $computerName);
my $expGroupEncoding = $cifsCommon->getExpGroupEncoding($groupNumber, $domainName, $computerName);
if(!defined($expGroupEncoding)) {
    print STDERR $const->ERRMSG_GETEXPORTGROUP."\n";
    $comm->writeErrMsg($const->ERRCODE_GETEXPORTGROUP,__FILE__,__LINE__+1);
    exit 1;
}

if($dirAccessFile eq ""){
    #there is no [dir access list file = xxx] in smb.conf.%L
    
    if(system("/home/nsadmin/bin/cifs_setDefaultGlobalDirAccessOption.pl", 
                            $groupNumber, $domainName, $computerName) != 0){
        print STDERR "Failed to set the Global Option [dir access list file = %r/%D/diraccesslist.%L].\n";
        exit 1;
    }
    $dirAccessFile = $cifsCommon->getDefaultDirAccessConfFileName($groupNumber, $domainName, $computerName);
}

if(!-e $dirAccessFile){
    $cifsCommon->makeLogFileDir($dirAccessFile, "yes");
    system("touch", $dirAccessFile);
    system("chmod", "644", $dirAccessFile);
}  

if($cvs->checkout($dirAccessFile)!=0){
    $comm->writeErrMsg($const->ERRCODE_FAILED_TO_CHECK_OUT_DIR_ACCESS_CONF_FILE,__FILE__,__LINE__+1);
    exit 1;    
}
my $needChangeCode = $codeConvert->needChange($expGroupEncoding);
if(!defined($needChangeCode)) {
    print STDERR $const->ERRMSG_CHANGEENCODING."\n";
    $comm->writeErrMsg($const->ERRCODE_CHANGEENCODING,__FILE__,__LINE__+1);
    exit 1;
}
if($needChangeCode eq "y") {
    system("cat ${tempFile} | $nsguiIconv -f UTF-8 -t UTF8-NEC-JP | $cmd_syncwrite_o ${dirAccessFile}");
} else {
    system("${cmd_syncwrite_m} ${tempFile} ${dirAccessFile}");
}

if($? != 0){
    system("rm -f ${tempFile}");
    $cvs->rollback($dirAccessFile);
    $comm->writeErrMsg($const->ERRCODE_FAILED_TO_WRITE_DIR_ACCESS_FILE,__FILE__,__LINE__+1);
    exit 1;
}
system("rm -f ${tempFile}");
if($cvs->checkin($dirAccessFile)!=0){
    #system("rm -f ${tempFile}");
    $cvs->rollback($dirAccessFile);
    $comm->writeErrMsg($const->ERRCODE_FAILED_TO_CHECK_IN_DIR_ACCESS_FILE,__FILE__,__LINE__+1);
    exit 1;
}

system("/home/nsadmin/bin/ns_nascifsstart.sh");
exit 0;