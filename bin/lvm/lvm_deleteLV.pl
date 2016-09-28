#!/usr/bin/perl -w
#
#       Copyright (c) 2005-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: lvm_deleteLV.pl,v 1.2 2008/04/19 14:51:33 xingyh Exp $"

## Function:
##     delete lv
##
## Parameters:
##     $lvName	    -- lv's name
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
use NS::ReplicationCommon;
use NS::ReplicationConst;

my $volumeCommon = new NS::VolumeCommon;
my $volumeConst  = new NS::VolumeConst;
my $repliCommon = new NS::ReplicationCommon;
my $repliConst = new NS::ReplicationConst;

if(scalar(@ARGV) != 1){
     $volumeConst->printErrMsg($volumeConst->ERR_PARAM_WRONG_NUM);
     exit 1;
}

my $lvName = shift;
my $lvPath = "/dev/$lvName/$lvName";
my $retVal = $volumeCommon->isLVMounted($lvPath);
if($retVal =~ /^0x108/){
    $volumeConst->printErrMsg($retVal);
    exit 1;
}elsif($retVal == 1){
    $volumeConst->printErrMsg($volumeConst->ERR_LV_MOUNTED);
    exit 1;
}

my $retVgpaircheck = $repliCommon->vgpaircheck($lvName);
if($retVgpaircheck == 0 ){
    $repliConst->printErrMsg($repliConst->ERR_IS_PAIRED, __FILE__, __LINE__ + 1);
	exit 1;
}elsif($retVgpaircheck != 1 ){
    $repliConst->printErrMsg($repliConst->ERR_EXECUTE_VGPAIRCHECK, __FILE__, __LINE__ + 1 );
	exit 1;
}
 
my $success = $volumeConst->SUCCESS_CODE;
$retVal = $volumeCommon->deleteLV($lvPath);
if($retVal ne $success){
    $volumeConst->printErrMsg($retVal);
    exit 1;
}

exit(0);
