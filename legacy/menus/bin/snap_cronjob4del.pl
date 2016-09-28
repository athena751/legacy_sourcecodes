#!/usr/bin/perl
#
#       Copyright (c) 2001-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: snap_cronjob4del.pl,v 1.7 2007/07/13 07:51:47 liy Exp $"

#    Function: delete the snapshot if the generation of exist snapshot which created by the schedule
#              is over the reserve generation.
#
#    Parameter:
#              mp : mount point name or device path
#              schedulename : snapshot schedule name
#              reservegeneration : reserve generation of snapshot
#
#    Return value:
#           0 : succeed
#           1 : faild
use strict;

if(scalar(@ARGV)!=3){
    ##print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}

my $mp = shift;
my $schedulename = shift;
my $reservegeneration = shift;
my $devname = $mp;

my @mpContent    = `/bin/mount 2>/dev/null`;
my $findFlag    = 1;

if($mp =~ /^\/dev\//){
	#need to get mount point name according the devname
	foreach(@mpContent){
	    if($_=~/^\s*$devname\s+on\s+(\S+)/){
	        $findFlag = 0;
	        $mp = $1;
	        last;
	    }
	}
}else {
	foreach(@mpContent){
	    if($_=~/\s+on\s+\Q$mp\E\s+/){
	        $findFlag = 0;
	        last;
	    }
	}
}
if($findFlag){
    exit 0;
}

#get the mp's snapshot which is created by the schedule
#uuu                              2006/11/08 11:35:24    active
my @tmpsnap=`/usr/sbin/sxfs_snapshot $mp 2>/dev/null`;  
my @snap;
foreach (@tmpsnap){
    if ($_=~/^\s*(\Q${schedulename}\E\d{12}\.CR)\s+\S+\s+\S+\s+active\s*$/){
            push(@snap,$1);
        }
}
my $deletesuccessflat = 0;
my $snapgeneration=scalar(@snap);
my $deletegeneration=$snapgeneration-$reservegeneration;
for (my $i=0;$i<$deletegeneration;$i++){
    if(system("/usr/sbin/sxfs_snapshot -d -n $snap[$i] $mp 2>/dev/null 1>&2")!=0){
        ##print STDERR "Failed to execute \"/usr/sbin/sxfs_snapshot -d -n $snap[i] $mp". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        $deletesuccessflat = 1;    
    }
}
if ($deletesuccessflat){exit 1;}
exit 0;