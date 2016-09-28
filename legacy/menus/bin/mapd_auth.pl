#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: mapd_auth.pl,v 1.2300 2003/11/24 00:54:36 nsadmin Exp $"



use strict;
use NS::CodeConvert;

#check number of the argument,if it isn't 2,exit
#(scalar(@ARGV)==2) or exit 1;
if(scalar(@ARGV)!=3)
{
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;    
}
#if(scalar(@ARGV)!=3){
#    exit 1;
#}

my $cc = new NS::CodeConvert();

my $imsPath = shift;
my $region=shift;
my $path=shift;
$path=$cc->hex2str($path);

if(system("/usr/bin/ims_auth -A $region -d $path -f -c $imsPath")!=0)
{
    print $!;
    exit (-1);
}

exit(0);

