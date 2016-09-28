#!/usr/bin/perl  -w
#
#       Copyright (c) 2001-2006 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
# 
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
 
# "@(#) $Id: cluster_checkStatus.pl,v 1.3 2006/02/20 01:15:44 dengyp Exp $"

#Function:  
#   check the cluster's status.

#Parameters: 
#   none.

#Output:
#   none.
#
#STDERR:
#   when cluster status is not normal, the message include 
#   errorCode will be output.
#
#exit code:
#   0 -- cluster is normal or the node is not one node of cluster. 
#   1 -- this node is in maintaince status.
#   2 -- other node is in maintaince status.
#   3 -- the cluster status is error.

use strict;

use NS::NsguiCommon;

my $comm = new NS::NsguiCommon;
my $friendIP = $comm->getFriendIP();
if (!defined($friendIP) || $friendIP eq ""){
    exit 0;    # not cluster;
}

my $myNodeNo = $comm->getMyNodeNo();

my @content = `mount 2> /dev/null`;
my $groupsNum = scalar(grep(/^\s*\S+\s+on\s+\/etc\/group[01]\.setupinfo\s+/,
                            @content));
my $errCode;

if ($groupsNum == 1){
	my $myGrpNum = scalar(grep(/^\s*\S+\s+on\s+\/etc\/group${myNodeNo}\.setupinfo\s+/,
                               @content));
    if ($myGrpNum != 1){
    	# the share filesystem on other node is not correctly mounted;
        $errCode = ($myNodeNo==0)?$comm->ERRCODE_NODE0_ERROR
                                 :$comm->ERRCODE_NODE1_ERROR;
        $comm->writeErrMsg($errCode,__FILE__,__LINE__+1);
    	exit 3;
    }
    if ($comm->isActive($friendIP) == 0 ){
        my @friendMount = `sudo -u nsgui rsh $friendIP mount 2> /dev/null`;
        my $otherNodeno = $myNodeNo == 0 ? 1:0;
        if (grep(/^\s*\S+\s+on\s+\/etc\/group${otherNodeno}\.setupinfo\s+/,
            	@friendMount) != 1
            || grep(/^\s*\S+\s+on\s+\/etc\/group[0|1]\.setupinfo\s+/,
            	    @friendMount) != 1){
            # the share filesystem on other node is not correctly mounted;
            $errCode = ($myNodeNo==0)?$comm->ERRCODE_NODE1_ERROR
                                     :$comm->ERRCODE_NODE0_ERROR;
            $comm->writeErrMsg($errCode,__FILE__,__LINE__+1);
            exit 3;
        }
        exit 0; # all is normal;
    }
    # the other node is not active;
    $errCode = ($myNodeNo==0)?$comm->ERRCODE_NODE1_ERROR
                             :$comm->ERRCODE_NODE0_ERROR;
    $comm->writeErrMsg($errCode,__FILE__,__LINE__+1);
    exit 3;
}

if ($groupsNum > 1){
    # the two share filesystem is mount on this node.
    my $errCode = ($myNodeNo==0)?$comm->ERRCODE_NODE0_MAINTAINCE
                                :$comm->ERRCODE_NODE1_MAINTAINCE;
    $comm->writeErrMsg($errCode,__FILE__,__LINE__+1);
    exit 1;
}

if ($groupsNum < 1){
    if ($comm->isActive($friendIP) == 0){
        my @friendMount = `sudo -u nsgui rsh $friendIP mount 2> /dev/null`;
        if (grep(/^\s*\S+\s+on\s+\/etc\/group[01]\.setupinfo\s+/,
            @friendMount) != 2){
            # the share filesystem is not correctly mounted;
            $errCode = ($myNodeNo==0)?$comm->ERRCODE_NODE1_ERROR
                                     :$comm->ERRCODE_NODE0_ERROR;
            $comm->writeErrMsg($errCode,__FILE__,__LINE__+1);
            exit 3;
        }
        # # the two share filesystem is mount on other node.
        $errCode = ($myNodeNo==0)?$comm->ERRCODE_NODE1_MAINTAINCE
                                 :$comm->ERRCODE_NODE0_MAINTAINCE;
        $comm->writeErrMsg($errCode,__FILE__,__LINE__+1);
        exit 2;
    }
    # the other node is not active;
    $errCode = ($myNodeNo==0)?$comm->ERRCODE_NODE1_ERROR
                             :$comm->ERRCODE_NODE0_ERROR;
    $comm->writeErrMsg($errCode,__FILE__,__LINE__+1);
    exit 3;
}