#!/usr/bin/perl
#
#       Copyright (c) 2005-2006 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: disk_expandPool.pl,v 1.3 2006/11/10 12:22:34 liq Exp $"

#Function:      expand the pool
#Parameters:    $arrayname -- DiskArray ID
#               $pdGNO -- PD group number
#               $poolname -- pool name
#               $pd -- pd info [00h,01h...]
#               $emode -- off | on
#               $etime -- expand time
#Exit:          0 -- successful  
#               1 -- failed
use strict;
use NS::DiskConst;
use NS::NsguiCommon;
use NS::DiskCommon;

if(scalar(@ARGV)!=6){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\nThis script need 6 parameters\n";
    exit 1;
}
my $const = new NS::DiskConst();
my $nsgui = new NS::NsguiCommon();
my $com = new NS::DiskCommon();

my ($arrayname,$pdGNO,$poolname,$pd,$emode,$etime)=@ARGV;
my @pd_array = split(",",$pd);
my @sortedpd = sort { hex([split("h",$a)]->[0]) <=> hex([split("h",$b)]->[0]) ;} @pd_array;
$pd = join(",",@sortedpd);

my @diskcmd =($const->CMD_POOL_BIND,$const->CMD_POOL_BIND_E,
              $const->CMD_POOL_BIND_ANAME,$arrayname,
              $const->CMD_POOL_BIND_PDG,$pdGNO."h",
              $const->CMD_POOL_BIND_PNAME,$poolname,
              $const->CMD_POOL_BIND_PDN,$pd,
              $const->CMD_POOL_BIND_EMODE,$emode);
if ($emode eq "on"){
    push (@diskcmd,$const->CMD_POOL_EXPAND_TIME);
    push (@diskcmd,$etime);
}
push (@diskcmd,"-restart");
push (@diskcmd,"2>&1");         

my @result =`@diskcmd`;
if ($? != 0){
    #"0x107000$errorcode,$errorcode"
    my @errorcode = split(",",$com->getErrorcode(\@result));
    print STDERR "$errorcode[1]\n";
    $nsgui->writeErrMsg($errorcode[0],__FILE__,__LINE__+1);
    exit 1;
} 
sleep(3);
exit 0;