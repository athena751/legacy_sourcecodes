#!/usr/bin/perl -w
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: ethguard_getAdminIP.pl,v 1.4 2005/07/14 00:42:15 key Exp $"

#parameter: isCluster (true|false)
#
#Output:
#---------------------------------------------------
#| isCluster |              STDOUT                 |
#---------------------------------------------------
#|   true    | FIP Address from nascluster.conf    |
#---------------------------------------------------
#|   false   | IP Address from ifcfg-eth0          |
#---------------------------------------------------
use strict;

if (scalar(@ARGV) != 1){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}

my $isCluster = shift;
my $ip = "";
if($isCluster eq "true"){
    my @grepContain = `grep -w FIPADDR /etc/nascluster.conf`;
    foreach(@grepContain){
        if(/^\s*FIPADDR\s*=\s*"*(\d[\d|\.]+)"*.*/){
            #get the FIP Address from nascluster.conf
            $ip = $1;
            last;
        }
    }
}else{
    my @grepContain = `grep -w IPADDR /etc/sysconfig/network-scripts/ifcfg-bond0`;
    foreach(@grepContain){
        if(/^\s*IPADDR\s*=\s*"*(\d[\d|\.]+)"*.*/){
            #get the IP Address from ifcfg-eth0
            $ip = $1;
            last;
        }
    }
}
print "$ip\n";

exit 0;