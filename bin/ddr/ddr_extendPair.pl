#!/usr/bin/perl -w
#
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: ddr_extendPair.pl,v 1.3 2008/05/21 07:48:22 xingyh Exp $"

## Function:
##     
##
## Parameters:
##	   
##	   mvName mvMountPoint rvNames mvSize
##         Comment:
##             "rvNames" is like ****#**** if multi-rv.
##             "mvSize" is mv's total size(vgSize + extendSize), and unit is GB.
##  
## Output:
##     STDOUT
##         success:
##         		ok
##	       failed:
##	        	ng
##         
##         error message and error code
##
## Returns:
##     0 -- normal
##     1 2 -- error

use strict;

use NS::DdrConst;
use NS::DdrCommon;
use NS::VolumeConst;
use NS::NsguiCommon;
use NS::VolumeCommon;
use Getopt::Long;

my $ddrConst  = new NS::DdrConst;
my $ddrCommon = new NS::DdrCommon;
my $volumeConst  = new NS::VolumeConst;
my $nsguiCommon = new NS::NsguiCommon;
my $volumeCommon = new NS::VolumeCommon;

my @para = @ARGV;
my $option = shift;

$option = lc($option);
if ($option ne $ddrConst->PAIRINFO_STATUS_EXTEND){
    $ddrConst->printErrMsg($ddrConst->ERR_PARAM_UNKNOWN);
    exit 1;
}
my ($mvName,$mp,$extendSize,$mvPool,$mvNode);
my ($rv0Name,$rv0Pool,$rv0Wwnn);
my ($rv1Name,$rv1Pool,$rv1Wwnn);
my ($rv2Name,$rv2Pool,$rv2Wwnn);
my ($disklist,$diskName,$striped);

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
						"disklist=s"    => \$disklist,
						"diskName=s"     => \$diskName,
						"striped=s"     => \$striped
						);
	};
if(!$result){
   $ddrConst->printErrMsg($ddrConst->ERR_PARAM_UNKNOWN);     
   exit 1;
}

## extend MV
my $isNashead = $nsguiCommon->isNashead();
my $friendIP = $nsguiCommon->getFriendIP();
my $retVal = "";
if(defined($friendIP)){
    my $exitVal = $nsguiCommon->isActive($friendIP);
    if($exitVal != 0 ){
        $retVal = $volumeConst->ERR_FRIEND_NODE_DEACTIVE;
        $ddrCommon->modifyPairResultInfo($mvName, &makeSGHash($retVal));
        exit 1;
    }
}
$retVal = $volumeCommon->extendFS($disklist, $mp, $striped, $diskName, $isNashead, $friendIP, $mvNode);
if($retVal ne $volumeConst->SUCCESS_CODE){
    $ddrCommon->modifyPairResultInfo($mvName, &makeSGHash($retVal));
    exit 1;
}
$retVal = $ddrConst->OPERATED_CODE;
$retVal = $ddrCommon->modifyPairResultInfo($mvName, &makeSGHash($retVal));
if($retVal ne $ddrConst->SUCCESS_CODE){
    exit 1;
}

## extend RV

if($rv0Name ne ""){
    # rv0:
    my $result = &execExtendRv(0, $mvName, $rv0Name, $rv0Pool);
    if($result != 0){
        exit 1;
    }
}
if($rv1Name ne ""){
    # rv1:
    my $result = &execExtendRv(1, $mvName, $rv1Name, $rv1Pool);
    if($result != 0){
        exit 1;
    }
}
if($rv2Name ne ""){
    # rv2:
    my $result = &execExtendRv(2, $mvName, $rv2Name, $rv2Pool);
    if($result != 0){
        exit 1;
    }
}
## if success, then delete sgfile's content about this section
$ddrCommon->deleteAsyncPairInfo($mvName);
exit 0;


sub execExtendRv(){
    my ($rvIndex, $mvName, $rvName, $poolName) = @_;
    
    my $rvCmd = &getExtendRvCmd($mvName, $rvName, $poolName);
    `sudo @$rvCmd >&/dev/null`;
    my $cmdRetValue = $?;
    my $cmdRetCode = $cmdRetValue >> 8;
    if($cmdRetValue != 0){
        $cmdRetCode += 100;
        $cmdRetCode = $ddrConst->getErrorCode($cmdRetCode);
    }else{
        $cmdRetCode = $ddrConst->OPERATED_CODE;
    }
    my $mySgHash = &makeSGHash($cmdRetCode, $rvIndex);
    $ddrCommon->modifyPairResultInfo($mvName, $mySgHash);
    if($cmdRetValue != 0){
        return 1;
    }
    return 0;
}

sub getExtendRvCmd(){
    my ($mvName, $rvName, $poolName) = @_;
    my @poolNameArr = split(",", $poolName);
    my @rvExtendCmd;
    push(@rvExtendCmd, $ddrConst->CMD_REPL2_EXTEND_RV);
    foreach (@poolNameArr){
        push(@rvExtendCmd, "-p");
        push(@rvExtendCmd, "$_");
    }
    push(@rvExtendCmd, "$mvName");
    push(@rvExtendCmd, "$rvName");
    return \@rvExtendCmd;
}

sub makeSGHash(){
    my ($resultCode, $rvIndex) = @_;
    my %resultHash = ();
    if(!defined($rvIndex)){
        # mv error
        $resultHash{"mv"} = $resultCode;
        if($resultCode ne $ddrConst->OPERATED_CODE){
            if($rv0Name ne ""){
                $resultHash{"rv0"} = $ddrConst->OPERATE_STOP_CODE;
            }
            if($rv1Name ne ""){
                $resultHash{"rv1"} = $ddrConst->OPERATE_STOP_CODE;
            }
            if($rv2Name ne ""){
                $resultHash{"rv2"} = $ddrConst->OPERATE_STOP_CODE;
            }
        }
    }elsif($rvIndex == 0){
        # rv0 error
        $resultHash{"rv0"} = $resultCode;
        if($resultCode ne $ddrConst->OPERATED_CODE){
            if($rv1Name ne ""){
                $resultHash{"rv1"} = $ddrConst->OPERATE_STOP_CODE;
            }
            if($rv2Name ne ""){
                $resultHash{"rv2"} = $ddrConst->OPERATE_STOP_CODE;
            }
        }
    }elsif($rvIndex == 1){
        # rv1 error
        $resultHash{"rv1"} = $resultCode;
        if(($resultCode ne $ddrConst->OPERATED_CODE) && ($rv2Name ne "")){
            $resultHash{"rv2"} = $ddrConst->OPERATE_STOP_CODE;
        }
    }elsif($rvIndex == 2){
        # rv2 error
        $resultHash{"rv2"} = $resultCode;
    }
    
    return \%resultHash;
}
