#!/usr/bin/perl -w
#
#       Copyright (c) 2006-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: volume_restartismsvr.pl,v 1.3 2007/09/21 02:24:21 pizb Exp $"


###Function : restart iSMsvr, execeute rescandd between stop and start 
###exit:
###     0 : success
###     1 : error occurs
###Output:
###     2.stderr
###       error message

use strict;
use NS::VolumeCommon;
use NS::VolumeConst;

my $volumeCommon = new NS::VolumeCommon;
my $volumeConst = new NS::VolumeConst;

sleep($volumeConst->TIME_AFTER_ISMSVRRESTART);

my $retVal = $volumeCommon->restartISMServ(2);
if($retVal != 0){
    $volumeConst->printErrMsg($volumeConst->ERR_EXECUTE_ISMSERV);
    exit $retVal;
}

my $cmd_rescandd = $volumeConst->SCRIPT_DDSCAN;
$retVal = system("$cmd_rescandd >&/dev/null");
if($retVal != 0){
    $volumeCommon->restartISMServ(1);
    $volumeConst->printErrMsg($volumeConst->ERR_EXECUTE_DDSCAN_PL);
    exit $retVal/256;
}

$retVal = $volumeCommon->restartISMServ(1);
if($retVal != 0){
    $volumeConst->printErrMsg($volumeConst->ERR_EXECUTE_ISMSERV);
}

exit $retVal;