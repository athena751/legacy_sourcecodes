#!/usr/bin/perl -w
#
#       Copyright (c) 2005-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: replication_deleteOriginal.pl,v 1.2 2008/05/28 01:48:45 chenb Exp $"
##
## Function:
##     delete original
##
## Parameters:
##     $filesetName	    --  the specifed fileset name 
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

if (scalar(@ARGV) != 2) {
	$repliConst->printErrMsg(
        $repliConst->ERR_PARAMETER_COUNT, __FILE__, __LINE__);
	exit 1;
}

my $filesetName = shift;
my $mountPoint = shift;

my $retValue = $repliCommon->deleteOriginal($filesetName, $mountPoint);

if ($retValue ne $repliConst->SUCCESS) {
	$repliConst->printErrMsg($retValue, __FILE__, __LINE__);
	exit 1;
}

exit 0;