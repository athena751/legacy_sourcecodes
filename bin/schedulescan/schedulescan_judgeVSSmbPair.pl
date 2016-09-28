#!/usr/bin/perl -w
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: schedulescan_judgeVSSmbPair.pl,v 1.1 2008/05/29 04:57:45 qim Exp $"

use strict;
use NS::CIFSCommon;
use NS::ScheduleScanCommon;
my $cifsCommon = new NS::CIFSCommon;
my $ssCommon = new NS::ScheduleScanCommon;

if(scalar(@ARGV)!=1){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}

my $nodeNo = shift;

my $VSFileName = $cifsCommon->getVsFileName($nodeNo);
if(!(-f $VSFileName)){
    print "no\n";
    exit 0;
}
open(FILE, $VSFileName);
my @VSContent = <FILE>;
close(FILE);

my $ssVSContent = $ssCommon->getVSContent4ScheduleScan(\@VSContent);
my $cifsConfFile;
foreach(@$ssVSContent){
    if ($_ =~ /^\s*\S+\s+(\S+)\s+(\S+)\s*$/){
        $cifsConfFile = $cifsCommon->getSmbFileName($nodeNo,$1,$2);
        if(!(-f $cifsConfFile)){
            print "no\n";
            exit 0;
        }
    }
}
print "yes\n";
exit 0;
