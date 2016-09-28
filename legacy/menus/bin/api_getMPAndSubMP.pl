#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: api_getMPAndSubMP.pl,v 1.2 2004/01/05 01:33:26 wangw Exp $"
#Function: 
#   Get LVM name of input mountpoint and its sub-mountpoint
#   from file: /etc/group[0|1]/cfstab

#Parameters: 
#   groupPath -- /etc/group[0|1]/
#   mountpoint -- the input mountpoint

#Output:
#   LVM1
#   mountpoint1
#   LVM2
#   mountpoint2
#   ......

#exit code:
#   0 -- successful 
#   1 -- failed
use strict;
use NS::APICommon;
use NS::ConstForAPI;
use NS::CodeConvert;

if (scalar(@ARGV) != 2){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}

my ($etcPath,$mountpoint) = @ARGV;
my $common  = new NS::APICommon();
my $const   = new NS::ConstForAPI();
my $cc      = new NS::CodeConvert();
my $refResult = $common->getMPAndSubMPInfo($etcPath,$cc->hex2str($mountpoint));
if(!defined($refResult)){
    print STDERR $common->error();
    exit $const->PERL_ERROR_EXIT_CODE;
}
for(my $i=0;$i<scalar(@$refResult);$i+=2) {
    print $$refResult[$i],"\n"; 
    print $cc->str2hex($$refResult[$i+1]),"\n"; 
}
exit $const->PERL_SUCCESS_EXIT_CODE;