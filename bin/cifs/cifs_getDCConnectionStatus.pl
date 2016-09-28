#!/usr/bin/perl
#
#       Copyright (c) 2006 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

## accessStatus = 1 -> o  : connect
## accessStatus = 2 -> x  : disconnect
## accessStatus = 0 -> -- : not access
##

# "@(#) $Id: cifs_getDCConnectionStatus.pl,v 1.2 2006/05/12 09:23:02 fengmh Exp $"

use strict;
use NS::CIFSConst;
use NS::NsguiCommon;
my $const = new NS::CIFSConst;
my $comm  = new NS::NsguiCommon;

if(scalar(@ARGV) != 1){
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}

my $domainName = shift;
my $cifs_dc_stat = $const->COMMAND_DC_STAT;
my $dcAccessStat;
my $priority = 1;
my $accessStat = "";
my $accessInfo = "";

my @dcAccessStatus = `$cifs_dc_stat -W $domainName 2>/dev/null`;
my $exitCode = $?/256;
if($exitCode == 3) {
    print STDERR "Time out when getting Domain Controller Connection Status.\n";
    $comm->writeErrMsg($const->ERRCODE_GET_DCCONNECTIONSTATUS_TIMEOUT,__FILE__,__LINE__+1);
    exit 1;
}elsif ($exitCode == 2) {
    print STDERR "Domain Controller Connection Status is null.\n";
    $comm->writeErrMsg($const->ERRCODE_GET_DCCONNECTIONSTATUS_NULL,__FILE__,__LINE__+1);
    exit 1;
}elsif ($exitCode == 1) {
    print STDERR "Option error in getting Domain Controller Connection Status.\n";
    $comm->writeErrMsg($const->ERRCODE_GET_DCCONNECTIONSTATUS_OPTIONERR,__FILE__,__LINE__+1);
    exit 1;
}
shift @dcAccessStatus;
foreach $dcAccessStat(@dcAccessStatus) {
    if($dcAccessStat =~ /^\s*(\S+)\t+(\S+)(\t+(.*))?/) {
        print "priority=$priority\n";
        print "domainController=$1\n";
        $accessStat = $2;
        if(defined($3)) {
            $accessInfo = $4;
        } else {
            $accessInfo = "";
        }
        if($accessStat eq "1") {
            $accessStat = "o";
        }elsif($accessStat eq "2") {
            $accessStat = "x";
        } else {
            $accessStat = "--";
        }
        print "accessStat=$accessStat\n";
        print "accessInfo=$accessInfo\n";
        $priority ++;
    }
}
exit 0;
