#!/usr/bin/perl -w
#
#       Copyright (c) 2005-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: replication_promoteReplica.pl,v 1.6 2008/07/29 03:41:06 chenb Exp $"
## Function:
##     promote the specified replica to original
##
## Parameters:
##     $mountPoint	-- mount point of the specified replica
##     $chekptSchedule - the specified checkpoint schedule
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
use NS::SystemFileCVS;

my $repliCommon  = new NS::ReplicationCommon;
my $repliConst   = new NS::ReplicationConst;
my $volumeCommon = new NS::VolumeCommon;
my $fileCommon   = new NS::SystemFileCVS;

if (scalar(@ARGV) != 2) {
	$repliConst->printErrMsg($repliConst->ERR_PARAMETER_COUNT, __FILE__, __LINE__ + 1);
	exit 1;
}

my $mountPoint = shift;
my $chekptSchedule = shift;
my $errFlag = $repliConst->ERR_FLAG;

## get cfstab path and checkout it
my $cfstabPath = $volumeCommon->getCfstabFile();
if ($fileCommon->checkout($cfstabPath) != 0) {
	$repliConst->printErrMsg($repliConst->ERR_EDIT_CFSTAB, __FILE__, __LINE__ + 1);
	exit 1;	
}

## modify cfstab file
my $retValue = $repliCommon->writeCfstab4Promote($cfstabPath, $mountPoint);
if ($retValue ne $repliConst->SUCCESS) {
	$fileCommon->rollback($cfstabPath);
	$repliConst->printErrMsg($retValue, __FILE__, __LINE__ + 1);
	exit 1;
}

## promote replica
my $cmd_promote = $repliConst->CMD_REPL_PROMOTE;
my $exitCode = system("${cmd_promote} ${mountPoint} 2>/dev/null");
if ($exitCode != 0) {
	$fileCommon->rollback($cfstabPath);
	$repliConst->printErrMsg($repliConst->ERR_EXECUTE_REPL_PROMOTE, __FILE__, __LINE__ + 1);
	exit 1;
}

my $cmd_chmod = $repliConst->CMD_CHMOD;
system("${cmd_chmod} 777 $mountPoint 2>/dev/null");

## checkin cfstab file
if ($fileCommon->checkin($cfstabPath) != 0) {
	$repliConst->printErrMsg($repliConst->ERR_EDIT_CFSTAB, __FILE__, __LINE__ + 1);
	exit 1;	
}
## set checkpoint shedule to cron file
if ($chekptSchedule ne "") {
	$exitCode = $repliCommon->setSchedule("add", $mountPoint, $chekptSchedule);
	if ($exitCode ne $repliConst->SUCCESS) {
		$repliConst->printErrMsg($exitCode, __FILE__, __LINE__ + 1);
		exit 1;
	}
}
exit 0;