#!/usr/bin/perl
#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: disk_getRaid6List.pl,v 1.1 2005/09/29 07:49:55 liq Exp $"

#Function:      get raid 6 list under arrayid|pdgn 
#Parameters:    $arrayid -- DiskArray ID
#               $pdgn   -- PD group number
#
#Exit:          0 -- successful  
#               1 -- failed
#Output
# $pname($pnumber) ---- pool name (pool number)

use strict;
use NS::DiskConst;
use NS::NsguiCommon;
use NS::DiskCommon;

if(scalar(@ARGV)!=2){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\nThis script need a parameter(diskarrayid)\n";
    exit 1;
}
my ($arrayid,$pdgn)= @ARGV;

my $const = new NS::DiskConst();
my $nsgui = new NS::NsguiCommon();
my $com = new NS::DiskCommon();

#get pd--pool info 
#cmd :iSAdisklist -p -aid $arrayid
my @pdcmd = ($const->CMD_DISK_LIST,$const->CMD_DISK_LIST_P,$const->CMD_DISK_LIST_AID,$arrayid,"2>&1");
my @pdinfo = `@pdcmd`;
if ($? != 0){
    #"0x107000$errorcode,$errorcode"
    my @errorcode = split(",",$com->getErrorcode(\@pdinfo));
    print STDERR "$errorcode[1]\n";
    $nsgui->writeErrMsg($errorcode[0],__FILE__,__LINE__+1);
    exit 1;
}
my %poolhash; # number->name;
foreach(@pdinfo){
    if ($_=~/^\s*${pdgn}h-[0-9a-fA-F]{2}h\s+.+\s+\d+\s+([0-9a-fA-F]{4}h)\s+(\S+)\s+/){
        $poolhash{$1}=$2;
    }
}


#cmd: iSAdisklist -pool -aid $arrayid
my @poolcmd = ($const->CMD_DISK_LIST,$const->CMD_DISK_LIST_POOL,$const->CMD_DISK_LIST_AID,$arrayid,"2>&1");
my @allpoolinfo = `@poolcmd`;

if ($? != 0){
    #"0x107000$errorcode,$errorcode"
    my @errorcode = split(",",$com->getErrorcode(\@allpoolinfo));
    print STDERR "$errorcode[1]\n";
    $nsgui->writeErrMsg($errorcode[0],__FILE__,__LINE__+1);
    exit 1;
}

foreach(@allpoolinfo){ 
    #0000h Pool0000 ready 6 6 559415040  --  
    if($_=~/^\s*([0-9a-fA-F]{4}h)\s+(\S+)\s+.+\s+6\s+(6|10)\s+(\d+)\s+/){
        if (exists($poolhash{$1})){
            print "$2($1)\n";
        }
    }
}

exit 0;