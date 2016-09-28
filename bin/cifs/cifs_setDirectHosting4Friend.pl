#!/usr/bin/perl -w
#       Copyright (c) 2006-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: cifs_setDirectHosting4Friend.pl,v 1.4 2008/05/19 05:47:49 chenbc Exp $"
#
#Function:
#    set or delete direct hosting for friend node.
#Arguments:
#    $groupNumber
#    $operation           set/del
#Exit code:
#    0 : can set(more than one windows domain or have no windows domain)
#    1 : executed failed
#Output:
#    null
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

if(scalar(@ARGV) != 2){
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}
my ($groupNumber, $operation) = @ARGV;

my $virtual_servers = $cifsCommon->getVsFileName($groupNumber);
my @virtual_servers_content;
if(-f $virtual_servers) {
    @virtual_servers_content = `cat $virtual_servers 2>/dev/null`;
    my $newContent = $comm->getVSContent(\@virtual_servers_content);
    @virtual_servers_content = @$newContent;
} else {
    exit 0;
}

my $domainName = "";
my $computerName = "";
my $smbFileName = "";
my @fileContent;
my $cmd_syncwrite_o = $cvs->COMMAND_NSGUI_SYNCWRITE_O;
my $needRestartxsmbd = "no";
if($operation eq "set") {
    my $windowsDomainCount = 0;
    foreach(@virtual_servers_content) {
        if(/^\s*\/\S+\s+(\S+)\s+(\S+)\s*$/) {
            $domainName = $1;
            $computerName = $2;
            $windowsDomainCount ++;
        }
        if($windowsDomainCount > 1) {
            exit 1;
        }
    }
    $smbFileName = $cifsCommon->getSmbFileName($groupNumber, $domainName, $computerName);
    if(-f $smbFileName) {
        my $oldDirectHosting = $cifsCommon->getDirectHosting($groupNumber, $domainName, $computerName);
        @fileContent = `cat $smbFileName 2>/dev/null`;
        if($oldDirectHosting eq "no") {
            $confCommon->setKeyValue("smb ports","445","global", \@fileContent);
            &writeFile();
            &writeSchedSmbConfFile();
            $needRestartxsmbd = "yes";
        }
    } else {
        exit 0;
    }
} elsif ($operation eq "del") {
    foreach(@virtual_servers_content) {
        if(/^\s*\/\S+\s+(\S+)\s+(\S+)\s*$/) {
            $domainName = $1;
            $computerName = $2;
        }
        $smbFileName = $cifsCommon->getSmbFileName($groupNumber, $domainName, $computerName);
        if(-f $smbFileName) {
            my $oldDirectHosting = $cifsCommon->getDirectHosting($groupNumber, $domainName, $computerName);
            @fileContent = `cat $smbFileName 2>/dev/null`;
            if($oldDirectHosting eq "yes") {
                $confCommon->deleteKey("smb ports", "global", \@fileContent);
                &writeFile();
                &writeSchedSmbConfFile();
                $needRestartxsmbd = "yes";
            }
        }
    }
} else {
    exit 0;
}


if($needRestartxsmbd eq "yes") {
    `/usr/sbin/xsmbdrestart -f 2>/dev/null`;
}
exit 0;

sub writeFile() {
    open(WRITE,"|${cmd_syncwrite_o} ${smbFileName}");
    print WRITE @fileContent;
    close WRITE;
}

sub writeSchedSmbConfFile(){
    my ($smbFileName4ScheduleScan, $smbConfContent4ScheduleScan) = $ssCommon->getFileContent($groupNumber, $domainName, $computerName);
    if(defined($smbConfContent4ScheduleScan)){
        $cifsCommon->updateScheduleGlobal(\@fileContent, $smbConfContent4ScheduleScan);
        open(WRITE4SCHED,"|${cmd_syncwrite_o} ${smbFileName4ScheduleScan}");
        print WRITE4SCHED @$smbConfContent4ScheduleScan;
        close(WRITE);
    }
}
