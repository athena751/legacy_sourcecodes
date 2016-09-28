#!/usr/bin/perl
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: cifs_isWorkingComputer.pl,v 1.1 2008/05/09 02:48:15 chenbc Exp $"

#Function: check the computer name is under connection or not
#Parameters:
    #$groupNumber      : the group number 0 or 1
    #$domainName       : the Domain Name
    #$computerName     : the Computer Name
#output:
    #true  ------ the computer is busy
    #false ------ the computer is not busy
#exit code:
    #0 ---- success
    #1 ---- failure

use strict;
use NS::NsguiCommon;
use NS::CIFSConst;
use NS::CIFSCommon;

my $comm  = new NS::NsguiCommon;
my $const = new NS::CIFSConst;
my $cifsCommon = new NS::CIFSCommon;

if(scalar(@ARGV)!=3){
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}

my $groupNumber = shift;
my $domainName = shift;
my $computerName = shift;

my $smbConfFile = $cifsCommon->getSmbFileName($groupNumber, $domainName, $computerName);
my $isWorking = 'false';
if(defined($smbConfFile) && -f $smbConfFile){
    $isWorking = $cifsCommon->isWorkingShare($groupNumber, $domainName, $computerName, '.+');
}
print "$isWorking\n";

exit 0;