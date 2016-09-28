#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: mapd_ims_chkconf_wrapper.pl,v 1.1 2004/09/11 11:30:20 wangzf Exp $"


use strict;

if(scalar(@ARGV)!=2) {
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;    
}

my $region = shift;
my $imsConf = shift;
my $find = "false";

my @content = `/usr/bin/ims_chkconf -f -c $imsConf 2>&1`;
foreach(@content) {
    if(/\s*warning:\s*"\Q${region}\E"\s+unused\s+domain\s*/) {
         $find = "true";
         last;
    }
}
print "$find\n";
exit 0;