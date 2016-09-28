#!/usr/bin/perl -w
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: schedulescan_getShareInfo.pl,v 1.2 2008/12/18 07:35:32 wanghui Exp $"

#Function: 
    #get the share list information for displaying in setting page.
    #the share list information includes [shareName]
#Arguments: 
    #$groupNumber      : the group number 0 or 1
    #$domainName       : the Domain Name
    #$vscomputerName   : the Computer Name
    #$sComputerName    : the schedule scan's computer Name
#exit code:
    #0 ---- success
    #1 ---- failure
#output:
    #----------------------------------------------------------
    #|STDOUT Content       
    #----------------------------------------------------------
    #unusedShareName[,unusedShareName...]
    #usedShareName[,usedShareName...]
    #------------------------------------------------------
use strict;
use NS::CIFSCommon;
use NS::ScheduleScanCommon;
use NS::NsguiCommon;
use NS::ScheduleScanConst;
my $cifsCommon = new NS::CIFSCommon;
my $ssCommon = new NS::ScheduleScanCommon;
my $comm = new NS::NsguiCommon;
my $const = new NS::ScheduleScanConst;


if(scalar(@ARGV)!=4){
    print STDERR "PARAMETER ERROR.Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

my $groupNumber = shift;
my $domainName = shift;
my $vsComputerName = shift;
my $sComputerName = shift;

my $cifsConfFile = $cifsCommon->getSmbFileName($groupNumber,$domainName,$vsComputerName);
my $ssCifsConfFile = $cifsCommon->getSmbFileName($groupNumber,$domainName,$sComputerName);
if(!(-f $cifsConfFile) || !(-f $ssCifsConfFile)){
    print STDERR "smb config file miss!Exit in perl script:",__FILE__," line:",__LINE__+1,".\n"; 
    $comm->writeErrMsg( $const->ERRCODE_GET_INFO,__FILE__, __LINE__ + 1 );
    exit 1;
}

open(FILE, $cifsConfFile);
my @cifsContent = <FILE>;
close(FILE);

open (FILE,$ssCifsConfFile);
my @ssCifsContent = <FILE>;
close(FILE);

my $allShareName = $ssCommon->getAllScanShare(\@cifsContent, $groupNumber, "sxfsfw");

my $usedShareName;
my $usedPath;
($usedShareName,$usedPath) = $ssCommon->getUsedScanShare(\@ssCifsContent);

if(!defined($allShareName)){
    $allShareName = "";
}
if(!defined($usedShareName)){
    $usedShareName = "";
}

if($allShareName eq "" || $usedShareName eq ""){
    print $allShareName."\n";
    print $usedShareName."\n";
}else{
    my %usedShareNameHash=();
    my @unUsedShare=();
        foreach(split(",",$usedShareName)){
            $usedShareNameHash{$_} = "";
        }
        foreach(split(",",$allShareName)){
            if(!defined($usedShareNameHash{$_})){
                push(@unUsedShare,$_);
    	    }
        }
    print join(",",@unUsedShare)."\n";
    print $usedShareName."\n";
}
exit 0;
