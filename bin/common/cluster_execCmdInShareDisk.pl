#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: cluster_execCmdInShareDisk.pl,v 1.2 2005/01/27 01:53:23 wangw Exp $"
#Function: 
#   exec command in the share disk.
#Parameters: 
#   $groupNo    --  [0|1]
#   $cmdStr 	--  such as "cat xxx 2> /dev/null"
#Output:
#	the specified command's output result
#   
#exit code:
#   0 -- successful
#   !0 -- failed

use strict;
use NS::NsguiCommon;

my $nsguicomm = new NS::NsguiCommon;
my $cmd_cluster_checkStatus_pl =  "/home/nsadmin/bin/cluster_checkStatus.pl";

if (scalar(@ARGV) != 2){
    print STDERR " ",__FILE__,"  parameter error!\n";
    exit 1;
}

my $groupNo = shift;
my $cmdStr = shift;

`$cmd_cluster_checkStatus_pl 2> /dev/null`;
my $exitCode = $? >> 8;
if($exitCode == 0){
    #0 -- cluster is normal or the node is not one node of cluster.	
    if ($nsguicomm->getMyNodeNo() eq $groupNo){
    	#exec cmd in local node
    	exit &execCmdInLocal();
    }else{
    	#exec cmd in friend node
    	exit &execCmdInFriend();
    }
}elsif($exitCode == 1){
    #1 -- the two share filesystem is mount on this node.
    exit &execCmdInLocal();
}elsif($exitCode == 2){
    #2 -- the two share filesystem is mount on other node.
    exit &execCmdInFriend();
}else{
    #3 -- the cluster status is error.
    exit &execCmdInLocal();
}
exit 0;

sub execCmdInLocal(){
    my $exitCode = system($cmdStr);
    $exitCode = $exitCode >> 8;
    return $exitCode;
}

sub execCmdInFriend(){
    my $targetIP = $nsguicomm->getFriendIP();	
    my ($ret, $content) = $nsguicomm->rshCmdWithSTDOUT($cmdStr, $targetIP);
    if (!defined($ret)){
            return 1;
    }
    print @$content;
    return $ret;
}