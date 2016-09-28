#!/usr/bin/perl
#
#       Copyright (c) 2001-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: collectall.pl,v 1.5 2007/03/07 05:03:58 zhangjun Exp $"

# funciton: collect all information for every target

use strict;
use NS::General;
use NS::ConstInfo;
use NS::Common;
use NS::MonitorConfig;
use NS::MonitorConfig2;
use NS::NsguiCommon;
use vars qw{@fileList};

my $currentMinute      = int((time + 2) / 60);
my $Common             = new NS::Common;
my $ConstInfo          = new NS::ConstInfo;
my @mcList             = (new NS::MonitorConfig(), new NS::MonitorConfig2());
my @collectionItemList = ($ConstInfo->getCPUStates(), 
                          $ConstInfo->getNetworkIO(), 
                          $ConstInfo->getFilesystem(), 
                          $ConstInfo->getNAS_LV_IO(),
                          $ConstInfo->getAnti_Virus_Scan());
my $nsguiCommon          = new NS::NsguiCommon;
if($nsguiCommon->checkRPQLicense($ConstInfo->getRpqNum())==0){
    push(@collectionItemList,$ConstInfo->getFilesystem_Quantity())
}

if (! -t 0) {
    $SIG{INT} = $SIG{QUIT} = $SIG{TSTP} =
    $SIG{TTIN} = $SIG{TTOU} = $SIG{HUP} = 'IGNORE';
}
my $errMsg = "";

if(!$mcList[0]->isActive()){
    $Common->writeSyslog($ConstInfo->getCollector(),
                            "main",
                            $ConstInfo->getSyslogDebug(),
                            "This node is not active");
    exit(0);    
}

foreach my $mc (@mcList){
    if(!$mc->loadDefs()){
        $Common->writeSyslog($ConstInfo->getCollector(),"main",$ConstInfo->getSyslogErr(),$ConstInfo->getColThreadLoadDefErr());  
        next;
    }
    my $targets = $mc->getTargetList(); 
    if (!$targets){
        $Common->writeSyslog($ConstInfo->getCollector(),"main",$ConstInfo->getSyslogDebug(),$mc->error());
        next;
    }
    foreach my $collectionItem (@collectionItemList){
        my $collectionItemDef = $mc->getCollectionItemDef($collectionItem);
        if(!defined($collectionItemDef)){
            next;
        }
        my @list              = split(",",$collectionItemDef->{"kind"});
        foreach my $target (@$targets) {
            my $targetDef     = $mc->getTargetDef($target);
            my $targetType    = $targetDef->{"type"};
            if(!$mc->getTargetStatus($target, $collectionItem)){
                 $Common->writeSyslog($ConstInfo->getCollectorThread(),"main",$ConstInfo->getSyslogDebug(),$target." is ".$mc->error());
                 next;    
            }
            my $interval = $mc->getInterval($target, $collectionItem);
            if($currentMinute % ($interval/60)){
                next;
            }
            
            if ( $collectionItem eq $ConstInfo->getAnti_Virus_Scan() ){
                my $cmdGetLicense = $ConstInfo->CMD_GET_LICENSE;
                my @result=`$cmdGetLicense`;
                my $hasNvavsLicense="yes";
                foreach(@result){
                    chomp;
                    if( $_ eq 'nvavs:0' ){
                        $hasNvavsLicense="no";
                        last;
                    }
                }
                if( $hasNvavsLicense eq "no" ){
                    next;
                }
            }
            
            if(grep(/\b${targetType}\b/,@list)){        
                my $pid;
                for(my $i = 0; $i < 3 && ($pid = fork() ) == -1; $i++) {
                    sleep 5;
                } 
                if($pid==0){
                    collectorThread($mc,$target,$collectionItem,$interval);
                    exit(0);
                }elsif($pid>0){
                }else{
                    $Common->writeSyslog($ConstInfo->getCollector(),"main",$ConstInfo->getSyslogErr(),$ConstInfo->getColThreadCantFork());
                }
            }
        }
    } 
}
while(wait()!=-1){
   # until all childprocesses end
} 
exit(0);

