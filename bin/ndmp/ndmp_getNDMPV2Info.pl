#!/usr/bin/perl -w
#       Copyright (c) 2006 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: ndmp_getNDMPV2Info.pl,v 1.1 2006/12/26 01:12:12 qim Exp $"

use strict;
use NS::NDMPCommonV4;
use NS::NDMPConst;

my $ndmpComm = new NS::NDMPCommonV4;
my $ndmpConst = new NS::NDMPConst;

my $ndmpv2ConfFile = $ndmpConst->NDMPV2_CONFIG_FILE_PATH;
if (!(-e $ndmpv2ConfFile) || !(-s $ndmpv2ConfFile)) {
    exit 0;
}
open(V2FILE, $ndmpv2ConfFile);
my @v2content = <V2FILE>;
close(V2FILE);

my %v2confInfo = ("dataConnectionIPV2", "",
                "backupSoftware", "");
my $v2value = $ndmpComm->getKeyValue("IPADDR", \@v2content);
if(defined($v2value)) {
    $v2confInfo{"dataConnectionIPV2"} = $v2value;
}
$v2value = $ndmpComm->getKeyValue("FHINFO", \@v2content);
if(defined($v2value)){
    $v2confInfo{"backupSoftware"} = $v2value;
}
foreach (keys(%v2confInfo)) {
    print "$_=$v2confInfo{$_}\n";
}
exit 0;
