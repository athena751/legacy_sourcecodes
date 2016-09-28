#!/usr/bin/perl -w
#       Copyright (c) 2004-2006 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: cluster_getGroupStatus.pl,v 1.4 2006/03/07 06:58:39 yangxj Exp $"

#Function: 
    #get the status of group2 and 0/1(used only when takeover occurs)
#Arguments: 
    #none.
#exit code:
    #0:succeed
    #1:failed
#output:
    #when there are no arguments 
    #   "0" ------------ group2 and group1 or group2 and group0 are at the same machine
    #   "1" ------------ group2 and group1 and group0 are at the same machine
    #   "2" ------------ group2 is at a machine, group0 and group1 are at the same machine  
    
    #when there are one arguments "getFIPNode"
    #   "0" ----------- where FIP is on node 0
    #   "1" ----------- where FIP is on node 1

use strict;
use NS::NsguiCommon;

my $comm = new NS::NsguiCommon;
my $cmd_cluster_checkStatus_pl = "/home/nsadmin/bin/cluster_checkStatus.pl 2>/dev/null";
my $exitCode = system($cmd_cluster_checkStatus_pl);
$exitCode = $exitCode >> 8;
if($exitCode == 3){
    print "$@\n";
    exit 1;
}elsif(($exitCode == 0) && (scalar(@ARGV) == 0)){
    print "0\n";
    exit 0;
}

my @groupStatus=`/usr/sbin/clpstat`;
if($? != 0){
    $comm->writeErrMsg("",__FILE__,__LINE__+1);
    exit 1;
}
my @grouplist=();
foreach ( @groupStatus ) {
   if(/^\s*current\s+:\s*(\S+)\s*$/){
      @grouplist=(@grouplist,$1);
   }
}
if(scalar(@ARGV) == 1 && $ARGV[0] eq "getFIPNode"){
    $grouplist[2]=~/^\S+([0-1])$/;
    print $1,"\n";
    exit 0;
}

if($grouplist[0] eq $grouplist[1]){
    if($grouplist[0] eq $grouplist[2]){
        print "1\n";
    }else{
        print "2\n";
    }
}else{
    print "0\n";
}

exit 0;

