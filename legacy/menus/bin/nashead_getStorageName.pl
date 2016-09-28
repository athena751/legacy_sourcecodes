#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: nashead_getStorageName.pl,v 1.1 2004/06/02 08:33:12 baiwq Exp $"

use strict;
use NS::NasHeadCommon;

if(scalar(@ARGV) != 1){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}
my $wwnn = shift;
my $nasHeadercommon = new NS::NasHeadCommon();
my $sanNickName_conf = $nasHeadercommon->getsannickname_conf();
my $storageName = "";
if(-f $sanNickName_conf){
    my @content;
    @content = `cat $sanNickName_conf`;
    foreach(@content){
        if(/^$wwnn,(.+)$/){
            $storageName = $1;
            chomp($storageName);
            last;
        }
    }
}

print "$storageName\n";

exit 0;