#!/usr/bin/perl -w
#       Copyright (c) 2004-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: cifs_deleteDirAccessControl.pl,v 1.5 2007/06/28 01:44:06 fengmh Exp $"

#Function: 
    #delete the dir access control
#Arguments: 
    #$groupNumber      : the group number 0 or 1
    #$domainName       : the Domain Name
    #$computerName     : the Computer Name
    #$shareName        : the Share Name
    #$directory        : the Directory
#exit code:
    #0 ---- success
    #1 ---- failure
    
use strict;
use NS::SystemFileCVS;
use NS::NsguiCommon;
use NS::CIFSConst;
use NS::CIFSCommon;
use NS::CodeConvert;

my $comm  = new NS::NsguiCommon;
my $cvs = new NS::SystemFileCVS;
my $const = new NS::CIFSConst;
my $cifsCommon = new NS::CIFSCommon;
my $codeConvert = new NS::CodeConvert;

if(scalar(@ARGV)!=5){
    print STDERR "The number of parameter is wrong. ";
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}

my $groupNumber = shift;
my $domainName = shift;
my $computerName = shift;
my $shareName = shift;
my $directory = shift;

my $expGroupEncoding = $cifsCommon->getExpGroupEncoding($groupNumber, $domainName, $computerName);
if(!defined($expGroupEncoding)) {
    print STDERR $const->ERRMSG_GETEXPORTGROUP."\n";
    $comm->writeErrMsg($const->ERRCODE_GETEXPORTGROUP,__FILE__,__LINE__+1);
    exit 1;
}
$shareName = $codeConvert->changeUTF8Encoding($shareName, $expGroupEncoding, $codeConvert->ENCODING_UTF8_NEC_JP);
$directory = $codeConvert->changeUTF8Encoding($directory, $expGroupEncoding, $codeConvert->ENCODING_UTF8_NEC_JP);
if(!defined($shareName) || !defined($directory)) {
    print STDERR $const->ERRMSG_CHANGEENCODING."\n";
    $comm->writeErrMsg($const->ERRCODE_CHANGEENCODING,__FILE__,__LINE__+1);
    exit 1;
}
my $cmd_syncwrite_o = $cvs->COMMAND_NSGUI_SYNCWRITE_O;
my $dirAccessFile = $cifsCommon->getDirAccessConfFileName($groupNumber, $domainName, $computerName);

if($dirAccessFile eq ""){
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

&deleteDirEntryFromFile();

if($cvs->checkin($dirAccessFile)!=0){
    $cvs->rollback($dirAccessFile);
    $comm->writeErrMsg($const->ERRCODE_FAILED_TO_CHECK_IN_DIR_ACCESS_FILE,__FILE__,__LINE__+1);
    exit 1;
}

system("/home/nsadmin/bin/ns_nascifsstart.sh");
exit 0;

sub deleteDirEntryFromFile(){
    open(F, $dirAccessFile);
    my @fileContent = <F>;
    close(F);
    my $shareSectionStartIndex = $cifsCommon->getShareSectionStartIndex($shareName, \@fileContent);
    if(!defined($shareSectionStartIndex)){
        return 0;
    }
    my $shareSectionEndIndex = $cifsCommon->getShareSectionEndIndex(\@fileContent, $shareSectionStartIndex);
    
    my $dirSectionStartIndex = $cifsCommon->getDirSectionStartIndex(
                 $directory, \@fileContent, $shareSectionStartIndex, $shareSectionEndIndex);
    if(!defined($dirSectionStartIndex)){
        return 0;
    }
    my $dirSectionEndIndex = $cifsCommon->getDirSectionEndIndex(\@fileContent, $dirSectionStartIndex, $shareSectionEndIndex);
    
    #delete the dir entry from the @fileContent
    splice(@fileContent, $dirSectionStartIndex, ($dirSectionEndIndex - $dirSectionStartIndex + 1));
    
    while(1){
        $shareSectionEndIndex = $shareSectionEndIndex - ($dirSectionEndIndex - $dirSectionStartIndex + 1);
        $dirSectionStartIndex = $cifsCommon->getDirSectionStartIndex(
                 $directory, \@fileContent, $dirSectionStartIndex, $shareSectionEndIndex);
        if(defined($dirSectionStartIndex)){
            $dirSectionEndIndex = $cifsCommon->getDirSectionEndIndex(\@fileContent, $dirSectionStartIndex, $shareSectionEndIndex);
            #delete the dir entry from the @fileContent
            splice(@fileContent, $dirSectionStartIndex, ($dirSectionEndIndex - $dirSectionStartIndex + 1));
            
        }else{
            last;
        }
    }
    
    open(W,"|${cmd_syncwrite_o} ${dirAccessFile}");
    print W @fileContent;
    if(!close(W)) {
     $cvs->rollback($dirAccessFile);
     print STDERR "The $dirAccessFile can not be written! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
     exit 1;
	}
}