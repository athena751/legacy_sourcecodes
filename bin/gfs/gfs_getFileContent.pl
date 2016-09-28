#!/usr/bin/perl
#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: gfs_getFileContent.pl,v 1.4 2005/11/22 02:03:06 zhangj Exp $"

#Function: 
    #get the file content--/etc/group0.setupinfo/gfstab_s
#Arguments:
    #myNodeNo:
    #    -1:single node
    #    0:cluster,node0
    #    1:cluster,node1
#exit code:
    #0:succeed
    #1:failed

use strict;
use NS::NsguiCommon;
use NS::ConstForGFS;
use NS::GFSCommon;

my $nsguicommon  = new NS::NsguiCommon;
my $const        = new NS::ConstForGFS;
my $gfscommon    = new NS::GFSCommon;

my $myNodeNo       = $nsguicommon->getMyNodeNo();
my $myFileName     = ($myNodeNo == 0) ? $const->GFS_FILENAME_GROUP0 : $const->GFS_FILENAME_GROUP1;
my $fileContentRef = $gfscommon->readFile($myFileName);

if( !defined($fileContentRef) ){
    print STDERR $gfscommon->error();
    $nsguicommon->writeErrMsg("",__FILE__,__LINE__+1);
    exit 1;
}
foreach(@$fileContentRef){
    print;
}
exit 0;
