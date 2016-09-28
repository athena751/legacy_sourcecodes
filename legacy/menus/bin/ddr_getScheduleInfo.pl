#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: ddr_getScheduleInfo.pl,v 1.1 2004/08/24 09:47:14 wangw Exp $"

#Function:      get the time string and action info
#Parameters:    account-- the path of cron file , normally is /var/spool/cron/DDR
#               mv ------ the mv's lvm name. e.g. NV_LVM_VG0
#               rv ------ the rv's lvm name. e.g. NV_RV0_VG0
#Exit:      0--successful  1--failed
#Output:
#       * */4 * * *:replicate(sync)
#       0 0 * * *:separate
#       ... ...
use strict;
use NS::DdrScheduleCommon;
if(scalar(@ARGV)!=3){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}
my ($ddrCronFile,$mvName,$rvName) = @ARGV;
my $common = new NS::DdrScheduleCommon;
my $cronContent = $common->getDdrScheduleInfo($ddrCronFile);
if(!defined($cronContent)){
    print STDERR $common->error();
    exit 1;
}
my $result = $$cronContent{"$mvName $rvName"};
if(defined($result)){
    my $size = scalar(@$result);
    for(my $i=0; $i<$size; $i+=2){
        print "$$result[$i]:$$result[$i+1]\n";
    }
}
exit 0;
