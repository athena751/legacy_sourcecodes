#!/usr/bin/perl -w
#
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: ddr_asyncMakePair.pl,v 1.4 2008/04/30 08:49:39 xingyh Exp $"

## Function:
##     get mv info which GUI ddr add pair page required
##
## Parameters:
##      $mv         name of mv   
##      $subcmd     --'always'|'generation'|'d2d2t'
##      $mp         when 'd2dt2' have this mount point  
##      $sched      schedule for set
##      $rv0        <POOL>#<master-vol>#<WWNN>#<replica-vol>
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
my $success = $ddrConst->SUCCESS_CODE;
## Get and check parameter 
my @param = @ARGV;
my $option = shift;
$option = lc($option);
if ($option ne $ddrConst->USAGE_ALWAYS && $option ne $ddrConst->USAGE_GENERATION && $option ne $ddrConst->USAGE_D2D2T){
    $ddrConst->printErrMsg($ddrConst->ERR_PARAM_UNKNOWN);
    exit 1;
}
my ($mv,$schedule,$mp,$rv0Info,$rv1Info,$rv2Info);
my $result = eval{
					$SIG{__WARN__} = sub { die $_[0]; };
					GetOptions( "mv=s"	        => \$mv,
								"sched=s"       => \$schedule,
								"mp=s"          => \$mp,
								"rv0=s"         => \$rv0Info,
								"rv1=s"         => \$rv1Info,
								"rv2=s"         => \$rv2Info);
			};
if(!$result){
   $ddrConst->printErrMsg($ddrConst->ERR_PARAM_UNKNOWN);     
   exit 1;
}
if(!defined($mv)){
   $ddrConst->printErrMsg($ddrConst->ERR_PARAM_UNKNOWN);     
   exit 1;
}
if(($option eq $ddrConst->USAGE_ALWAYS)&&(!defined($rv0Info))){
   $ddrConst->printErrMsg($ddrConst->ERR_PARAM_UNKNOWN);     
   exit 1;
}
if(($option eq $ddrConst->USAGE_D2D2T)&&(!defined($mp))){
   $ddrConst->printErrMsg($ddrConst->ERR_PARAM_UNKNOWN);     
   exit 1;
}


## Generate checkRv parameter
my $rvCount = 0;
## Generate oneSyncPairHash
my %oneAsyncPairHash = ();
$oneAsyncPairHash{"action"} = "create";
$oneAsyncPairHash{"mv"}  = $mv.":".$ddrConst->OPERATING_CODE;
if($ddrCommon->checkRvInfo($rv0Info)){
    &setRvInfo2Hash("rv0",$rv0Info,\%oneAsyncPairHash);
    $rvCount++;
}
if($ddrCommon->checkRvInfo($rv1Info)){
    &setRvInfo2Hash("rv1",$rv1Info,\%oneAsyncPairHash);
    $rvCount++;
}
if($ddrCommon->checkRvInfo($rv2Info)){
    &setRvInfo2Hash("rv2",$rv2Info,\%oneAsyncPairHash);
    $rvCount++;
}

if(($option eq $ddrConst->USAGE_GENERATION)&&(($rvCount < 2)||(!defined($schedule)))){
   $ddrConst->printErrMsg($ddrConst->ERR_PARAM_UNKNOWN);     
   exit 1;
}
## Check RV Capacity
if($option eq $ddrConst->USAGE_ALWAYS){
    $retVal = $ddrCommon->checkPoolCapacity($mv,$rv0Info,$rv1Info,$rv2Info);
    if($retVal ne $success ){
        $ddrConst->printErrMsg($ddrConst->ERR_CHECK_RV_CAPACITY);
        exit 1;
    }
}
if(defined($schedule)){
	$schedule =~ s/\"//g;
    $oneAsyncPairHash{"sched"}  = $schedule.":".$ddrConst->OPERATING_CODE; 
}
## Add the oneAsyncPairHash to tmp file
$retVal = $ddrCommon->addAsyncPairInfo(\%oneAsyncPairHash);
if($retVal ne $success){
    $ddrConst->printErrMsg($ddrConst->ERR_EDIT_DDR_ASYNCFILE);
    exit 1;
}

## Execute the real command to make pair 
my $scriptMakePair = $ddrConst->SCRIPT_DDR_MAKE_PAIR;
my @retAry = `sudo $scriptMakePair @param >&/dev/null &`;
exit 0;

###Function : Set RV info 2 async Pair Hash
###           rv0=<rvName> <wwnn>(<poolName1>,<poolName2>):<>resultCode>
###Parameter:
###         $key = "rv0|1|2"
###         $rvInfo = <poolName>#<mvName>#<wwnn>#<rvName>
###			\%asyncPairHash
###Return:
###         none
sub setRvInfo2Hash(){
    my ($key,$rvInfo,$oneAsyncPairHash) = @_;
    my ($poolName,$mvName,$wwnn,$rvName) = split('#',$rvInfo);
    $$oneAsyncPairHash{$key} = $rvName." ".$wwnn."(".$poolName.")".":".$ddrConst->OPERATING_CODE;;
}



