#!/usr/bin/perl
#
#       Copyright (c) 2001-2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: nasswitch_collector.pl,v 1.2 2005/11/01 04:52:33 het Exp $"

# funciton: collect all nas switch information for every target

use strict;
use NS::General3;
use NS::ConstInfo;
use NS::Common;
use NS::MonitorConfig3;
use NS::NASCollector3;
use NS::NsguiCommon;

my $mc3                = new NS::MonitorConfig3;
my $collector3         = new NS::NASCollector3;
my $Common             = new NS::Common;
my $ConstInfo          = new NS::ConstInfo;
my @collectionItemList = ($ConstInfo->NFS_VIRTUAL_EXPORT, 
                          $ConstInfo->NFS_VIRTUAL_SERVER, 
                          $ConstInfo->NFS_VIRTUAL_NODE);
my $currentMinute      = int((time + 2) / 60);

if (! -t 0) {
    $SIG{INT} = $SIG{QUIT} = $SIG{TSTP} =
    $SIG{TTIN} = $SIG{TTOU} = $SIG{HUP} = 'IGNORE';
}
my $errMsg = "";

if(!$mc3->isActive()){
    $Common->writeSyslog($ConstInfo->getCollector(),
                            "main",
                            $ConstInfo->getSyslogDebug(),
                            "This node is not active.");
    exit(0);    
}


if(!$mc3->loadDefs()){
    $Common->writeSyslog($ConstInfo->getCollector(),"main",$ConstInfo->getSyslogErr(),$ConstInfo->getColThreadLoadDefErr());  
    exit(0);    
}
my $targets = $mc3->getTargetList(); 
if (!$targets){
    $Common->writeSyslog($ConstInfo->getCollector(),"main",$ConstInfo->getSyslogDebug(),$mc3->error());
    exit(0);    
}

# get the maintaince status. return 0 if this node type is single.
# return 1 if group0 and group1 and group2 are on this node.
# return 2 if group0 and group1 are on the other node. group2 is on this node.
# return 3 when errors.
my $adminTargetStatus = &checkNodeStatus();
if($adminTargetStatus == 3){
    $Common->writeSyslog($ConstInfo->getCollector(),"main",$ConstInfo->getSyslogDebug(),"Cluster status errors are found.");
    exit 0;
}
my $nsgui = new NS::NsguiCommon;
my $adminNodeNo = $nsgui->getMyNodeNo();

