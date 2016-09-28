#!/usr/bin/perl
#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: disk_bindPool.pl,v 1.3 2005/09/29 07:49:55 liq Exp $"

#Function:      Bind the pool
#Parameters:    $arrayname -- DiskArray ID
#               $pdGNO -- PD group number
#               $pd -- pd info [00h,01h...]
#               $poolno -- pool number
#               $poolname -- pool name
#               $raidtype -- raid type
#               $basepd -- basepd
#               $rebtime -- rebuild time

#Exit:          0 -- successful  
#               1 -- failed

use strict;
use NS::DiskConst;
use NS::NsguiCommon;
use NS::DiskCommon;

if(scalar(@ARGV)!=8){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\nThis script need 8 parameters\n";
    exit 1;
}
my $const = new NS::DiskConst();
my $nsgui = new NS::NsguiCommon();
my $com = new NS::DiskCommon();

my ($arrayname,$pdGNO,$pd,$poolno,$poolname,$raidtype,$basepd,$rebtime)=@ARGV;

my @pd_array = split(",",$pd);
my @sortedpd = sort { hex([split("h",$a)]->[0]) <=> hex([split("h",$b)]->[0]) ;} @pd_array;
$pd = join(",",@sortedpd);

my $namecheck = $com->isPoolNameExists($arrayname, $poolname);
if($namecheck ne "false"){
    my @errorcode = split(",",$namecheck);
    if ($errorcode[1] ne "31"){
        print STDERR "$errorcode[1]\n";
    }
    $nsgui->writeErrMsg($errorcode[0],__FILE__,__LINE__+1);
    exit 1; 
}

my @diskcmd =($const->CMD_POOL_BIND,$const->CMD_POOL_BIND_B,
              $const->CMD_POOL_BIND_ANAME,$arrayname,
              $const->CMD_POOL_BIND_PDG,$pdGNO."h",
              $const->CMD_POOL_BIND_PDN,$pd,
              $const->CMD_POOL_BIND_PNO,$poolno."h",
              $const->CMD_POOL_BIND_PNAME,$poolname,
              $const->CMD_POOL_BIND_RAID,$raidtype,
              $const->CMD_POOL_BIND_BASEPD,$basepd,
              $const->CMD_POOL_BIND_RBTIME,$rebtime,
              "-restart","2>&1");
              
my @result =`@diskcmd`;
 
if ($? != 0){
    #"0x107000$errorcode,$errorcode"
    my @errorcode = split(",",$com->getErrorcode(\@result));
    if ($errorcode[1] ne "31"){
        print STDERR "$errorcode[1]\n";
    }
    $nsgui->writeErrMsg($errorcode[0],__FILE__,__LINE__+1);
    exit 1;
} 
sleep(3);
exit 0;