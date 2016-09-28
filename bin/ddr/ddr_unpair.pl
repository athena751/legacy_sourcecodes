#!/usr/bin/perl -w
#
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: ddr_unpair.pl,v 1.2 2008/04/20 08:48:56 liuyq Exp $"

#Function:
#       unpair;
#Arguments:
#       $mv: mv name, e.g. NV_LVM_vol
#       $rv_sum: rv name, e.g. NV_RV0_vol,NV_RV1_vol,NV_RV2_vol
#exit code:
#       0:succeeded
#       1:failed
#output:
#       null

use strict;

use NS::DdrCommon;
use NS::DdrConst;

my $ddrCommon = new NS::DdrCommon;
my $ddrConst = new NS::DdrConst;

if(scalar(@ARGV) != 2){
    $ddrConst->printErrMsg($ddrConst->DDR_EXCEP_WRONG_PARAMETER , __FILE__, __LINE__ + 1);
    exit 1;
}
my ($mv,$rv_sum) = @ARGV;

#sort rv
my @rv = split(",",$rv_sum);
@rv=sort(@rv);
$rv_sum=join(",",@rv);

my $cmd_repl2 = $ddrConst->CMD_REPL2;
my $syncState_separated = $ddrConst->SYNCSTATE_SEPARATED;
my $syncState_cancel = $ddrConst->SYNCSTATE_CANCEL;
my $syncState_fault = $ddrConst->SYNCSTATE_FAULT;

#check if the pair can be unpair or not
my $ret = 0;
my $ldPairListOfVolPair;
my $syncState;
foreach(@rv){
    ($ldPairListOfVolPair,$ret) = $ddrCommon->getLdPairListOfVolPair($mv, $_);
    if (defined($ret)){
        $ddrConst->printErrMsg( $ret, __FILE__, __LINE__ + 1 );
        exit 1;
    }
    $syncState = $ddrCommon->getSyncState($ldPairListOfVolPair);
    if( $syncState ne $syncState_separated && $syncState ne $syncState_cancel && $syncState ne $syncState_fault ){
    	$ddrConst->printErrMsg($ddrConst->DDR_EXCEP_CAN_NOT_UNPAIR , __FILE__, __LINE__ + 1 );
        exit 1;
    }
}

#delete schedule
my @scheduleContent = `$cmd_repl2 sched list 2>/dev/null`;
foreach(@scheduleContent){
    if(/\Q$mv\E\s+\Q$rv_sum\E/){
        $ret=system("$cmd_repl2 sched del \Q$mv\E \Q$rv_sum\E >& /dev/null");
        if($ret != 0){
            $ddrConst->printErrMsg($ddrConst->DDR_EXCEP_DELETE_SCHEDULE_FAILED , __FILE__, __LINE__ + 1 );
            exit 1;
        }
        last;
    }
}

#do unpair
foreach(@rv){
	$ret=system("$cmd_repl2 unpair vol -a \Q$mv\E \Q$_\E >& /dev/null");
    $ret=$ret>>8;
    if($ret != 0){
        $ret = $ddrConst->getErrorCode($ret + 200);
        $ddrConst->printErrMsg($ret , __FILE__, __LINE__ + 1 );
        exit 1;
    }
}

exit 0;
