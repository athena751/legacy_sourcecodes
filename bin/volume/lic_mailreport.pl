#!/usr/bin/perl -w
#       Copyright (c) 2007-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: lic_mailreport.pl,v 1.3 2008/02/25 05:47:14 liy Exp $"

#Function: 
    #write mail message into log
#Arguments: 
#exit code:
    #0:succeed 
    #1:failed
    #2:time out parameter wrong
#user:root

use strict;
use Getopt::Long;
use NS::LicenseCommon;
use NS::LicenseConst;
use NS::NsguiCommon;
use NS::Syslog;
use NS::ClusterStatus;
use NS::VolumeConst;

my $comm = new NS::LicenseCommon;
my $const = new NS::LicenseConst;
my $nsguiCommon  = new NS::NsguiCommon;
my $clusterStatus = new NS::ClusterStatus;
my $volumeConst = new NS::VolumeConst;

my %optHash;
if(!GetOptions(\%optHash,"t=s")){
    exit 2;
}
my $timeout = $optHash{'t'};
if(defined($timeout) && $timeout !~ /^\d+$/){
    exit 2;	
}

my $dayLeft = shift;

##output message to mail message file 

my $checkResultFile = $const->CHECKRESULTFILE;
my $CMD_GRACEPERIOD = $const->CMD_GRACEPERIOD;
my $periodStart = "${CMD_GRACEPERIOD} start 2>/dev/null";
my $periodStop = "${CMD_GRACEPERIOD} stop 2>/dev/null";
my $periodStatus="${CMD_GRACEPERIOD} status 2>/dev/null";
my $stopped = $const->CONST_STATUS_STOPPED;
my $started = $const->CONST_STATUS_STARTED;
my $expired = $const->CONST_STATUS_EXPIRED;

my $MAIL_MSG_STARTEDSTATUS_PARA = $const->MAIL_MSG_STARTEDSTATUS_PARA;
my $MAIL_MSG_STARTEDSTATUS_ENDED = $const->MAIL_MSG_STARTEDSTATUS_ENDED;
my $MAIL_MSG_EXPIREDSTATUS = $const->MAIL_MSG_EXPIREDSTATUS;

##excute only on Procyon or later. 
if(!defined($nsguiCommon->isProcyonOrLater()) || !$nsguiCommon->isProcyonOrLater()){
    exit 0;
}
##excute on single node or fip node of cluster 
if ($clusterStatus->isCluster()) {
    if (!$clusterStatus->update()) {
        exit 1;  ## failed to get cluster info
    }
    elsif(!$clusterStatus->isActiveNode()){
        exit 0;
    }
} 

### modify for no limited license
my $cmd_getlicensedcapacity = $const->CMD_GETLICENSEDCAPACITY;
my $licensedfscapacity = `${cmd_getlicensedcapacity} 2>/dev/null`;
chomp($licensedfscapacity);
if($licensedfscapacity eq "nolimit"){
	$comm->clearStatus($timeout);
    exit 0;	
}

my $timeoutStr = defined($timeout) ?  "-t $timeout" : "";
my ($status,$remainingDays) = `${periodStatus} $timeoutStr`;

if($status =~ /^\s*status\s*:\s*${stopped}\s*$/){
##if the status is stoped and licensed capacity exceeded,start the status
    if(-f $checkResultFile){
        system("$periodStart $timeoutStr");
    }
}
elsif($status  =~ /^\s*status\s*:\s*${started}\s*$/){
    if(-f $checkResultFile){
        if(defined($dayLeft) && $dayLeft ne ""){
            if($dayLeft eq "0"){
                $comm->writeSysLog(LOG_CRIT,$MAIL_MSG_STARTEDSTATUS_ENDED);
            }
            else {
                $comm->writeSysLog(LOG_WARNING,sprintf($MAIL_MSG_STARTEDSTATUS_PARA,$dayLeft));
            } 
        }
    }
    else{
        system("$periodStop $timeoutStr");
    }
}
elsif($status =~ /^\s*status\s*:\s*${expired}\s*$/){
    if(-f $checkResultFile){
        $comm->writeSysLog(LOG_CRIT,$MAIL_MSG_EXPIREDSTATUS);
    }
    else{
        system("$periodStop $timeoutStr");
    }
}

exit 0;
