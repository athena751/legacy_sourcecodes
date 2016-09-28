#!/usr/bin/perl
#
#       Copyright (c) 2001-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: snap_createSnap.pl,v 1.2301 2007/05/30 09:47:31 liy Exp $"


use strict;
use NS::CodeConvert;
#check number of the argument,if it isn't 2,exit
if(scalar(@ARGV)!=2){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}
my $cc          = new NS::CodeConvert();
my $snapName    = shift;
my $mp          = shift;
$mp             = $cc->hex2str($mp);
my $returnCode  = system("/usr/sbin/sxfs_snapshot -c -n $snapName $mp") >> 8;

exit ($returnCode);

## -------------------END--------------------##
