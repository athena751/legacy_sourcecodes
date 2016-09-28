#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: api_getExportGroup.pl,v 1.2 2004/01/05 01:33:26 wangw Exp $"
#Function: 
#   Get exporgroup and codepage according to file: /etc/group[0|1]/expgrps

#Parameters: 
#   groupPath -- /etc/group[0|1]/

#Output:
#   exportgroup1
#   codepage1
#   exportgroup2
#   codepage2
#   ......

#exit code:
#   0 -- successful 
#   1 -- failed
use strict;
use NS::APICommon;
use NS::ConstForAPI;
if (scalar(@ARGV) != 1){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}

my $etcPath = shift;
my $common  = new NS::APICommon();
my $const   = new NS::ConstForAPI();
my $refResult = $common->getExportGroupInfo($etcPath);
if(!defined($refResult)){
    print STDERR $common->error();
    exit $const->PERL_ERROR_EXIT_CODE;
}
my @allkeys = keys(%$refResult);
foreach (@allkeys) {
    print "$_\n", "$$refResult{$_}\n"; 
}
exit $const->PERL_SUCCESS_EXIT_CODE;
