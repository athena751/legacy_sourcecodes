#!/usr/bin/perl -w
#
#       Copyright (c) 2001-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: volume_list.pl,v 1.19 2007/09/21 01:56:22 wanghb Exp $"

## Function:
##     get volume info which GUI volume list page required
##
## Parameters:
##     $exportGroup	-- export  group specified by GUI
##  
## Output:
##     STDOUT
##         NV:     volumeName   mountPoint  poolNameAndNo raidType  capacity    fsType  quota   replication updateAccessTime    snapshot    accessmode  isMounted norecovery dmapi useRate useGfs aid aname operation resultCode useCode fsSize wpPeriod
##         NASHEAD volumeName   mountPoint  storage lun     capacity    fsType,quota    replication updateAccessTime    snapshot    accessmode  isMounted norecovery dmapi useRate useGfs useCode fsSize wpPeriod
##     STDERR
##         error message and error code
##
## Returns:
##     0 -- success 
##     1 -- failed

use strict;
use NS::NsguiCommon;
use NS::VolumeCommon;
use NS::VolumeConst;
use POSIX;

my $nsguiCommon  = new NS::NsguiCommon;
my $volumeCommon = new NS::VolumeCommon;
my $volumeConst  = new NS::VolumeConst;

if(scalar(@ARGV) != 1){
     $volumeConst->printErrMsg($volumeConst->ERR_PARAM_WRONG_NUM);
     exit 1;
}

my $exportGroup = shift;

my $mpsOption = $volumeCommon->getMountOptionsFromCfstab();
if(defined($$mpsOption{$volumeConst->ERR_FLAG})){
    $volumeConst->printErrMsg($$mpsOption{$volumeConst->ERR_FLAG});
    exit 1;
}

my @validMP = grep(/^\Q$exportGroup\E\/+\S+/ , keys(%$mpsOption));

## get mounted  mount point
my $mountMP = $volumeCommon->getMountMP();
if (defined($$mountMP{$volumeConst->ERR_FLAG})) {
    $volumeConst->printErrMsg($$mountMP{$volumeConst->ERR_FLAG});
    exit 1;
}

## get replic mount point and original mount point
my ($exportsMP, $importsMP, $errCode) = $volumeCommon->getReplicationMP();
if (defined($errCode)) {
    $volumeConst->printErrMsg($errCode);
    exit 1;
}

## get VG Name,VG Size and PV Name from vgdisplay command
my $vgInfo = $volumeCommon->getVgdisplayInfo();
if ((defined($$vgInfo{$volumeConst->ERR_FLAG}))&&($$vgInfo{$volumeConst->ERR_FLAG} ne "")){ 
    $volumeConst->printErrMsg($$vgInfo{$volumeConst->ERR_FLAG});
    exit 1;
}

## get machine type 
my ($ldInfoHash, $ldhardlnHash);
my $isNashead = $nsguiCommon->isNashead();

if ($isNashead == 0) {
    ## NV :  get LD info from "iSAdisklist -l  -aid  $aid"            
    $ldInfoHash = $volumeCommon->getLdInfo("1", "1");
    if (defined($$ldInfoHash{$volumeConst->ERR_FLAG})) {
        $volumeConst->printErrMsg($$ldInfoHash{$volumeConst->ERR_FLAG});
        exit 1;
    }
}

##NASHEAD: get info from ldhardln.conf and nasnickname file              
$ldhardlnHash = $volumeCommon->getLdhardlnStorage();
if (defined($$ldhardlnHash{$volumeConst->ERR_FLAG})) {
    $volumeConst->printErrMsg($$ldhardlnHash{$volumeConst->ERR_FLAG});
    exit 1;
}

my $dfInfo = $volumeCommon->getDfInfo();
if (defined($$dfInfo{$volumeConst->ERR_FLAG})) {
    $volumeConst->printErrMsg($$dfInfo{$volumeConst->ERR_FLAG});
    exit 1;
}

my $gfsVolumes = {};
if ($isNashead == 1) {
    $gfsVolumes = $volumeCommon->getGfsVolumes();
    if(defined($$gfsVolumes{$volumeConst->ERR_FLAG})){
        $volumeConst->printErrMsg($$gfsVolumes{$volumeConst->ERR_FLAG});
        exit 1;
    }
}

## get asynchronous volume info
my $tmpFile = $volumeConst->FILE_ASYNC_TMP;
my $hash = $volumeCommon->getAsyncVolFromFile($tmpFile, "mp");
if(defined($$hash{$volumeConst->ERR_FLAG})){
    $volumeConst->printErrMsg($$hash{$volumeConst->ERR_FLAG});
    exit 1;
}

