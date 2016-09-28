#!/usr/bin/perl
#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: gfs_modifyFileContent.pl,v 1.5 2005/12/16 12:52:42 zhangjun Exp $"

#Function:
    #modify the file--/etc/group0.setupinfo/gfstab_s
#Arguments:
    #$tmpFileName:the filename of tmpfile
#exit code:
    #0:succeed
    #1:failed

use strict;

use NS::NsguiCommon;
use NS::ConstForGFS;
use NS::GFSCommon;

my $comm        = new NS::NsguiCommon;
my $const       = new NS::ConstForGFS;
my $gfscommon   = new NS::GFSCommon;

if(scalar(@ARGV)!=1){
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}
my $tmpFileName = shift;

my $ret = $gfscommon->modifyFileProcess($tmpFileName);
if($ret == 2){
    $comm->writeErrMsg($const->ERRCODE_GFSSERVADD_FAILED,__FILE__,__LINE__+1);
    exit 1;
}elsif($ret == 1){
    print STDERR $gfscommon->error();
    $comm->writeErrMsg("",__FILE__,__LINE__+1);
    exit 1;
}else{
    exit 0;
}
