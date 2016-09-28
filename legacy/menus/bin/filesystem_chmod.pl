#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: filesystem_chmod.pl,v 1.2300 2003/11/24 00:54:35 nsadmin Exp $"


use strict;
use NS::CodeConvert;
#check number of the argument,if it isn't 1,exit
if(scalar(@ARGV)!=3)
{
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}
#get the parameter and change its coding
my $cc      = new NS::CodeConvert();
my $convert = shift;
my $path    = shift;
if($convert eq "-c") {
    $path        = $cc->hex2str($path);
}
my $mod = shift;
#run the command
if(system("chmod $mod $path")!=0)
{
    print STDERR "In FileSystemSOAPServer:Run command \"chmod\" failed! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit(1);
}
exit(0);

## -------------------END--------------------##
