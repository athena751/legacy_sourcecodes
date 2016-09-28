#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: nfs_getentries.pl,v 1.2 2004/08/16 08:44:40 wangw Exp $"

use strict;
use NS::NFSCommon;
if(scalar(@ARGV)!=2){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}
my $common = new NS::NFSCommon();
my ($exportGroup,$groupNo) = @ARGV;
my $infoList = $common->getExportClientInfo($exportGroup,$groupNo);
if(!defined($infoList)){
    print STDERR $common->error();
    exit 1;
}
foreach(keys(%$infoList)){
    print "$_ ",shift(@{$$infoList{$_}})," "
                ,scalar(@{$$infoList{$_}}),"\n";
    foreach(@{$$infoList{$_}}){
        print "$_\n";
    }
}
exit 0;
