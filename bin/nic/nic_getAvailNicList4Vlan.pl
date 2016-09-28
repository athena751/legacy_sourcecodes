#!/usr/bin/perl
#
#       Copyright (c) 2005-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
# "@(#) $Id: nic_getAvailNicList4Vlan.pl,v 1.2 2007/08/23 02:54:58 fengmh Exp $"
#
#Function
		#to get all the interface names
#Output:
		#Output nicnames like the format
		#nicName1
		#nicName2
		#nicName3
  	#......
#Parameters: none  
#Returns:
		#0: successful
		#1:failure

use strict;
use constant ERRCODE_NICNAMES_CANNOTGET             => "0x18A00022";
use NS::NicCommon;
use NS::NsguiCommon;

my $nic_common = new NS::NicCommon;
my $nsgui_common = new NS::NsguiCommon;

#get the interface names.
my $nicName = $nic_common->getNicNames("-ex");
if(!defined($nicName)){
		$nsgui_common->writeErrMsg(ERRCODE_NICNAMES_CANNOTGET,__FILE__,__LINE__+1);
		exit 1;
}
my @nicNames = @$nicName;
my $interfaceNames = $nic_common->getNicNames("-a");
if(defined($interfaceNames)) {
    foreach my $nic (@nicNames){
        chomp($nic);
        my $hasSetAlias = $nic_common->hasAlias($nic, $interfaceNames);
        if($hasSetAlias ne "yes") {
            print "$nic\n";
        }
    }
} else {
    print @nicNames;
}

exit 0;