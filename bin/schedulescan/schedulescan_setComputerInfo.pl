#!/usr/bin/perl -w
#       Copyright (c)2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: schedulescan_setComputerInfo.pl,v 1.5 2008/05/29 04:46:58 chenjc Exp $"

#Function:
#    set computer name in in virtual_servers file,rename the smb.conf file if necessary
#Arguments:
#    $groupNumber
#    $exportGroupPath
#    $domainName
#    $oldVComputerName
#    $vComputerName
#exit code:
#    0:succeed
#    1:failed

use strict;
use NS::SystemFileCVS;
use NS::NsguiCommon;
use NS::ScheduleScanConst;
use NS::CIFSCommon;

my $comm               = new NS::NsguiCommon;
my $cvs                = new NS::SystemFileCVS;
my $const              = new NS::ScheduleScanConst;
my $cifsCommon         = new NS::CIFSCommon;

if ( scalar(@ARGV) != 5 ) {
    print STDERR "PARAMETER NUMBER ERROR!\nError exit in perl script:", __FILE__, " line:", __LINE__ + 1, ".\n";
    exit 1;
}
my ( $groupNumber, $exportGroupPath, $domainName, $oldVComputerName, $vComputerName ) = @ARGV;

#do nothing when there is no change of computer name
if( $oldVComputerName eq $vComputerName ) {
    exit 0;
}

#get virtual_servers file content
my $vsFile = $cifsCommon->getVsFileName($groupNumber);
if(!(-f $vsFile)){
    print STDERR "$vsFile HAS LOST!\n";
    $comm->writeErrMsg( $const->ERRCODE_SET_INFO, __FILE__, __LINE__ + 1 );
    exit 1;
}

open( VSFILE, "$vsFile" );
my @vsFileContent = <VSFILE>;
close(VSFILE);

$exportGroupPath =~ s/\/+$//;

#delete old computer name from virtual_servers file content
my $index2replace=0;
foreach( @vsFileContent ) {
    if( /^\s*\Q${exportGroupPath}\E\s+\Q${domainName}\E\s+\Q${oldVComputerName}\E\s*$/o ) {
        splice( @vsFileContent, $index2replace, 1 );
        last;
    }
    $index2replace++;
}
#save virtual_servers content of no old computer name for rollback use
my @vsFileContent4rollback=@vsFileContent;

#check out the virtual_servers file
if ( $cvs->checkout($vsFile) != 0 ) {
    print STDERR "CHECK OUT $vsFile ERROR!\n";
    $comm->writeErrMsg( $const->ERRCODE_SET_INFO, __FILE__, __LINE__ + 1 );
    exit 1;
}

#write content into virtual_servers file
my $cmd_syncwrite_o = $cvs->COMMAND_NSGUI_SYNCWRITE_O;
open( WRITE, "|${cmd_syncwrite_o} ${vsFile}" );
print WRITE @vsFileContent;

if ( !close(WRITE) ) {
    $cvs->rollback($vsFile);
    print STDERR "THE $vsFile CAN NOT BE WRITTEN!\n";
    $comm->writeErrMsg( $const->ERRCODE_SET_INFO, __FILE__, __LINE__ + 1 );
    exit 1;
}

#rename smb.conf.oldVComputerName to smb.conf.vComputerName if necessary
my $cmd_syncwrite_m = $cvs->COMMAND_NSGUI_SYNCWRITE_M;
my $oldScanSmbConfFile=$cifsCommon -> getSmbFileName( $groupNumber, $domainName, $oldVComputerName );
my $newScanSmbConfFile=$cifsCommon -> getSmbFileName( $groupNumber, $domainName, $vComputerName );
if( -f $oldScanSmbConfFile ){
    if( system("${cmd_syncwrite_m} $oldScanSmbConfFile $newScanSmbConfFile") != 0 ) {
        $cvs -> rollback($vsFile);
        print STDERR "RENAME $oldScanSmbConfFile TO $newScanSmbConfFile ERROR!\n";
        $comm->writeErrMsg( $const->ERRCODE_SET_INFO, __FILE__, __LINE__ + 1 );
        exit 1;
    }
} else {
    $cvs->checkin($vsFile);
    print STDERR "$oldScanSmbConfFile HAS LOST!\n";
    $comm->writeErrMsg( $const->ERRCODE_SET_INFO, __FILE__, __LINE__ + 1 );
    exit 1;
}

#add new computer name to virtual_servers file
#push( @vsFileContent, "${exportGroupPath} ${domainName} ${vComputerName}\n" );
splice( @vsFileContent, $index2replace, 0, "${exportGroupPath} ${domainName} ${vComputerName}\n");
open( WRITE, "|${cmd_syncwrite_o} ${vsFile}" );
print WRITE @vsFileContent;

if ( !close(WRITE) ) {
    open( WRITE2, "|${cmd_syncwrite_o} ${vsFile}" );
    print WRITE2 @vsFileContent4rollback;
    close(WRITE2);
    system("${cmd_syncwrite_m} $newScanSmbConfFile $oldScanSmbConfFile");
    $cvs->rollback($vsFile);
    print STDERR "THE $vsFile CAN NOT BE WRITTEN!\n";
    $comm->writeErrMsg( $const->ERRCODE_SET_INFO, __FILE__, __LINE__ + 1 );
    exit 1;
}

#check in virtual_servers file
$cvs->checkin($vsFile);

#restart smb server if necessary
my $restartCmd = $const->COMMAND_CIFS_RESTART;
system("$restartCmd 2>/dev/null 1>&2");

exit 0;


