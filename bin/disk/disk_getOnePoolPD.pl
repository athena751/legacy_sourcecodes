#!/usr/bin/perl
#
#       Copyright (c) 2005-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: disk_getOnePoolPD.pl,v 1.3 2007/04/16 08:05:03 liuyq Exp $"

#Function:      get a Pool info 
#Parameters:    $arrayid -- DiskArray ID
#               $pooln   -- Pool number(without h)
#
#Exit:          0 -- successful  
#               1 -- failed
#Output
# raidtype ----  6_6 |6_10
# capacity ----  xxxx byte
# pdinfo (>1 line)  ----  pdnumber,capacity(byte)

use strict;
use NS::DiskConst;
use NS::NsguiCommon;
use NS::DiskCommon;

if(scalar(@ARGV)!=2){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\nThis script need a parameter(diskarrayid)\n";
    exit 1;
}
my ($arrayid,$pooln)= @ARGV;

my $const = new NS::DiskConst();
my $nsgui = new NS::NsguiCommon();
my $com = new NS::DiskCommon();

#get pd which bind the specify pool
#cmd :iSAdisklist -poolp -aid $arrayid -pno $pooln
my @poolpdcmd = ($const->CMD_DISK_LIST,$const->CMD_DISK_LIST_POOLP,$const->CMD_DISK_LIST_AID,$arrayid,$const->CMD_POOL_BIND_PNO,$pooln."h","2>&1");
my @poolpdinfo = `@poolpdcmd`;
if ($? != 0){
    #"0x107000$errorcode,$errorcode"
    my @errorcode = split(",",$com->getErrorcode(\@poolpdinfo));
    print STDERR "$errorcode[1]\n";
    $nsgui->writeErrMsg($errorcode[0],__FILE__,__LINE__+1);
    exit 1;
}
my $onepd;
my @pdinfo=();
foreach(@poolpdinfo){
    #00h-05h ready 71601225728 data     
    if($_=~/^\s*([0-9A-Fa-f]{2}h\-[0-9A-Fa-f]{2}h)\s+\S+\s+(\d+)\s+data\s+\S+\s+(SATA|SAS|FC)\s*/){
        push (@pdinfo, $1.",".$2.",".$3);
    }
}
foreach(@pdinfo){
    print $_."\n";
}

exit 0;
