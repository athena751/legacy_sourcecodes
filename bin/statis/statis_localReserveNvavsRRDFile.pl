#!/usr/bin/perl
#
#       Copyright (c) 2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: statis_localReserveNvavsRRDFile.pl,v 1.2 2007/04/02 05:53:15 yangxj Exp $"

use strict;
use NS::MonitorConfig;

my $COLLECTIONITEM_NVAVS   = "Anti_Virus_Scan";

# Get arguments
my $cpName = shift;

# Prepare
my $mc = new NS::MonitorConfig();
$mc->loadDefs() or exit 1;

my @collectionItemList = ($COLLECTIONITEM_NVAVS);

foreach my $colItem(@collectionItemList){
    my $targets = $mc->getTargetList();
    foreach my $target(@$targets){
        my @needDelIDArr = ();
        my $rrdFileDir = $mc->getRRDFilesDir($target, $colItem);
        next if (! -d $rrdFileDir);

        my $rfi = $mc->loadRRDFilesInfo($target, $colItem);
        next if (!$rfi);
        
        while(my ($key, $val)= each %{$rfi}){
            my $curCpName = $val->{"info"}->{"ComputerName"};
            my $curHost = $val->{"info"}->{"Host"};
            if(($curCpName eq $cpName) && (scalar(grep(/^$curHost$/,@ARGV)) == 0)){
                #current key need delete
                push(@needDelIDArr,$key);
            }
        }
        if(scalar(@needDelIDArr) != 0){
            $mc->deleteRRDFiles($target,$colItem,\@needDelIDArr);
        }
    }
}
exit 0;
