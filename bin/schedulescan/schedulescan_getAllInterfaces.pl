#!/usr/bin/perl -w
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: schedulescan_getAllInterfaces.pl,v 1.1 2008/05/08 09:15:30 chenbc Exp $"

#Function:
#    get all interface:include unused interfaces and using interfaces
#Arguments:
#    $groupNumber
#    $domainName
#    $vComputerName
#Outputs:
#    interfaces ip    : all ip joined by " "
#    interfaces label : all label joined by " "
#exit code:
#    0:succeed
#    1:failed
use strict;
use NS::NsguiCommon;
use NS::ScheduleScanConst;
use NS::ScheduleScanCommon;
use NS::CIFSCommon;

my $nsguiCommon  = new NS::NsguiCommon;
my $cifsCommon = new NS::CIFSCommon;
my $const = new NS::ScheduleScanConst;
my $scheduleScanCommon = new NS::ScheduleScanCommon;

if(scalar(@ARGV)!=3){
    print STDERR "PARAMETER NUMBER ERROR!\nError exit in perl script:", __FILE__, " line:", __LINE__ + 1, ".\n";
    exit 1;
}

my $groupNumber = shift;
my $domainName=shift;
my $vComputerName=shift;

my @allInterfaces=$cifsCommon->getAllInterfaces();
my $scanSmbConfFile= $cifsCommon->getSmbFileName($groupNumber, $domainName, $vComputerName);
my @fileContent=();
if(-f $scanSmbConfFile){
    open(SMBFILE,"$scanSmbConfFile");
    @fileContent = <SMBFILE>;
    close(SMBFILE);
}
my $usedInterfaces=$scheduleScanCommon->getUsedInterface(\@fileContent);
if(!defined($usedInterfaces)){
    $usedInterfaces="";
}
my @unusedInterfaces=$cifsCommon->getUnusedInterfaces($groupNumber,$allInterfaces[0],$allInterfaces[1],$usedInterfaces);
foreach(@unusedInterfaces){
    print $_,"\n";
}
exit 0
