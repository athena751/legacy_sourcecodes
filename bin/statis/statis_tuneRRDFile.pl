#!/usr/bin/perl
#
#       Copyright (c) 2001-2006 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: statis_tuneRRDFile.pl,v 1.3 2006/11/14 03:18:14 zhangjun Exp $"

# funciton: collect all information for every target

use strict;
use NS::NsguiCommon;
use NS::MonitorConfig;
use NS::MonitorConfig2;
use NS::ConstForStatis;
use RRDs;
my $comm  = new NS::NsguiCommon;
my $const = new NS::ConstForStatis;
if(scalar(@ARGV) != 2){
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}
my ($collectionItem, $subItem) = @ARGV;
my @mcList = (new NS::MonitorConfig(), new NS::MonitorConfig2());
foreach my $mc (@mcList){
    if(!$mc->loadDefs()){
        $comm->writeErrMsg($mc->error(),__FILE__,__LINE__+1);
        exit 1;
    }
    my $targets = $mc->getTargetList(); 
    if (!$targets){
        $comm->writeErrMsg($mc->error(),__FILE__,__LINE__+1);
        exit 1;
    }
    foreach my $target (@$targets){
        my $dir = $mc->getRRDFilesDir($target, $collectionItem);
        my $file = "${dir}/RRD${subItem}.rrd";
        if( -f $file ){
            if( ref($mc) eq "NS::MonitorConfig" ){
                my $tmpRrdFileName = "${file}.tmp.$$";
                `/bin/cp $file $tmpRrdFileName`;
                RRDs::tune($tmpRrdFileName,"-c");
                my $tuneErr = RRDs::error();
                if($tuneErr){
                    `/bin/rm -f $tmpRrdFileName`;
                    $comm->writeErrMsg($tuneErr,__FILE__,__LINE__+1);
                    exit 1;
                }
                if( system($const->SCRIPT_NSGUI_FSYNC." $tmpRrdFileName") !=0 ){
                    `/bin/rm -f $tmpRrdFileName`;
                    $comm->writeErrMsg($tuneErr,__FILE__,__LINE__+1);
                    exit 1;
                }
                if( system("/bin/mv -f $tmpRrdFileName $file") !=0 ){
                    `/bin/rm -f $tmpRrdFileName`;
                    $comm->writeErrMsg($tuneErr,__FILE__,__LINE__+1);
                    exit 1;
                }
            }else{
                RRDs::tune($file,"-c");
                my $tuneErr = RRDs::error();
                if($tuneErr){
                    $comm->writeErrMsg($tuneErr,__FILE__,__LINE__+1);
                    exit 1;    
                }
            }
        }
    }
}

exit 0;
