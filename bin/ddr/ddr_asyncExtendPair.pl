#!/usr/bin/perl -w
#
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: ddr_asyncExtendPair.pl,v 1.2 2008/05/21 07:47:01 xingyh Exp $"

## Function:
##     
##
## Parameters:
##	   
##	   mvName mvMountPoint extendSize mvPool rv0Name rv0Pool rv0Wwnn rv1Name rv1Pool rv1Wwnn rv2Name rv2Pool rv2Wwnn striped
##
##  
## Output:
##     STDOUT
##         none
##
## Returns:
##     0 -- success
##     1 -- input parameter is wrong
##     2 -- check mv parameter is wrong.
##     3 -- check rv capacity size is wrong.
##     4 -- sg file operation is error.
##     

use strict;

use NS::VolumeConst;
use NS::DdrConst;
use NS::DdrCommon;
use NS::NsguiCommon;
use Getopt::Long;

my $volumeConst  = new NS::VolumeConst;
my $ddrConst  = new NS::DdrConst;
my $ddrCommon = new NS::DdrCommon;
my $nsguiCommon  = new NS::NsguiCommon;

my $option = $ARGV[0];
my @para = @ARGV;
$option = lc($option);
if ($option ne $ddrConst->PAIRINFO_STATUS_EXTEND){
    $ddrConst->printErrMsg($ddrConst->ERR_PARAM_UNKNOWN);
    exit 1;
}
my ($mvName,$mp,$extendSize,$mvPool,$mvNode);
my ($rv0Name,$rv0Pool,$rv0Wwnn);
my ($rv1Name,$rv1Pool,$rv1Wwnn);
my ($rv2Name,$rv2Pool,$rv2Wwnn);
my $striped;

$rv0Name = "";
$rv1Name = "";
$rv2Name = "";
my $result = eval{
			$SIG{__WARN__} = sub { die $_[0]; };
			GetOptions( "mv=s"	        => \$mvName,
						"mp=s"          => \$mp,
						"exsz=s"        => \$extendSize,
						"mvpool=s"      => \$mvPool,
						"mvnode=s"      => \$mvNode,
						"rv0=s"         => \$rv0Name,
						"rv0pool=s"     => \$rv0Pool,
						"rv0wwnn=s"     => \$rv0Wwnn,
						"rv1=s"         => \$rv1Name,
						"rv1pool=s"     => \$rv1Pool,
						"rv1wwnn=s"     => \$rv1Wwnn,
						"rv2=s"         => \$rv2Name,
						"rv2pool=s"     => \$rv2Pool,
						"rv2wwnn=s"     => \$rv2Wwnn,
						"striped=s"     => \$striped
						);
	};
if(!$result){
   $ddrConst->printErrMsg($ddrConst->ERR_PARAM_UNKNOWN);     
   exit 1;
}
my @checkPairStatusOpt;
push(@checkPairStatusOpt, $mvName);
if($rv0Name ne ""){
	push(@checkPairStatusOpt, $rv0Name);
}
if($rv1Name ne ""){
	push(@checkPairStatusOpt, $rv1Name);
}
if($rv2Name ne ""){
	push(@checkPairStatusOpt, $rv2Name);
}
my $statusResult = `/opt/nec/nsadmin/bin/ddr_checkPairStatus4extend.pl @checkPairStatusOpt 2>/dev/null`;
if($? != 0){
    chomp($statusResult);
    $ddrConst->printErrMsg($statusResult);
    exit 1;
}

## check MV
my @checkParam;
push(@checkParam, $ddrConst->PAIRINFO_STATUS_EXTEND);
push(@checkParam, "--do");
push(@checkParam, "poolno=".$mvPool.","."volsz=".$extendSize);
push(@checkParam, "--lv");
push(@checkParam, "striped=".$striped);
push(@checkParam, "--mp");
push(@checkParam, $mp);
foreach(@checkParam){
    if($_ =~ /\(|\)/){
        $_ = "\"".$_."\"";
    }
}
my $checkParamCmd = $volumeConst->SCRIPT_VOLUME_ASYNC_CHECKPARAM;
my $curNode = $nsguiCommon->getMyNodeNo();
my $friendIP = $nsguiCommon->getFriendIP();

