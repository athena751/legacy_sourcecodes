#!/usr/bin/perl -w
#       Copyright (c) 2004 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: cluster_getMyStatus.pl,v 1.2 2005/02/14 02:20:38 liuhy Exp $"

#Function: 
    #get the status of the machine
#Arguments: 
    #none.
#exit code:
    #0:succeed
    #1:the cluster status is error
#output:
    #   "0" ------------ normal status
    #   "1" ------------ TakeOver status (can connect to other node; other node is active)
    #   "2" ------------ Maintain status (can not connect to other node)
    

use strict;
use NS::NsguiCommon;

my $comm = new NS::NsguiCommon;
my $cmd_cluster_checkStatus_pl = "/home/nsadmin/bin/cluster_checkStatus.pl";
my $exitCode = system($cmd_cluster_checkStatus_pl);
$exitCode = $exitCode >> 8;
if($exitCode == 0){
    #   0 -- cluster is normal or the node is not one node of cluster.
    print "0\n";
}elsif($exitCode == 2){
    print "1\n";
}elsif($exitCode == 1){
    my $friendIP = $comm->getFriendIP();
    if($comm->isActive($friendIP) == 1){
        #can not connect to other node
        print "2\n";
    }else{
        print "1\n";
    }
    
}else{
    #   3 -- the cluster status is error.
    #$errCode = ($myNodeNo==0)?$comm->ERRCODE_NODE1_ERROR
    #                                 :$comm->ERRCODE_NODE0_ERROR;
    $comm->writeErrMsg($comm->ERRCODE_NODE1_ERROR,__FILE__,__LINE__+1);
    exit 1;
}
exit 0;