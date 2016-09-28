#!/usr/bin/perl -w
#
#       Copyright (c) 2005-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: filesystem_checkDestinationDir.pl,v 1.2 2008/07/02 03:46:24 xingyh Exp $"

use strict;
use NS::FilesystemCommon;
use NS::FilesystemConst;
use NS::VolumeCommon;
use NS::VolumeConst;

my $fsCommon = new NS::FilesystemCommon;
my $fsConst = new NS::FilesystemConst;
my $volCommon = new NS::VolumeCommon;
my $volConst = new NS::VolumeConst;

if(scalar(@ARGV)!=3){
    $fsConst->printErrMsg($fsConst->ERR_PARAM_NUM);
    exit 1;
}
my $desmp = shift;
my $fstype = shift;
my $encoding = shift;

my $exportGroup = &getExpGrpFromMP($desmp);
my $ret = $fsCommon->checkExpgrpDir($exportGroup, $encoding);
if ($ret =~ /^0x108000/) {
    $volConst->printErrMsg($ret);
    exit 1;
}

if($ret != 0 ) {
    $fsConst->printErrMsg($fsConst->ERR_EXPORTGOUP);
    exit 1;
}

# check whether $desmp has been used as a mount point
my $cfstab = $volCommon->getMountOptionsFromCfstab();
if(defined($$cfstab{$volConst->ERR_FLAG})){
    $volConst->printErrMsg($$cfstab{$volConst->ERR_FLAG});
    exit 1;
}

my $mount =  $volCommon->getMountMP();
if (defined($$mount{$volConst->ERR_FLAG})) {
    $volConst->printErrMsg($$mount{$volConst->ERR_FLAG});
    exit 1;
}

if(defined($cfstab->{$desmp}) || defined($mount->{$desmp}) ) {
    $fsConst->printErrMsg($fsConst->ERR_DIRECTORY_EXIST);
    exit 1;
}

my $hasChild = $volCommon->hasChild($desmp);
if($hasChild =~ /^0x108000/){
   $volConst->printErrMsg($hasChild);
   exit 1;
}
if($hasChild == 0){
   $volConst->printErrMsg($volConst->ERR_FS_HAS_CHILD);
   exit 1;
}

if($volCommon->isChild($desmp)==0) {
    my $directMP = &getDirectFromMP($desmp);

    my $retVal = $volCommon->hasMounted($directMP);
    if ($retVal =~ /^0x108000/) {
        $volConst->printErrMsg($retVal);
        exit 1;
    }
    
    ## direct mp is unmount
    if ($retVal == 1) {
        $fsConst->printErrMsg($fsConst->ERR_DIRECTMP_UMOUNTED);
        exit 1;
    }
    
    my ($type , $access , $error) = $volCommon->getTypeAccessOfParent($desmp);
    if (defined($error)) {
        $volConst->printErrMsg($error);
        exit 1;
    }
    
    if($type ne $fstype) {
        $fsConst->printErrMsg($fsConst->ERR_NOT_SAME_FSTYPE);
        exit 1;        
    }
    
    if($access eq "ro") {
        $fsConst->printErrMsg($fsConst->ERR_PARENT_READONLY);
        exit 1;     
    }
    
    $ret = $volCommon->hasRepliParent($desmp);
    if ($ret =~ /^0x108000/) {
        $volConst->printErrMsg($ret);
        exit 1;
    }
    if($ret != 0) {    
        $fsConst->printErrMsg($fsConst->ERR_PARENT_HAS_REPLICATION);
        exit 1;        
    }
}

exit 0;

sub getExpGrpFromMP() {
    my $mp = shift;
    $mp=~/^\s*(\/export\/[^\/]+)/;
    return $1;
}

sub getDirectFromMP() {
    my $mp = shift;
    $mp=~/^\s*(\/export\/[^\/]+\/[^\/]+)/;
    return $1;
}