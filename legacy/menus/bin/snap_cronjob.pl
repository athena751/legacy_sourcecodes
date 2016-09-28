#!/usr/bin/perl
#
#       Copyright (c) 2001-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: snap_cronjob.pl,v 1.2304 2007/07/13 07:51:39 liy Exp $"

use strict;

#check number of the argument(mountpoint,schedulename,generation),if it isn't 3,exit
if(scalar(@ARGV)!=3){
    ##print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}

my $mountPoint    = shift;
my @mpContent    = `/bin/mount 2>/dev/null`;
my $findFlag    = 1;

if($mountPoint =~ /^\/dev\//){
	my $devname = $mountPoint;
	#need to get mount point name according the devname
	foreach(@mpContent){
	    if($_=~/^\s*$devname\s+on\s+(\S+)/){
	        $findFlag = 0;
	        $mountPoint = $1;
	        last;
	    }
	}
}
else {
	foreach(@mpContent){
	    if($_=~/\s+on\s+\Q$mountPoint\E\s+/){
	        $findFlag = 0;
	        last;
	    }
	}
}
if($findFlag){
    exit 0;
}
my $scheduleName=shift;
my $generation=shift;
#snapname= schedulename + system time ( YYYYMMDDHHmm) 
my ($min,$hour,$day,$month,$year)=(localtime)[1..5];
$year=$year+1900;
$month=$month+1;
$month=changeFormat($month);
$day=changeFormat($day);
$hour=changeFormat($hour);
$min=changeFormat($min);
my $snapName = $scheduleName.$year.$month.$day.$hour.$min.".CR";

# some commands
my $createSnap_CMD="/usr/sbin/sxfs_snapshot -c -n $snapName $mountPoint 2>/dev/null 1>&2";
my $listMountPoint_CMD="/usr/sbin/sxfs_snapshot $mountPoint 2>/dev/null";

if(system($createSnap_CMD)!=0){
    ##print STDERR "Failed to execute \"$createSnap_CMD\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit(1);
}
my @allmpList=`$listMountPoint_CMD`;
#my @mpList=grep(/^\s*${scheduleName}.*\.CR\s+/,@allmpList);
 my @mpList=grep(/^\s*\Q${scheduleName}\E\d{12}\.CR\s+\S+\s+\S+\s+active\s*/,@allmpList);

my $leftNumber = @mpList-$generation;
for (my $i=0; $i<$leftNumber; $i++){
    my @tmpList=split(/\s+/,$mpList[$i]);
    if(system("/usr/sbin/sxfs_snapshot -d -n $tmpList[0] $mountPoint >&/dev/null &")!=0){
        ##print STDERR "Failed to execute \"/usr/sbin/sxfs_snapshot -d -n $tmpList[0] $mountPoint &\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit(1);
    }
}

sub changeFormat(){
    my $tmp=shift;
    my @list=split("",$tmp);
    if(scalar(@list)==1){
        $tmp="0".$tmp;
    }
    return $tmp;
}
exit(0);