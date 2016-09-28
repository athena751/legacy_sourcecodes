#!/usr/bin/perl -w
#       Copyright (c) 2006 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: hosts_synchronizePartner.pl,v 1.1 2006/05/19 03:30:32 dengyp Exp $"
#Function:
#    To apply(copy) the local /etc/hosts to the other node.
#Params:
#    None.
#Return:
#    0: succeeded.
#    1: failed.
#Output:
#    None.

use strict;
use NS::NsguiCommon;
use NS::HostsCommon;

my $nsguicomm = new NS::NsguiCommon;
my $hostscomm = new NS::HostsCommon;

my $syncfileCmd = $hostscomm->CMD_CLUSTER_SYNCFILE;
my $hostsFile = $hostscomm->HOSTS_CONFIG;

if(system("$syncfileCmd $hostsFile 'fromMyNode'") != 0){
    $nsguicomm->writeErrMsg($hostscomm->ERRCODE_APPLYTOPARTNER,__FILE__,__LINE__+1);
    exit 1;
}

exit 0;
