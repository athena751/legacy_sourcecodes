#!/usr/bin/perl
#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: exportroot_getludb_root.pl,v 1.2301 2005/08/23 08:07:14 liq Exp $"

use strict;

my $cmd = "/usr/bin/ludb_admin root";
my @content = `$cmd`;
if($?){
    print STDERR "Failed to run command \"$cmd\". Exit in perl module:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
# print the ludb root's path 
chomp($content[0]);
print $content[0]."\n";
exit 0;