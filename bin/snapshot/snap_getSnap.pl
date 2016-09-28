#!/usr/bin/perl
#
#       Copyright (c) 2001-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: snap_getSnap.pl,v 1.2 2008/05/30 02:11:37 lil Exp $"

use strict;
use NS::CodeConvert;

#check number of the argument,if it isn't 1,exit
if(scalar(@ARGV)!=1){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}

my $cc = new NS::CodeConvert();
my $mp = shift;
$mp = $cc->hex2str($mp);

system("sudo /usr/sbin/sxfs_snapshot $mp 2>/dev/null");
exit 0;

## -------------------END--------------------##
