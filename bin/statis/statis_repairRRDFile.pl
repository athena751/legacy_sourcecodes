#!/usr/bin/perl
#
#       Copyright (c) 2006-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: statis_repairRRDFile.pl,v 1.3 2007/03/07 05:04:28 zhangjun Exp $"

# funciton: collect all information for every target

use strict;

use RRDs;
use NS::ConstInfo;
use NS::Common;
use NS::NsguiCommon;
use NS::MonitorConfig;
use NS::MonitorConfig2;

my $ConstInfo   = new NS::ConstInfo;
my $Common      = new NS::Common;
my $NsguiCommon = new NS::NsguiCommon;
my @mcList      = (new NS::MonitorConfig(), new NS::MonitorConfig2());
my @collectionItemList  =   ($ConstInfo->getCPUStates(),
                            $ConstInfo->getNetworkIO(),
                            $ConstInfo->getFilesystem(),
                            $ConstInfo->getNAS_LV_IO(),
                            $ConstInfo->getAnti_Virus_Scan());

my $flag=0;
foreach my $mc (@mcList){
    if( $mc->loadDefs() eq 0 ){
        $NsguiCommon->writeErrMsg($mc->error(),__FILE__,__LINE__+1);
        exit 1;
    }
    my $targets = $mc->getTargetList(); 
    if (!$targets){
        $NsguiCommon->writeErrMsg($mc->error(),__FILE__,__LINE__+1);
        exit 1;
    }
    foreach my $target (@$targets){
        foreach my $collectionItem (@collectionItemList){
            if(!defined($mc->getCollectionItemDef($collectionItem))){
                next;
            }
            my $dir = $mc->getRRDFilesDir($target, $collectionItem);
            if (!defined($dir)){
                $NsguiCommon->writeErrMsg($mc->error(),__FILE__,__LINE__+1);
                exit 1;
            }
            my $rfi =$mc->loadRRDFilesInfo($target,$collectionItem);
            if (!defined($rfi)){
                $NsguiCommon->writeErrMsg($mc->error(),__FILE__,__LINE__+1);
                exit 1;
            }
            foreach my $subItem (keys %$rfi){
                my $fileName = $$rfi{$subItem}{'fname'};
                my $rrdFileName = join("",($dir,"/",$fileName));
                if(-f $rrdFileName){
                    RRDs::info($rrdFileName);
                    my $infoErr = RRDs::error();
                    my $brokenErr = $ConstInfo->ERR_STRING_RRD_FILE_BROKEN;
                    if($infoErr =~ /\Q${brokenErr}\E\s*$/){
                        my $errString   = join("",("[",$ConstInfo->ERR_CODE_RRD_FILE_BROKEN,"] '",$rrdFileName,"'",$ConstInfo->ERR_STRING_RRD_FILE_BROKEN_SYSLOG));
                        $Common->writeSyslog('statis_repairRRDFile.pl','main',$ConstInfo->getSyslogWarning(),$errString);
                        if(!$mc->deleteRRDFile($target,$collectionItem,$subItem) ){
                            $NsguiCommon->writeErrMsg($mc->error(),__FILE__,__LINE__+1);
                            $flag=1;
                        }
                    }
                }
            }
        }
    }
}

if($flag==1){
    exit 1;
}
exit 0;
