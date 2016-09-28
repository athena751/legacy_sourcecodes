#!/usr/bin/perl -w
#
#       Copyright (c) 2005-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: replication_createOriginal.pl,v 1.5 2008/05/28 01:43:23 chenb Exp $"
##
## Function:
##     create original
##
## Parameters:
##     $filesetName	    --  the specifed fileset name 
##	   $transInterface  --  the specifed interface
##     $bandWidth       --  the specifed band width
##     $mountPoint      --  the specifed mount poing
## 
## Stdin:
##     $clients         --  the specifed external hosts
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

if (scalar(@ARGV) != 6) {
	$repliConst->printErrMsg(
        $repliConst->ERR_PARAMETER_COUNT, __FILE__, __LINE__);
	exit 1;
}

my ($filesetName, $transInterface, $bandWidth, $mountPoint, $tempFile, $schedule) = @ARGV;

my $CMD_CAT = $repliConst->CMD_CAT;
my $CMD_RM = $repliConst->CMD_RM;
my $clients = `$CMD_CAT \Q${tempFile}\E`;
if($? != 0) {
    system("$CMD_RM -f \Q${tempFile}\E");
    print STDERR "Failed to read $tempFile.\n";
    exit 1;
}
system("$CMD_RM -f \Q${tempFile}\E");

chomp($clients);

##if the mp is not spare, it is invalid . lyb  2006.6.6
my $retVgpaircheck = $repliCommon->vgpaircheck($mountPoint);
if($retVgpaircheck == 0 ){
    #The mountpoint is used in  ReplicationControl.
	$repliConst->printErrMsg(
        $repliConst->ERR_IS_PAIRED, __FILE__, __LINE__);
	exit 1;
}elsif($retVgpaircheck != 1 ){
    #Failed to execute /sbin/vgpaircheck.
    $repliConst->printErrMsg(
        $repliConst->ERR_EXECUTE_VGPAIRCHECK, __FILE__, __LINE__);
	exit 1;
}
my $retValue = $repliCommon->createOriginal(
        $filesetName, $transInterface, $bandWidth, $mountPoint, $clients, $schedule);

if ($retValue ne $repliConst->SUCCESS) {
	$repliConst->printErrMsg($retValue, __FILE__, __LINE__);
	exit 1;
}

exit 0;