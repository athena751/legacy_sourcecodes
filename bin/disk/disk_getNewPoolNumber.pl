#!/usr/bin/perl
#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: disk_getNewPoolNumber.pl,v 1.1 2005/09/21 01:51:20 liq Exp $"

#Function:      get the smallest Pool number that is not used on the specified diskarray
#Parameters:    $arrayid -- DiskArray ID
#
#Exit:          0 -- successful  
#               1 -- failed
#Output
# nnnn   -- pooldnumber

use strict;
use NS::DiskConst;
use NS::NsguiCommon;
use NS::DiskCommon;

if(scalar(@ARGV)!=1){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\nThis script need a parameter(diskarrayid)\n";
    exit 1;
}
my $arrayid = shift;
my $const = new NS::DiskConst();
my $nsgui = new NS::NsguiCommon();
my $com = new NS::DiskCommon();

my @diskcmd =($const->CMD_DISK_LIST,$const->CMD_DISK_LIST_POOL,$const->CMD_DISK_LIST_AID,$arrayid,"2>&1");
my @poolinfo = `@diskcmd`;
if ($? != 0){
    #"0x107000$errorcode,$errorcode"
    my @errorcode = split(",",$com->getErrorcode(\@poolinfo));
    print STDERR "$errorcode[1]\n";
    $nsgui->writeErrMsg($errorcode[0],__FILE__,__LINE__+1);
    exit 1;
}

my %pdNhash; #decN-->hexString: 40-->0028
#get all pool
foreach(@poolinfo){
    if ($_=~/^\s*([0-9A-Fa-f]{4})h\s*/){
        $pdNhash{hex($1)}=$1;
    }
}

#find the smallest one
my $smallpoolN = -1;
my $tmppoolN = 0;
while($smallpoolN == -1){
    if (exists($pdNhash{$tmppoolN})){
        $tmppoolN++;
    }else{
        $smallpoolN = $tmppoolN;
    }
}
#change dec2hex
if ($smallpoolN<16){
    print sprintf("000%x\n",$smallpoolN);
}elsif ($smallpoolN<256){
    print sprintf("00%x\n",$smallpoolN);
}elsif ($smallpoolN<4096){
     print sprintf("0%x\n",$smallpoolN);
}else{
    print sprintf("%x\n",$smallpoolN);
}

exit 0;



