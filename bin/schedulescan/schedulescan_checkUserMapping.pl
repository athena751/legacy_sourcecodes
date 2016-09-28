#!/usr/bin/perl -w
#       Copyright (c)2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: schedulescan_checkUserMapping.pl,v 1.2 2008/05/14 08:19:07 chenjc Exp $"

#Function:
#    1.check the computer name is used or not
#    2.check there is user mapping of ADS domain and domain type for the computer or not
#Arguments:
#    $groupNumber
#    $domainName
#    $oldVComputerName
#    $vComputerName
#Outputs:
#    "no":no user database
#    "yes":have user database
#exit code:
#    0:succeed
#    1:failed

use strict;
use NS::NsguiCommon;
use NS::ScheduleScanCommon;
use NS::ScheduleScanConst;

my $comm  = new NS::NsguiCommon;
my $scheduleScanCommon = new NS::ScheduleScanCommon;
my $const = new NS::ScheduleScanConst;

if ( scalar(@ARGV) != 4 ) {
    print STDERR "PARAMETER NUMBER ERROR!\nError exit in perl script:", __FILE__, " line:", __LINE__ + 1, ".\n";
    exit 1;
}
my ( $groupNumber, $domainName, $oldVComputerName, $vComputerName ) = @ARGV;

#check the new computerName has been used or not
#when first set or modify
if( $oldVComputerName ne $vComputerName ) {
    my $isExist = $scheduleScanCommon->checkComputerName( $groupNumber, $vComputerName );
    if ( !defined($isExist) ) {
        print STDERR "CHECK COMPUTER NAME ERROR!\n";
        $comm->writeErrMsg( $const->ERRCODE_CHECK_INFO, __FILE__, __LINE__ + 1 );
        exit 1;
    }
    if ( $isExist eq "yes" ) {
        print STDERR "THE SPECIFIED COMPUTER NAME HAS EXISTED!\n";
        $comm->writeErrMsg( $const->ERRCODE_COMPUTER_EXIST, __FILE__, __LINE__ + 1 );
        exit 1;
    }
}

#Begin to check use database
my $imsNativeCmd = $const->COMMAND_IMS_NATIVE;
my $imsFile      = $const->CONST_IMS_FILE;

my @nativeList = `$imsNativeCmd /etc/group${groupNumber}/$imsFile 2>/dev/null`;
if ( $? != 0 ) {
    print STDERR "EXECUTE IMS_NATIVE COMMAND ERROR!\n";
    $comm->writeErrMsg( $const->ERRCODE_CHECK_INFO, __FILE__, __LINE__ + 1 );
    exit 1;
}

my $haveUser4OldVComputer = "no";
my $haveUser4VComputer    = "no";

if( $oldVComputerName !~ /^\s*$/){
    foreach (@nativeList) {
        if (/^NS=\Q${domainName}\E\+\Q${oldVComputerName}\E\/\s+pwd/) {
            $haveUser4OldVComputer = "yes";
            last;
        }
    }
}
#If old computer name is the same as new computer name,print and exit 0
if( $oldVComputerName eq $vComputerName ){
    $haveUser4VComputer = $haveUser4OldVComputer;
    print "$haveUser4OldVComputer\n";
    print "$haveUser4VComputer\n";
    exit 0;
}

my $haveFound = 0;
my $domain;
my $type;

foreach (@nativeList) {
    if (/^NS=(\S+?)\+\Q${vComputerName}\E\/\s+(\S+)\s*$/) {
        if ($haveFound) {
            print STDERR "IT IS POSSIBILITY THAT SPECIFIED COMPUTER ALREADY EXISTS!\n";
            $comm->writeErrMsg( $const->ERRCODE_USER_COMPUTER_EXIST, __FILE__, __LINE__ + 1 );
            exit 1;
        }
        $haveFound = 1;
        $domain = $1;
        $type   = $2;
    }
}

if( defined($domain) && defined($type) ){
	if($haveUser4OldVComputer eq "yes") {
        print STDERR "IT IS POSSIBILITY THAT SPECIFIED COMPUTER ALREADY EXISTS!\n";
        $comm->writeErrMsg( $const->ERRCODE_USER_COMPUTER_EXIST, __FILE__, __LINE__ + 1 );
        exit 1;
    }
    if ( $domain eq $domainName ) {
        if ( index($type,"pwd") == 0 ) {
            $haveUser4VComputer = "yes";           
        } else {
            print STDERR "DOMAIN TYPE OF SPECIFIED COMPUTER IS NOT PASSWD DOMAIN!\n";
            $comm->writeErrMsg( $const->ERRCODE_USER_NOT_PWD, __FILE__, __LINE__ + 1 );
            exit 1;
        }
    } else {
        print STDERR "DOMAIN OF SPECIFIED COMPUTER IS DIFFERENT!\n";
        $comm->writeErrMsg( $const->ERRCODE_USER_NOT_ADS, __FILE__, __LINE__ + 1 );
        exit 1;
    }
}

print "$haveUser4OldVComputer\n";
print "$haveUser4VComputer\n";
exit 0;

