#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: api_getCodePage.pl,v 1.2 2004/01/05 01:33:26 wangw Exp $"
#Function: 
#   Get codepage according to groupname
#   Get it from file: /etc/group[0|1]/expgrps

#Parameters: 
#   groupPath -- /etc/group[0|1]/
#   exportgroup -- whose codepage is needed

#Output:
#   codepage

#exit code:
#   0 -- successful 
#   1 -- failed
use strict;
use NS::APICommon;
use NS::ConstForAPI;

if (scalar(@ARGV) != 2){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}

my ($etcPath,$exportgroup) = @ARGV;
my $common      = new NS::APICommon();
my $const       = new NS::ConstForAPI();
my $refResult   = $common->getExportGroupInfo($etcPath);
if(!defined($refResult)){
    print STDERR $common->error();
    exit $const->PERL_ERROR_EXIT_CODE;
}
print $$refResult{$exportgroup}."\n"; 
exit $const->PERL_SUCCESS_EXIT_CODE;
