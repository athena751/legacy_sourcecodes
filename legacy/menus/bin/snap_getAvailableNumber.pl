#!/usr/bin/perl
#
#       Copyright (c) 2005-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: snap_getAvailableNumber.pl,v 1.2306 2008/07/01 07:21:53 liy Exp $"

use strict;
use NS::CodeConvert;
#check number of the argument,if it isn't 2,exit 1
if(scalar(@ARGV)!=2 && scalar(@ARGV)!=3){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}
my $cc    = new NS::CodeConvert();
my $mp    = shift;
$mp        = $cc->hex2str($mp);

my $devname = shift;
my $printDetail = shift;
my $availableNumber = 255;
my $noAutoSnapNumber = 0;

#add by maojb on 2003/07/18 
my @scheduleNameInCrontab = (); #all schedule names of crontab
my @scheduleInCrontabNumber = (); # all schedule occur times in snapshot lists
my @scheduleInCrontabGenerations = (); # all schedule generations

# all schedules which have been deleted , but exist in snapshotlist
my @scheduleNameOutCrontab = ();
my @scheduleOutCrontabNumber = (); 

my $scheduleName;

my @snapshotCreated = `/usr/sbin/sxfs_snapshot $mp`;
my $snapListReturnValue = $?;
@snapshotCreated=grep(/^\s*\S+\s+\S+\s+\S+\s+\Qactive\E\s*/,@snapshotCreated);

my @cronContain = `/usr/bin/crontab -l -u snapshot`;
my $cronListReturnValue = $?;


if($cronListReturnValue == 0){ #file /var/spool/cron/snapshot exists
    foreach(@cronContain){
        if(/^\s*#/){
            next;
        }
        ###### modify by lil at 0805(MVDSync add $cronCmd, mod if(regx)) begin ######
        my $cronCmd = "/home/nsadmin/bin/snap_cronjob.pl";
        if(/\s+(?:\Q$cronCmd\E)\s+(\Q$mp\E|$devname)\s+(\S+)\s+(\d+)\s*$/){
        ###### modify by lil at 0805(MVDSync add $cronCmd, mod if(regx)) end ###### 
            push(@scheduleNameInCrontab,$2);
            push(@scheduleInCrontabGenerations,$3);
            push(@scheduleInCrontabNumber,0);
        }
    }
}

if($snapListReturnValue == 0){#there is snapshot under the mount point
    foreach(@snapshotCreated){
        if(/^\s*(.+)\d{12}\.CR\s+/){
            #this snap created automatically
            my $scheduleName = $1;

            my $findInCrontab = 0;
            for(my $i = 0 ; $i < @scheduleNameInCrontab; $i++) {
                if ($scheduleName eq $scheduleNameInCrontab[$i]){
                    $findInCrontab = 1;
                    $scheduleInCrontabNumber[$i]++;
                    last;
                }
            }            
            
            my $findOutCrontab = 0;
            if(!$findInCrontab) {
                $noAutoSnapNumber++;
                for (my $i = 0 ; $i < @scheduleNameOutCrontab; $i++) {
                    if ($scheduleName eq $scheduleNameOutCrontab[$i]) {
                        $findOutCrontab = 1;
                        $scheduleOutCrontabNumber[$i]++;
                        last;
                    }
                }
                if (!$findOutCrontab) {
                    push(@scheduleNameOutCrontab , $scheduleName);
                    push(@scheduleOutCrontabNumber , 1);
                }
            } 
        }else{
            $noAutoSnapNumber++;
        }
    }
}

my $autoSnapNumber = 0;
for (my $i = 0 ; $i < @scheduleNameInCrontab; $i++) {
    if ($scheduleInCrontabNumber[$i] >= $scheduleInCrontabGenerations[$i]) {
        $autoSnapNumber += $scheduleInCrontabNumber[$i];
    } else {
        $autoSnapNumber += $scheduleInCrontabGenerations[$i];
    }
}

$availableNumber = $availableNumber - $noAutoSnapNumber - $autoSnapNumber;

print "$availableNumber\n";
if (defined($printDetail)) {
    for (my $i = 0 ; $i < @scheduleNameOutCrontab ; $i++) {
	    my $availableNumberOfSchedule = $availableNumber + $scheduleOutCrontabNumber[$i];
        print "$scheduleNameOutCrontab[$i]:$availableNumberOfSchedule\n";
    }
} 

exit 0;
