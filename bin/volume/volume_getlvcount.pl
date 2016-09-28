#!/usr/bin/perl -w
#       Copyright (c) 2004-2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: volume_getlvcount.pl,v 1.3 2005/09/29 03:43:48 liuyq Exp $"

use strict;

use NS::VolumeCommon;
use NS::VolumeConst;
use NS::NsguiCommon;

my $volumeCommon = new NS::VolumeCommon;
my $comm = new NS::VolumeConst;
my $nsguiCommon = new NS::NsguiCommon;

my $lvCount = $volumeCommon->getVgCountOfAll();
if($lvCount =~/^0x108000/){
	$comm->printErrMsg($lvCount);
	exit 1;
}

## get machine type 
my ($ldInfoHash, $ldhardlnHash);
my $isNashead = $nsguiCommon->isNashead();
my $totalLdCount = 0;

if ($isNashead == 0) {
    my $diskArraysHash = $volumeCommon->getArrayInfo("0");
    if(defined($$diskArraysHash{$comm->ERR_FLAG})){
        $comm->printErrMsg($$diskArraysHash{$comm->ERR_FLAG});
        exit 1;
    }

    foreach(keys %$diskArraysHash){
    	my $ldCount = $volumeCommon->getLdNumOfAll($_);
    	if($ldCount =~ /^0x108000/){
    		$comm->printErrMsg($ldCount);
    		exit 1;
    	}
    	$totalLdCount = $totalLdCount + $ldCount;
    }
}else{
    my $lunLdHash = $volumeCommon->getLunLdPathHash();
    if (defined($$lunLdHash{$comm->ERR_FLAG})) {
	    $comm->printErrMsg($$lunLdHash{$comm->ERR_FLAG});
	    exit 1;
	}
	$totalLdCount = scalar( keys (%$lunLdHash));
}
print "$totalLdCount $lvCount";
exit 0;