####print out the lv Count and ld count start
my $vgCount = scalar(keys (%$vgInfo));
my $totalLdCount = 0;

if ($isNashead == 0) {
    my $diskArraysHash = $volumeCommon->getArrayInfo("0");
    if(defined($$diskArraysHash{$volumeConst->ERR_FLAG})){
        $volumeConst->printErrMsg($$diskArraysHash{$volumeConst->ERR_FLAG});
        exit 1;
    }

    foreach(keys %$diskArraysHash){
    	my $ldCount = $volumeCommon->getLdNumOfAll($_);
    	if($ldCount =~ /^0x108000/){
    		$volumeConst->printErrMsg($ldCount);
    		exit 1;
    	}
    	$totalLdCount = $totalLdCount + $ldCount;
    }
}else{
    my $lunLdHash = $volumeCommon->getLunLdPathHash();
    if (defined($$lunLdHash{$volumeConst->ERR_FLAG})) {
	    $volumeConst->printErrMsg($$lunLdHash{$volumeConst->ERR_FLAG});
	    exit 1;
	}
	$totalLdCount = scalar( keys (%$lunLdHash));
}
####print out the lv Count and ld count end

## get extend volume info and delete it from $hash
my $oneVolHashRef = ();
my %allAsyncExtendHash = ();
foreach (keys %$hash) {
    $oneVolHashRef = $$hash{$_};
    if (defined($$oneVolHashRef{"operation"}) 
        && ($$oneVolHashRef{"operation"} eq "extend")) {
        $allAsyncExtendHash{$_} = $oneVolHashRef;
        delete($$hash{$_});
    }
}

