#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: mapd_nisdomainusedbynfs.pl,v 1.1 2004/02/13 00:30:22 wangli Exp $"

use strict;
if(scalar(@ARGV)!=2) {
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}
my ($grpPath, $nisDomain) = @ARGV;
my @content =`cat ${grpPath}exports`;
foreach(@content){
    if ($_=~/^[^\#]+[\(\s,]nisdomain\s*=\s*([\w\.\-]+)/){
        if ($1 eq $nisDomain){
            print "yes\n";
            exit 0;
        }
    }
}
print "no\n";
exit 0;