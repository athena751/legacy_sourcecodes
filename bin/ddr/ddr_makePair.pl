#!/usr/bin/perl -w
#
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: ddr_makePair.pl,v 1.2 2008/04/26 06:06:08 xingyh Exp $"

## Function:
##     get mv info which GUI ddr pair create page required
##
## Parameters:
##      $subcmd     --'always'|'generation'|'d2d2t'
##      $mp         when 'd2dt2' have this mount point  
##      $sched      schedule for set
##      $sync       Sync make pair
##      $rv0        <POOL> <master-vol> <WWNN> <replica-vol>
##      $rv1        ...
##      $rv2        ...
## Output:
##
##     STDERR
##         error message and error code
## Returns:
##     0 -- success 
##     1 -- failed

use strict;
use Getopt::Long;
use NS::DdrCommon;
use NS::DdrConst;


my $ddrCommon = new NS::DdrCommon;
my $ddrConst  = new NS::DdrConst;
my $retVal ;

## Get and check parameter 
my $option = shift;
$option = lc($option);
if ($option ne $ddrConst->USAGE_ALWAYS && $option ne $ddrConst->USAGE_GENERATION && $option ne $ddrConst->USAGE_D2D2T){
    $ddrConst->printErrMsg($ddrConst->ERR_PARAM_UNKNOWN);
    exit 1;
}
my ($mvName,$schedule,$mp,$rv0Info,$rv1Info,$rv2Info);
my $result = eval{
					$SIG{__WARN__} = sub { die $_[0]; };
					GetOptions( "mv=s"	        => \$mvName,
								"sched=s"       => \$schedule,
								"mp=s"          => \$mp,
								"rv0=s"         => \$rv0Info,
								"rv1=s"         => \$rv1Info,
								"rv2=s"         => \$rv2Info
                              );
			};
my $repl2PairCmd = $ddrConst->CMD_REPL2_PAIR_VOL;
my %resultCodeHash = ();
if(defined($rv0Info)){
    $resultCodeHash{'rv0'} = $ddrConst->OPERATING_CODE;   
}
if(defined($rv1Info)){
    $resultCodeHash{'rv1'} = $ddrConst->OPERATING_CODE;    
}
if(defined($rv2Info)){
    $resultCodeHash{'rv2'} = $ddrConst->OPERATING_CODE;  
}
## When D2DAlways
if($option eq $ddrConst->USAGE_ALWAYS){
    my ($resultCode,$rv0Name) = $ddrCommon->exeRepl2PairVolCmd($rv0Info);
    if($resultCode != 0){
    	$resultCodeHash{'rv0'} = $ddrConst->getErrorCode($resultCode);
    	$ddrCommon->modifyPairResultInfo($mvName,\%resultCodeHash);
    	exit 1;
    }
    my $repl2ReplCmd = $ddrConst->CMD_REPL2_REPLICATE;
    `sudo ${repl2ReplCmd} ${mvName} ${rv0Name} nowait >&/dev/null`;
    if($? != 0){
        $resultCodeHash{'rv0'} = $ddrConst->ERR_EXE_REPL2_REPLICATE;
    	$ddrCommon->modifyPairResultInfo($mvName,\%resultCodeHash);
    	exit 1;
    }    
    $ddrCommon->deleteAsyncPairInfo($mvName);
}
## When D2DGeneration
if($option eq $ddrConst->USAGE_GENERATION){
    my @rvNameAry = ();
    if(defined($rv0Info)){
        my ($resultCode,$rv0Name) = $ddrCommon->exeRepl2PairVolCmd($rv0Info);
		if($resultCode != 0){
		    ## Generate detail Error infomation
		    $resultCodeHash{'rv0'} = $ddrConst->getErrorCode($resultCode);
		    if(defined($resultCodeHash{'rv1'})){
	                $resultCodeHash{'rv1'} = $ddrConst->OPERATE_STOP_CODE;    
	        }
		    if(defined($resultCodeHash{'rv2'})){
	                $resultCodeHash{'rv2'} = $ddrConst->OPERATE_STOP_CODE;    
	        }
	        $resultCodeHash{'sched'} = $ddrConst->OPERATE_STOP_CODE;
	        $ddrCommon->modifyPairResultInfo($mvName,\%resultCodeHash);
	    	exit 1;
		}
		$resultCodeHash{'rv0'} = $ddrConst->OPERATED_CODE;
		$ddrCommon->modifyPairResultInfo($mvName,\%resultCodeHash);
		push(@rvNameAry,$rv0Name);
    }
    if(defined($rv1Info)){
        my ($resultCode,$rv1Name) = $ddrCommon->exeRepl2PairVolCmd($rv1Info);
		if($resultCode != 0){
	 	    ## Generate detail Error infomation
		    $resultCodeHash{'rv1'} = $ddrConst->getErrorCode($resultCode);
		    if(defined($resultCodeHash{'rv2'})){
	            $resultCodeHash{'rv2'} = $ddrConst->OPERATE_STOP_CODE;    
	        }
	        $resultCodeHash{'sched'} = $ddrConst->OPERATE_STOP_CODE;
	        $ddrCommon->modifyPairResultInfo($mvName,\%resultCodeHash);
	        exit 1;
		}
		$resultCodeHash{'rv1'} = $ddrConst->OPERATED_CODE;
	    $ddrCommon->modifyPairResultInfo($mvName,\%resultCodeHash);
	    push(@rvNameAry,$rv1Name);
    
    }
    if(defined($rv2Info)){
	    my ($resultCode,$rv2Name) = $ddrCommon->exeRepl2PairVolCmd($rv2Info);
	    if($resultCode != 0){
	        ## Generate detail Error infomation
	        $resultCodeHash{'rv2'} = $ddrConst->getErrorCode($resultCode);
	        $resultCodeHash{'sched'} = $ddrConst->OPERATE_STOP_CODE;
            $ddrCommon->modifyPairResultInfo($mvName,\%resultCodeHash);
    	    exit 1;
	    }
	    $resultCodeHash{'rv2'} = $ddrConst->OPERATED_CODE;
	    $ddrCommon->modifyPairResultInfo($mvName,\%resultCodeHash);
	    push(@rvNameAry,$rv2Name);
    }
	
    ## Set Schedule for all pairs
    my $rvNameList = join(",",@rvNameAry);
    my $repl2SchedCmd = $ddrConst->CMD_REPL2_ADD_SCHEDULE;
    my @scheduleAry = split(/\s+/,$schedule);
    $schedule = join("' '",@scheduleAry);
    $schedule = "'".$schedule."'";

    `sudo ${repl2SchedCmd} add ${mvName} ${rvNameList} rplsep-sync $schedule >&/dev/null`;
    ## Change all the result code to error code
    if($? != 0){
    	my $resultCode = $ddrConst->ERR_EXE_REPL2_ADD_SCHEDULE;
    	$resultCodeHash{'sched'} = $resultCode;
    	$ddrCommon->modifyPairResultInfo($mvName,\%resultCodeHash);
    	exit 1;
    }
    $ddrCommon->deleteAsyncPairInfo($mvName);
}
exit 0;






