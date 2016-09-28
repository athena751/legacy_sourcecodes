#!/usr/bin/perl -w
#       Copyright (c)2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: schedulescan_setGlobalInfo.pl,v 1.2 2008/05/26 05:15:48 chenjc Exp $"

#Function:
#    set the global section of smb.conf.%L of schedulescan computer
#Arguments:
#    $groupNumber
#    $domainName
#    $computerName;
#    $vComputerName
#    $Interfaces
#    $Users
#    $scanServer
#    $shouldRestart
#exit code:
#    0:succeed
#    1:failed

use strict;
use NS::SystemFileCVS;
use NS::NsguiCommon;
use NS::ConfCommon;
use NS::ScheduleScanConst;
use NS::ScheduleScanCommon;
use NS::CIFSCommon;

my $comm               = new NS::NsguiCommon;
my $cvs                = new NS::SystemFileCVS;
my $confCommon         = new NS::ConfCommon;
my $const              = new NS::ScheduleScanConst;
my $scheduleScanCommon = new NS::ScheduleScanCommon;
my $cifsCommon         = new NS::CIFSCommon;

if ( scalar(@ARGV) != 8 ) {
    print STDERR "PARAMETER NUMBER ERROR!\nError exit in perl script:", __FILE__, " line:", __LINE__ + 1, ".\n";
    exit 1;
}

my ($groupNumber,$domainName,$computerName,$vComputerName,
    $interfaces, $users,$scanServer,$shouldRestart) = @ARGV;

#edit the users string
my @tmpUsers=split(/\:/,$users);
foreach my $line(@tmpUsers){
    $line = $domainName."+".$line;
    if($line =~ /\s/) {
        $line = "\"".$line."\"";
    }
}
$users = join(" ", @tmpUsers);

my $scanSmbConfFile= $cifsCommon->getSmbFileName($groupNumber, $domainName, $vComputerName); 
if(!( -f $scanSmbConfFile)){
    print STDERR "$scanSmbConfFile HAS LOST!\n";
    $comm->writeErrMsg($const->ERRCODE_SET_INFO,__FILE__,__LINE__+1);
    exit 1;
}

open(SMBFILE,"$scanSmbConfFile");
my @fileContent = <SMBFILE>;
close(SMBFILE);

#set interfaces,users,server
my $globalSection="global";
$confCommon->setKeyValue("interfaces", $interfaces,$globalSection, \@fileContent);
$confCommon->setKeyValue("valid users", $users, $globalSection, \@fileContent);
$confCommon->setKeyValue("hosts allow", $scanServer,$globalSection, \@fileContent);

#check out the file
if($cvs->checkout($scanSmbConfFile)!=0){
    print STDERR "CHECK OUT $scanSmbConfFile ERROR!\n";
    $comm->writeErrMsg($const->ERRCODE_SET_INFO,__FILE__,__LINE__+1);
    exit 1;
}

#write file content
my $cmd_syncwrite_o = $cvs->COMMAND_NSGUI_SYNCWRITE_O;
open(WRITE,"|${cmd_syncwrite_o} ${scanSmbConfFile}");
print WRITE @fileContent;

if(!close(WRITE)) {
    $cvs->rollback($scanSmbConfFile);
    print STDERR "THE $scanSmbConfFile CAN NOT BE WRITTEN!\n"; 
    $comm->writeErrMsg($const->ERRCODE_SET_INFO,__FILE__,__LINE__+1);
    exit 1;
}

#check in the file
if($cvs->checkin($scanSmbConfFile)!=0){
    $cvs->rollback($scanSmbConfFile);
    print STDERR "CHECK IN $scanSmbConfFile ERROR!\n";
    $comm->writeErrMsg($const->ERRCODE_SET_INFO,__FILE__,__LINE__+1);
    exit 1;
}

#restart if when there are necessary shares
#my $haveShareSection=$scheduleScanCommon->haveShareSection(\@fileContent);
if($shouldRestart eq "yes"){
    my $restartCmd=$const->COMMAND_CIFS_RESTART;
    system("$restartCmd 2>/dev/null 1>&2");
}

exit 0;
