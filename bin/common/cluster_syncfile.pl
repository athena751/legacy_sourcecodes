#!/usr/bin/perl  -w
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
# 
 
# "@(#) $Id: cluster_syncfile.pl,v 1.1 2004/07/21 02:59:54 het Exp $"

#Function: 
#   sync file.

#Parameters: 
#   $file     : file to be sync.
#   $type     : "toMyNode" or "fromMyNode"
#   
#Output:
#  none

#STDERR:
#   when failed, the error message include errorCode.
#
#exit code: 
#    0: successful
#    1: failed.
use strict;
use NS::NsguiCommon;
my $comm = new NS::NsguiCommon;

if (scalar(@ARGV) != 2){
    $comm->writeErrMsg($comm->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1,);
    exit 1;
}

my $friendIP = $comm->getFriendIP();
if ($comm->isActive($friendIP) != 0){
    $comm->writeErrMsg($comm->ERRCODE_TARGET_NOT_ACTIVE,__FILE__,__LINE__+1);
    exit 1;
}

my $type = pop(@ARGV);
my $ret;
if ($type eq "toMyNode"){
    $ret = $comm->syncFileFromOther($ARGV[0],$friendIP);
}else{
    $ret = $comm->syncFileToOther($ARGV[0],$friendIP);
}
if ($ret != 0 ){
    $comm->writeErrMsg($comm->ERRCODE_FILE_SYNC_FAILED,__FILE__,__LINE__+1);
    exit 1;
}
exit 0;
