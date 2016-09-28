#!/usr/bin/perl -w
#
#       Copyright (c) 2005-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: replication_getReplicaList.pl,v 1.14 2008/10/09 09:47:43 chenb Exp $"
## Function:
##     get all replica info for replica list page
##
## Parameters:
##     $exportGroup	-- export  group specified by GUI
##     $groupNo 	-- group number selected by GUI
##  
## Output:
##     STDOUT
##		    filesetName=***
##			replicationData=onlysnap|curdata|all
##			connected=yes|no
##			mountPoint=***
##			originalServer=***
##			syncRate=0~100|-
##			transInterface=IP(nickname)	|NoBindings
##			hasShared=yes|no
##			hasMounted=yes|no
##			originalMP=***|--
##			onceConnected=yes|no|--
##			volumeName=NV_LVM_***
##          wpCode=--|-1|write protect's period
##          snapKeepLimit=--|number                 #add for reform FCL,2008.4.24
##          repliMethod=FullFCL|SplitFCL			
##          volSyncInFileset=0|1|0x12400052            
##			[blank line]
##     STDERR
##          error message and error code
##
## Returns:
##     0 -- success 
##     1 -- failed
use strict;
use NS::ReplicationCommon;
use NS::ReplicationConst;
use NS::VolumeCommon;
use NS::VolumeConst;
use NS::VolCommon4Maintenance;
use NS::NsguiCommon;

my $repliCommon  = new NS::ReplicationCommon;
my $repliConst   = new NS::ReplicationConst;
my $volumeCommon = new NS::VolumeCommon;
my $volumeConst  = new NS::VolumeConst;
my $volMaintenance = new NS::VolCommon4Maintenance;
my $nsguiCommon = new NS::NsguiCommon;

if ((scalar(@ARGV) != 1) && (scalar(@ARGV) != 2)) {
	$repliConst->printErrMsg($repliConst->ERR_PARAMETER_COUNT, __FILE__, __LINE__ + 1);
	exit 1;
}

my $exportGroup = shift;
my $groupNo = shift;
my $nodeNo = $nsguiCommon->getMyNodeNo();
if (!defined($groupNo)) {
	$groupNo = $nodeNo;
}
my $errFlag = $repliConst->ERR_FLAG;

## get mounted mount point
my $mountMPHash = $volumeCommon->getMountMP();
if (defined($$mountMPHash{$errFlag})) {
	$volumeConst->printErrMsg($$mountMPHash{$errFlag});
	exit 1;		
}

## get all mount point in cfstab
my $mpsOption = $volMaintenance->getMountOptionsFromCfstab($groupNo);
if(defined($$mpsOption{$errFlag})){
    $volumeConst->printErrMsg($$mpsOption{$errFlag});
    exit 1;
}

## get all original info
my ($originalInfoHash, $errCode) = $repliCommon->getOriginalStatus($exportGroup);
if (defined($errCode)) {
	$repliConst->printErrMsg($errCode, __FILE__, __LINE__ + 1);
	exit 1;
}

## get all replication mount point's interface
my $interfaceHash = $repliCommon->getInterface4Maintenance("import", $groupNo);
if (defined($$interfaceHash{$errFlag})) {
	$repliConst->printErrMsg($$interfaceHash{$errFlag}, __FILE__, __LINE__ + 1);
	exit 1;
}

## get all replica info
my $replicaInfoArr;
($replicaInfoArr, $errCode) = $repliCommon->getReplicaInfo();
if (defined($errCode)) {
	$repliConst->printErrMsg($errCode, __FILE__, __LINE__ + 1);
	exit 1;
}

## get async volume info
my $tmpFile = $volumeConst->FILE_ASYNC_TMP;
my $asyncHash = {};
if ($groupNo eq $nodeNo) {
	$asyncHash = $volumeCommon->getAsyncVolFromFile($tmpFile, "mp");
	if(defined($$asyncHash{$volumeConst->ERR_FLAG})){
    	$volumeConst->printErrMsg($$asyncHash{$volumeConst->ERR_FLAG});
    	exit 1;
	}
} else {
	$asyncHash = $volumeCommon->getAsyncVolFromOtherNode($tmpFile, "mp");
	if(defined($$asyncHash{$volumeConst->ERR_FLAG})){
    	$asyncHash = {}; # as empty hash if failed to get info
	}
}

