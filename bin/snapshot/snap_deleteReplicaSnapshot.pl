#!/usr/bin/perl
#
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: snap_deleteReplicaSnapshot.pl,v 1.1 2008/05/28 02:11:38 lil Exp $"
use strict;
use NS::CodeConvert;
use NS::SnapshotConst;

my $cc = new NS::CodeConvert();
my $snapshotConst = new NS::SnapshotConst;

# check param number
if(scalar(@ARGV) != 2){
    $snapshotConst->printErrMsg($snapshotConst->ERR_PARAMETER_COUNT, __FILE__, __LINE__ + 1);
    exit 1;
}

my $mp = shift;
my $snapName = shift;
$mp = $cc->hex2str($mp);

# split $snapName
my @delSnapNameArrs = split(",", $snapName);

# delete snapshot
foreach(@delSnapNameArrs){
    my $resCode = system("sudo /usr/sbin/sxfs_snapshot -d -n $_ $mp 2>/dev/null") >> 8;
    if($resCode != 0){
        $snapshotConst->printErrMsg($snapshotConst->ERR_EXECUTE_DELETE, __FILE__, __LINE__ + 1);
        exit $resCode;
    }
}
exit 0;
