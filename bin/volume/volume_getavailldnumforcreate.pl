#!/usr/bin/perl -w
#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: volume_getavailldnumforcreate.pl,v 1.2 2005/12/28 05:59:42 wangzf Exp $"

###Function : 
###		1.	get ld number that can be create of specified diskArray
###Parameters:
###     type : 
###            $aid -- disk array's id
###Output:
###     1. get information of pool
###        $availNum
###     2. stderr
###         Parameter's number is wrong.
###         Error occured. (error_code=0x10800000)
###Return :
###     0 -- success
###     1 -- failed

use strict;
use NS::VolumeCommon;
use NS::VolumeConst;

my $volumeCommon = new NS::VolumeCommon;
my $volumeConst = new NS::VolumeConst;

### check parameter number
if(scalar(@ARGV) > 1){
    &showHelp();
    $volumeConst->printErrMsg($volumeConst->ERR_PARAM_WRONG_NUM);
    exit 1;
}

if(scalar(@ARGV)>0) {
    my ($aid)=@ARGV;
    my $availNum = $volumeCommon->getAvailLdNum4Create($aid);
    if($availNum =~ /^\s*0x108000/){
        $volumeConst->printErrMsg($availNum);
        exit 1;
    }
    print "$availNum\n";
} else {
    my $diskArraysHash = $volumeCommon->getArrayInfo("0");
    if(defined($$diskArraysHash{$volumeConst->ERR_FLAG})){
        $volumeConst->printErrMsg($$diskArraysHash{$volumeConst->ERR_FLAG});
        exit 1;
    }
    
    my $availNum;
    foreach(sort keys %$diskArraysHash){
    	my $singleArrayInfo = $$diskArraysHash{$_};
        $availNum = $volumeCommon->getAvailLdNum4Create($$singleArrayInfo[0]);
        if($availNum =~ /^\s*0x108000/){
            $volumeConst->printErrMsg($availNum);
            exit 1;
        }
        print "$$singleArrayInfo[0] $availNum\n";
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
    volume_getavailpool.pl <aid>
            
_EOF_
}

#### sub function defination end   ####

