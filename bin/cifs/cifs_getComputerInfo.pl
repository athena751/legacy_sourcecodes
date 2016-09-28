#!/usr/bin/perl -w
#       Copyright (c) 2004-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: cifs_getComputerInfo.pl,v 1.4 2008/05/09 02:48:15 chenbc Exp $"

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
    #$securityMode
    #$hasSetDirectHosting    yes/no
    
use strict;
use NS::NsguiCommon;
use NS::CIFSConst;
use NS::CIFSCommon;

my $comm  = new NS::NsguiCommon;
my $const = new NS::CIFSConst;
my $cifsCommon = new NS::CIFSCommon;

if(scalar(@ARGV)!=2){
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}

my $groupNumber = shift;
my $exportGroup = shift;
my $virtual_servers = $cifsCommon->getVsFileName($groupNumber);
my @virtual_serversInfo = `cat $virtual_servers`;
my $domainName = "";
my $computerName = "";
my $securityMode = "";
my $hasSetDirectHosting = "";

my $newVSContent = $comm->getVSContent(\@virtual_serversInfo);
foreach(@$newVSContent){
    if(/^\s*\Q$exportGroup\E\s+(\S+)\s+([a-zA-Z0-9\-]+)/){
        #there is the line :
        # /export/necas NISDOMAIN COMPUTER-NIS
        $domainName = $1;
        $computerName = $2;
        last;
    }
}
if(($domainName ne "") && ($computerName ne "")){
    $securityMode = $cifsCommon->getSecurityMode($groupNumber, $domainName, $computerName);
} else {
    $hasSetDirectHosting = `/home/nsadmin/bin/userdb_checkdirecthosting.pl $groupNumber 2>/dev/null`;
    chomp($hasSetDirectHosting);
}
print "$domainName\n";
print "$computerName\n";
print "$securityMode\n";
print "$hasSetDirectHosting\n";
exit 0;
