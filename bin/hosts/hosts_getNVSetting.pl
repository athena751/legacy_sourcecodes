#!/usr/bin/perl -w
#       Copyright (c) 2006 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: hosts_getNVSetting.pl,v 1.1 2006/05/19 10:15:28 dengyp Exp $"

#Function:
    #get the NV setting info;    
#Arguments:
    #node
#exit code:
    #0:succeeded
    #1:failed
#output:
# the NV setting. 

use strict;
use NS::HostsCommon;
my $hostscomm  = new NS::HostsCommon;

my $myNodeInfoVar = $hostscomm->getMyNodeHostsInfo();
if(!defined($myNodeInfoVar)){    
    exit 1;
}
my @myNodeInfo = @$myNodeInfoVar;

#get my node setting information
my $myNodeSettingVar = $hostscomm->getHostsSettingInfo(\@myNodeInfo);
my @myNodeSetting;
if(defined($myNodeSettingVar)){
    @myNodeSetting = @$myNodeSettingVar;          
}

print @myNodeSetting;
exit 0;
