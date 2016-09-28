#!/usr/bin/perl -w
#
#       Copyright (c) 2009 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: snap_getArea.pl,v 1.1 2009/01/13 11:31:40 xingyh Exp $"

use strict;
use POSIX;

if(scalar(@ARGV) != 1){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}

my $mp = shift;

my $limitArea = "100";
my $usedArea  = "0";
    
## get limit and used of snapshot area
my $cmd_snapshot = "/usr/sbin/sxfs_snapshot"; 

##reference VolumeCommon.pm->getSnapshot() and volume_list.pl
my @retArr = `${cmd_snapshot} -P ${mp} 2>/dev/null`;
if ($? == 0) {
	foreach (@retArr) {
	    if ($_ =~ /^\s*limit\s+(\d+)\%\s+\S+\s*$/) {
	        $limitArea = $1;
	    }
	    if ($_ =~ /^\s*used\s+(\d+)\%\s+\S+\s*$/) {
	        $usedArea = $1;
	    }        
	}
}
$limitArea = &get_area_4_GUI($limitArea);
print "limitArea=$limitArea\n";
print "usedArea=$usedArea\n";
exit(0);

sub get_area_4_GUI() {
    my $snapshot=shift;
	if ( $snapshot == 0) {
		$snapshot = 100;	
	} else {
		$snapshot = (POSIX::ceil($snapshot / 10)) * 10;
	}
    return $snapshot;
}