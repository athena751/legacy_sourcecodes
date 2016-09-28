#!/usr/bin/perl
#
#       Copyright (c) 2001-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: ddr_delPairingSchedule.pl,v 1.6 2007/09/10 11:30:39 liy Exp $"

#Function:      delete all schedules of the input mv and rv
#Parameters:    account-- the path of cron file , normally is /var/spool/cron/DDR
#               job ------ the script to be started.e.g. /home/nsadmin/bin/ddr_cronjob.pl
#               mv rv ------ the mv and rv's lvm name. e.g. "NV_LVM_VG0 NV_RV0_RV1"
#Exit:          0--successful  1--failed
#Output:        none
use strict;
use NS::SystemFileCVS;
use NS::DdrScheduleCommon;
use NS::NsguiCommon;
my $filename = shift;
my $job = shift;
my @pairingString = @ARGV; 
my $ddrCommon = new NS::DdrScheduleCommon;
my $common = new NS::SystemFileCVS;
my $nsgui_common = new NS::NsguiCommon;

my $cmd_syncwrite_o = $common->COMMAND_NSGUI_SYNCWRITE_O;

if($common->checkout($filename)!=0){
    print STDERR "Failed to checkout \"$filename\". Exit in perl script:",
            __FILE__," line:",__LINE__+1,".\n";
    exit 1;    
}
my $cronContent = $ddrCommon->openFile($filename);
if(!defined($cronContent)){
    $common->rollback($filename);
    print STDERR $ddrCommon->error();
    exit 1;
}
#write files on node0
foreach(@pairingString){
    my ($mv,$rv) = split(/\s+/,$_);
    $cronContent = $ddrCommon->deleteScheduleInfo($cronContent,$mv,$rv,$job);
}
if(!open(FILE,"| ${cmd_syncwrite_o} $filename")){
    $common->rollback($filename);
    print STDERR "The $filename can not be written! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
print FILE @$cronContent;
if(!close(FILE)) {
    $common->rollback($filename);
    print STDERR "The $filename can not be written! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

$nsgui_common->reloadCron($ddrCommon->USERNAME_DDR, $filename);

#if cluster, write thie correspond file on node1
my $friendIp = `sudo /home/nsadmin/bin/getMyFriend.sh`;
if($? != 0){
    $common->rollback($filename);
    print STDERR "Failed to execute:/home/nsadmin/bin/getMyFriend.sh. Exit in perl script:"
            ,__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
chomp($friendIp);
if (defined($friendIp)&& $friendIp ne "") {
    if($ddrCommon->syncDdrCronFile($filename, $friendIp)){
        $common->rollback($filename);
        print STDERR "Failed to execute:sudo -u nsgui /usr/bin/rsh. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }
}
#checkin file at node0 
if($common->checkin($filename)!=0){
    $common->rollback($filename);
    print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
exit 0;