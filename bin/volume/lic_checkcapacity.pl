#!/usr/bin/perl -w
#       Copyright (c) 2007-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: lic_checkcapacity.pl,v 1.6 2008/02/25 05:47:06 liy Exp $"

#Function: 
    #check if total volume capacity has exceeded the licensed value,output the result or save into file by arguement.
#Arguments: 
    #$file       : whether to save result into file or not
#exit code:
    #0:succeed 
    #1:failed
    #2:time out parameter wrong 
#user:root, nsgui

use strict;
use NS::NsguiCommon;
use NS::VolumeConst;
use NS::LicenseConst;
use NS::ClusterStatus;
use NS::Syslog;
use Getopt::Long;
use NS::LicenseCommon;

my $common = new NS::LicenseCommon;
my $const = new NS::LicenseConst;
my $nsguiCommon  = new NS::NsguiCommon;
my $volConst = new NS::VolumeConst;
my $clusterStatus = new NS::ClusterStatus;
my $cmd_getfscapacity = $const->CMD_GETFSCAPACITY;
my $cmd_getlicensedcapacity = $const->CMD_GETLICENSEDCAPACITY;
my $CMD_TOUCH = $volConst->CMD_TOUCH;
my $CMD_RM = $volConst->CMD_RM;
my $CMD_MKDIR = $volConst->CMD_MKDIR;

my %optHash;
if(!GetOptions(\%optHash,"t=s")){
    exit 2;
}
my $timeout = $optHash{'t'};
if(defined($timeout) && $timeout !~ /^\d+$/){
    exit 2;	
}

##excute only on Procyon or later. 
if(!defined($nsguiCommon->isProcyonOrLater()) || !$nsguiCommon->isProcyonOrLater()){
    exit 0;
}
my $checkResultFile = $const->CHECKRESULTFILE;
my $LIC_DIRECTORY = $const->LIC_DIRECTORY;
my $timeoutStr = defined($timeout) ? "-t $timeout" : "";
my $fscapacity = `${cmd_getfscapacity} -p $timeoutStr 2>/dev/null`;
my $licensedfscapacity = `${cmd_getlicensedcapacity} $timeoutStr 2>/dev/null`;
chomp($fscapacity);
chomp($licensedfscapacity);

$nsguiCommon->writeLog( $const->LICENSE_CHECK,LOG_INFO, sprintf($const->GRACE_PERIOD_CHECKCAPACITY_LOGMSG,$licensedfscapacity,$fscapacity));

my $nolimit = "false";
if($licensedfscapacity eq "nolimit"){
	$licensedfscapacity = -1;
	$nolimit = "true";
}

my $overflowFlag = $fscapacity>$licensedfscapacity?1:0;


##if no parameter,output result to startard outputstream

if(scalar(@ARGV)==0) {  ## this branch will not be use
    exit $overflowFlag;
}
else {
    ##excute on single node or fip node of cluster 
    if ($clusterStatus->isCluster()) {
        if (!$clusterStatus->update()) {
            exit 1;  ## failed to get cluster info
        }
        elsif(!$clusterStatus->isActiveNode()){
            exit 0;
        }
    } 
    
    if($nolimit eq "true"){
    	$common->clearStatus($timeout);
    	exit 0;
    }
    
    my $cmd="";
    if($overflowFlag ){
        $cmd = "sudo $CMD_TOUCH $checkResultFile >&/dev/null";
        if(!(-d $LIC_DIRECTORY)){
            $cmd = "sudo $CMD_MKDIR -p $LIC_DIRECTORY && $cmd";            
        }
        $cmd = "$cmd && sudo /bin/chown nsgui:nsadmin $checkResultFile >&/dev/null";
    }else{
        $cmd = "sudo $CMD_RM -f $checkResultFile  2>/dev/null";
    }
    system($cmd);
    my $friendIP = $nsguiCommon->getFriendIP();
    if(defined($friendIP)){
        my $retVal = $nsguiCommon->isActive($friendIP);## check friend node is active
        if($retVal == 0){
            my $retVol = $nsguiCommon->rshCmdTimeout($cmd, $friendIP, $timeout);
        }
    }    
}

exit 0;