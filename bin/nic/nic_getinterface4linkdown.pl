#!/usr/bin/perl
#copyright (c) 2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: nic_getinterface4linkdown.pl,v 1.2 2007/08/28 04:58:31 chenbc Exp $"
#Function :
    #get ge/te/bond info
#Arguments: 
    #--
#exit code:
    #0:succeed 
    #1:error
#output:
    #interface1,interface2
    #IP1,IP2

use strict;

my @ipInfo = `/home/nsadmin/bin/nic_ifconfig.pl -s 2>/dev/null`;
if ($?!=0){exit 1;}
shift(@ipInfo);
my @interface;
my @ip;
#ge30a0   DOWN   UP                 --              --              -- 00:04:23:c2:82:ee 1500 NORMAL   --  NO --
#ge30a1     UP   UP   172.28.11.187/25   172.28.11.255              -- 00:04:23:c2:82:ef 9000 NORMAL   --  NO --
foreach (@ipInfo){
    if ($_=~/^\s*((ge|te|bond)[a-zA-Z0-9]{1,})\s+(DOWN|UP)\s+(DOWN|UP)\s+((\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})|(\-\-))/){
        push (@interface,$1);
        push (@ip,$5);
    }
}
my $interfaceForOutput=join (",",@interface);
my $ipForOutput=join(",",@ip);

print "$interfaceForOutput\n";
print "$ipForOutput\n";
exit 0;
