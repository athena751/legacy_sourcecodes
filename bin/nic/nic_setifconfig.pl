#!/usr/bin/perl -w
#      copyright (c) 2005-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: nic_setifconfig.pl,v 1.9 2007/09/05 03:07:31 fengmh Exp $"
#
#Function:
    #Set interface IP,netmask,gateway,MTU;
#Arguments:
    #$interfaceName     : interface name
    #$IPAndmask         : IP Address/netmask as int
    #$gateway           : the gateway(can be empty)
    #$MTU               : mtu
#exit code:
    #0:succeed
    #1:failed
#output:
    #null

use strict;

use NS::NsguiCommon;
use NS::NicCommon;
my $comm  = new NS::NsguiCommon;
my $nic_common = new NS::NicCommon;

if(scalar(@ARGV) == 0||(scalar(@ARGV) == 1 && $ARGV[0] eq "--help") || scalar(@ARGV) != 4) {
    print "Usage:nic_setifconfig.pl INTERFACENAME IPADDRESS/NETMASK [GATEWAY] MTU\nSet the IP Address,netmask,gateway,mtu of the interface.\n";
    exit 1;
}

my $interfaceName = $ARGV[0];
my $IPAndMask = $ARGV[1];
my $gateway = $ARGV[2];
my $MTU = $ARGV[3];
my $vlanParentMTU = "";
my $command =$nic_common->CMD_NV_IFCONFIG;
my $cmd;
my $exitCode = 0;
my $nicName;
my $alias;

if ($interfaceName =~/^\s*(\S+)\:(\d{3,})\s*$/) {
    $nicName = $1;
    $alias = $2;
    if($gateway eq "") {
        $cmd = "$command $nicName $IPAndMask gw none alias $alias >& /dev/null";
    }elsif($gateway ne "") {
        $cmd = "$command $nicName $IPAndMask gw $gateway alias $alias >& /dev/null";
    }
}else{
    if($gateway eq "") {
        $cmd = "$command $interfaceName $IPAndMask gw none mtu $MTU >& /dev/null";
    }elsif($gateway ne "") {
        $cmd = "$command $interfaceName $IPAndMask gw $gateway mtu $MTU >& /dev/null";
    }
}
$exitCode = system($cmd)/256;
if($exitCode != 0){
     $comm->writeErrMsg($nic_common->CMD_ERROR,__FILE__,__LINE__+1,"nv_ifconfig_$exitCode");
     exit 1;
}
exit 0;
