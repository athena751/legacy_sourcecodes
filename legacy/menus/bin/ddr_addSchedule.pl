#!/usr/bin/perl
#
#       Copyright (c) 2001-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: ddr_addSchedule.pl,v 1.8 2007/09/05 06:38:03 liy Exp $"

#Function:      add schedules of the input mv and rv
#Parameters: 
#	usecase1:   ddr_addSchedule.pl@-s cronfile [schedule]c
#				cronfile --- the path of cron file , normally is /var/spool/cron/DDR
#               schedule - the string that should be written. 
# 			e.g. "* */3 * * * sudo /home/nsadmin/bin/ddr_cronjob.pl NV_LVM_VG0 NV_RV0_VG0 separate 2>&1 > /dev/null"
#   usecase2:   ddr_addSchedule.pl@cronfile tmpfile
#				cronfile --- the path of cron file , normally is /var/spool/cron/DDR
#               tmpfile - the temp file that schedules should be written.
#Exit:          0-- successful  
#               1-- failed
#               2-- input time has been used by the same mv and rv 
#               18-- cron file reload failed 
#Output:        none
use strict;
use NS::SystemFileCVS;
use NS::DdrScheduleCommon;
use NS::DdrConst;
use NS::NsguiCommon;
use Getopt::Long;

my %optHash;
## get ARGS
if(!GetOptions(\%optHash,"s")){
    exit 1;
}

my $ddrCommon = new NS::DdrScheduleCommon;
my $common = new NS::SystemFileCVS;
my $const = new NS::DdrConst;
my $nsgui_common = new NS::NsguiCommon;
my $filename = shift;
my @schString;
if($optHash{'s'}){
    @schString = @ARGV;
}else{
	my $tmpFile = shift;
	if(!(-f $tmpFile)){
	    print STDERR "The temporary file $tmpFile does not exist! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
	    exit 1;
	}
	my $cmd_cat = $const->CMD_CAT;
	@schString = `$cmd_cat $tmpFile`;
	if($? != 0){
	    print STDERR "The temporary file $tmpFile can not be opened! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
	    exit 1;
	}
}
my $cmd_syncwrite_o = $common->COMMAND_NSGUI_SYNCWRITE_O;
 
if(!(-f $filename)){
    if(!open(FILE,"| ${cmd_syncwrite_o} $filename")){
        print STDERR "The $filename can not be written! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }
    print FILE "#ddr schedule begin\n";
    print FILE "#ddr schedule end\n";
    if(!close(FILE)) {
        print STDERR "The $filename can not be written! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }
}
my $cronContent = $ddrCommon->openFile($filename);
if(!defined($cronContent)){
    print STDERR $ddrCommon->error();
    exit 1;
}
my $originalSize = scalar(@$cronContent);
#write files on node0
my $cronjobName;
LOOP1:foreach(@schString){
    chomp($_);
    $_=~/^\s*([^#]+)\s+sudo\s+(\S+)\s+(\S+)\s+(\S+)\s+/;
    my $schTime = $1;
    $cronjobName = $2;
    my ($mv,$rv) = ($3,$4);
    my $schTimeExist = 0;
    my $size = scalar(@$cronContent);
    my $addPosition;
    for(my $i=0; $i<$size; $i++){
        if($$cronContent[$i]=~/^\s*#\s*MV\s*:\s*$mv\s+RV\s*:\s*$rv\s+BEGIN/){
            $addPosition = $i+1;
        }elsif($$cronContent[$i]=~/^\s*\Q$schTime\E\s+sudo\s+\S+\s+$mv\s+$rv\s+/){
            next LOOP1;
        }
    }
    if($addPosition){
        splice(@$cronContent,$addPosition,0,$_."\n");
    }else{
        splice(@$cronContent,1,0,"#MV:$mv RV:$rv BEGIN\n");
        splice(@$cronContent,2,0,"$_\n");
        splice(@$cronContent,3,0,"#MV:$mv RV:$rv END\n");
    }
}
if($originalSize==scalar(@$cronContent)){
    $nsgui_common->writeErrMsg($const->DDR_EXCEP_NO_SAME_SCHEDULE);
	exit 2;
}
if($common->checkout($filename)!=0){
    print STDERR "Failed to checkout \"$filename\". Exit in perl script:",
            __FILE__," line:",__LINE__+1,".\n";
    exit 1;    
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

my $ret = $nsgui_common->reloadCron($ddrCommon->USERNAME_DDR, $filename);
if($ret != 0) {
    $common->rollback($filename);
    print STDERR "Failed to execute:/usr/bin/crontab. Exit in perl script:"
            ,__FILE__," line:",__LINE__+1,".\n";
    $nsgui_common->writeErrMsg($const->DDR_EXCEP_NO_CRONTAB_FAILED);
	exit 18;	
}

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