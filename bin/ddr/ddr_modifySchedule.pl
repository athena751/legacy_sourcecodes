#!/usr/bin/perl
#
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: ddr_modifySchedule.pl,v 1.2 2008/04/21 07:31:24 liy Exp $"

#Function:      modify schedules of the input mv and rv
#Parameters: 
#	usecase1:   ddr_modifySchedule.pl mv rv schedule
#				file --- cron file path
#				mv --- mv name
#				rv --- rv name
#               timeStr - the string that should be replaced. 
#               newTimeStr - the string that should be written. 

#Exit:          0-- successful
#               1-- failed
#               3-- specified schedule not found
#               18-- cron file reload failed
#Output:        none
use strict;
use NS::SystemFileCVS;
use NS::DdrScheduleCommon;
use NS::DdrConst;
use NS::NsguiCommon;
use NS::VolumeCommon;

my $ddrCommon = new NS::DdrScheduleCommon;
my $common = new NS::SystemFileCVS;
my $const = new NS::DdrConst;
my $nsguiCommon = new NS::NsguiCommon;
my $volumeCommon = new NS::VolumeCommon;

if(scalar(@ARGV)!= 5){
	$const->printErrMsg($const->ERR_PARAMETER_COUNT);
	exit 1;
}

my $filename = shift;
my $mv = shift;
my $rv = shift;
my $timeStr = shift;
my $newTimeStr = shift;

my $cronContent = $nsguiCommon->getFileContent($filename);
if(!defined($cronContent)){
    $const->printErrMsg($const->DDR_EXCEP_MODIFY_READCRON);
    exit 1;
}
if(!(scalar(@$cronContent)>0)){
    push(@$cronContent,"#ddr schedule begin\n");
    push(@$cronContent,"#ddr schedule end\n");
}

##write files on node0
my $size = scalar(@$cronContent);
my $modifyFlag;
##modify schedule
for(my $i=0; $i<$size; $i++){
    if($$cronContent[$i]=~/^\s*\Q$timeStr\E\s+sudo\s+\S+\s+$mv\s+$rv\s+/){
       	$$cronContent[$i]=~s/\Q$timeStr\E/$newTimeStr/;
       	##position matched
       	$modifyFlag = $i;
       	last;
    }
}
##add schedule if no match
if(!defined($modifyFlag)){
	my $addPosition;
    for(my $i=0; $i<$size; $i++){
        if($$cronContent[$i]=~/^\s*#\s*MV\s*:\s*$mv\s+RV\s*:\s*$rv\s+BEGIN/){
            $addPosition = $i+1;
            last;
        }
    }
    my $line = "$newTimeStr sudo /sbin/alternate_rpl $mv $rv -c sync -m protect 2>&1 > /dev/null";
    if($addPosition){
        splice(@$cronContent,$addPosition,0,"$line\n");
    }else{
        splice(@$cronContent,1,0,"#MV:$mv RV:$rv BEGIN\n");
        splice(@$cronContent,2,0,"$line\n");
        splice(@$cronContent,3,0,"#MV:$mv RV:$rv END\n");
    }
}

if($common->checkout($filename)!=0){
    $const->printErrMsg($const->DDR_EXCEP_MODIFY_EDITCRON);
    exit 1;    
}
if($volumeCommon->writeArrayToFile($filename,$cronContent)!= 0) {
    $common->rollback($filename);
    $const->printErrMsg($const->DDR_EXCEP_MODIFY_EDITCRON);
    exit 1;
}

if($nsguiCommon->reloadCron($ddrCommon->USERNAME_DDR, $filename) != 0) {
    $common->rollback($filename);
    $const->printErrMsg($const->DDR_EXCEP_MODIFY_RELOADCRON);
	exit 18;
}

#if cluster, write the correspond file on node1
my $friendIp = `sudo /home/nsadmin/bin/getMyFriend.sh`;
if($? != 0){
    $common->rollback($filename);
    $const->printErrMsg($const->DDR_EXCEP_MODIFY_SYNCCRON);
    exit 1;
}
chomp($friendIp);
if (defined($friendIp)&& $friendIp ne "") {
    if($ddrCommon->syncDdrCronFile($filename, $friendIp)){
        $common->rollback($filename);
    	$const->printErrMsg($const->DDR_EXCEP_MODIFY_SYNCCRON);
    	exit 1;
    }
}
#checkin file at node0 
if($common->checkin($filename)!=0){
    $common->rollback($filename);
    $const->printErrMsg($const->DDR_EXCEP_MODIFY_EDITCRON);
    exit 1;
}
exit 0;
