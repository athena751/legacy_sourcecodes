#!/usr/bin/perl -w
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: schedulescan_getAllDomAndCom.pl,v 1.2 2008/05/13 00:56:15 fengmh Exp $"
#
use strict;
use NS::CIFSCommon;
use NS::NsguiCommon;
use NS::ScheduleScanCommon;

my $cifsCommon = new NS::CIFSCommon;
my $comm = new NS::NsguiCommon;
my $scheduleScanCommon = new NS::ScheduleScanCommon;

if(scalar(@ARGV) != 1 && scalar(@ARGV) != 2){
    $comm->writeErrMsg("Parameter number error!");
    exit 1;
}

my $groupNo = shift;
my $isFriend = shift;

my $vsFile = $cifsCommon->getVsFileName($groupNo);
my @domPlusCom;
if(-f $vsFile) {
    my @vsConf = `cat $vsFile 2>/dev/null`;
    my $vsFileContent4ScheduleScan = $scheduleScanCommon->getVSContent4ScheduleScan(\@vsConf);
    foreach(@$vsFileContent4ScheduleScan) {
        if(/^\s*#/) {
            next;
        }
        if(/^\s*(\S+)\s+(\S+)\s+(\S+)\s*$/) {
            push(@domPlusCom, $2."+".$3."\n");
        }
    }
}

if(!defined($isFriend) || $isFriend ne "true") {
    my $friendIP = $comm->getFriendIP();
    if(defined($friendIP)) {
        `/home/nsadmin/bin/cluster_checkStatus.pl 2>/dev/null`;
        if($? == 0) {
            my $friendNo = 1-$groupNo;
            my ($exitCode, $friendDomPlusComAddr) = $comm->rshCmdWithSTDOUT("sudo /home/nsadmin/bin/schedulescan_getAllDomAndCom.pl $friendNo true", $friendIP);
            if(defined($exitCode) && $exitCode == 0) {
                my @friendDomPlusCom = @$friendDomPlusComAddr;
                if(scalar(@friendDomPlusCom) > 0) {
                    push(@domPlusCom, @friendDomPlusCom);
                }
            }
        }
    }
}

print @domPlusCom;
exit 0;