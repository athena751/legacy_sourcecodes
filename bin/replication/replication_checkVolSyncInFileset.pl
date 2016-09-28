#!/usr/bin/perl -w
#
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: replication_checkVolSyncInFileset.pl,v 1.2 2008/06/04 04:48:52 liy Exp $"

## Function:
##     check whether there is a sync replica in the fileset
##
## Parameters:
##     $originalServer -- original server name
##	   $filesetName    -- fileset name
##	   $showNoOriErr   -- true|false, whether print the error if original does not exist
##  
## Output:
##     STDOUT
##         none
##     STDERR
##         error message and error code
##
## Returns:
##     0 -- success 
##     1 -- failed

use strict;
use NS::ReplicationConst;
use NS::ReplicationCommon;

my $repliConst = new NS::ReplicationConst;
my $repliCommon  = new NS::ReplicationCommon;

if(scalar(@ARGV) != 3) {
     $repliConst->printErrMsg($repliConst->ERR_PARAMETER_COUNT, __FILE__, __LINE__ + 1);
     exit 1;
}

my ($originalServer, $filesetName, $showNoOriErr) = @ARGV;

# add for checking whether there is sync volume inf the fileset
my $hasSyncReplica = $repliCommon->hasReplicaSyncInFileset($originalServer , $filesetName);
# $hasSyncReplica is "0", INFO_VOLSYNC_IN_FILESET, ERR_EXECUTE_SYNCINFO, ERR_ORIGINAL_NOT_EXIST
if (($hasSyncReplica eq $repliConst->INFO_VOLSYNC_IN_FILESET)
     || ($hasSyncReplica eq $repliConst->ERR_EXECUTE_SYNCINFO)){
    $repliConst->printErrMsg($repliConst->INFO_VOLSYNC_IN_FILESET, __FILE__, __LINE__ + 1);
	exit 1;	
}

if ($showNoOriErr eq "true") {
	if ($hasSyncReplica eq $repliConst->ERR_ORIGINAL_NOT_EXIST) {
	    $repliConst->printErrMsg($repliConst->ERR_ORIGINAL_NOT_EXIST, __FILE__, __LINE__ + 1);
		exit 1;	
	}
}

exit 0;