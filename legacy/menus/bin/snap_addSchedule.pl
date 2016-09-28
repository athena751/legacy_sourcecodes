#!/usr/bin/perl -w
#
#       Copyright (c) 2001-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: snap_addSchedule.pl,v 1.2309 2008/05/28 03:28:15 liy Exp $"


use strict;
use NS::CodeConvert;
use NS::SystemFileCVS;
use NS::NsguiCommon;
#check number of the argument,if it isn't 5,exit
if(scalar(@ARGV)!=5){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}
my $cc=new NS::CodeConvert();
my $cvs = new NS::SystemFileCVS;
my $nsgui_common = new NS::NsguiCommon;
my $filename=shift;
my $schedulehead=shift;
my $mountpoint=shift;
my $devname=shift;#2003/07/14 add by maojb , xinghui
my $schedulebottom=shift;

my $cmd_syncwrite_o = $cvs->COMMAND_NSGUI_SYNCWRITE_O;
my $cmd_syncwrite_a = $cvs->COMMAND_NSGUI_SYNCWRITE_A;

$mountpoint=$cc->hex2str($mountpoint);
#my $schedule=$schedulehead.$mountpoint.$schedulebottom;
my $schedule=$schedulehead.$devname.$schedulebottom;#2003/07/14 add by maojb , xinghui

# open $filename and append $schedule to it
if(!(-f $filename)){
    if(!open(FILE,"| ${cmd_syncwrite_o} $filename"))
    {
        print STDERR "The $filename can not be written! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }
    print FILE "#/bin/sh\n";
    print FILE "SHELL=/bin/bash\n";
    if(!close(FILE)) {
        print STDERR "The $filename can not be written! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;    
    }
}

if(!open(FILE,"$filename"))
{
    print STDERR "The $filename can not be opened! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;    
}
my @content = <FILE>;
close(FILE);

$schedulebottom =~ /^\s*(\S+)\s+\d+\s*$/;
my $schName = $1;
my $tmpSchName = $schName;
$schedulehead=~/^\s*(\S+\s+\S+\s+\S+\s+\S+\s+\S+)\s+sudo\s+/;
my $schTime = $1;
my $schTimeExist = 0;

my $snapCronjob = "/home/nsadmin/bin/snap_cronjob.pl";

#loop for file content and check the schedule's name and time whether exists
foreach(@content){
    if(/^\s*#/){
        next;
    }
    if(/\s+(\Q$snapCronjob\E)\s+(\Q$mountpoint\E|$devname)\s+\Q${tmpSchName}\E\s+/){
        exit 5;
    }
    
    if(/^\s*\Q$schTime\E\s+sudo\s+($snapCronjob)\s+(\Q$mountpoint\E|$devname)\s+/){
        print "$schName\n";
        exit 0;
    }
}
# check the time of schedule whether exists
# add schedule time to file
if(!open(FILE,"| ${cmd_syncwrite_o} $filename")){
    print STDERR "The $filename can not be written! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

my $delSnapCronjob = "/home/nsadmin/bin/snap_cronjob4del.pl";

#replace the schedule if $tmpSchName exists
foreach(@content){
    if (/\s+(\Q$delSnapCronjob\E)\s+(\Q$mountpoint\E|$devname)\s+\Q${tmpSchName}\E\s+/){
    	next;
    } else {
    	print FILE $_;
    }
}
print FILE $schedule."\n";
if(!close(FILE)){
    print STDERR "The $filename can not be written! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

my $ret = $nsgui_common->reloadCron("snapshot", $filename);
if($ret != 0) {
    print STDERR "Failed to execute:/usr/bin/crontab. Exit in perl script:"
            ,__FILE__," line:",__LINE__+1,".\n";
    exit 18;	
}
exit 0;