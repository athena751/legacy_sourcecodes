#!/usr/bin/perl
#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: disk_getOnePoolInfo.pl,v 1.1 2005/09/29 07:49:55 liq Exp $"

#Function:      get a Pool info 
#Parameters:    $arrayid -- DiskArray ID
#               $pooln   -- Pool number(without h)
#
#Exit:          0 -- successful  
#               1 -- failed
#Output
# raidtype ----  6_6 |6_10
# capacity ----  xxxx byte

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

#get pool info basic info [capacity|raidtype]
#cmd: iSAdisklist -pool -aid $arrayid
my @poolbasiccmd = ($const->CMD_DISK_LIST,$const->CMD_DISK_LIST_POOL,$const->CMD_DISK_LIST_AID,$arrayid,"2>&1");
my @poolbasicinfo = `@poolbasiccmd`;

if ($? != 0){
    #"0x107000$errorcode,$errorcode"
    my @errorcode = split(",",$com->getErrorcode(\@poolbasicinfo));
    print STDERR "$errorcode[1]\n";
    $nsgui->writeErrMsg($errorcode[0],__FILE__,__LINE__+1);
    exit 1;
}
my $basicinfo="";
foreach(@poolbasicinfo){
    #0000h Pool0000 ready 6 6 559415040  --  
    if($_=~/^\s*${pooln}h\s+\S+\s+.+\s+(1|5|10|50|6)\s+(-|6|10)\s+(\d+)\s+/){
        my $c= $3*512;
        $basicinfo =$c.",".$1."_".$2;
        last;
    }
}

print $basicinfo."\n";

exit 0;