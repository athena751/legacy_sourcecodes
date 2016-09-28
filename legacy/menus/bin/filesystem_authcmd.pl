#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: filesystem_authcmd.pl,v 1.2300 2003/11/24 00:54:35 nsadmin Exp $"

use strict;
use NS::CodeConvert;

my $len = @ARGV;
if($len != 2)  
{
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1; 
}
my $ims_path = shift;
my $mp=shift;
my $name; 
my $cc=new NS::CodeConvert();
$mp=$cc->hex2str($mp);

if (!$mp) 
{    #print" invalid parameter";
    print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

if(system("/usr/bin/ims_auth -D -d $mp -f -c $ims_path")!=0)
{
    print STDERR "Failed to execute \"ims_auth -D -d $mp -f -c $ims_path\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit(1);
}
exit 0;
     
