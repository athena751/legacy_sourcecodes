#!/usr/bin/perl -w
#
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
# 
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
 
# "@(#) $Id$"

#Function:  
#   get the export group list

#Parameters: 
#   etcPath -- /etc/group[0|1]/

#Output:
#   exportgroup1
#   codepage1
#   exportgroup2
#   codepage2
#   ......

#exit code:
#   0 -- successful 
#   1 -- failed

use strict;
use NS::APICommon;
use NS::ClusterStatus;

if (scalar(@ARGV) != 1){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}
my $etcPath = shift;
my $nodeNo = 0;
if($etcPath=~/^\/etc\/group(\d)/){
    $nodeNo = $1;
}
my $cs = new NS::ClusterStatus;
my $apicommon  = new NS::APICommon();

if ($cs->isCluster()){
    my @content = `mount 2> /dev/null`;
    my $grpNum = scalar(grep(/^\s*\S+\s+on\s+\/etc\/group${nodeNo}\.setupinfo\s+/,@content));
    if ($grpNum != 1){
        exit 0;
    }
}

my $refResult = $apicommon->getExportGroupInfo($etcPath);
if(!defined($refResult)){
    print STDERR $apicommon->error();
    exit 1;
}
foreach (keys(%$refResult)) {
    print "$_\n", "$$refResult{$_}\n"; 
}
exit 0;
