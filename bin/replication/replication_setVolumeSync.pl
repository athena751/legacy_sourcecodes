#!/usr/bin/perl -w
#
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: replication_setVolumeSync.pl,v 1.3 2008/05/28 02:04:31 lil Exp $"

## Function:
##     Synchronize the specified replica in the way of current or all .
## Parameters:
##     $replicaMP----mount point of the replica volume
##     $syncType----cur(sync current date) or all(sync all date)  
## Output:
##     STDOUT----none
##     STDERR----error message and error code
## Returns:
##     0----success 
##     1----failed

use strict;
use NS::ReplicationConst;
my $repliConst   = new NS::ReplicationConst;

if (scalar(@ARGV) != 2) {
	$repliConst->printErrMsg($repliConst->ERR_PARAMETER_COUNT, __FILE__, __LINE__ + 1);
	exit 1;
}
my ($replicaMP, $syncType) = @ARGV;

## execute the command of volume sync
my $cmd_syncckpt = $repliConst->CMD_SYNCCKPT;
my $retValue = system("sudo ${cmd_syncckpt} --sync \Q$replicaMP\E >& /dev/null");
$retValue = $retValue>>8;
if($retValue != 0){
    if($retValue == 102){
        $repliConst->printErrMsg($repliConst->ERR_EXECUTE_SYNCCKPT_NO_ORIGINAL, __FILE__, __LINE__ + 1);
        exit 1;
    }elsif($retValue == 103){
        $repliConst->printErrMsg($repliConst->ERR_EXECUTE_SYNCCKPT_NO_REPLICA, __FILE__, __LINE__ + 1);
        exit 1;
    }elsif($retValue == 104){
        $repliConst->printErrMsg($repliConst->ERR_EXECUTE_SYNCCKPT_OTHER_SYNCING, __FILE__, __LINE__ + 1);
        exit 1;
    }else{
        $repliConst->printErrMsg($repliConst->ERR_EXECUTE_SYNCCKPT_UNKNOWN, __FILE__, __LINE__ + 1);
        exit 1;
    }
}else{
    exit 0;
}
