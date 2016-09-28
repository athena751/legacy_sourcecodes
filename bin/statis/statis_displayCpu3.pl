#!/usr/bin/perl
#
#       Copyright (c) 2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: statis_displayCpu3.pl,v 1.1 2007/09/04 02:03:03 yangxj Exp $"

use strict;
use NS::NsguiCommon;

my $nsguicommon = new NS::NsguiCommon;

my $cpu3ConfFile = "/opt/nec/nsadmin/etc/statistics/common/statis.conf";
my $checkSettingScript = "/opt/nec/nsadmin/bin/statis_getItemset.sh";

if(-f $cpu3ConfFile){
	# Don't need to check the machine type.
	my $needDisplay = `$checkSettingScript`;
	print "$needDisplay";
}else{
	# Need to check the machine type.
	my $isProcyonOrLaterMachine = $nsguicommon->isProcyonOrLater2();
	if(defined($isProcyonOrLaterMachine) && $isProcyonOrLaterMachine){
		print "no\n";
	}else{
		print "yes\n";
	}
}
exit 0;
