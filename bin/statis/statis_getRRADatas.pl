#!/usr/bin/perl
#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: statis_getRRADatas.pl,v 1.1 2005/10/18 16:21:14 het Exp $"

use strict;
use RRDs;
use NS::MonitorConfig3;
use NS::RRDCommandCommon;

if(scalar(@ARGV) != 4){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}
my ($collectionItem,$startTime,$endTime,$sampleInterval) = @ARGV;
my @subItemList = <STDIN>;
my $mc = new NS::MonitorConfig3();
$mc->loadDefs() or exit 1;
my $watchItemListRef = NS::RRDCommandCommon->getWatchItemFromCollectionItem($collectionItem);
my %rrdFileInfos;
for(my $i = 0; $i < scalar(@subItemList); $i += 2){
    my ($subItemId, $targetId) = @subItemList[$i,$i+1];            
    chomp($subItemId), chomp($targetId);
    my $rrdFileInfo = $rrdFileInfos{$targetId};
    if(!defined($rrdFileInfo)){
        $rrdFileInfos{$targetId} = $mc->loadRRDFilesInfo($targetId, $collectionItem);
        $rrdFileInfo = $rrdFileInfos{$targetId};
    }
    my (@opts,$datas,$x,$y);
    my $RRDFileDir=$mc->getRRDFilesDir($targetId,$collectionItem);
    my $rrdFileName = $$rrdFileInfo{$subItemId}->{'fname'};
    if(defined($rrdFileName) && -f "${RRDFileDir}/${rrdFileName}"){
        push (@opts,"-","-s","$startTime","-e","$endTime");
        push (@opts,"--step",$sampleInterval) if $sampleInterval;
        my $cnt=0;
        my %existDS;
        foreach my $watchItem (@$watchItemListRef){
            my $watchItemDef = $mc->getWatchItemDef($watchItem);
            my $collectionItemRef = $$watchItemDef{'collectionItem'};
            my $dataSources = $$collectionItemRef{'dataSources'};
            my @dataSource = split(",",$dataSources);
            foreach my $ds (@dataSource){
				if(!$existDS{$ds}){
                    push(@opts, "DEF:$ds=${RRDFileDir}/${rrdFileName}:$ds:AVERAGE");
                    $existDS{$ds} = 1;
                }
            }
        }
        foreach my $watchItem (@$watchItemListRef){
            my $watchItemDef = $mc->getWatchItemDef($watchItem);
            my $displayInfos = $$watchItemDef{'displayInfos'};
            my $maxFormat = $$displayInfos{'fmtMax'};
            $maxFormat =~ m/.*(%.*?f).*/;
            $maxFormat = $1;
            my $averageFormat = $$displayInfos{'fmtAverage'};
            $averageFormat =~ m/.*(%.*?f).*/;
            $averageFormat = $1;
            my $displayInfoArray = $$displayInfos{'displayInfo'};    
            foreach my $displayInfo (@$displayInfoArray){
                push(@opts, "CDEF:c${cnt}=$$displayInfo{'expression'}");
                push(@opts, "PRINT:c${cnt}:MAX:$maxFormat");
                $cnt++;
                push(@opts, "CDEF:c${cnt}=$$displayInfo{'expression'}");
                push(@opts, "PRINT:c${cnt}:AVERAGE:$averageFormat");
                $cnt++;
            }
        }
        ($datas,$x,$y) = RRDs::graph(@opts);
        if(!defined($datas)){
            $datas = ['nan','nan','nan','nan','nan','nan'];
        }
    }else{
        $datas = ['nan','nan','nan','nan','nan','nan'];
    }
    print "${subItemId} ${targetId} @${datas}\n";
}


exit 0;