sub collectorThread()
{
    my ($mc,$target,$collectionItem,$interval)=@_;
    # 1. get dir of RRD file about this $collectionItem and $target,if 
    # if failed, write syslog
    my $dir=$mc->getRRDFilesDir($target,$collectionItem);
    if(!$dir){
        $Common->writeSyslog($ConstInfo->getCollectorThread(),"main",$ConstInfo->getSyslogDebug(),$mc->error());
    }else{
        $mc->makeDir($dir);
    }
    # 2.lock RRDfile:if $target or $collectorItem doesn't exist,then write syslog and exit(1);
    # else if locking failed,then exit(0);           
    my $lockFlag=$mc->lockRRD($target, $collectionItem);
    if(!$lockFlag){
        $Common->writeSyslog($ConstInfo->getCollectorThread(),"main",$ConstInfo->getSyslogErr(),$mc->error());
        exit(1);
    }            
    # 3.collect information for each subItem of collectorItem
    # a)get stockPeriod of current target to my $stockPeriod,if get failed,write syslog
    my $stockPeriod=$mc->getStockPeriod($target, $collectionItem);
    if(!$stockPeriod){
        $Common->writeSyslog($ConstInfo->getCollectorThread(),"main",$ConstInfo->getSyslogDebug(),$mc->error());              
    }
    # b)load information of RRDFile,if failed,then write syslog       
    my $rfi = $mc->loadRRDFilesInfo($target, $collectionItem);
    if(!$rfi){
        $Common->writeSyslog($ConstInfo->getCollectorThread(),"main",$ConstInfo->getSyslogDebug(),$mc->error());
    }
    # c)collect information  for $collectionItem of $target
    my $General=new NS::General; 
    my $result=$General->collector($mc, $target,$collectionItem,$stockPeriod,$interval);
    # d)if $result and $rfi isn't undef,then update information of RRD file,and save information of RRD file
    # I)update information of RRD file,if failed,write syslog.
    if($rfi){               
        my ($filelistflag, $subItemID, $rrdFileName, $size, $fname, $filename, $subItemInfo, $key, $val);
        my @infoExistIndex    = ();
        my @updateInfo        = ();
        while(($key, $val)= each %{$rfi}) {
            # (1)if RRD file correspondent to current element isn't in the filelist in the $dir,then delete it 
            if($dir){
                $fname    = $val->{"fname"};
                $filename = $dir."/".$fname;
                if(!(-f $filename)){
                    delete($rfi->{$key});
                }
            }
            #(2) update it
            if($result){
                my $array     = $result->{"updateInfo"};
                @updateInfo   = @$array;
                my $updateLen = @updateInfo;
                if($updateLen > 0){
                    my $index = -1;
                    foreach $subItemInfo(@updateInfo){
                        $index++;
                        if($subItemInfo->{"subItemID"} eq $val->{"id"}){
                            $val->{"info"} = $subItemInfo->{"info"};
                            $val->{"size"} = $subItemInfo->{"size"};
                            push(@infoExistIndex, $index);
                            next; 
                        } 
                    }                
                } 
            }                  
        }
             
        #III) add information of new RRD files to information of RRD file($rfi)
        if($result){
            my %subInfo;
            my $array      = $result->{"createInfo"};
            my @createInfo = @$array;
            my $createlen  = @createInfo;
            if($createlen > 0){
                foreach $subItemInfo(@createInfo){
                    my %subInfo;
                    $subInfo{"id"}        = $subItemInfo->{"subItemID"};
                    $subInfo{"size"}      = $subItemInfo->{"size"};
                    $subInfo{"fname"}     = $subItemInfo->{"rrdFileName"};
                    $subInfo{"info"}      = $subItemInfo->{"info"};
                    $$rfi{$subInfo{"id"}} = \%subInfo;
                }
            }
            if($rfi){
                $array      = $result->{"updateInfo"};
                @updateInfo = @$array;
                my @key     = keys(%$rfi);
                if(scalar(@key) <= 0){
                    my $existInfo;
                    foreach $existInfo(@updateInfo){
                        my %rfiContent = %$rfi;
                        if(!exists($rfiContent{$existInfo->{"id"}})){
                            my %addInfo;
                            $addInfo{"id"}        = $existInfo->{"subItemID"};
                            $addInfo{"size"}      = $existInfo->{"size"};
                            $addInfo{"fname"}     = $existInfo->{"rrdFileName"};
                            $addInfo{"info"}      = $existInfo->{"info"};
                            $$rfi{$addInfo{"id"}} = \%addInfo;
                        }
                    }
                }else{                           
                    if(scalar(@infoExistIndex) < scalar(@updateInfo)){                       
                        for(my $i = 0; $i < scalar(@updateInfo); $i++ ){
                            my $existFlag = 0;
                            my $info;
                            foreach $info (@infoExistIndex){
                                if( $info == $i ){
                                    $existFlag = 1;
                                    last;
                                }
                            }
                            if($existFlag==0){
                                my %subInfo1;
                                $subInfo1{"id"}=$updateInfo[$i]->{"subItemID"};
                                $subInfo1{"size"}=$updateInfo[$i]->{"size"};
                                $subInfo1{"fname"}=$updateInfo[$i]->{"rrdFileName"};
                                $subInfo1{"info"}=$updateInfo[$i]->{"info"};
                                $$rfi{$subInfo1{"id"}}=\%subInfo1;          
                            }
                        }  
                    }
                }               
            } 
        }
        
        # II)save information of RRD file,if failed,write syslog
        my $saveFlag=$mc->saveRRDFilesInfo($target, $collectionItem, $rfi);
        if(!$saveFlag){
            $Common->writeSyslog($ConstInfo->getCollectorThread(),"main",$ConstInfo->getSyslogDebug(),$mc->error());
        }
    }
    # 6.unlock RRD file,if failed write syslog
    my $unlockFlag=$mc->unlockRRD($target,$collectionItem);
    if(!$unlockFlag){
        $Common->writeSyslog($ConstInfo->getCollectorThread(),"main",$ConstInfo->getSyslogDebug(),$mc->error());
        exit(1);
    }     
    # 7 exit normally
    exit(0);    
}
