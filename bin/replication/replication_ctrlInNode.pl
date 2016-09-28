#!/usr/bin/perl -w
#
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: replication_ctrlInNode.pl,v 1.1 2008/06/17 10:51:13 jiangfx Exp $"
## Function:
##     replace original volume with replica volume or exchange original volume and replica volume
##
## Parameters:
##     $operation -- replace or exchange
##     $replicaMP  -- mount point of the replica volume
##     $originalMP -- mount point of the original volume
##  
## Output:
##     STDOUT
##		    none
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
use NS::NsguiCommon;

my $repliCommon  = new NS::ReplicationCommon;
my $repliConst   = new NS::ReplicationConst;
my $volumeCommon = new NS::VolumeCommon;
my $volumeConst  = new NS::VolumeConst;
my $nsguiCommon  = new NS::NsguiCommon;

if (scalar(@ARGV) != 3) {
	$repliConst->printErrMsg($repliConst->ERR_PARAMETER_COUNT, __FILE__, __LINE__ + 1);
	exit 1;
}

my ($operation, $replicaMP, $originalMP) = @ARGV;

if (($operation ne "replace") && ($operation ne "exchange")) {
	$repliConst->printErrMsg($repliConst->ERR_PARAMETER_CONTENT, __FILE__, __LINE__ + 1);
	exit 1; 
}

## get all mount point info from cfstab
my $mpsOption = $volumeCommon->getMountOptionsFromCfstab();
if (defined($$mpsOption{$volumeConst->ERR_FLAG})){
    $volumeConst->printErrMsg($$mpsOption{$volumeConst->ERR_FLAG});
    exit 1;
}

## execute command "/usr/lib/rcli/repl replace" or command "/usr/lib/rcli/repl exchange"
if ($operation eq "replace"){
	my $cmd_replace = $repliConst->CMD_REPL_REPLACE;
	if (system("sudo ${cmd_replace} $originalMP $replicaMP 2>/dev/null") != 0){
		$repliConst->printErrMsg($repliConst->ERR_EXECUTE_REPL_REPLACE, __FILE__, __LINE__ + 1);
		exit 1;
	}	
}else {
	my $cmd_exchange = $repliConst->CMD_REPL_EXCHANGE;
	if (system("sudo ${cmd_exchange} $originalMP $replicaMP 2>/dev/null") != 0){
		$repliConst->printErrMsg($repliConst->ERR_EXECUTE_REPL_EXCHANGE, __FILE__, __LINE__ + 1);
		exit 1;
	}
}

## get friend IP, add by jiangfx 2005/11/22
my $retVal;
my $friendIP = $nsguiCommon->getFriendIP();
if (defined($friendIP)) {
    $retVal = $nsguiCommon->isActive($friendIP);
    if($retVal != 0 ){
        $volumeConst->printErrMsg($volumeConst->ERR_FRIEND_NODE_DEACTIVE);
        exit 1;
    }	
}

my $replicaMPOption  = $$mpsOption{$replicaMP};
my $replicaLvpath    = $$replicaMPOption{"lvpath"};
my $originalMPOption = $$mpsOption{$originalMP};
my $originalLvpath   = $$originalMPOption{"lvpath"};

## modify /var/spool/cron/snapshot file, add by jiangfx, 2005/11/22
$retVal = $volumeCommon->modifyCron($originalLvpath, $replicaLvpath, $friendIP , "modify");
if($retVal =~ /^0x108000/) {
    $volumeConst->printErrMsg($retVal);
    exit 1;
}

## modify /var/spool/cron/syncckpt file
my $replCronFile = $repliConst->REPL_CRON_FILE;
$retVal = $repliCommon->modifyReplCron($replCronFile, $originalLvpath, $replicaLvpath);
if ($retVal ne $repliConst->SUCCESS) {
    $repliConst->printErrMsg($retVal, __FILE__, __LINE__ + 1);
    exit 1;
}

exit 0;