foreach my $collectionItem (@collectionItemList){
    my $collectionItemDef = $mc3->getCollectionItemDef($collectionItem);
    my @list              = split(",",$collectionItemDef->{"kind"});
    foreach my $target (@$targets) {
        my $targetDef     = $mc3->getTargetDef($target);
        my $targetType    = $targetDef->{"type"};
        my $addr          = $targetDef->{"address"};
        if(grep(/\b${targetType}\b/,@list)){
            my $subItemHashRef = &getSubItemList($mc3, $currentMinute,$target,$collectionItem);  
            while(my ($interval, $subItemListRef) = each %$subItemHashRef) {          
                if(scalar(@$subItemListRef) != 0){
                    if($collectionItem ne $ConstInfo->NFS_VIRTUAL_NODE){
                        &filterSubItemList($addr, $adminTargetStatus, $adminNodeNo, 
                            $collectionItem, $subItemListRef);            
                    }else{
                        &filterSubItemList4Node($addr, $target, $adminTargetStatus, $adminNodeNo, $subItemListRef);
                    }
                }
                if(scalar(@$subItemListRef) == 0){
                    next;
                }
                my $pid;
                for(my $i = 0; $i < 3 && ($pid = fork() ) == -1; $i++) {
                    sleep 5;
                } 
                if($pid==0){
                    collectorThread($mc3,$target,$collectionItem,$subItemListRef,$interval);
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
    my ($mc3,$target,$collectionItem, $subItemListRef,$interval)=@_;
    # 1. get dir of RRD file about this $collectionItem and $target,if 
    # if failed, write syslog
    my $dir=$mc3->getRRDFilesDir($target,$collectionItem);
    if(!$dir){
        $Common->writeSyslog($ConstInfo->getCollectorThread(),"main",$ConstInfo->getSyslogDebug(),$mc3->error());
    }else{
        $mc3->makeDir($dir);
    }
    # 2.lock RRDfile:if $target or $collectorItem doesn't exist,then write syslog and exit(1);
    # else if locking failed,then exit(0);           
    my $lockFlag=$mc3->lockRRD($target, $collectionItem);
    if(!$lockFlag){
        $Common->writeSyslog($ConstInfo->getCollectorThread(),"main",$ConstInfo->getSyslogErr(),$mc3->error());
        exit(1);
    }            
    # b)load information of RRDFile,if failed,then write syslog       
    my $rfi = $mc3->loadRRDFilesInfo($target, $collectionItem);
    if(!$rfi){
        $Common->writeSyslog($ConstInfo->getCollectorThread(),"main",$ConstInfo->getSyslogDebug(),$mc3->error());
    }
    # c)collect information  for $collectionItem of $target
    my $General3=new NS::General3;        
    my $result=$General3->collector($mc3, $target, $collectionItem, $subItemListRef,$interval);
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
        my $saveFlag=$mc3->saveRRDFilesInfo($target, $collectionItem, $rfi);
        if(!$saveFlag){
            $Common->writeSyslog($ConstInfo->getCollectorThread(),"main",$ConstInfo->getSyslogDebug(),$mc3->error());
        }
    }
    # update the date of rrd file
    my $updateTime=undef;
    if($result){
        $updateTime=$result->{"time"};
    }else{
        $updateTime=time;
    }
    # 6.unlock RRD file,if failed write syslog
    my $unlockFlag=$mc3->unlockRRD($target,$collectionItem);
    if(!$unlockFlag){
        $Common->writeSyslog($ConstInfo->getCollectorThread(),"main",$ConstInfo->getSyslogDebug(),$mc3->error());
        exit(1);
    }     
    # 7 exit normally
    exit(0);    
}

sub checkNodeStatus(){
    return system("/opt/nec/nsadmin/bin/cluster_checkStatus.pl") >> 8;    
}

#Function: get subitem list collected on special node.
#Parameters:
#       $addr - ip address of special node.
#       $adminTargetStatus - status of FIP.
#       $adminNo - the node number of admin target.
#       $collectionItem - collection Item Id
#       $subItemListRef - reference of subitem list.
#Return:
#       none
sub filterSubItemList(){
    my ($addr, $adminTargetStatus, $adminNo, $collectionItem, $subItemListRef) = @_;
    my $nodeNo = $collector3->getMyNodeNumber($addr);
    
    # get the sub item hashset, sub item id is key, service group is value.
    # if this node type is single, all the service groups are g0.
    # if collectionItem is "node", undef is return;
    my $serviceGroupHashRef = $collector3->getServiceGroupHash($collectionItem);            
    my $isReservedTarget = ($adminTargetStatus == 1 && $nodeNo == $adminNo) ||
                            ($adminTargetStatus == 2 && $nodeNo != $adminNo);
    if($adminTargetStatus == 0){
        for(my $i = 0; $i < scalar(@$subItemListRef); $i++){  
            if($$serviceGroupHashRef{$$subItemListRef[$i]} ne "both" &&
                $$serviceGroupHashRef{$$subItemListRef[$i]} ne "group${nodeNo}") {  
                splice (@$subItemListRef, $i, 1); #delete this element
                $i--;
            }
        }
    }else{
        if($collectionItem eq $ConstInfo->NFS_VIRTUAL_EXPORT){
            for(my $i = 0; $i < scalar(@$subItemListRef); $i++){  
                if($isReservedTarget){
                    if($$serviceGroupHashRef{$$subItemListRef[$i]} ne "both" &&
                        $$serviceGroupHashRef{$$subItemListRef[$i]} ne "group${nodeNo}") {  
                        splice (@$subItemListRef, $i, 1); #delete this element
                        $i--;
                    }
                }else{
                    if($$serviceGroupHashRef{$$subItemListRef[$i]} ne "group${nodeNo}") {  
                        splice (@$subItemListRef, $i, 1); #delete this element
                        $i--;
                    }
                }
            }                            
        }elsif($collectionItem eq $ConstInfo->NFS_VIRTUAL_SERVER){
            for(my $i = 0; $i < scalar(@$subItemListRef); $i++){  
                if($isReservedTarget){
                    if(!defined($$serviceGroupHashRef{$$subItemListRef[$i]})) {  
                        splice (@$subItemListRef, $i, 1); #delete this element
                        $i--;
                    }
                }else{
                    splice (@$subItemListRef, $i, 1); #delete this element
                    $i--;
                }
            }            
        }  
    }    
}

sub filterSubItemList4Node(){
    my ($addr, $target, $adminTargetStatus, $adminNo, $subItemListRef) = @_;
    my $nodeNo = $collector3->getMyNodeNumber($addr);
    my $isReservedTarget = ($adminTargetStatus == 1 && $nodeNo == $adminNo) ||
                            ($adminTargetStatus == 2 && $nodeNo != $adminNo);
    if($adminTargetStatus == 0){
        for(my $i = 0; $i < scalar(@$subItemListRef); $i++){  
            if($$subItemListRef[$i] ne $target) {  
                splice (@$subItemListRef, $i, 1); #delete this element
                $i--;
            }
        }
    }else{
        for(my $i = 0; $i < scalar(@$subItemListRef); $i++){  
            if($isReservedTarget){
                if($$subItemListRef[$i] ne $target) {  
                    splice (@$subItemListRef, $i, 1); #delete this element
                    $i--;
                }
            }else{
                splice (@$subItemListRef, $i, 1); #delete this element
                $i--;
            }
        }                            
    }    
}

#Function: get subitem list which must be collected at current time.
#Parameters:
#       $mc3 - Object of MonitorConfig3
#       $currentMinute - Current Minute
#       $target - Target Id of Sub Node
#       $collectionItem - collection Item Id
#Return:
#       reference of subitem hash (key=interval(sec), value=reference of subitemId).

sub getSubItemList(){
    my ($mc3, $currentMinute,$target,$collectionItem) = @_;
    my $adminTargetId = $collector3->getAdminTargetId($mc3,$target);
    my $samplingConfs = $mc3->getSamplingConfs($adminTargetId, $collectionItem);
    my %result;
    my @subItemList = ();
    foreach(@$samplingConfs){
        my $subItemListRef = $result{$_->{'interval'}};
        if(!defined($subItemListRef)){
            $subItemListRef = [];
        }                
        push(@$subItemListRef,$_->{'id'}) if($currentMinute % ($_->{'interval'}/60) == 0);
        $result{$_->{'interval'}} = $subItemListRef;
    }  
    return \%result;  
}

