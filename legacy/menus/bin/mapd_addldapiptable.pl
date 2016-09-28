#!/usr/bin/perl -w
use strict;
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: mapd_addldapiptable.pl,v 1.2300 2003/11/24 00:54:36 nsadmin Exp $"

if(scalar(@ARGV)!=1){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;    
}
my $serverName=shift;

foreach (split(/\s+/, $serverName)) {
    $_ =~ s/:.*$//g;
    system("/home/nsadmin/bin/nsgui_iptables.sh -A -s $_ -- -389/tcp -389/udp -636/tcp -636/udp 2> /dev/null");
    if ($? != 0){
        print STDERR " Failed to add host or network $_.\n";
        exit 1;
    }else{
        #print "$_ was successfully added!\n";
    }
}


exit 0;