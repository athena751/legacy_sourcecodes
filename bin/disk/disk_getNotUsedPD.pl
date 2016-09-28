#!/usr/bin/perl
#
#       Copyright (c) 2005-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: disk_getNotUsedPD.pl,v 1.6 2007/04/16 08:02:41 liuyq Exp $"

#Function:      get the unused PD'numbers and capacity on the specified diskarray
#Parameters:    $arrayid -- DiskArray ID
#               $pdgn    -- PD group Number
#
#Exit:          0 -- successful  
#               1 -- failed
#Output
# xxh-yyh,cccc,FC/SATA/SAS  -- pdnumber,capacity(byte)

use strict;
use NS::DiskConst;
use NS::NsguiCommon;
use NS::DiskCommon;

if(scalar(@ARGV)!=2){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\nThis script need 2 parameters\n";
    exit 1;
}
my ($arrayid, $pdgn) = @ARGV;
my $const = new NS::DiskConst();
my $nsgui = new NS::NsguiCommon();
my $com = new NS::DiskCommon();

my @diskcmd =($const->CMD_DISK_LIST,$const->CMD_DISK_LIST_P,$const->CMD_DISK_LIST_AID,$arrayid,"2>&1");
my @diskinfo_all = `@diskcmd`;
if ($? != 0){
    #"0x107000$errorcode,$errorcode"
    my @errorcode = split(",",$com->getErrorcode(\@diskinfo_all));
    print STDERR "$errorcode[1]\n";
    $nsgui->writeErrMsg($errorcode[0],__FILE__,__LINE__+1);
    exit 1;
}
#diskinfo line: 
#(xxh-yyh) status (ccccc) poolnum poolname none
my @diskinfo=();
foreach(@diskinfo_all){
    if ($_=~/^\s*(${pdgn}h\-[0-9A-Fa-f]{2}h)\s+ready\s+(\d+)\s+\-\-\s+\-\-\s+none\s+\S+\s+\S+\s+(SATA|SAS|FC)\s*/){
        push (@diskinfo, $1.",".$2.",".$3);
    }
}
foreach(@diskinfo){
    print $_."\n";
}

exit 0;