#!/usr/bin/perl -w
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: mapd_getadsconf.pl,v 1.2 2004/01/20 07:38:31 changhs Exp $"

#Function: 
#   get the dnsDomain and kdcServer from krb5.conf
#Arguments: 
#   path:     /etc/group[0|1]/nas_cifs/DEFAULT/<ntdomain>/
#Output:
#   dnsDomain
#   kdcServer
#       output nothing when krb5.conf doesn't exist 
#       or doesn't contain the info.
#exit code:
#   0---------success
#   1---------param error

use strict;
use NS::MAPDCommon;

if(scalar(@ARGV)!=1){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}

my $path = shift;
my $MC = new NS::MAPDCommon;
my ($dnsDomain, $kdcServer) = $MC->getADSConf($path);
if (defined($dnsDomain) && defined($kdcServer)) {
    print "${dnsDomain}\n";
    print "${kdcServer}\n";
}
exit 0;