my $retVal;
my $mvCheckReturnCode = 1;
if(!defined($friendIP)|| !defined($mvNode) || $mvNode == $curNode ){
	# mv is at current node
	my @tmpRetVal = `sudo $checkParamCmd @checkParam 2>/dev/null`;
	$mvCheckReturnCode = $? >> 8;
	$retVal = \@tmpRetVal;
}else{
	# mv is at friend node
    my $exitVal = $nsguiCommon->isActive($friendIP);
    if($exitVal != 0 ){
        $volumeConst->printErrMsg($volumeConst->ERR_FRIEND_NODE_DEACTIVE);
        exit 1;
    }
    my $rshCmd = "sudo $checkParamCmd @checkParam 2>/dev/null";
    ($mvCheckReturnCode, $retVal) = $nsguiCommon->rshCmdWithSTDOUT($rshCmd, $friendIP);
	if(!defined($mvCheckReturnCode)){
        $ddrConst->printErrMsg($nsguiCommon->ERRCODE_RSH_COMMAND_FAILED, __FILE__, __LINE__ + 1);
        exit 1;
    }
}
if($mvCheckReturnCode != 0){
    my $errCode = pop(@$retVal);
    chomp($errCode);
    $volumeConst->printErrMsg($errCode);
    exit 2;
}

my $paramOperation = pop(@$retVal);
chomp($paramOperation);
my @paramAry = split(/\s+/, $paramOperation);
my $disklist = $paramAry[1];
my $diskName= $paramAry[4];

## check RV

my $checkRvCapCmd = $ddrConst->CMD_CHECK_RV_CAPACITY;
my @checkRvCapOpt;
push(@checkRvCapOpt, "-c");
push(@checkRvCapOpt, "extend");
push(@checkRvCapOpt, "-m");
push(@checkRvCapOpt, $mvName);

my @paraInfo = split(",", $disklist);
my @rvSize;
foreach (@paraInfo){
    my @tempElem = split("#", $_);
    push(@checkRvCapOpt, "-s");
    push(@checkRvCapOpt, $tempElem[5]);
}

if($rv0Name ne ""){
    push(@checkRvCapOpt, "-r");
    push(@checkRvCapOpt, $rv0Name);
    my @rv0PoolOpt = split(",", $rv0Pool);
    foreach (@rv0PoolOpt){
        push(@checkRvCapOpt, "-p");
        push(@checkRvCapOpt, $_);
    }
}
if($rv1Name ne ""){
    push(@checkRvCapOpt, "-r");
    push(@checkRvCapOpt, $rv1Name);
    my @rv1PoolOpt = split(",", $rv1Pool);
    foreach (@rv1PoolOpt){
        push(@checkRvCapOpt, "-p");
        push(@checkRvCapOpt, $_);
    }
}
if($rv2Name ne ""){
    push(@checkRvCapOpt, "-r");
    push(@checkRvCapOpt, $rv2Name);
    my @rv2PoolOpt = split(",", $rv2Pool);
    foreach (@rv2PoolOpt){
        push(@checkRvCapOpt, "-p");
        push(@checkRvCapOpt, $_);
    }
}
my @rvCheckRes = `sudo $checkRvCapCmd @checkRvCapOpt >& /dev/null`;
if($? != 0){
    $ddrConst->printErrMsg($ddrConst->ERR_EXTEND_CHECK_SIZE);
    exit 1;
}

## save sgfile

my %oneSyncPairHash = ();
$oneSyncPairHash{"action"} = $ddrConst->PAIRINFO_STATUS_EXTEND;
$oneSyncPairHash{"mv"}  = $mvName.":".$ddrConst->OPERATING_CODE;
if($rv0Name ne ""){
    $oneSyncPairHash{"rv0"}  = $rv0Name." ".$rv0Wwnn."(".$rv0Pool.")".":".$ddrConst->OPERATING_CODE;
}
if($rv1Name ne ""){
    $oneSyncPairHash{"rv1"}  = $rv1Name." ".$rv1Wwnn."(".$rv1Pool.")".":".$ddrConst->OPERATING_CODE;
}
if($rv2Name ne ""){
    $oneSyncPairHash{"rv2"}  = $rv2Name." ".$rv2Wwnn."(".$rv2Pool.")".":".$ddrConst->OPERATING_CODE;
}
my $addInfoRet = $ddrCommon->addAsyncPairInfo(\%oneSyncPairHash);
if($addInfoRet ne $ddrConst->SUCCESS_CODE){
	$ddrConst->printErrMsg($ddrConst->ERR_EDIT_DDR_ASYNCFILE);
	exit 1;
}

my $extendPairScript = $ddrConst->SCRIPT_DDR_EXTEND_PAIR;
push(@para, "-disklist");
push(@para, $disklist);
push(@para, "-diskName");
push(@para, $diskName);
foreach(@para){
    if($_ =~ /\(|\)/){
        $_ = "\"".$_."\"";
    }
}

`sudo $extendPairScript @para >&/dev/null &`;
exit 0;
