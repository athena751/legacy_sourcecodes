#!/usr/bin/perl -w
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: volume_getavailpdgandrankinfo.pl,v 1.1 2004/08/14 10:29:42 changhs Exp $"

###Function : for getting  all pdg or getting all available rank for creating volume
###Parameters:
###     type : pdg or rank
###            pdg -- get all physical disk group in current system
###            rank -- get all information of available rank for creating volume in current system
###Output:
###     1. get information of pdg
###         00h
###         01h     
###         03h
###     2. get information of all rank
###         00h  00h  10    105.0 105.0
###         00h  01h  0     20.2  30.5
###         00h  03h  1     15.0  15.0
###         00h  04h  0     0.5   0.5
###         00h  05h  0     0.1   0.1
###     3. stderr
###         Parameter's number is wrong.
###         Error occured. (error_code=0x10800000)
###Return :
###     0 -- success
###     1 -- failed

use strict;

use NS::VolumeCommon;
use NS::VolumeConst;
use NS::NsguiCommon;

my $volumeCommon = new NS::VolumeCommon;
my $volumeConst = new NS::VolumeConst;
my $nsguiCommon = new NS::NsguiCommon;

### check parameter number
if(scalar(@ARGV) != 1){
    &showHelp();
    $volumeConst->printErrMsg($volumeConst->ERR_PARAM_WRONG_NUM);
    exit 1;
}

###  validate parmeters 
my $operation = lc(shift);
if(($operation ne "pdg") && ($operation ne "rank")){
    &showHelp();
    $volumeConst->printErrMsg($volumeConst->ERR_PARAM_INVALID);
    exit 1;
}

### get aid by calling $volumeCommon->getArrayInfo()
my($aid , $aname , $atype , $errCode) = $volumeCommon->getArrayInfo();
if(defined($errCode)){
    $volumeConst->printErrMsg($errCode);
    exit 1;
}

if($operation eq "pdg"){ ### process get pdg info case
    my $cmd_disklist = $volumeConst->CMD_ISADISKLIST;
    my $availPdgHash = $volumeCommon->getAvailPdgs($aid);
    if(defined($$availPdgHash{$volumeConst->ERR_FLAG})){
        $volumeConst->printErrMsg($$availPdgHash{$volumeConst->ERR_FLAG});
        exit 1;
    }
    my @pdgAry = sort keys %$availPdgHash;
    print join("\n",@pdgAry);
}else{ ### process get rank info case
    my $rankHash = $volumeCommon->getAllRankInfo($aid); ### get all rank hash
    if(defined($$rankHash{$volumeConst->ERR_FLAG})){
        $volumeConst->printErrMsg($$rankHash{$volumeConst->ERR_FLAG});
        exit 1;
    }
    foreach(sort keys(%$rankHash)){
        my @pdgAndRank = split("-" , $_);
        my $ldCountOfRank = $volumeCommon->getLdNumOfRank($aid , @pdgAndRank);
        if($ldCountOfRank =~ /^0x108000/){
            $volumeConst->printErrMsg($ldCountOfRank);
            exit 1;
        }
        if($ldCountOfRank >= 36){
            next;
        }
        my $info = $$rankHash{$_};
        my ($raidType , $maxFreeCap , $totalFreeCap) = @$info;
        $maxFreeCap = $nsguiCommon->deleteAfterPoint($maxFreeCap/1024/1024/1024 , 1);
        $totalFreeCap = $nsguiCommon->deleteAfterPoint($totalFreeCap/1024/1024/1024 , 1);
        ##if(($maxFreeCap < 0.1) || ($maxFreeCap > 2 * 1024)){
        if($maxFreeCap < 0.1){
            next;
        }
        print join(" " , @pdgAndRank , $raidType , $maxFreeCap , $totalFreeCap)."\n";
    }
}

exit 0;

#### sub function defination start ####
### Function: show help message;
### Paremeters:
###     none;
### Return:
###     none
### Output:
###     Usage:
###         volume_getavailpdgandrankinfo.pl [pdg|rank]
###            
sub showHelp(){
    print (<<_EOF_);
Usage:
    volume_getavailpdgandrankinfo.pl [pdg|rank]
        
_EOF_
}

#### sub function defination end   ####
