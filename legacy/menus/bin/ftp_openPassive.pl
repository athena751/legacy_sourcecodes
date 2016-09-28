#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: ftp_openPassive.pl,v 1.2301 2005/08/29 02:49:21 liq Exp $"


use strict;
#check number of the argument,if it isn't 2,exit
if(scalar(@ARGV)!=2)
{
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}


my $passive_start = shift;
my $passive_stop = shift;
system("/home/nsadmin/bin/nsgui_iptables2.sh -A INPUT -i ! bond0 -p tcp --dport $passive_start:$passive_stop -j ACCEPT");
system("/home/nsadmin/bin/nsgui_iptables_save.sh");
exit 0;
