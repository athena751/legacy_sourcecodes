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
# "@(#) $Id: nic_getNic4IPAlias.pl,v 1.1 2007/08/29 04:41:26 wanghb Exp"
#
#Function
#    get all available I/Fs for setting IP alias.
#Parameters: none
#Returns:
#    0:succeed
#    1:failed
#Output:
#    Output the interface lists like the format:
#    Interface,ip/netmask

use strict;
use constant ERRCODE_INTERFACES_CANNOTGET        => "0x18A00013";
use constant ERRCODE_ALIASNUM_OVER_TOTAL         => "0x18A00038";
use NS::NicCommon;
use NS::NsguiCommon;

my $nic_common = new NS::NicCommon;
my $nsgui_common = new NS::NsguiCommon;

my $result = $nic_common->checkIPAlias4Set();
if($result != 0){
    $nsgui_common->writeErrMsg(ERRCODE_ALIASNUM_OVER_TOTAL, __FILE__, __LINE__+1);
    exit 1;
}

#get the interface names.
my $nicInfo = $nic_common->getInterfaces("-s");
if(!defined($nicInfo)){
    $nsgui_common->writeErrMsg(ERRCODE_INTERFACES_CANNOTGET, __FILE__, __LINE__+1);
    exit 1;
}

my @outputArray;
my $interface = "";
my $ip = "";
my $alias = "";
my $resultString;

foreach(@$nicInfo){
    if(/^(\S+)\s+\S+\s+(\S+)\s+\S+\s+\S+\s+\S+\s*/){
        $interface = $1;
        $ip = $2;
        if($interface =~/^\S+\:\d+$/ || $ip =~/^--$/){
            next;
        }else{
        	$alias = $nic_common->getNewAliasID($interface,$nicInfo);
            $resultString = $interface.",".$ip.",".$alias."\n";
            push(@outputArray,$resultString);
        }
    }
}
print @outputArray;
exit 0;