## get async replica Info
my %allAsyncReplicaHash = ();
foreach (keys %$asyncHash) {
    my $oneVolHashRef = $$asyncHash{$_};
    if (defined($$oneVolHashRef{"operation"}) 
        && ($$oneVolHashRef{"operation"} eq "replica")) {
        $allAsyncReplicaHash{$_} = $oneVolHashRef;
    }
}

foreach (@$replicaInfoArr) {
	my $oneReplicaHash = $_;
	
	my $replicaMP   = $$oneReplicaHash{"Mount"};
	
	## check export group
	if ($replicaMP !~ /^\Q$exportGroup\E\/+\S+/) {
		next;	
	}
	
	if (defined($allAsyncReplicaHash{$replicaMP})) {
	    next;
	}
	
	my $filesetName = $$oneReplicaHash{"Fileset"};
	my $server      = $$oneReplicaHash{"Server"};
	my $replStatus  = $$oneReplicaHash{"Replication"};

	## get synchronization rate
	my $syncRate = "-";
	if ($replStatus eq $repliConst->CONST_REPLSTATUS_STOP) {
		$syncRate = "stopped";
    } elsif ($replStatus =~ /^Synchronizing\s+\(\s*(\S+)%\s*\)$/) {
		$syncRate = $1;
	} else {
        $syncRate = $repliCommon->getSyncRate($replicaMP, $filesetName, $server, $replStatus);
	}
	
	## get replication data's time
	my $snapshot = $$oneReplicaHash{"Snapshot"};
	my $snapkeep = $$oneReplicaHash{"Snap Keep"};
	my $snapKeepLimit = "--";
	if ($snapkeep =~ /^yes\s*\(\s*Limit\s*:\s*(\d+)\s*\)$/) {
		$snapKeepLimit = $1;
	}
	
	if ($snapshot eq "only snapshot") {
		$snapshot = "onlysnap";
	} elsif ($snapshot eq "no snapshot") {
		$snapshot = "curdata";
	} else {
		$snapshot = "all";
	}

	my $interfaceIP = (defined($$interfaceHash{$replicaMP})) ? $$interfaceHash{$replicaMP}
															 : $repliConst->CONST_NOBINDINGS;

	## get whether mount point has set CIFS|NFS|FTP share or not
	my $hasShared = $volMaintenance->isUsedMP($replicaMP, $groupNo);
	if($hasShared eq $volumeConst->ERR_OPEN_FILE_READING){
		$volumeConst->printErrMsg($hasShared);
		exit 1;			
	}

	## get mount point's mount status
	my $hasMounted = (defined($$mountMPHash{$replicaMP})) ? "yes" : "no";
	
	## get replica's original mount point
	my $originalMP = "--";
	if (defined($$originalInfoHash{$filesetName})) {
		my $tmpHash = $$originalInfoHash{$filesetName};
		$originalMP = $$tmpHash{"Directory"};
	}
	
	## get whether replica has connected with original or not
	my $onceConnected;
	my @tmpArr = split("#", $filesetName);
	my $fsType = $tmpArr[scalar(@tmpArr) - 1];
	
	## $fsType is sxfs, or  $fsType is encoding(eg. EUC-JP,English,UTF8,SJIS) when filesystem is sxfsfw
	if ($fsType eq "sxfs") {
		$onceConnected = "--";
	} elsif (-d "$replicaMP\/\.psid_lt") {
		$onceConnected = "yes";
	} else {
		$onceConnected = "no";
	}

    ## get write-protect command code
    my $wpCode = "--";
    my $cmd_sxfsprotect = $volumeConst->CMD_SXFS_PROTECT;
    if(!(-x $cmd_sxfsprotect)){
       $volumeConst->printErrMsg($volumeConst->ERR_EXECUTE_SXFS_PROTECT);
       exit 1;
    }
    if($fsType ne "sxfs"){
			$wpCode = "-1";     	
    }elsif($hasMounted eq "yes"){
    	my @result = `$cmd_sxfsprotect -o $replicaMP 2>/dev/null`;
    	my $retCode = $? /256;
    	if($retCode == 6){
    		$wpCode = "-1";
    	}else{
    		if(defined($result[0]) && 
    		  ($result[0] =~/^\s*(\d+)\s+days\s*$/)){
    			$wpCode = $1;
    		}
    	}
    }

    ## get replication method
    my $repliMethod = $$oneReplicaHash{"Replication Method"};
    if ($repliMethod =~/^\s*Full\s+FCL\s*$/) {
    	$repliMethod = $repliConst->CONST_REPLI_METHOD_FULL;
    } else {
    	$repliMethod = $repliConst->CONST_REPLI_METHOD_SPLIT;
    }
    
    my $volSyncInFileset = $repliCommon->hasReplicaSyncInFileset($server, $filesetName);
    # $volSyncInFileset is "0", INFO_VOLSYNC_IN_FILESET, ERR_EXECUTE_SYNCINFO, ERR_ORIGINAL_NOT_EXIST
	if (($volSyncInFileset eq $repliConst->INFO_VOLSYNC_IN_FILESET)
	    || ($volSyncInFileset eq $repliConst->ERR_EXECUTE_SYNCINFO)) {
		$volSyncInFileset = 1;
	}
	
	## get volume name
	my $mpOption   = $$mpsOption{$replicaMP};
	my $volumeName = (split(/\//, $$mpOption{"lvpath"}))[3];
	
	## print one replica info
	print "originalServer=$server\n";
	print "filesetName=$filesetName\n";
	print "connected=$$oneReplicaHash{'Connected'}\n";
	print "syncRate=$syncRate\n";
	print "transInterface=$interfaceIP\n";
	print "replicationData=$snapshot\n";
	print "mountPoint=$$oneReplicaHash{'Mount'}\n";
	print "hasShared=$hasShared\n";
	print "hasMounted=$hasMounted\n";
	print "originalMP=$originalMP\n";
	print "onceConnected=$onceConnected\n";
	print "volumeName=$volumeName\n";
	print "wpCode=$wpCode\n";
	print "snapKeepLimit=$snapKeepLimit\n";
	print "repliMethod=$repliMethod\n";
	print "volSyncInFileset=$volSyncInFileset\n";
	print "asyncStatus=normal\n";
	print "errCode=0x00000000\n";
	print "\n";
}

## print async replica info
foreach (keys %allAsyncReplicaHash) {
   my $mp = $_;
   if ($mp !~ /^\Q$exportGroup\E\/\S+/) {
       next;
   }
   my $hash = $allAsyncReplicaHash{$mp};

    my $server = $$hash{"serverName"};
    my $filesetName = $$hash{"filesetName"};
    my $snapshot = $$hash{"snap"};
    my $volName = $$hash{"volName"};
    my $interfaceIP = $$hash{"ip"};
    if($interfaceIP eq ""){
        $interfaceIP = "NoBindings";
    }else{
        my ($result , $errCode)  = $volMaintenance->getUpIPList($groupNo);
        if(defined($errCode)){
            $repliConst->printErrMsg($errCode , __FILE__ , __LINE__ + 1);
            exit(1);
        }
        my %ipHash = @$result;
        if(defined($ipHash{$interfaceIP})){
            $interfaceIP = $interfaceIP."(".$ipHash{$interfaceIP}.")";
        }
    }
    my $snapKeepLimit = $$hash{"snapKeepLimit"};
    my $repliMethod = $repliConst->CONST_REPLI_METHOD_SPLIT;
    my $volSyncInFileset = 1;
    
    my $resultCode = $$hash{"resultCode"};
    
    my $originalMP = "--";
	if (defined($$originalInfoHash{$filesetName})) {
		my $tmpHash = $$originalInfoHash{$filesetName};
		$originalMP = $$tmpHash{"Directory"};
	}
	my $onceConnected = "--";
	if ($$hash{"fsType"} eq "sxfsfw") {
		$onceConnected = "no";
	}
    print "originalServer=$server\n";
	print "filesetName=$filesetName\n";
	print "connected=no\n";
	print "syncRate=--\n";
	print "transInterface=$interfaceIP\n";
	print "replicationData=$snapshot\n";
	print "mountPoint=$mp\n";
	print "hasShared=0x00000000\n";
	print "hasMounted=no\n";
	print "originalMP=$originalMP\n";
	print "onceConnected=$onceConnected\n";
	print "volumeName=$volName\n";
	print "wpCode=--\n";
	print "snapKeepLimit=$snapKeepLimit\n";
	print "repliMethod=$repliMethod\n";
	print "volSyncInFileset=$volSyncInFileset\n";	
	print "asyncStatus=replica\n";
	print "errCode=$resultCode\n";
	print "\n";

}
exit 0;