#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: snap_hexMP2DevName.pl,v 1.2301 2004/03/04 09:17:42 liuhy Exp $"

use strict;
use NS::CodeConvert;

if(scalar(@ARGV) != 1) {
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}

my $cc = new NS::CodeConvert();
my $mountPoint = shift;
my $findFlag = 0;

$mountPoint = $cc->hex2str($mountPoint);

my @mpContent    = `/bin/mount`;

foreach (@mpContent) {
    if (/\s*(\S+)\s+on\s+\Q$mountPoint\E\s+/) {
        print "$1\n";
        $findFlag = 1;
	last;
    }
}

if($findFlag) {
    exit(0);
} else {
    print STDERR "The $mountPoint does not exist !\n";
    exit(1);
}

