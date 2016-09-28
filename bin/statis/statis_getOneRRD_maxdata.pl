#!/usr/bin/perl 
#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: statis_getOneRRD_maxdata.pl,v 1.2 2005/10/20 15:04:42 pangqr Exp $"

use strict;
use RRDs;
use NS::MonitorConfig;
use NS::MonitorConfig2;
my ($targetID,$startTime,$endTime,$rrdFileName,$collectionItem,$watchItem,$sampleInterval,$isInvestGraph,$subItemId);
$targetID = shift;
$collectionItem = shift;
$watchItem = shift;
$startTime = shift;
$endTime = shift;
$sampleInterval=shift;
$isInvestGraph=shift;
$subItemId = shift;

#$targetID = "192.168.1.118";
#$collectionItem = "Filesystem";
#$watchItem = "Disk_Used_Rate";
#$startTime = 1019458916;
#$endTime = 1019545316;

my $mc;
if($isInvestGraph){
  $mc=new NS::MonitorConfig2();
}else{
  $mc = new NS::MonitorConfig()
}
$mc->loadDefs() or exit 1;

my $RRDFileDir=$mc->getRRDFilesDir($targetID,$collectionItem);
my $rrdFileInfo = $mc->loadRRDFilesInfo($targetID, $collectionItem);
my $watchItemDef = $mc->getWatchItemDef($watchItem);
my $displayInfos = $$watchItemDef{'displayInfos'};
my $maxFormat = "%lf";
my $displayInfoArray = $$displayInfos{'displayInfo'};
my $collectionItemRef = $$watchItemDef{'collectionItem'};
my $dataSources = $$collectionItemRef{'dataSources'};
my @dataSource = split(",",$dataSources);
my $val = $$rrdFileInfo{$subItemId};
my @opts;
push (@opts,"-","-s","$startTime","-e","$endTime");
push (@opts,"--step",$sampleInterval) if $sampleInterval;
$rrdFileName = $$val{'fname'};
foreach my $ds (@dataSource)
{
    push(@opts, "DEF:$ds=${RRDFileDir}/$rrdFileName:$ds:AVERAGE");    
}

    my $cnt=0;
foreach my $displayInfo (@$displayInfoArray)
{        
    push(@opts, "CDEF:c${cnt}=$$displayInfo{'expression'}");
    push(@opts, "PRINT:c${cnt}:MAX:$maxFormat");
    $cnt++;                      
}
my $max = getMaxInOneRRD(\@opts);
print $max;
exit 0;
sub getMaxInOneRRD
{
    my $option = shift;
    my ($tmpMax,$x,$y,$result);
    $result = 0;
    ($tmpMax,$x,$y) = RRDs::graph(@$option);
    foreach (@$tmpMax)
    {
        $result = ($_ > $result)? $_ : $result;
    }
    return $result;    
}
__END__
