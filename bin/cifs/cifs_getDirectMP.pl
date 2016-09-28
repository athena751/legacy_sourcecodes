#!/usr/bin/perl
#
#       Copyright (c) 2007-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

#"@(#) $Id: cifs_getDirectMP.pl,v 1.2 2008/12/18 07:35:57 chenbc Exp $"
#Function:
#    Used for get direct mount point. unmounted mount point will be also getted.
#Input:
#    groupNo        0 | 1
#    exportGroup    like /export/aaa
#    fstype         all | sxfs | sxfsfw
#Output:
#    direct mount point
#    Just the direct mount point will be printed.
#

use strict;
use NS::NsguiCommon;
use NS::CIFSConst;
use NS::CIFSCommon;

my $comm       = new NS::NsguiCommon;
my $const      = new NS::CIFSConst;
my $cifsCommon = new NS::CIFSCommon;

if(scalar(@ARGV) != 3){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}

my ($groupNo, $exportGroup, $fstype) = @ARGV;
$exportGroup =~ s/\/*$//;
my $conffile = "/etc/group".$groupNo."/cfstab";
my @resultMount = `/bin/cat $conffile`;
my @directMP;
my $mp;
my $type;
my $tmpOption;
foreach(@resultMount) {
    if(/^\s*\S+\s+\Q$exportGroup\E\/(\S+)\s+(\S+)\s+(\S+)/) {
        $mp = $1;
        $type = $2;
        $tmpOption = $3;
    } else {
        next;
    }
    if(index($mp, "/") == -1) {
        if(lc($type) eq "syncfs" and $tmpOption =~ /cache_type=(\w+)/i) {
            $type = $1;
        }
        $type = lc($type);
        if($fstype eq "all" or $type eq $fstype) {
            push(@directMP, "${mp}(${type})\n");
        }
    }
}
print @directMP;
exit 0;