## get volume info of each valid mount point
my ($isMounted, $lvPath, $access, $replic);
my ($lvName, $mp, $capacity, $fsType, $quota, $replication, $updateAccessTime, $norecovery , $snapshot , $dmapi , $useRate);
my ($aid, $aname, $poolNameAndNo, $raidType);
my ($storage, $lun, $wwnn);
my $volumeInfo;
my ($fsSize, $wpPeriod);
foreach (@validMP) {

        ## get mount point
        $mp = $_;
        
        if (defined($$hash{$mp})) {
            next;
        }      
        ## get $isMounted, $fsType, $access, $quota, $updateAccessTime
        my $mpOption = $$mpsOption{$mp};
        $lvPath = $$mpOption{"lvpath"};
        $fsType = $$mpOption{"ftype"};
        $access = $$mpOption{"access"};
        $quota = defined($$mpOption{"quota"}) ? "on" : "off";
        $replic = defined($$mpOption{"repli"}) ? "1" : "0";
        $updateAccessTime = defined($$mpOption{"noatime"}) ? "on" : "off";
        $norecovery = defined($$mpOption{"norecovery"}) ? "on" : "off";
        $dmapi = defined($$mpOption{"dmapi"}) ? "on" : "off";
        
        if (defined($$dfInfo{$mp})){
            ($fsSize, $useRate) = (split(/\s+/, $$dfInfo{$mp}))[1, 4];
            $fsSize = $fsSize / 1024 / 1024;
            $fsSize = sprintf("%.1f", $fsSize);
            chop($useRate);
        }else{
            $useRate = "--";
            $fsSize = "--";
        }
        ## set $isMounted
        if (defined($$mountMP{$mp})) {
            $isMounted = "mount";    
        } else {
            $isMounted = "umount";
        }
        
        ## get $lvName
        $lvName = (split(/\//, $lvPath))[3];
        
        ## get $replication
        $replication = $volumeCommon->getReplicationType($replic, $mp, $importsMP, $exportsMP);
        
        ## get $capacity and $ldPathList
        my $vgName = $lvName;
        my $ldPathList;
        if (defined($$vgInfo{$vgName})) {
            ($capacity, $ldPathList) = split(":", $$vgInfo{$vgName});
        } else {
            $capacity = "--";
            $ldPathList = "--";  ### for not exist vg
        }
        
        #get $snapshot
        $snapshot = $volumeCommon->getSnapshot($mp);
        
        ## if $snapshot=0, that is no limit(100%), 
        ## else round-up the ($snapshot/10) and then multiply 10
        if (($snapshot eq "--") || ($snapshot == 0)) {
        	$snapshot = 100;	
        } else {
        	$snapshot = (POSIX::ceil($snapshot / 10)) * 10;
        }
       
        ## get share code
        my $useCode = $volumeCommon->isUsedMP($mp);
        if($useCode eq $volumeConst->ERR_OPEN_FILE_READING){
            $volumeConst->printErrMsg($useCode);
            exit 1;
        }
        
        ## get write-protect command code
        $wpPeriod = "--";
        my $cmd_sxfsprotect = $volumeConst->CMD_SXFS_PROTECT;
        if(!(-x $cmd_sxfsprotect)){
           $volumeConst->printErrMsg($volumeConst->ERR_EXECUTE_SXFS_PROTECT);
           exit 1;
        }
        if($fsType eq "sxfsfw"){
			$wpPeriod = "-1";     	
        }elsif($isMounted eq "mount"){
        	my @result = `$cmd_sxfsprotect -o $mp 2>/dev/null`;
        	my $retCode = $? /256;
        	if($retCode == 6){
        		$wpPeriod = "-1";
        	}else{
        		if(defined($result[0]) && 
        		  ($result[0] =~/^\s*(\d+)\s+days\s*$/)){
        			$wpPeriod = $1;
        		}
        	}
        }

        my $useGfs = defined($$gfsVolumes{$lvName}) ? "true" : "false";

        ($storage, $lun, $wwnn) = $volumeCommon->getStorage($ldPathList, $ldhardlnHash);
        ## NV:      get $aid, $aname, poolNameNo, raidType
        ## NASHAED: get $storage and $lun 
        if ($isNashead == 0) {
            my $resultCode = "0x00000000";
            my $operation = "normal";
            ($aid, $aname, $poolNameAndNo, $raidType) = $volumeCommon->getPool($wwnn, $lun, $ldInfoHash); 
            if (defined($allAsyncExtendHash{$mp})) {
                my $extendVolHash = $allAsyncExtendHash{$mp};                            
                $operation = "extend";
                $resultCode= $$extendVolHash{"resultCode"};
            }
             
            $volumeInfo = join("\t", $lvName, $mp, $poolNameAndNo, $raidType, $capacity, $fsType, 
                               $quota, $replication, $updateAccessTime, $snapshot,
                               $access, $isMounted , $norecovery , $dmapi , $useRate, $useGfs,
                               $aid, $aname, $operation, $resultCode, $useCode, $fsSize, $wpPeriod);
        } elsif ($isNashead == 1) {
            $volumeInfo = join("\t", $lvName, $mp, $storage, $lun, $capacity, $fsType, 
                               $quota, $replication, $updateAccessTime, $snapshot,
                               $access, $isMounted, $norecovery , $dmapi , $useRate, $useGfs, $useCode, $fsSize, $wpPeriod);
        }
        
        ## print volume info
        print "$volumeInfo\n";

} ## end of foreach 

foreach (keys %$hash) {
    $mp = $_;
    if($mp !~ /^\Q$exportGroup\E\/\S+/){
        next;
    }

    $oneVolHashRef = $$hash{$mp};
    
    $lvName = $$oneVolHashRef{"volName"};
    my @pools = split(",", $$oneVolHashRef{"disklist"});
    my ($aid, $aname, $raidType, $capacity)=("--", "--", "--", 0);
    foreach(@pools){
        my @tmpAry = split("#", $_);
        $aid = $tmpAry[0];
        $aname = $tmpAry[1];
        $raidType = $tmpAry[4];
        $capacity += $tmpAry[5];
    }
    $poolNameAndNo = $volumeCommon->getAsyncPoolNameAndNo(\@pools);##TODO

    $fsType = $$oneVolHashRef{"fsType"};
    $quota = $$oneVolHashRef{"quota"} eq "true" ? "on" : "off";
    $replication = $$oneVolHashRef{"repli"} eq "normal" ? "--" : "notset";
    if($$oneVolHashRef{"operation"} eq "replica"){
        $replication = "replic";
    }
    $updateAccessTime = $$oneVolHashRef{"noatime"} eq "true" ? "on" : "off";
    $snapshot = $$oneVolHashRef{"snapshot"};
    $access = $$oneVolHashRef{"repli"} eq "replic" ? "ro" : "rw";
    $isMounted = "umount";
    $norecovery = "off";
    $dmapi = $$oneVolHashRef{"dmapi"} eq "true" ? "on" : "off";    
    $useRate = "--";
    my $useGfs = $$oneVolHashRef{"usegfs"};
    my $operation = $$oneVolHashRef{"operation"};
    my $resultCode = $$oneVolHashRef{"resultCode"};
    my $useCode = "0x00000000";
    my $fsSize = "--";
    my $wpPeriod = "--";
    
    $volumeInfo = join("\t", $lvName, $mp, $poolNameAndNo, $raidType, $capacity, $fsType, 
                               $quota, $replication, $updateAccessTime, $snapshot,
                               $access, $isMounted , $norecovery , $dmapi , $useRate, $useGfs,
                               $aid, $aname, $operation, $resultCode, $useCode, $fsSize, $wpPeriod);
    print "$volumeInfo\n";
}

print "$totalLdCount $vgCount\n";
exit 0;