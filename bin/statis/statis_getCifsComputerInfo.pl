#!/usr/bin/perl -w
#       Copyright (c) 2007-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: statis_getCifsComputerInfo.pl,v 1.3 2008/05/12 05:12:27 zhangjun Exp $"

#Function: 
    #get the DomainName and the ComputerName and the SecurityMode of the specified ExportGroup;
#Arguments: 
    #$groupNumber       : the group number 0 or 1
    #$exportGroup       : the ExportGroup
#exit code:
    #0:succeed 
    #1:failed
#output:
    #$domainName
    #$computerName
    
use strict;
use NS::NsguiCommon;
use NS::CIFSCommon;
use NS::ConstForStatis;

my $comm        = new NS::NsguiCommon;
my $cifsCommon  = new NS::CIFSCommon;
my $const       = new NS::ConstForStatis;

if(scalar(@ARGV)!=2){
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}

my $groupNumber = shift;
my $exportGroup = shift;
my $virtual_servers = $cifsCommon->getVsFileName($groupNumber);
my @virtual_serversInfo = `cat $virtual_servers`;
my $validVSContent = $comm->getVSContent(\@virtual_serversInfo);
my $domainName = "";
my $computerName = "";
foreach(@$validVSContent){
    # /export/necas NISDOMAIN COMPUTER-NIS
    if(/^\s*\Q$exportGroup\E\s+(\S+)\s+([a-zA-Z0-9\-]+)/){
        $domainName = $1;
        $computerName = $2;
        last;
    }
}
print "$domainName\n";
print "$computerName\n";

exit 0;
