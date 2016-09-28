#!/usr/bin/perl -w
#    Copyright (c) 2006-2009 NEC Corporation
#
#    NEC SOURCE CODE PROPRIETARY
#
#    Use, duplication and disclosure subject to a source code
#    license agreement with NEC Corporation.
#
# "@(#) $Id: hosts_saveFile.pl,v 1.4 2009/01/19 09:50:03 fengmh Exp $"
#Function:
    #get the information of user's input
#Arguments:
    #node
#exit code:
    #0:succeeded
    #1:failed
#output:
    #apply information
use strict;
use NS::SystemFileCVS;
use NS::HostsCommon;
use NS::NsguiCommon;
my $comm  = new NS::HostsCommon;
my $nsguiComm = new NS::NsguiCommon;
my $hosts_File = $comm->HOSTS_CONFIG;
my $cvs = new NS::SystemFileCVS;
my $firstComment = $comm->FIRST_COMMENT;
my $secondComment = $comm->SECOND_COMMENT;
my $cmd_syncwrite_o = $cvs->COMMAND_NSGUI_SYNCWRITE_O;
my $cmd_write_otherNode ="/home/nsadmin/bin/hosts_synchronizePartner.pl";

if(scalar(@ARGV)!=1){
    print STDERR "PARAMETER ERROR\n";
    exit 1;
}

my $tempFile = shift;

if($cvs->checkout($hosts_File)!=0){
    system("rm -f ${tempFile}");
    print STDERR "CHECKOUT FILE ERROR\n";
    exit 1;
}

my $cmdGetTmpFile = "cat ".$tempFile;
my $tmpNVInfo = $comm->getNVInfo();
my @NVInfo = @$tmpNVInfo;


my $NVKeyWordsVar = $comm->getNVKeyWords(\@NVInfo);
my %NVKeyWords;
if(defined($NVKeyWordsVar)){
   %NVKeyWords =  %$NVKeyWordsVar;
}
my $icLanKeyAddr = $comm->getIcLanKey();
my %icLanKey;
if(defined($icLanKeyAddr)) {
    %icLanKey = %$icLanKeyAddr;
}

my @tmpFileContent = `$cmdGetTmpFile 2>/dev/null`;
my @setToFileLine = ($firstComment,$secondComment,@NVInfo);
my $guardFlag = 0;
foreach(@tmpFileContent){
    my $tmpFileLine = $_;
    my $isNVInformation = 0;
    my $tmpLine = $comm->trimLine($tmpFileLine);
    my @tmpArray = split(/\s+/,$tmpLine);
    foreach(@tmpArray){
        if(defined($NVKeyWords{$_}) || defined($icLanKey{$_})){
            $isNVInformation = 1; 
            last;
        }                	
    }    	
    if($isNVInformation == 0){
        push(@setToFileLine,$tmpFileLine);
    }else{
        $guardFlag = 1;      
    }
}

#write to hosts file.
open(W,"|${cmd_syncwrite_o} ${hosts_File}");
print W @setToFileLine;


if(!close(W)){
    system("rm -f ${tempFile}");
    $cvs->rollback($hosts_File);
    print STDERR "syncWrite file error\n";
    exit 1;
}
if($cvs->checkin($hosts_File)!=0){
    system("rm -f ${tempFile}");
    $cvs->rollback($hosts_File);
    print STDERR "checkin file error\n";
    exit 1;
}
my $friendIp = $nsguiComm->getFriendIP();
if(defined($friendIp)){
    system($cmd_write_otherNode);
    if($?!=0){
        system("rm -f ${tempFile}");
        print STDERR "FAIL_WRITE_OTHERNODE";
        $nsguiComm->writeErrMsg($comm->ERRCODE_WRITETO_OTHERNODE_ERROR,__FILE__,__LINE__+1);
        exit 1;
    }
}
system("rm -f ${tempFile}");
if($guardFlag == 1){
    print STDOUT "GUARD_USER_SETTING\n";
    exit 0;
}
print STDOUT "SUCCESS\n";
exit 0;
