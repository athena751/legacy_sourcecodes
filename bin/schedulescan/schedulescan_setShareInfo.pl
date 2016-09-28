#!/usr/bin/perl -w
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: schedulescan_setShareInfo.pl,v 1.2 2008/05/09 04:58:55 qim Exp $"

#Function: 
    #set the share list information.
#Arguments: 
    #$groupNumber      : the group number 0 or 1
    #$domainName       : the Domain Name
    #$vscomputerName   : the Computer Name
    #$sComputerName    : the schedule scan's computer Name
    #$shareNames       : the setting share names
#exit code:
    #0 ---- success
    #1 ---- failure
use strict;
use NS::CIFSCommon;
use NS::ConfCommon;
use NS::ScheduleScanCommon;
use NS::SystemFileCVS;
use NS::ScheduleScanConst;
use NS::NsguiCommon;
my $cifsCommon = new NS::CIFSCommon;
my $confCommon = new NS::ConfCommon;
my $ssCommon = new NS::ScheduleScanCommon;
my $const = new NS::ScheduleScanConst;
my $cvs = new NS::SystemFileCVS;
my $comm = new NS::NsguiCommon;

if(scalar(@ARGV)!=5){
    print STDERR "PARAMETER ERROR.Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

my $groupNumber = shift;
my $domainName = shift;
my $vsComputerName = shift;
my $sComputerName = shift;
my $shareNames = shift;

my $cifsConfFile = $cifsCommon->getSmbFileName($groupNumber,$domainName,$vsComputerName);
my $ssCifsConfFile = $cifsCommon->getSmbFileName($groupNumber,$domainName,$sComputerName);
if(!(-f $cifsConfFile)||!(-f $ssCifsConfFile)){
    print STDERR "cifs smb file isn't exist:",__FILE__," line:",__LINE__+1,".\n";
    $comm->writeErrMsg( $const->ERRCODE_SET_INFO,__FILE__, __LINE__ + 1 );
    exit 1;
}
open(FILE, $cifsConfFile);
my @cifsContent = <FILE>;
close(FILE);
open(FILE, $ssCifsConfFile);
my @ssCifsContent4Global = <FILE>;
close(FILE);

my $globalSection = $confCommon->getSectionValue("global", \@ssCifsContent4Global);
my @ssCifsSmbContent;
if(defined($globalSection)){
    push(@ssCifsSmbContent,"[global]\n");
    push(@ssCifsSmbContent,@$globalSection);
}else{
   print STDERR "cifs smb file's global section is missing:",__FILE__," line:",__LINE__+1,".\n";
   $comm->writeErrMsg( $const->ERRCODE_SET_INFO,__FILE__, __LINE__ + 1 );
   exit 1;
}
my @shareNameArray = split(",",$shareNames);
foreach(@shareNameArray){
    my $shareSectionAddr = $cifsCommon->initShare4ScheduleScan($_,\@cifsContent);
    if(!defined($shareSectionAddr)){
        next;
    }
    push(@ssCifsSmbContent,"[$_]\n");
    push(@ssCifsSmbContent,@$shareSectionAddr);
}

if($cvs->checkout($ssCifsConfFile)!=0){
    print STDERR "CHECK OUT $ssCifsConfFile ERROR:",__FILE__," line:",__LINE__+1,".\n";
    $comm->writeErrMsg( $const->ERRCODE_SET_INFO,__FILE__, __LINE__ + 1 );
    exit 1;
}

my $cmd_syncwrite_o = $cvs->COMMAND_NSGUI_SYNCWRITE_O;

open(WRITE,"|${cmd_syncwrite_o} ${ssCifsConfFile}");
print WRITE @ssCifsSmbContent;

if(!close(WRITE)) {
    $cvs->rollback($ssCifsConfFile);
    print STDERR "THE $ssCifsConfFile CAN NOT BE WRITTEN:",__FILE__," line:",__LINE__+1,".\n";
    $comm->writeErrMsg( $const->ERRCODE_SET_INFO,__FILE__, __LINE__ + 1 );
    exit 1;
}
if($cvs->checkin($ssCifsConfFile)!=0){
    $cvs->rollback($ssCifsConfFile);
    print STDERR "CHECK IN $ssCifsConfFile ERROR:",__FILE__," line:",__LINE__+1,".\n";
    $comm->writeErrMsg( $const->ERRCODE_SET_INFO,__FILE__, __LINE__ + 1 );
    exit 1;
}
my $restartCmd=$const->COMMAND_CIFS_RESTART;
system("$restartCmd 2>/dev/null 1>&2");
exit 0;


