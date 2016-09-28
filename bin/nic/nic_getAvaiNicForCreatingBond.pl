#!/usr/bin/perl
#
#       Copyright (c) 2005-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
# "@(#) $Id: nic_getAvaiNicForCreatingBond.pl,v 1.1 2005/08/29 04:41:26 changhs Exp"
#
#Function
		#to get the available IFs' information for creating a bond.
#Output:
		#	Output example
        #	ge2061,192.168.245.1
        #  	ge2060,--

#Parameters: none
#Returns:
    #0:successful
    #1:failure

use strict;
use constant ERRCODE_INTERFACES_CANNOTGET        => "0x18A00013";
use NS::NicCommon;
use NS::NsguiCommon;

my $nic_common = new NS::NicCommon;
my $nsgui_common = new NS::NsguiCommon;

#get the interface names.
my $nicInfo = $nic_common->getInterfaces("-s");
if(!defined($nicInfo)){
    $nsgui_common->writeErrMsg(ERRCODE_INTERFACES_CANNOTGET, __FILE__, __LINE__+1);
    exit 1;
}

my %availableIFs;
my @vlanSetIFs;

foreach(@$nicInfo){
	if(/^(\S+)\s+\S+\s+(\S+)\s+\S+\s+\S+\s+\S+\s*/){
		my $interface = $1;
    	my $ip = $2;
		if($interface =~ /^bond([0-9]+)/){
			next;#the bonding IF
		}elsif($interface =~ /(.+)\./){
			push(@vlanSetIFs, $1);#the vlan
		}elsif($interface =~ /\w+:\d{3,}/) {
		    next;#the alias
		}else{
			#the interface is such as ge18000
			$ip =~ s/\/[0-9]+$//;
			$availableIFs{$interface}=$ip;
		}
	}
}

foreach(@vlanSetIFs){
    if(defined($availableIFs{$_})){
        delete($availableIFs{$_});
    }
}

my @ifs = keys(%availableIFs);
my @toe;
my $nic;
if(scalar(@ifs) > 0){
    sort(@ifs);
    my $interfaceNames = $nic_common->getNicNames("-a");
    if(defined($interfaceNames)) {
        foreach $nic (@ifs){
            my $hasSetAlias = $nic_common->hasAlias($nic, $interfaceNames);
            if($hasSetAlias ne "yes") {
                if($nic =~ /^te/) {
                    push(@toe, "$nic,$availableIFs{$nic},\n");
                } else {
                    print "$nic,",$availableIFs{$nic},"\n";
                }
            }
        }
        if (scalar(@toe) > 1) {
            print @toe;
        }
    } else {
        foreach $nic (@ifs){
            if($nic =~ /^te/) {
                push(@toe, "$nic,$availableIFs{$nic},\n");
            } else {
                print "$nic,",$availableIFs{$nic},"\n";
            }
        }
        if (scalar(@toe) > 1) {
            print @toe;
        }
    } 
}

exit 0;