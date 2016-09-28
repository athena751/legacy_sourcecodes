#!/usr/bin/perl -w
#
#       Copyright (c) 2006-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: replication_async_createreplica.pl,v 1.7 2008/05/28 01:42:15 chenb Exp $"

use strict;
use Getopt::Long;
use NS::VolumeCommon;
use NS::VolumeConst;
use NS::ReplicationConst;

Getopt::Long::Configure("bundling" , "ignore_case_always");

my $volumeCommon = new NS::VolumeCommon;
my $volumeConst = new NS::VolumeConst;
my $repliConst = new NS::ReplicationConst;
my $fileCommon = new NS::SystemFileCVS;

my $cmd = shift;
if(!defined($cmd)){
     $volumeConst->printErrMsg($volumeConst->ERR_PARAM_WRONG_NUM);
     exit 1;
}
$cmd = lc($cmd);

my ($fsoption , $diskoption , $mountoption , $mp, $lvoption, $replication);

my $success = $volumeConst->SUCCESS_CODE;
my $errFlag = $volumeConst->ERR_FLAG;

if($cmd eq "create" ){
    my $result = eval {
                        $SIG{__WARN__} = sub { die $_[0]; };
                        GetOptions("fsoption|fs=s"        => \$fsoption,
	    				           "diskoption|do=s"      => \$diskoption,
		    			           "mountoption|mo=s"     => \$mountoption,
			    		           "mountpoint|mp=s"      => \$mp,
				    	           "lvoption|lo=s"        => \$lvoption,
				    	           "replication|ro=s"     => \$replication);
				       };
    if(!$result){
        $volumeConst->printErrMsg($volumeConst->ERR_PARAM_UNKNOWN);
        exit 1;
    }
}

my $script_chkparam = $volumeConst->SCRIPT_VOLUME_ASYNC_CHECKPARAM;

my @retVal = `sudo $script_chkparam create --do \"$diskoption\" --fs $fsoption --mo $mountoption --lo $lvoption --mp $mp 2>/dev/null`;
if($? != 0){
    my $index = scalar(@retVal);
    my $errCode = $retVal[$index -1];
    chomp($errCode);
    $volumeConst->printErrMsg($errCode);
    exit 1;
}
my $index = scalar(@retVal);
my $param = $retVal[$index -1];
chomp($param);
my @paramAry = split(/\s+/, $param);
my %hash = ();
$hash{"operation"} = "replica";
$hash{"disklist"}  = $paramAry[1];
$hash{"volName"}   = $paramAry[2];
$hash{"isStriped"} = $paramAry[3];
$hash{"fsType"}    = $paramAry[4];
$hash{"repli"}     = $paramAry[5];
$hash{"journal"}   = $paramAry[6];
$hash{"snapshot"}  = $paramAry[7];
$hash{"quota"}     = $paramAry[8];
$hash{"noatime"}   = $paramAry[9];
$hash{"dmapi"}     = $paramAry[10];
$hash{"mp"}        = $paramAry[11];
$hash{"usegfs"}    = $paramAry[12];
$hash{"codepage"}  = $paramAry[13];
$hash{"wpperiod"}  = $paramAry[14];
$hash{"resultCode"}= $volumeConst->SUCCESS_CODE;

my @repliAry = split(",", $replication);
$hash{"serverName"}     = $repliAry[0];
$hash{"filesetName"}     = $repliAry[1];
$hash{"mode"}     = $repliAry[3];
$hash{"snap"}     = $repliAry[4];
$hash{"snapKeepLimit"} = $repliAry[5];
$hash{"ip"}     = defined($repliAry[6]) ? $repliAry[6] : "";

my $retStr = $volumeCommon->lockFile();
if( $retStr ne $success){
    $volumeConst->printErrMsg($retStr);
    exit 1;
}
my $tmpFile = $volumeConst->FILE_ASYNC_TMP;
if($fileCommon->checkout($tmpFile) != 0 ){
    $volumeConst->printErrMsg($volumeConst->ERR_EDIT_TMPFILE);
    $volumeCommon->unlockFile();
    exit 1;
}
my $retVal = $volumeCommon->addAsyncVolToFile(\%hash, $tmpFile);
if($retVal ne $success){
    $fileCommon->rollback($tmpFile);
    $volumeConst->printErrMsg($volumeConst->ERR_EDIT_TMPFILE);
    $volumeCommon->unlockFile();
    exit 1;
}
if($fileCommon->checkin($tmpFile) != 0){
    $fileCommon->rollback($tmpFile);
    $volumeConst->printErrMsg($volumeConst->ERR_EDIT_TMPFILE);
    $volumeCommon->unlockFile();
    exit 1;
}
$volumeCommon->unlockFile();

my $script_operation = $repliConst->SCRIPT_REPLI_ASYNC_OPERATION;
foreach(@paramAry){
    if($_ =~ /\(|\)/){
        $_ = "\"".$_."\"";
    }
}
$param = join(" ", @paramAry);
system("sudo $script_operation $param $replication >&/dev/null &");
exit 0;
