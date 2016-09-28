#!/usr/bin/perl -w
#       Copyright (c)2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: schedulescan_setNewComputerInfo.pl,v 1.2 2008/05/29 04:46:58 chenjc Exp $"

#Function:
#    set a new computer name to virtual_servers file, create smb.conf file and its global section
#Arguments:
#    $groupNumber
#    $exportGroupPath
#    $domainName
#    $computerName
#    $vComputerName
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

if ( scalar(@ARGV) != 5 ) {
    print STDERR "PARAMETER NUMBER ERROR!\nError exit in perl script:", __FILE__, " line:", __LINE__ + 1, ".\n";
    exit 1;
}

my ( $groupNumber, $exportGroupPath, $domainName, $computerName, $vComputerName ) = @ARGV;

#get an un-used interface
my @unusedInterfaces = $cifsCommon->getUnusedInterfaces($groupNumber);
if ( scalar(@unusedInterfaces) == 0 ) {
    print STDERR "THERE IS NO INTERFACE TO SET!\n";
    $comm->writeErrMsg( $const->ERRCODE_NO_AVAILABLE_INTERFACE, __FILE__, __LINE__ + 1 );
    exit 1;
}
my $interface4Set = shift(@unusedInterfaces);

#edit smb file content
my @smbFileContent  = ();
my $cifsSmbConfFile = $cifsCommon->getSmbFileName( $groupNumber, $domainName, $computerName );
if ( !( -f $cifsSmbConfFile ) ) {
    print STDERR "$cifsSmbConfFile HAS LOST!\n";
    $comm->writeErrMsg( $const->ERRCODE_SET_INFO, __FILE__, __LINE__ + 1 );
    exit 1;
}
open( CIFSSMBFILE, "$cifsSmbConfFile" );
my @cifsSmbContent = <CIFSSMBFILE>;
close(CIFSSMBFILE);
my $copyContentRef = $cifsCommon->initGlobal4ScheduleScan( \@cifsSmbContent );
if ( defined($copyContentRef) ) {
    $confCommon->setSectionValue( $copyContentRef, "global", \@smbFileContent );
} else {
    print STDERR "GLOBAL SECTION OF $cifsSmbConfFile HAS LOST!\n";
    $comm->writeErrMsg( $const->ERRCODE_SET_INFO, __FILE__, __LINE__ + 1 );
    exit 1;
}
#delete hosts and users, set interface
$confCommon->deleteKey( "hosts allow", "global", \@smbFileContent );
$confCommon->deleteKey( "valid users", "global", \@smbFileContent );
$confCommon->setKeyValue( "interfaces", $interface4Set, "global", \@smbFileContent );

#create smb file
my $scanSmbConfFile=$cifsCommon -> getSmbFileName( $groupNumber, $domainName, $vComputerName );
if ( $cvs->checkout($scanSmbConfFile) != 0 ) {
    print STDERR "CHECK OUT $scanSmbConfFile ERROR!\n";
    $comm->writeErrMsg( $const->ERRCODE_SET_INFO, __FILE__, __LINE__ + 1 );
    exit 1;
}

my $cmd_syncwrite_o = $cvs->COMMAND_NSGUI_SYNCWRITE_O;
open( WRITE, "|${cmd_syncwrite_o} ${scanSmbConfFile}" );
print WRITE @smbFileContent;

if ( !close(WRITE) ) {
    $cvs->rollback($scanSmbConfFile);
    system("/bin/rm -f $scanSmbConfFile 2>/dev/null 1>&2");
    print STDERR "THE $scanSmbConfFile CAN NOT BE WRITTEN!\n";
    $comm->writeErrMsg( $const->ERRCODE_SET_INFO, __FILE__, __LINE__ + 1 );
    exit 1;
}

#check in smb file
if ( $cvs->checkin($scanSmbConfFile) != 0 ) {
    $cvs->rollback($scanSmbConfFile);
    system("/bin/rm -f $scanSmbConfFile 2>/dev/null 1>&2");
    print STDERR "CHECK IN $scanSmbConfFile ERROR!\n";
    $comm->writeErrMsg( $const->ERRCODE_SET_INFO, __FILE__, __LINE__ + 1 );
    exit 1;
}

#get vs file name
my $vsFile = $cifsCommon->getVsFileName($groupNumber);
if ( !( -f $vsFile ) ) {
    system("/bin/rm -f $scanSmbConfFile 2>/dev/null 1>&2");
    print STDERR "$vsFile HAS LOST!\n";
    $comm->writeErrMsg( $const->ERRCODE_SET_INFO, __FILE__, __LINE__ + 1 );
    exit 1;
}

#get virtual_servers file content
open( VSFILE, "$vsFile" );
my @vsContent = <VSFILE>;
close(VSFILE);
my $vsFileContent              = $comm->getVSContent( \@vsContent );
my $vsFileContent4ScheduleScan = $scheduleScanCommon->getVSContent4ScheduleScan( \@vsContent );

#add new computer name to vs file
push( @$vsFileContent4ScheduleScan, "${exportGroupPath} ${domainName} ${vComputerName}\n" );

#check out the virtual_servers file
if ( $cvs->checkout($vsFile) != 0 ) {
    system("/bin/rm -f $scanSmbConfFile 2>/dev/null 1>&2");
    print STDERR "CHECK OUT $vsFile ERROR!\n";
    $comm->writeErrMsg( $const->ERRCODE_SET_INFO, __FILE__, __LINE__ + 1 );
    exit 1;
}

#write content into virtual_servers file
open( WRITE, "|${cmd_syncwrite_o} ${vsFile}" );
print WRITE @$vsFileContent, @$vsFileContent4ScheduleScan;

if ( !close(WRITE) ) {
    $cvs->rollback($vsFile);
    system("/bin/rm -f $scanSmbConfFile 2>/dev/null 1>&2");
    print STDERR "THE $vsFile CAN NOT BE WRITTEN!\n";
    $comm->writeErrMsg( $const->ERRCODE_SET_INFO, __FILE__, __LINE__ + 1 );
    exit 1;
}

#check in virtual_servers file
$cvs->checkin($vsFile);

exit 0;
