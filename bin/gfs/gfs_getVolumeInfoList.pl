#!/usr/bin/perl -w
#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: gfs_getVolumeInfoList.pl,v 1.3 2005/12/01 01:52:14 zhangjun Exp $"

use strict;
use NS::NsguiCommon;
use NS::ConstForGFS;
use NS::GFSCommon;

my $nsguicommon  = new NS::NsguiCommon;
my $const        = new NS::ConstForGFS;
my $gfscommon    = new NS::GFSCommon;

my $nodeNo = $nsguicommon->getMyNodeNo();

my $volumeRef = $gfscommon->getAllVolumeAndLd($nodeNo);
if(!defined($volumeRef)){
    print STDERR $gfscommon->error();
    $nsguicommon->writeErrMsg("",__FILE__,__LINE__+1);
    exit 1;
}
if(scalar(keys(%$volumeRef)) == 0){
    exit 0;
}

my $ldRef = $gfscommon->getMountPoint($nodeNo,$volumeRef);
if(!defined($ldRef)){
    print STDERR $gfscommon->error();
    $nsguicommon->writeErrMsg("",__FILE__,__LINE__+1);
    exit 1;
}
if(scalar(keys(%$volumeRef)) == 0){
    exit 0;
}

if($gfscommon->getVolumeSize($volumeRef) != 0){
    print STDERR $gfscommon->error();
    $nsguicommon->writeErrMsg("",__FILE__,__LINE__+1);
    exit 1;
}
if($gfscommon->getLdSize($ldRef) != 0){
    print STDERR $gfscommon->error();
    $nsguicommon->writeErrMsg("",__FILE__,__LINE__+1);
    exit 1;
}
if($gfscommon->getLdType($nodeNo,$ldRef) != 0){
    print STDERR $gfscommon->error();
    $nsguicommon->writeErrMsg("",__FILE__,__LINE__+1);
    exit 1;
}
if($gfscommon->getLdWwnnAndLun($ldRef) != 0){
    print STDERR $gfscommon->error();
    $nsguicommon->writeErrMsg("",__FILE__,__LINE__+1);
    exit 1;
}
if($gfscommon->getSerialNo($ldRef) != 0){
    print STDERR $gfscommon->error();
    $nsguicommon->writeErrMsg("",__FILE__,__LINE__+1);
    exit 1;
}

my $index = 0;
my $volumeNo = scalar(keys %$volumeRef);
foreach (keys %$volumeRef){
    $index ++;
    print "$_ $$volumeRef{$_}{'volumeSize'} $$volumeRef{$_}{'mountPoint'}\n";
    my $ldHash = $$volumeRef{$_}{'LD'};
    foreach (keys %$ldHash){
        print "$_ $$ldRef{$_}{'deviceLun'} $$ldRef{$_}{'deviceWwnn'} $$ldRef{$_}{'deviceSize'} $$ldRef{$_}{'type'} $$ldRef{$_}{'serialNo'}\n";
    }
    if($index != $volumeNo){
        print "\n";
    }
}

exit 0;