#!/usr/bin/perl
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: cifs_hasScheduleScanConnection.pl,v 1.1 2008/05/09 02:48:15 chenbc Exp $"

#Function: check whether the schedule scan share is under connection.
#Parameters:
#   $groupNumber
#   $domainName
#   $computerName : the computer name of the export group.
#   $shareName  : if share name is omitted, this script will check all the schedule scan shares.

#output:
    #true  ------ under connection
    #false ------ NOT under connection
#exit code:
    #0 ---- success
    #1 ---- failure

use strict;
use NS::CIFSCommon;
use NS::NsguiCommon;
use NS::CIFSConst;
use NS::ScheduleScanCommon;

my $comm  = new NS::NsguiCommon;
my $const = new NS::CIFSConst;
my $cifsCommon = new NS::CIFSCommon;
my $ssCommon = new NS::ScheduleScanCommon;

if(scalar(@ARGV)!=3 && scalar(@ARGV)!=4){
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}

my($groupNumber,$domainName,$computerName,$shareName) = @ARGV;

defined($shareName) or $shareName = '.+';

my $exportGroupPath = $cifsCommon->getExportGroup($groupNumber, $domainName, $computerName);
if(!defined($exportGroupPath)) {
    print STDERR $const->ERRMSG_GETEXPORTGROUP."\n";
    $comm->writeErrMsg($const->ERRCODE_GETEXPORTGROUP,__FILE__,__LINE__+1);
    exit 1;
}
my $computerName4ScheduleScan = $ssCommon->getComputerName4ScheduleScan($groupNumber, $exportGroupPath, $domainName);
if(defined($computerName4ScheduleScan)){
    my $connecting = 'false';
    my $smbConfFile = $cifsCommon->getSmbFileName($groupNumber, $domainName, $computerName4ScheduleScan);
    if(defined($smbConfFile) && -f $smbConfFile){
        $connecting = $cifsCommon->isWorkingShare($groupNumber, $domainName, $computerName4ScheduleScan, $shareName);
    }
    print $connecting, "\n";
}else{
    print "false\n";
}

exit 0;