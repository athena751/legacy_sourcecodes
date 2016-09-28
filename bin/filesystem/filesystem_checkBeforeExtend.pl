#!/usr/bin/perl -w
#
#       Copyright (c) 2005-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: filesystem_checkBeforeExtend.pl,v 1.2 2008/04/19 14:32:31 jiangfx Exp $"

use strict;
use NS::FilesystemConst;
use NS::VolumeCommon;
use NS::VolumeConst;
use NS::ReplicationCommon;
use NS::ReplicationConst;

my $fsConst = new NS::FilesystemConst;
my $volCommon = new NS::VolumeCommon;
my $volConst = new NS::VolumeConst;
my $repliCommon     = new NS::ReplicationCommon;
my $repliConst      = new NS::ReplicationConst;

if(scalar(@ARGV)!=1){
    $fsConst->printErrMsg($fsConst->ERR_PARAM_NUM);
    exit 1;
}
my $mp = shift;

my $retVal = $volCommon->hasMounted($mp);
## execute command [mount] error
if ($retVal =~ /^0x108000/) {
	$volConst->printErrMsg($retVal);
	exit 1;
}
    
## $mp is unmount
if ($retVal == 1) {
	$volConst->printErrMsg($volConst->ERR_FS_UMOUNTED);
	exit 1;
}

## check if vgpair has been set or not.
$retVal = $repliCommon->vgpaircheck($mp);
if ($retVal == 0) {
   $repliConst->printErrMsg($repliConst->ERR_IS_PAIRED);
   exit 1;
} elsif ($retVal != 1) {
   $repliConst->printErrMsg($repliConst->ERR_EXECUTE_VGPAIRCHECK);
   exit 1;
}
exit 0;