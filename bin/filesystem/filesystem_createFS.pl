#!/usr/bin/perl -w
#       Copyright (c) 2005-2009 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: filesystem_createFS.pl,v 1.8 2009/01/13 10:41:34 wanghb Exp $"

#Function: create FS after checking the validity of the specified path
#Parameters:
    #--fs		fstype=<sxfs|sxfsfw>[,format=yes][,repli=<original|replic>][,journal=expand]
    #--mount	access=<rw|ro>[,snapshot=<snapshot_limit>][,quota=no]
    #           [,noatime=on][,dmapi=on][,norecovery=on][,useGfs=<true|false>][,wpperiod=<--|-1|0|1~10950>]
    #--lv		<lvName>[,striped=<true|false>]
    #--mp		<mountPoint>
#output:
    #none
#exit code:
    #0 ---- success
    #1 ---- failure
    
use strict;
use Getopt::Long;
use NS::FilesystemCommon;
use NS::FilesystemConst;
use NS::VolumeConst;
use NS::VolumeCommon;
use NS::ReplicationCommon;
use NS::ReplicationConst;
Getopt::Long::Configure("bundling" , "ignore_case_always");

my $fsCommon = new NS::FilesystemCommon;
my $volumeConst = new NS::VolumeConst;
my $volumeCommon = new NS::VolumeCommon;
my $fsConst = new NS::FilesystemConst;
my $repliCommon = new NS::ReplicationCommon;
my $repliConst = new NS::ReplicationConst;

my ($fsoption , $mountoption , $mp, $lvName);

my $retVal;
my $succMsg;
my $success = $volumeConst->SUCCESS_CODE;
my $errFlag = $volumeConst->ERR_FLAG;
my @args = ();

if (scalar(@ARGV) != 8){
	$fsConst->printErrMsg($fsConst->ERR_PARAM_NUM);	
	exit 1;
}

my $result = GetOptions("fs=s"        => \$fsoption,
		                "mount=s"     => \$mountoption,
			    		"mp=s"        => \$mp,
				    	"lv=s"        => \$lvName);

### all the saved params of file system may be:fstype,journal,repli,format
my $fsHash = $volumeCommon->parseOption($fsoption);
### all the saved params of mount option may be:snapshot,quota,noatime,dmapi,norecovery,access
my $mountHash = $volumeCommon->parseOption($mountoption);

### check mount point
###check exist when direct mount
###check parent ftype , access mode , mounted , replication when sub mount
$retVal = $fsCommon->validateMP4Use($mp , $$fsHash{"fstype"});  
if($retVal ne $success){
	$volumeConst->printErrMsg($retVal);
    exit 1;
}

### check if pair is set on VG when set replication(MVDSync)
### 0 : pair is set on VG, 1: pair is not set on VG, other value: failed to execute vgpaircheck
if (defined($$fsHash{"repli"})) {
	my $vgPairFlag = $repliCommon->vgpaircheck($lvName);
	if ($vgPairFlag == 0) {
		$repliConst->printErrMsg($repliConst->ERR_IS_PAIRED);
		exit 1;
	} elsif ($vgPairFlag != 1) {
		$repliConst->printErrMsg($repliConst->ERR_EXECUTE_VGPAIRCHECK);
		exit 1;
	}
}

### make file system if format=yes
my $codePage = $volumeCommon->getCodepageForMP($mp);
if($codePage =~ /^0x108000/){
    $volumeConst->printErrMsg($codePage);
    exit 1;
}
if (defined($$fsHash{"format"})){	
	@args = ($$fsHash{"fstype"} , $codePage , $$fsHash{"repli"});
    push(@args , $$fsHash{"journal"} , "/dev/${lvName}/${lvName}");
    $retVal = $volumeCommon->createFS(@args);
    if($retVal ne $success){
        $volumeConst->printErrMsg($retVal);
        exit 1;        
    }
    $succMsg = sprintf($volumeConst->MSG_FS_CREATE_1 , "/dev/${lvName}/${lvName}");
    print STDOUT $succMsg."\n";
}else{
	$retVal = $fsCommon->checkFS($mp,$$fsHash{"fstype"}, "/dev/${lvName}/${lvName}", $codePage, $$fsHash{"repli"}, $$mountHash{"access"}, $$mountHash{"quota"}, $$mountHash{"noatime"}, $$mountHash{"norecovery"}, $$mountHash{"dmapi"});
	if($retVal ne $success){
		$fsConst->printErrMsg($retVal);
		exit 1;	
	}	
}

### mount file system

my $notFormat = 0; #default is need format
if (defined($$fsHash{"format"})){
     $notFormat = 0;  #need format
}else{
     $notFormat = 1;#doesn't need format
}
@args = ($$fsHash{"fstype"} , $$fsHash{"repli"});
push(@args , $$mountHash{"snapshot"} , $$mountHash{"quota"} , $$mountHash{"noatime"} , $$mountHash{"norecovery"} , $$mountHash{"dmapi"});
push(@args , "/dev/${lvName}/${lvName}" , $mp);
push(@args , $notFormat, $$mountHash{"access"});## 0 means create fs not modify
push(@args, $$mountHash{"usegfs"}); ## add useGfs option
push(@args, $$mountHash{"wpperiod"});## add write-protect option

$retVal = $volumeCommon->mountFS(@args);
if($retVal ne $success){
    $volumeConst->printErrMsg($retVal);
    exit 1; 
}
$succMsg = sprintf($volumeConst->MSG_FS_MOUNT_1 , $mp);
print STDOUT $succMsg."\n";

### set auth for mount point 
$retVal = $volumeCommon->setAuth($mp , $$fsHash{"fstype"});
if(($retVal ne $volumeConst->AUTH_SET_SUCCESS) && ($retVal ne $volumeConst->REGION_NOT_EXIST)){
    $volumeConst->printErrMsg($retVal);
    exit 1; 
}

exit 0;