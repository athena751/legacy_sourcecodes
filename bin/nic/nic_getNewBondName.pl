#!/usr/bin/perl
#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
# "@(#) $Id: nic_getNewBondName.pl,v 1.1 2005/08/29 04:41:26 changhs Exp"
#
#Function
		#to get a new bondingIF name.
#Output:
		#	Output example
        #	bond9

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

#
my @existedBondsNumber = ();

foreach(@$nicInfo){
	if(/^(\S+)\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s*/){
		my $interface = $1;
		if($interface =~ /\./){
			next;#the vlan
		}elsif($interface =~ /^bond([0-9]+)\b/){
			$existedBondsNumber[$1] = "";
		}
	}
}

my $tmpMax = scalar(@existedBondsNumber);
my $i;
my $bondingIF_Name = 1;
for($i = 1; $i < $tmpMax; $i++){
	if(defined($existedBondsNumber[$i])){
		$bondingIF_Name++;
	}else{
		last;
    }
}
$bondingIF_Name = "bond".$bondingIF_Name;
print "$bondingIF_Name\n";
exit 0;