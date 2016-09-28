#!/usr/bin/perl -w
#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: lvm_createLV.pl,v 1.1 2005/10/24 05:43:41 liuyq Exp $"

## Function:
##     create lv
##
## Parameters:
##     $lvName	    -- lv's name
##     $diskPath	-- ld path list. eg. /dev/ld16,dev/ld17
##     $striped	-- whether to striping the lv. true or false
##  
## Output:
##     STDOUT
##         none
##     STDERR
##         error message and error code
##
## Returns:
##     0 -- success 
##     1 -- failed

use strict;
use NS::VolumeCommon;
use NS::VolumeConst;

my $volumeCommon = new NS::VolumeCommon;
my $volumeConst  = new NS::VolumeConst;

if(scalar(@ARGV) != 3){
     $volumeConst->printErrMsg($volumeConst->ERR_PARAM_WRONG_NUM);
     exit 1;
}

my ($lvName , $diskPath , $striped) = @ARGV;

my $errFlag = $volumeConst->ERR_FLAG;
my $lvNameList = $volumeCommon->getAllLvName();
if(defined($$lvNameList{$errFlag})){
    $volumeConst->printErrMsg($$lvNameList{$errFlag}); 
    exit 1;
}elsif(defined($$lvNameList{$lvName})){
    $volumeConst->printErrMsg($volumeConst->ERR_LVM_USED_LVNAME);
    exit 1;
}

### check lv count
my $vgCount = $volumeCommon->getVgCountOfAll();
if($vgCount =~ /^0x108000/){
    $volumeConst->printErrMsg($vgCount);
    exit 1;
}elsif($vgCount > 255){
    $volumeConst->printErrMsg($volumeConst->ERR_LVM_COUNT256);
    exit 1;
}

my $success = $volumeConst->SUCCESS_CODE;
my $retVal = $volumeCommon->createLV($diskPath, $lvName, $striped);
if($retVal ne $success){
    $volumeConst->printErrMsg($retVal);
    exit 1;
}
exit 0;