#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: cluster_deleteDir.pl,v 1.2300 2003/11/24 00:54:35 nsadmin Exp $"

use strict;
use NS::CodeConvert;
if(scalar(@ARGV)!=1){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}
my $dir = shift;
my $cc = new NS::CodeConvert();
$dir = $cc->hex2str($dir);
if(!$dir){
    print STDERR "The parameter path not a hex string. In script:(",__FILE__,")\n";
    exit(1);
}
if(system("rm -rf $dir")!=0){
    print STDERR " Remove directory \"$dir\" failed! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit(1);
}
exit(0);
