#!/usr/bin/perl
#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
# "@(#) $Id: nic_getnicnames.pl,v 1.2 2005/09/26 02:48:59 dengyp Exp $"
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
use constant ERRCODE_NICNAMES_CANNOTGET             => "0x18A00021";
use NS::NicCommon;
use NS::NsguiCommon;

my $nic_common = new NS::NicCommon;
my $nsgui_common = new NS::NsguiCommon;

#get the interface names.
my $nicName = $nic_common->getNicNames();
if(!defined($nicName)){
		$nsgui_common->writeErrMsg(ERRCODE_NICNAMES_CANNOTGET,__FILE__,__LINE__+1);
		exit 1;
}
my @nicNames = @$nicName;
print @nicNames;

exit 0;