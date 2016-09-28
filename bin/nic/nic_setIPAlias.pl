#!/usr/bin/perl
#
#       Copyright (c) 2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#
#       license agreement with NEC Corporation.
#
# "@(#) $Id: nic_setIPAlias.pl,v 1.1 2007/08/29 04:41:26 wanghb Exp"
#
#Function
#    set and modify IP alias.
#Parameters:
#    nicName
#    ipAddress
#    gateway
#    alias
#Returns:
#    0:succeed
#    1:failed
#Output:
#    null

use strict;
use constant ERRCODE_INTERFACES_CANNOTGET            => "0x18A00013";
use constant ERRCODE_ARGUMENT                        => "0x18A00016";
use constant ERRCODE_CANNOT_SET_SAME_ALIAS           => "0x18A00037";
use constant ERRCODE_ALIASNUM_OVER_TOTAL             => "0x18A00038";

use NS::NsguiCommon;
use NS::NicCommon;
my $nsgui_common  = new NS::NsguiCommon;
my $nic_common = new NS::NicCommon;

if (scalar(@ARGV) != 4) {
    $nsgui_common->writeErrMsg(ERRCODE_ARGUMENT,__FILE__,__LINE__+1);
    exit 1;
}

my $nicName = shift;
my $ipAddress = shift;
my $gateway = shift;
my $alias = shift;

my $result = $nic_common->checkIPAlias4Set();
if($result != 0){
    $nsgui_common->writeErrMsg(ERRCODE_ALIASNUM_OVER_TOTAL, __FILE__, __LINE__+1);
    exit 1;
}

my $nicInfo = $nic_common->getInterfaces("-s");
if(!defined($nicInfo)){
    $nsgui_common->writeErrMsg(ERRCODE_INTERFACES_CANNOTGET, __FILE__, __LINE__+1);
    exit 1;
}
foreach(@$nicInfo){
    if(/^\s*\Q$nicName\E\:\Q$alias\E\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s*/){
        $nsgui_common->writeErrMsg(ERRCODE_CANNOT_SET_SAME_ALIAS, __FILE__, __LINE__+1);
        exit 1;
    }
}

my $cmd_nv_ifconfig =$nic_common->CMD_NV_IFCONFIG;
my $cmd;
if($gateway eq "") {
    $cmd = "$cmd_nv_ifconfig $nicName $ipAddress alias $alias >& /dev/null";
}elsif($gateway ne "") {
    $cmd = "$cmd_nv_ifconfig $nicName $ipAddress gw $gateway alias $alias >& /dev/null";
}
my $exitCode = system($cmd)/256;
if($exitCode != 0){
     $nsgui_common->writeErrMsg($nic_common->CMD_ERROR,__FILE__,__LINE__+1,"nv_ifconfig_$exitCode");
     exit 1;
}

exit 0;