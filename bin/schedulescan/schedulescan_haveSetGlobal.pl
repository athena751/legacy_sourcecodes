#!/usr/bin/perl -w
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: schedulescan_haveSetGlobal.pl,v 1.2 2008/05/24 08:07:30 chenjc Exp $"

use strict;
use NS::NsguiCommon;
use NS::CIFSCommon;
use NS::ConfCommon;

my $nsguiCommon  = new NS::NsguiCommon;
my $cifsCommon = new NS::CIFSCommon;
my $confCommon = new NS::ConfCommon;

if(scalar(@ARGV)!=3){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}

my $groupNumber = shift;
my $domainName=shift;
my $vComputerName=shift;

my $scanSmbConfFile = $cifsCommon->getSmbFileName($groupNumber,$domainName,$vComputerName);
if(-f $scanSmbConfFile){
    open(SMBFILE,"$scanSmbConfFile");
    my @fileContent = <SMBFILE>;
    close(SMBFILE);
    my $hosts=$confCommon->getKeyValue("hosts allow", "global", \@fileContent);
    if(defined($hosts) && $hosts ne ""){
        print "yes\n";
        exit 0;
    }
}
print "no\n";
exit 0;