#!/usr/bin/perl -w
#copyright (c) 2005-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: nic_setvlan.pl,v 1.4 2007/08/23 02:54:58 fengmh Exp $"
#
#Function: 
    #Add new vlan;
#Arguments: 
    #$interfaceName     : the vlan interface's parent interface name.
    #$vid               : the vlan interface's vid.
    
#exit code:
    #0:succeed 
    #1:failed
#output:
    #null
      
use strict;

use NS::NsguiCommon;
use NS::NicCommon;
use NS::NASCollector;
use NS::ConstInfo;
my $comm  = new NS::NsguiCommon;
my $nic_common = new NS::NicCommon;

if((scalar(@ARGV) == 1 && $ARGV[0] eq "--help") || scalar(@ARGV) != 2) {
    print "Usage:nic_setvlan.pl INTERFACENAME VID\n";
    exit 1;
}

my $interfaceName = $ARGV[0];
my $vid = $ARGV[1];
my $cmd_nv_vlan =$nic_common->CMD_NV_VLAN;
my $exitCode = 0;

my $hasSetAlias = $nic_common->hasAlias($interfaceName);
if($hasSetAlias eq "yes") {
    print STDERR "This I/F is alias's base I/F.\n";
    $comm->writeErrMsg($nic_common->VLAN_ISALIAS_BASEIF,__FILE__,__LINE__+1);
    exit 1;
}

if($interfaceName ne "" && $vid ne "") {
#  write information in RRD files for statistic. modified by dengyp, 2006-03-02
    NS::NASCollector->tuneRRDFile(NS::ConstInfo->getNetworkIO(),"$interfaceName.$vid");
    $exitCode = system("$cmd_nv_vlan add $interfaceName $vid >& /dev/null" )/256;        
}
if($exitCode != 0){
     $comm->writeErrMsg($nic_common->CMD_ERROR,__FILE__,__LINE__+1,"nv_vlan_$exitCode"); 
     exit 1;
} 

exit 0;