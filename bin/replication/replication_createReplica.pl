#!/usr/bin/perl -w
#
#       Copyright (c) 2005-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: replication_createReplica.pl,v 1.8 2008/06/04 04:49:44 liy Exp $"
#######################################################################
#####Reversion history##### 

##### liuyq     2005/07/21    first commit         

#######################################################################

use strict;
use NS::ReplicationConst;
use NS::VolumeConst;
use NS::ReplicationCommon;
use NS::VolumeCommon;
use NS::SystemFileCVS;

my $repliCommon = new NS::ReplicationCommon;
my $repliConst = new NS::ReplicationConst;
my $volumeCommon = new NS::VolumeCommon;
my $volumeConst = new NS::VolumeConst;
my $fileCommon = new NS::SystemFileCVS;

### 1.check number of the argument , if it is not 5 or 6, exit 1
if( scalar(@ARGV) != 6 && scalar(@ARGV) != 7 ){
    $repliConst->printErrMsg($repliConst->ERR_PARAMETER_COUNT , __FILE__, __LINE__ + 1);
    exit 1; 
}
### 2.initiates variable
my ($serverName , $filesetName , $mountPoint , $mode , $snap , $snapKeepLimit, $ip) = @ARGV; 
if($snap eq "onlysnap"){
    $snap = "--snaponly";
}elsif($snap eq "all"){
    $snap = "--snap";
}else{
    $snap = "";
}

##if the mp is not spare, it is invalid . lyb  2006.6.6
my $retVgpaircheck = $repliCommon->vgpaircheck($mountPoint); 
if($retVgpaircheck == 0 ){                     
    #The mountpoint is used in  ReplicationControl.
    $repliConst->printErrMsg(
        $repliConst->ERR_IS_PAIRED, __FILE__, __LINE__ + 1);
	exit 1;
}elsif($retVgpaircheck != 1 ){
    #Failed to execute /sbin/vgpaircheck.
    $repliConst->printErrMsg(
        $repliConst->ERR_EXECUTE_VGPAIRCHECK, __FILE__, __LINE__ + 1);
	exit 1;
}
my $hasSyncReplica = $repliCommon->hasReplicaSyncInFileset($serverName , $filesetName);
# $hasSyncReplica is "0", INFO_VOLSYNC_IN_FILESET, ERR_EXECUTE_SYNCINFO, ERR_ORIGINAL_NOT_EXIST
if (($hasSyncReplica eq $repliConst->INFO_VOLSYNC_IN_FILESET)
     || ($hasSyncReplica eq $repliConst->ERR_EXECUTE_SYNCINFO)){
    $repliConst->printErrMsg($repliConst->INFO_VOLSYNC_IN_FILESET, __FILE__, __LINE__ + 1);
	exit 1;	
}

my $snapkeepOption = "";
if ($snapKeepLimit ne "--") {
	$snapkeepOption = "--snapkeep --keeplimit $snapKeepLimit";
}

### 3.run the command
my $cmd = $repliConst->CMD_SYNCCONF_IMPORT;
$cmd = "sudo $cmd -f --mode $mode $snap $snapkeepOption ${serverName}:${filesetName} $mountPoint 2>/dev/null";
if(system($cmd)!=0){
    $repliConst->printErrMsg($repliConst->ERR_EXECUTE_SYNCCONF_IMPORT , __FILE__, __LINE__ + 1);
    exit 1;
}
### 4.set bind ip by command
if(defined($ip) && ($ip ne "")){    
    $cmd = $repliConst->CMD_SYNCCONF_BIND_IMPORT;
    my $ret = $repliCommon->retry("${cmd} ${mountPoint} ${ip}");
    if($ret == 1){
        $repliCommon->dumpConf(); 
        $repliConst->printErrMsg($repliConst->ERR_EXECUTE_SYNCCONF_BIND_IMPORT , __FILE__, __LINE__ + 1);
        exit 1;
    }
}

### 5.write mvdsync files
$repliCommon->dumpConf();

exit 0;
