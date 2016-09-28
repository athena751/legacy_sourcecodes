#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: api_getNisDomainServer.pl,v 1.2 2004/01/05 01:33:26 wangw Exp $"
#Function: 
#   Get all nisdomains' servers
#   from file:  /etc/yp.conf

#Parameters: 
#   nisdomain's name

#Output:
#   server1 server2 ......

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

my $nisdomain = shift;
my $common  = new NS::APICommon();
my $const   = new NS::ConstForAPI();
my $allnisdomain = $common->getNisDomainServer();
if(!defined($allnisdomain)){
    print STDERR $common->error();
    exit $const->PERL_ERROR_EXIT_CODE;
}
print $$allnisdomain{$nisdomain},"\n";
exit $const->PERL_SUCCESS_EXIT_CODE;
