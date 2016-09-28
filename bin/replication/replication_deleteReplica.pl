#!/usr/bin/perl -w
#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: replication_deleteReplica.pl,v 1.1 2005/09/15 05:29:22 liyb Exp $"
## Function:
##     delete the specified replica
##
## Parameters:
##     $mountPoint	-- mount point of the specified replica
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

my $repliCommon  = new NS::ReplicationCommon;
my $repliConst   = new NS::ReplicationConst;

if (scalar(@ARGV) != 1) {
	$repliConst->printErrMsg($repliConst->ERR_PARAMETER_COUNT, __FILE__, __LINE__ + 1);
	exit 1;
}

my $mountPoint = shift;

## delete replica
my $retValue = $repliCommon->rmImport($mountPoint);
if ($retValue ne $repliConst->SUCCESS) {
	$repliConst->printErrMsg($retValue, __FILE__, __LINE__ + 1);
	exit 1;
}

exit 0;