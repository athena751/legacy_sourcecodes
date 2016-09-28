#!/usr/bin/perl
#
#       Copyright (c) 2001-2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: statis_getResourceNumber.pl,v 1.1 2005/10/18 16:21:14 het Exp $"
use strict;
use NS::NASCollector;

if(scalar(@ARGV) != 2){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}
my $collector = new NS::NASCollector();
my $number = $collector->getResourceNumber(@ARGV);
if($number == -1){
    print STDERR "Failed to get resource number. Exit in perl script:",
                     __FILE__," line:",__LINE__+1,".\n";
    exit 1;
}else{
    print $number,"\n"; 
}
exit(0); 