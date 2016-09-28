#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: filesystem_chkNFSExport.pl,v 1.2302 2004/08/31 23:56:43 wangw Exp $"

use strict;
use NS::CodeConvert;
#check number of the argument
if(scalar(@ARGV)!=3)
{
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}
#get the parameter 
my $cc = new NS::CodeConvert();
my $exportGroup = shift;
my $mountPoint = shift;
$mountPoint = $cc->hex2str($mountPoint);
my $etcPath = shift;
my $fileName = $etcPath."exports";

-f $fileName or exit 0;
if(!open(INPUT,$fileName)) {
    print STDERR "Read $fileName failed! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
my @content = <INPUT>;
close(INPUT);
my $find="false";
foreach(@content) {
    if(/^\s*\Q${mountPoint}\E\s+/ || /^\s*\Q${mountPoint}\E\//) {
        $find="true";
        last;
    }
}
print "$find\n";
exit 0;
##------------------------END----------------------##
