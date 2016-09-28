#!/usr/bin/perl -w
#       Copyright (c) 2004-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: cifs_setDirAccessControl.pl,v 1.5 2007/06/28 01:42:30 fengmh Exp $"

#Function: 
    #delete the dir access control
#Arguments: 
    #$groupNumber      : the group number 0 or 1
    #$domainName       : the Domain Name
    #$computerName     : the Computer Name
    #$operation
    #$shareName        : the Share Name
    #$directory        : the Directory
    #$allowHost
    #$denyHost
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

if(scalar(@ARGV)!=8){
    print STDERR "The number of parameter is wrong. ";
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}

my $groupNumber = shift;
my $domainName = shift;
my $computerName = shift;
my $operation = shift;
my $shareName = shift;
my $directory = shift;
my $allowHost = shift;
my $denyHost = shift;

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

my $dirAccessFile = $cifsCommon->getDirAccessConfFileName($groupNumber, $domainName, $computerName);
my $cmd_syncwrite_o = $cvs->COMMAND_NSGUI_SYNCWRITE_O;
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

open(FILE, "$dirAccessFile");
my @fileContent = <FILE>;
close(FILE);

my @dirEntry = ("dir:$directory\n", "allow:$allowHost\n", "deny:$denyHost\n");

my $shareSectionStartIndex = $cifsCommon->getShareSectionStartIndex($shareName, \@fileContent);
if(defined($shareSectionStartIndex)){
    #there is share entry
    my $shareSectionEndIndex = $cifsCommon->getShareSectionEndIndex(\@fileContent, $shareSectionStartIndex);
    my $dirSectionStartIndex = $cifsCommon->getDirSectionStartIndex(
                 $directory, \@fileContent, $shareSectionStartIndex, $shareSectionEndIndex);
    if(defined($dirSectionStartIndex)){
        #there is dir entry
        my $dirSectionEndIndex = $cifsCommon->getDirSectionEndIndex(\@fileContent, $dirSectionStartIndex, $shareSectionEndIndex);        
        if($operation eq "add"){
            #need to check whether the setting for the dir has existed or not
            if(&isValidDirEntry(\@fileContent, $dirSectionStartIndex, $dirSectionEndIndex) == 1){
                #the entry has existed
                $cvs->rollback($dirAccessFile);
                $comm->writeErrMsg($const->ERRCODE_DIR_ENTRY_EXIST,__FILE__,__LINE__+1);
                exit 1;
            }
        }

        #modify the dir entry from the @fileContent
        splice(@fileContent, $dirSectionStartIndex, ($dirSectionEndIndex - $dirSectionStartIndex + 1), @dirEntry);
    }else{
        #there is not dir entry, add the dir entry at the end of the share entry
        splice(@fileContent, $shareSectionEndIndex+1, 0, @dirEntry);
    }
}else{
    #there is not share entry
    push(@fileContent, "share:$shareName\n");
    push(@fileContent, @dirEntry);
}

open(WRITE,"|${cmd_syncwrite_o} ${dirAccessFile}");
print WRITE @fileContent;
if(!close(WRITE)) {
     $cvs->rollback($dirAccessFile);
     print STDERR "The $dirAccessFile can not be written! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
     exit 1;
}


if($cvs->checkin($dirAccessFile)!=0){
    $cvs->rollback($dirAccessFile);
    $comm->writeErrMsg($const->ERRCODE_FAILED_TO_CHECK_IN_DIR_ACCESS_FILE,__FILE__,__LINE__+1);
    exit 1;
}

system("/home/nsadmin/bin/ns_nascifsstart.sh");
exit 0;

sub isValidDirEntry(){
    my $contentRef = shift;
    my $startIndex = shift;
    my $endIndex = shift;
    my $tmpIndex = $startIndex + 1;
    $tmpIndex = $cifsCommon->getNextValidLineIndex($contentRef, $tmpIndex, $endIndex);
    if(defined($tmpIndex)){
        if($$contentRef[$tmpIndex]=~/^allow:/){
            #need check the next valid line is starts with [deny:] or not
            $tmpIndex++;
            $tmpIndex = $cifsCommon->getNextValidLineIndex($contentRef, $tmpIndex, $endIndex);
            if(defined($tmpIndex)){
                if($$contentRef[$tmpIndex]=~/^deny:/){
                    #need check there is next valid line or not
                    $tmpIndex++;
                    $tmpIndex = $cifsCommon->getNextValidLineIndex($contentRef, $tmpIndex, $endIndex);
                    if(defined($tmpIndex)){
                        #there is next valid line, so this entry is not valid
                        return 0;
                    }else{
                        #there is no next valid line in the section, so this entry is valid
                        return 1;
                    }
                }else{
                    #the line after [allow:] is not starts with [deny:]
                    return 0;
                }
            }else{
                #there is not valid line after [allow:]
                return 0;
            }
        }else{
            #the line after [dir:] is not starts with [allow:]
            return 0;
        }
    }else{
        #there is not valid line after [dir:]
        return 0;
    }
}