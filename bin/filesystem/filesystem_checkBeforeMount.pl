#!/usr/bin/perl -w
#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: filesystem_checkBeforeMount.pl,v 1.1 2005/06/10 09:41:05 jiangfx Exp $"
## Function:
##     check whether get mountpint can be mount or not
##
## Parameters:
##     $mp	-- mountpoint will be mount
##  
## Output:
##     STDOUT
##         none
##         
##     STDERR
##         error message and error code
##
## Returns:
##     0 -- can be mount 
##     1 -- cannot be mount
use strict;
use NS::FilesystemConst;
use NS::VolumeConst;
use NS::VolumeCommon;

my $filesystemConst = new NS::FilesystemConst;
my $volumeConst     = new NS::VolumeConst;
my $volumeCommon    = new NS::VolumeCommon;

## check parameters 
if (scalar(@ARGV) != 1) {
    $filesystemConst->printErrMsg($filesystemConst->ERR_PARAM_NUM);
    exit 1;
}

my $mp = shift;

## check whether $mp has been mount
my $hasMounted = $volumeCommon->hasMounted($mp);
if ($hasMounted =~ /^0x108000/) {
    $volumeConst->printErrMsg($hasMounted);
    exit 1;
}

if ($hasMounted == 0) {
    $filesystemConst->printErrMsg($filesystemConst->ERR_HAS_MOUNTED);
    exit 1;
}

## check whether $mp is child
my $isChild = $volumeCommon->isChild($mp);

## check parent mountpoint's status if $mp is child
if ($isChild == 0) {
    my ($fsType, $accessMode, $errCode) = $volumeCommon->getTypeAccessOfParent($mp);
    if (defined($errCode)) {
        $volumeConst->printErrMsg($errCode);
        exit 1;
    }
}

exit 0;