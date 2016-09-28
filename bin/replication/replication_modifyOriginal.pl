#!/usr/bin/perl -w
#
#       Copyright (c) 2005-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: replication_modifyOriginal.pl,v 1.4 2008/06/04 04:52:52 liy Exp $"
##
## Function:
##     modify original
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

if (scalar(@ARGV) != 7) {
	$repliConst->printErrMsg(
        $repliConst->ERR_PARAMETER_COUNT, __FILE__, __LINE__);
	exit 1;
}

my ($filesetName, $transInterface, $bandWidth, $mountPoint, $tempFile, $schedule, $convert) = @ARGV;

my $CMD_CAT = $repliConst->CMD_CAT;
my $CMD_RM = $repliConst->CMD_RM;
my $CMD_SWITCH = $repliConst->CMD_CRON_SWITCH;

my $clients = `$CMD_CAT \Q${tempFile}\E`;
if($? != 0) {
    system("$CMD_RM -f \Q${tempFile}\E");
    print STDERR "Failed to read $tempFile.\n";
    exit 1;
}
system("$CMD_RM -f \Q${tempFile}\E");

chomp($clients);

if($convert eq "on"){
	my $ret = system("sudo ${CMD_SWITCH} $filesetName >& /dev/null")>>8;
	if ($ret!=0) {
		$repliConst->printErrMsg($repliConst->ERR_EXECUTE_ORIGINAL_SWITCH, __FILE__, __LINE__);
		exit 1;
	}
}

my $retValue = $repliCommon->modifyOriginal(
        $filesetName, $transInterface, $bandWidth, $mountPoint, $clients, $schedule);

if ($retValue ne $repliConst->SUCCESS) {
	$repliConst->printErrMsg($retValue, __FILE__, __LINE__);
	exit 1;
}

exit 0;