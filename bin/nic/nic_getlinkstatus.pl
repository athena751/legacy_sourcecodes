#!/usr/bin/perl
#copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: nic_getlinkstatus.pl,v 1.4 2005/10/24 01:32:55 dengyp Exp $"
#
#Function:
    #get linkstatus,ifstatus,autoNego,communicationstatus,macaddress and active
#Arguments:
    #$interfaceName     : interface name
#exit code:
    #0:succeed
    #1:failed
#output:
    #$nicName                           : nic name
    #$linkStatus                        : link status(UP/DOWN)
    #$autoNego                          : auto negotiation or not(disable/enable)
    #$speed                                     : communication speed(10M/100M/1G/Unknown)
    #$duplex                            : duplex(full-Duplex/half-Duplex/Unknown)
    #$ifstatus                          : work status(UP/DOWN)
    #macaddress                         : the subcard's macaddress
    #active                             : if the interface is "AB" bonding interface, so show the subcard's active status or not. 
#STDERR:
        #0x18A00009                     :exec nv_ifconfig error

use strict;
use NS::NicCommon;
use constant ERRCODE_EXECCMD_ERROR              => "0x18A00009";

use NS::NsguiCommon;
my $comm  = new NS::NsguiCommon;

if(scalar(@ARGV) == 0||(scalar(@ARGV) == 1 && $ARGV[0] eq "--help")||scalar(@ARGV) != 1) {
    print "`basename $0` <dev>\nList the linkstatus of the interface\n";
    exit 1;
}

my $nic_common = new NS::NicCommon;
my $interfaceName = $ARGV[0];
my $nv_ifconfig = $nic_common->CMD_NV_IFCONFIG;

#get network interface card name
$interfaceName =~ s/:\w*$//;
$interfaceName =~ s/\.\w*$//;

my $interfaceConstruct = $nic_common->getBonds();
if(!defined($interfaceConstruct)){
    $comm->writeErrMsg(ERRCODE_EXECCMD_ERROR,__FILE__,__LINE__+1);
    exit 1;
}

my %interfaceConstructHash = %$interfaceConstruct;

my @nicNames = ();
my @macAddresses = ();
my @active = ();
if(defined($interfaceConstructHash{$interfaceName})) {
    my @tmp = split(/\s+/,$interfaceConstructHash{$interfaceName});
    @nicNames = split(/,/,$tmp[0]);
    @macAddresses = split(/,/,$tmp[1]);
    my $tmpActive = $tmp[4];
    @active = @nicNames;
    foreach (@active){
        if($_ eq $tmpActive){
            $_ = "UP";                
        }else{
            $_ = "--";               
        }            
    }
} else {
    $nicNames[0] = $interfaceName;
    $macAddresses[0] = "--";    
    $active[0] = "--";
}

print "      Interface  status  AutoNego    Speed         Duplex  Ifstatus          macAddress  Active\n";
my $i = 0;
foreach (@nicNames) {
        my $tmpNicName = $_;
        my @ifInfo = `$nv_ifconfig $tmpNicName 2> /dev/null | grep -v "^[[:space:]]*\$"`;
        if($? != 0) {
            $comm->writeErrMsg(ERRCODE_EXECCMD_ERROR,__FILE__,__LINE__+1);
            exit 1;
        }
        my $tmpIfStatus = "DOWN";
        if($ifInfo[0] =~ /\bUP\b/) {
           $tmpIfStatus = "UP";
        } 
        
        # Format : Speed Duplex Auto-negotiation LinkStatus
        my $linkStatus = $nic_common->getLinkInfo($_);
        
        if(!defined($linkStatus)){
             $comm->writeErrMsg(ERRCODE_EXECCMD_ERROR,__FILE__,__LINE__+1);
             exit 1;
        }
        $linkStatus =~ s/b\/s//;
		my @temp = split(/\s+/,$linkStatus);

        my $output = sprintf("%15s %7s %9s %8s %14s %9s %19s %7s",$tmpNicName,$temp[3],$temp[2],$temp[0],$temp[1],$tmpIfStatus,$macAddresses[$i],$active[$i]);
        print "$output\n";
        $i = $i +1;
}
exit 0;