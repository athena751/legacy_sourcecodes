#!/usr/bin/perl -w
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: ethguard_getIpForAdmin.pl,v 1.2 2005/07/14 00:42:08 key Exp $"

#parameter: isCluster (true|false)
#
#Output:
#-----------------------------------------------------------
#| isCluster |              STDOUT                         |
#-----------------------------------------------------------
#|   true    | IP Address from ifcfg-eth0,ifcfg-eth0.z     |
#|           |                 ifcfg-eth0:0,ifcfg-eth0.z:0 |
#|           | FIP and Node0's IP and Node1's IP           |
#|           |          from  nascluster.conf              |
#-----------------------------------------------------------
#|   false   | IP Address from ifcfg-eth0, ifcfg-eth0.z    |
#-----------------------------------------------------------
use strict;

if (scalar(@ARGV) != 1){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}
my $isCluster = shift;

my $ifcfgFilePre = "/etc/sysconfig/network-scripts/ifcfg-bond0";
my @grepContain = `grep -H IPADDR ${ifcfgFilePre}*`;
foreach(@grepContain){
    if(/^\s*$ifcfgFilePre\s*:\s*IPADDR\s*=\s*"*(\d[\d|\.]+)"*.*/){
        #get the ip from ifcfg-eth0
        print "$1\n";
    }elsif(/^\s*$ifcfgFilePre\.\d+\s*:\s*IPADDR\s*=\s*"*(\d[\d|\.]+)"*.*/){
        #get the ip from ifcfg-eth0.z
        print "$1\n";
    }elsif(/^\s*$ifcfgFilePre:0\s*:\s*IPADDR\s*=\s*"*(\d[\d|\.]+)"*.*/){
        #get the ip from ifcfg-eth0:0
        print "$1\n";
    }elsif(/^\s*$ifcfgFilePre\.\d+:0\s*:\s*IPADDR\s*=\s*"*(\d[\d|\.]+)"*.*/){
        #get the ip from ifcfg-eth0.z:0
        print "$1\n";
    }
}

if($isCluster eq "true"){
    if(open(FILE,"/etc/nascluster.conf")){
        foreach(<FILE>){
            if(/^\s*FIPADDR\s*=\s*"*(\d[\d|\.]+)"*.*/){
                #get the FIP Address from nascluster.conf
                print "$1\n";
            }elsif(/^\s*IPADDR0\s*=\s*"*(\d[\d|\.]+)"*.*/){
                #get the IP Address of Node0 from nascluster.conf
                print "$1\n";
            }elsif(/^\s*IPADDR1\s*=\s*"*(\d[\d|\.]+)"*.*/){
                #get the IP Address of Node1 from nascluster.conf
                print "$1\n";
            }
        }
        close(FILE);
    }
}

exit 0;