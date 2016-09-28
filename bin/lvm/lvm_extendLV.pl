#!/usr/bin/perl -w
#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: lvm_extendLV.pl,v 1.2 2005/11/18 00:48:18 liuyq Exp $"

## Function:
##     extend lv
##
## Parameters:
##     $lvName	    -- lv's name
##     $diskPath	-- ld path list. eg. /dev/ld16,dev/ld17
##     $isStriped	-- whether to stripe the lv. true or false
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

my ($lvName , $diskPath, $isStriped) = @ARGV;
my $lvPath = "/dev/$lvName/$lvName";
my $success = $volumeConst->SUCCESS_CODE;
my $retVal = $volumeCommon->extendLV($diskPath, $lvPath, $isStriped);
if($retVal ne $success){
    $volumeConst->printErrMsg($retVal);
    exit 1;
}

my @mount=`mount 2>/dev/null`;
foreach (@mount) {
    if ($_ =~/^\s*$lvPath\s+on\s+(\S+)\s+.*/){
        my $cmd_xfs_growfs = $volumeConst->CMD_XFS_GROWFS;
        my $retVal =system("$cmd_xfs_growfs $1 >&/dev/null");
        if($retVal != 0){
            $volumeConst->printErrMsg($volumeConst->ERR_EXECUTE_XFS_GROWFS);
            exit 1;
        }
        exit(0);
    }
}
exit(0);
