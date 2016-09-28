#!/usr/bin/perl
#       copyright (c) 2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: snmp_getMaxCommunityNum.pl,v 1.1 2007/09/10 01:29:04 yangxj Exp $"

# function:
#       get the max number of community that permit to be created 
# Parameters:
#       none
# output:
#       the max community number:
#           the newer machine -> 8
#           the older machine -> 50
#

use strict;
use NS::NsguiCommon;

my $scriptGetMaxNum = "/opt/nec/nsadmin/bin/snmp_getConfig.sh";

my $nsguicommon = new NS::NsguiCommon;
my $isProcyonOrLaterMachine = $nsguicommon->isProcyonOrLater2();
if(defined($isProcyonOrLaterMachine) && $isProcyonOrLaterMachine){
	# read the conf file
	my $maxNum = `$scriptGetMaxNum`;
	print "$maxNum";
}else{
	print "50\n";
}
exit 0;