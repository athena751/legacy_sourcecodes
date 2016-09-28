#!/usr/bin/perl -w
#       Copyright (c) 2006-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: cifs_setDirectHosting.pl,v 1.3 2008/05/09 02:48:15 chenbc Exp $"
#
#Function:
#    set or delete direct hosting.
#    if it is cluster, need set or delete for friend node.
#Arguments:
#    $groupNumber
#    $domainName
#    $computerName
#    $directHosting   yes/no   set direct hosting or not.
#Exit code:
#    0 : executed successful
#    1 : executed failed
#Output:
#    0 : node 0 can not set direct hosting because there are more than one windows domain in this node
#    1 : node 1 can not set direct hosting because there are more than one windows domain in this node
# "\n" : set successful or don't need to set.
# 
use strict;
use NS::NsguiCommon;
use NS::CIFSConst;
use NS::CIFSCommon;
use NS::ConfCommon;
use NS::SystemFileCVS;
use NS::ScheduleScanCommon;

my $comm = new NS::NsguiCommon;
my $const = new NS::CIFSConst;
my $cifsCommon = new NS::CIFSCommon;
my $confCommon = new NS::ConfCommon;
my $cvs        = new NS::SystemFileCVS;
my $ssCommon    = new NS::ScheduleScanCommon;

if(scalar(@ARGV) != 4){
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}

my ($groupNumber, $domainName, $computerName, $directHosting) = @ARGV;

my $operation = "";
if($directHosting eq "yes") {
    my $canSetDH = `/home/nsadmin/bin/cifs_canSetDirectHosting.pl $groupNumber`;
    my $reval = $?;
    if($reval == 0) {
        defined($canSetDH) or $canSetDH = "";
        chomp($canSetDH);
        if($canSetDH eq "no") {
            print "0\n";
            exit 0;
        }
    } else {
        exit $reval;
    }
}
my $smb_conf_File = $cifsCommon->getSmbFileName($groupNumber, $domainName, $computerName);
if($cvs->checkout($smb_conf_File)!= 0){
    $comm->writeErrMsg($const->ERRCODE_FAILED_TO_CHECK_OUT_SMB_CONF_FILE,__FILE__,__LINE__+1);
    exit 1;
}
my @fileContent = `cat $smb_conf_File`;

if($directHosting eq "yes") {
    $confCommon->setKeyValue("smb ports","445","global", \@fileContent); 
    $operation = "set";   
} else {
    $confCommon->deleteKey("smb ports", "global", \@fileContent);
    $operation = "del";
}
my $cmd_syncwrite_o = $cvs->COMMAND_NSGUI_SYNCWRITE_O;
open(WRITE,"|${cmd_syncwrite_o} ${smb_conf_File}");
print WRITE @fileContent;

my ($smbFileName4ScheduleScan, $smbConfContent4ScheduleScan) = $ssCommon->getFileContent($groupNumber, $domainName, $computerName);
if(defined($smbConfContent4ScheduleScan)){
    if($cvs->checkout($smbFileName4ScheduleScan)!=0){
	    $comm->writeErrMsg($const->ERRCODE_FAILED_TO_CHECK_OUT_SMB_CONF_FILE,__FILE__,__LINE__+1);
	    exit 1;
	}
    $cifsCommon->updateScheduleGlobal(\@fileContent, $smbConfContent4ScheduleScan);
    open(WRITE4SCHED,"|${cmd_syncwrite_o} ${smbFileName4ScheduleScan}");
    print WRITE4SCHED @$smbConfContent4ScheduleScan;
    if(!close(WRITE) || !close(WRITE4SCHED)){
        $cvs->rollback($smb_conf_File);
        $cvs->rollback($smbFileName4ScheduleScan);
        print STDERR "The $smb_conf_File can not be written! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }
    if($cvs->checkin($smbFileName4ScheduleScan)!=0){
        $cvs->rollback($smbFileName4ScheduleScan);
        $comm->writeErrMsg($const->ERRCODE_FAILED_TO_CHECK_IN_SMB_CONF_FILE,__FILE__,__LINE__+1);
        exit 1;
    }
}else{
    if(!close(WRITE)) {
        $cvs->rollback($smb_conf_File);
        print STDERR "The $smb_conf_File can not be written! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }
}
my $friendIP = $comm->getFriendIP();
if(defined($friendIP)) {
    `/home/nsadmin/bin/cluster_checkStatus.pl 2>/dev/null`;
    if($? == 0) {
        $groupNumber = 1 - $groupNumber;
        my $exitCode = $comm->rshCmd("sudo /home/nsadmin/bin/cifs_setDirectHosting4Friend.pl $groupNumber $operation", $friendIP);
        my $reval = $?;
        if($reval != 0 || !defined($exitCode) || $exitCode != 0) {
            $cvs->rollback($smb_conf_File);
            if(defined($smbConfContent4ScheduleScan)){
                $cvs->rollback($smbFileName4ScheduleScan);
            }
            if($reval != 0 || !defined($exitCode)) {
                $comm->writeErrMsg($comm->ERRCODE_NODE1_ERROR,__FILE__,__LINE__+1);
                exit 1;
            } elsif ($exitCode == 1) {
                print "1\n";
                exit 0;
            }
        }
    } else {
        $cvs->rollback($smb_conf_File);
        if(defined($smbConfContent4ScheduleScan)){
            $cvs->rollback($smbFileName4ScheduleScan);
        }
        $comm->writeErrMsg($comm->ERRCODE_NODE1_ERROR,__FILE__,__LINE__+1);
        exit 1;
    }
}
if(defined($smbConfContent4ScheduleScan)){
    $cvs->checkin($smbFileName4ScheduleScan)!=0
}
$cvs->checkin($smb_conf_File);
`/usr/sbin/xsmbdrestart -f 2>/dev/null`;
print "\n";
exit 0;
