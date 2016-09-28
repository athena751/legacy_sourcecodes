#!/usr/bin/perl
#
#       Copyright (c) 2001-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: ddr_delScheduleInfo.pl,v 1.6 2007/09/10 11:32:09 liy Exp $"

#Function:      delete all schedules of the input mv and rv
#Parameters:    account - the path of cron file , normally is /var/spool/cron/DDR
#               mv ------ the mv's lvm name. e.g. NV_LVM_VG0
#               rv ------ the rv's lvm name. e.g. NV_RV0_VG0
#				job ------ the script to be started.e.g. /home/nsadmin/bin/ddr_cronjob.pl
#               schstring - the string that should be written. e.g. "* */3 * * *"
#Exit:          0-- successful  
#               1-- failed
#Output:        none
use strict;
use NS::SystemFileCVS;
use NS::DdrScheduleCommon;
use NS::NsguiCommon;
if(scalar(@ARGV)!=5){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}
my ($filename,$mv,$rv,$job,$timeStr) = @ARGV; 
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
my $deletedContent = $ddrCommon->deleteScheduleInfo($cronContent,$mv,$rv,$job,$timeStr);
if(!open(FILE, "| ${cmd_syncwrite_o} $filename")){
    $common->rollback($filename);
    print STDERR "The $filename can not be written! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
print FILE @$deletedContent;
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