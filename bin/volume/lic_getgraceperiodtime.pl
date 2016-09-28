#!/usr/bin/perl -w
#       Copyright (c) 2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: lic_getgraceperiodtime.pl,v 1.2 2007/07/10 10:37:45 liy Exp $"

#Function: 
    #output the grace period start time and end time in format
#Arguments: 
    #none
#exit code:
    #0:succeed 
    #2:time out parameter wrong 
#Usage:
#	lic_getgraceperiodtime.pl
#Output
#   Start time = 2007/8/15 10:49:21
#   End   time = 2007/8/15 10:49:21
#when cannot get 
#   Start time = --
#   End   time = --
#user:root,nsgui
use strict;
use NS::LicenseCommon;
use Getopt::Long;

my $licenseCommon = new NS::LicenseCommon;
my $startTimeStr = "--";
my $endTimeStr = "--";

my %optHash;
## get ARGS
if(!GetOptions(\%optHash,"t=s")){
    exit 2;
}
my $timeout = $optHash{'t'};
if(defined($timeout) && $timeout !~ /^\d+$/){
    exit 2;	
}

my ($startTime, $endTime) = $licenseCommon->getStartTimeAndEndTime($timeout);

if($startTime ne "--"){
	$startTimeStr = $licenseCommon->formatTimeShown($startTime);
    $endTimeStr = $licenseCommon->formatTimeShown($endTime);
}

print "Start time = $startTimeStr\n";
print "End   time = $endTimeStr\n";
exit 0;