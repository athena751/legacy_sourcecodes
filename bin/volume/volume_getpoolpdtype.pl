#!/usr/bin/perl -w
#
#       Copyright (c) 2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: volume_getpoolpdtype.pl,v 1.2 2007/06/13 06:18:51 liq Exp $"

###Function : 
###			get all available pools of the system that specify the pd type
###Parameters:
###     aid
###     raidtype
###     poolNo
###Output:
###     use volume_getavailpool.pl and the same output
###     stderr
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
if(scalar(@ARGV) !=2){
    $volumeConst->printErrMsg($volumeConst->ERR_PARAM_WRONG_NUM);
    exit 1;
}

my ($aid,$poolnameno) = @ARGV;
my @poollist=split(/#/, $poolnameno); ##poolname(poolno)
my $pdtype="";
foreach (@poollist){
    if (/^\s*\S+\((\S+h)\)\s*$/){
        my $pdList=$volumeCommon->getPdList($aid, $1); # 01h,02h,03h,SAS
        if ($pdList =~ /^0x108/) { ## get next when error 
            $volumeConst->printErrMsg($pdList);
            exit 1;
        }
        if($pdList =~ /^\s*\S+,(\S+)\s*$/){
            if ($pdtype eq ""){
                $pdtype= $1;
            }else{
                if ($pdtype ne $1){
                    $pdtype="MIX";
                    last;
                }
            }
        }
    
    }
}


print $pdtype;
exit 0;


