#!/usr/bin/perl -w
#
#       Copyright (c) 2001-2006NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: volume_fcsan_exec.pl,v 1.4 2006/11/17 14:12:33 liuyq Exp $"

###Function: execute fcsan commands with exec in fip node
###Parameter :
###     command to be execute
###Output:
###     the ouput of command
###Return
###     command 's exit code

use strict;
use NS::ClusterStatus();

my $clusterStatus = new NS::ClusterStatus;

if((-f "/var/lock/subsys/iSMSM") || (-f "/var/lock/subsys/iSMsvr") || (!$clusterStatus->isCluster())){
    exec @ARGV;  
}else{
    if (!$clusterStatus->update()) {
        exit 1;  ## failed to get cluster info
    }
    if ($clusterStatus->isActiveNode()) {
        exec @ARGV;
    }else{
        my $friendIp = &getFriendIP();
        if(system("sudo ping -c 1 -w 2  ${friendIp} >& /dev/null") != 0 ){
            print STDERR "Friend node is not active.\n";
            exit 1;
        }
        my $cluster_rsh = "/home/nsadmin/bin/cluster_rsh.pl";
        my @cmds =($cluster_rsh ,"sudo");
        push (@cmds,@ARGV);
        push (@cmds,$friendIp);
        exec @cmds;
    }
}

#Function:
#   return the IP address of friend node.
#Arguments:
#   None
#return value:
#   IP address of friend node.
sub getFriendIP {
    my $sh_getMyFriend = "/home/nsadmin/bin/getMyFriend.sh";
    my $friendIp       = `$sh_getMyFriend`;
    chomp($friendIp);
    if (!defined($friendIp) ||$friendIp eq ""){
        return undef;
    }
    return $friendIp;
}