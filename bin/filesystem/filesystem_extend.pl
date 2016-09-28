#!/usr/bin/perl -w
#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: filesystem_extend.pl,v 1.3 2005/11/18 01:23:01 jiangfx Exp $"
## Function:
##    extend filesystem
##
## Parameters:
##     $mp     -- mount point of the filesystem need to be extend, eg: /export/management/staff
##     $lvPath -- logic volume name of the filesytem need to be extend, eg: /dev/NV_LVM_01/NV_LVM_01
##     $ldList -- one or more logic disk used to extend filesystem, eg: /dev/hmd/18,/dev/hmd/20 or /dev/ld16
##     $striping -- value is true or false, specify the the specified LD is striping or linear
##  
## Output:
##     STDOUT
##         none
##         
##     STDERR
##         error message and error code
##
## Returns:
##     0 -- success 
##     1 -- failed
use strict;
use NS::FilesystemConst;
use NS::VolumeCommon;
use NS::VolumeConst;

my $filesystemConst = new NS::FilesystemConst;
my $volumeCommon    = new NS::VolumeCommon;
my $volumeConst     = new NS::VolumeConst;

## check parameter num
if (scalar(@ARGV) != 4) {
    $filesystemConst->printErrMsg($filesystemConst->ERR_PARAM_NUM);
    exit 1;
}

my ($mp, $lvPath, $ldList, $striping) = @ARGV;

## check whether $mp has been mounted
my $retValue = $volumeCommon->hasMounted($mp);
## execute command [mount] error
if ($retValue =~ /^0x108000/) {
	$volumeConst->printErrMsg($retValue);
	exit 1;
}
    
## $mp is unmount
if ($retValue == 1) {
	$volumeConst->printErrMsg($volumeConst->ERR_FS_UMOUNTED);
	exit 1;
}

## extend LV
$retValue = $volumeCommon->extendLV($ldList, $lvPath, $striping);
if ($retValue ne  $volumeConst->SUCCESS_CODE) {
    $volumeConst->printErrMsg($retValue);
    exit 1;
}

## extend FS
my $cmd_xfs_growfs = $volumeConst->CMD_XFS_GROWFS;
if (system($cmd_xfs_growfs, $mp) != 0) {
    $volumeConst->printErrMsg($volumeConst->ERR_EXECUTE_XFS_GROWFS);
    exit 1;
}

exit 0;