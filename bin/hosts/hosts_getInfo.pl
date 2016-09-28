#!/usr/bin/perl -w
#       Copyright (c) 2006 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: hosts_getInfo.pl,v 1.3 2006/05/19 10:51:32 dengyp Exp $"

#Function:
    #get the hosts setting info;
    #if not recover, then output the setting.
    #if recover, then output the node0 and node1's setting.
#Arguments:
    #node
#exit code:
    #0:succeeded
    #1:failed
#output:
    #the hosts setting.

use strict;
use NS::NsguiCommon;
use NS::HostsCommon;

my $nsguicomm  = new NS::NsguiCommon;
my $hostscomm  = new NS::HostsCommon;
my $cmdStr = $hostscomm->COMMAND_GET_NV_INFO;

if(scalar(@ARGV)!=0){
    $nsguicomm->writeErrMsg($hostscomm->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}

#get my node setting information
my @myNodeSetting = `$cmdStr 2>/dev/null`;
if ( $? != 0 ) {
   $nsguicomm->writeErrMsg($hostscomm->ERRCODE_CANNOT_GET_SELF_HOSTS_INFO,__FILE__,__LINE__+1);
   exit 1;
}  

my $friendIP=$nsguicomm->getFriendIP();
#judge whether it is cluster environment
if(defined($friendIP)){
    my ($ret, $friendNodeSettingVar) = $nsguicomm->rshCmdWithSTDOUT($cmdStr, $friendIP);
    if (!defined($ret) || $ret != 0){
       $nsguicomm->writeErrMsg($hostscomm->ERRCODE_CANNOT_GET_FRIEND_HOSTS_INFO,__FILE__,__LINE__+1);
        exit 1;
    }
    my @friendNodeSetting=@$friendNodeSettingVar;               

    my $myNodeSettingStr = join("|",@myNodeSetting);
    my $friendNodeSettingStr = join("|",@friendNodeSetting);    
    if($myNodeSettingStr ne $friendNodeSettingStr){
        my $myNodeNo = $nsguicomm->getMyNodeNo();
        print "Recovered:\n";
        print "Node0:\n";
        ($myNodeNo == 0)? print @myNodeSetting : print @friendNodeSetting;    
        print "Node1:\n";
        ($myNodeNo == 0)? print @friendNodeSetting : print @myNodeSetting;              
    }else{
        print @myNodeSetting;      
    }            
    exit 0;
}

print @myNodeSetting;
exit 0;
