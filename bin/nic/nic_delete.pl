#!/usr/bin/perl
#
#       Copyright (c) 2005-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
# "@(#) $Id: nic_delete.pl,v 1.7 2007/08/29 00:51:57 fengmh Exp $"
#
#Function:
		#The command to operate the interface delete function
#Output:
		#None
#Parameters: 
		#InterfaceName: the interface name of the interface to be deleted.
#Returns:
		#0: successful
		#1: failed
		
use strict;
use constant ERRCODE_ARGUMENT                             => "0x18A00016";
use constant ERRCODE_INTERFACE_CANNOTDELETE_NOTEXIST      => "0x18A00017";
use constant ERRCODE_INTERFACE_CANNOTDELETE_IPNULL        => "0x18A00018";

use NS::NsguiCommon;
use NS::NicCommon;
my $nsgui_common = new NS::NsguiCommon;
my $nic_common = new NS::NicCommon;
     
#get the params
if(scalar(@ARGV) == 0) {
		$nsgui_common->writeErrMsg(ERRCODE_ARGUMENT,__FILE__,__LINE__+1); 
    exit 1;
}

my $interface = shift;
my $ex = shift;
my $tmpInterface = $interface;

if($interface =~ /^(\S+):\d{3,}$/) {
    $tmpInterface = $1;
}
my $interfaceInfo = $nic_common->getInterfaces("-dev",$tmpInterface);
if(defined($interfaceInfo)){	
    my @tmpArray = @$interfaceInfo;
    my $targetInterfaceInfo = "";
    foreach my $info (@tmpArray) {
        if($info =~ /^\Q$interface\E\s+/) {
            $targetInterfaceInfo = $info;
        }
    }
    if($targetInterfaceInfo eq ""){
        $nsgui_common->writeErrMsg(ERRCODE_INTERFACE_CANNOTDELETE_NOTEXIST,__FILE__,__LINE__+1);
        exit 1;
    }else{
        if( $targetInterfaceInfo =~ /^$interface\s+\S+\s+\-\-\s+\S+\s+\S+\s+\S+\s*/ && $ex ne "-ex"){
            $nsgui_common->writeErrMsg(ERRCODE_INTERFACE_CANNOTDELETE_IPNULL,__FILE__,__LINE__+1);
            exit 1;
        }
    }
}else{
    $nsgui_common->writeErrMsg(ERRCODE_INTERFACE_CANNOTDELETE_NOTEXIST,__FILE__,__LINE__+1);
    exit 1;
}

#execute the delete command
my $rtval = 0;
my $commandCode = "";
if( $interface =~ /\./ && $ex eq "-ex"){
		my $cmd_nv_vlan = $nic_common->CMD_NV_VLAN;		
	  $rtval = system("$cmd_nv_vlan rem $interface >& /dev/null")/256;
	  $commandCode = "nv_vlan_$rtval";
}elsif($interface =~ /^bond/ && $ex eq "-ex"){
		my $cmd_nv_bond = $nic_common->CMD_NV_BOND;		
	  $rtval = system("$cmd_nv_bond  release $interface >& /dev/null")/256;
	  $commandCode = "nv_bond_$rtval";
}else{
		my $cmd_nv_ifconfig = $nic_common->CMD_NV_IFCONFIG;		
		$rtval = system("$cmd_nv_ifconfig $interface del >& /dev/null")/256;
		$commandCode = "nv_ifconfig_$rtval";
}
if($rtval != 0){
     $nsgui_common->writeErrMsg($nic_common->CMD_ERROR,__FILE__,__LINE__+1,$commandCode); 
     exit 1;
} 
exit 0;