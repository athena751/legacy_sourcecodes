#!/usr/bin/perl -w
#       Copyright (c) 2005-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: filesystem_delFS.pl,v 1.4 2008/06/17 07:33:48 jiangfx Exp $"

#Function: delete the specified filesystem
#Parameters:
    #$fs		filesystem
    #$forceFlag	"force" or undef

#output:
    #none
#exit code:
    #0 ---- success
    #1 ---- failure
    
use strict;
use NS::FilesystemCommon;
use NS::FilesystemConst;
use NS::VolumeConst;
use NS::VolumeCommon;
use NS::ReplicationCommand;
use NS::ConstForRepli;
use NS::NsguiCommon;
use NS::ReplicationCommon;
use NS::ReplicationConst;

my $fsCommon = new NS::FilesystemCommon;
my $fsConst = new NS::FilesystemConst;
my $volumeConst = new NS::VolumeConst;
my $volumeCommon = new NS::VolumeCommon;
my $rc = new NS::ReplicationCommand;
my $RepliConst = new NS::ConstForRepli;
my $nsguiCommon = new NS::NsguiCommon;
my $repliCommon  = new NS::ReplicationCommon;
my $newRepliConst  = new NS::ReplicationConst;

if (scalar(@ARGV) != 2 && scalar(@ARGV) != 3){
	$fsConst->printErrMsg($fsConst->ERR_PARAM_NUM);
	exit 1;
}
my ($mp , $repli_licence , $force) = @ARGV;
my $succMsg;
my $retVal;
my $success = $volumeConst->SUCCESS_CODE;

#check if the fs is used by CIFS, FTP, NFS
$retVal = $volumeCommon->isUsedMP($mp);
if($retVal =~ /^0x108000/ && ($retVal ne $volumeConst->ERR_FTP_USED)){## some error occur
    $volumeConst->printErrMsg($retVal);
    exit 1;  
}

#if has replication licence, then delete the replication
if ($repli_licence eq "true"){
	my ($status,$fileset) = $rc->getRepliStatusFileset($mp);	
	if(!defined($status)){
        $fsConst->printErrMsg($fsConst->ERR_GET_REPLICATION_STATUS);
        exit 1;
    }
	if ($status ne $RepliConst->NOT_REPLICAIOTN) {
		my $originalServer = "";
	    # set original server
	    if (($status eq $RepliConst->LOCAL) 
	        || ($status eq $RepliConst->EXPORT)) {
	    	## set originalServer is localhost if original or local is set on the file system
			$originalServer = "localhost";
	    } elsif ($status eq $RepliConst->IMPORT) {
	    	## get originalServer if replica is set on the file system
		    ## get all replica info
		    my ($replicaInfoArr, $errCode) = $repliCommon->getReplicaInfo();
			if (defined($errCode)) {
				$newRepliConst->printErrMsg($errCode);
				exit 1;
			}
			
			foreach (@$replicaInfoArr) {
		          my $oneReplicaHash = $_;
		          if ($mp eq $$oneReplicaHash{"Mount"}) {
		          	$originalServer  = $$oneReplicaHash{"Server"};
		          	last;
		          }
		    }
		}
		
		if ($originalServer ne "") {
			my $volSyncInFileset = $repliCommon->hasReplicaSyncInFileset($originalServer, $fileset);
		    # $volSyncInFileset is "0", INFO_VOLSYNC_IN_FILESET, ERR_EXECUTE_SYNCINFO, ERR_ORIGINAL_NOT_EXIST
			if ($volSyncInFileset eq $newRepliConst->INFO_VOLSYNC_IN_FILESET) {
				$newRepliConst->printErrMsg($volSyncInFileset);
				exit 1;
			}
		}
	    
	    # delete checkpoint's schedule form cron if original is set
	    if (($status eq $RepliConst->LOCAL) 
	        || ($status eq $RepliConst->EXPORT)) {
		    $retVal = $repliCommon->setSchedule("delete", $mp);
		    if($retVal ne $newRepliConst->SUCCESS){
		        $newRepliConst->printErrMsg($retVal);
		        exit 1;
		    }
		}    
	    my $rmFileset = $RepliConst->CMD_SYNCCONF_RMFSET;
		my $rmExport = $RepliConst->CMD_SYNCCONF_RMEXPORT;
		my $rmImport = $RepliConst->CMD_SYNCCONF_RMIMPORT;
	    
	    my $etcPath = &getEtcPath();
	    
	    if( $status eq $RepliConst->LOCAL ) {
	        if(system("${rmFileset} -f $fileset")!=0) {
	        	$fsConst->printErrMsg($fsConst->ERR_RM_FILESET);
	        	exit 1;
	        }
	        $repliCommon->dumpConf();
	    }elsif( $status eq $RepliConst->EXPORT ){
	        if(system("${rmExport} -f $fileset")!=0){
	        	$fsConst->printErrMsg($fsConst->ERR_RM_EXPORT);
	        	exit 1;
	        }
	        my $exitAbnormal = 0;
	        if(system("${rmFileset} -f $fileset")!=0){
	        	$exitAbnormal = 1; 
	        	$fsConst->printErrMsg($fsConst->ERR_RM_FILESET);
	        }
			$repliCommon->dumpConf();
	        if($exitAbnormal == 1){
	            exit 1;
	        }
	    }elsif( $status eq $RepliConst->IMPORT ){
	        if(system("${rmImport} -f $mp")!=0){
	        	$fsConst->printErrMsg($fsConst->ERR_RM_IMPORT);
	        	exit 1;
	        }
			$repliCommon->dumpConf();
	    }
    }
}

### get lv path of the specified mount point
my $lvpath = $volumeCommon->getLVPath($mp);
if($lvpath =~ /^0x108000/){## some error occur
	$volumeConst->printErrMsg($lvpath);
	exit 1;
}

### umountFS ,include check whether has child
$retVal = $fsCommon->umountFS($mp,$force);
if($retVal =~ /^0x108000/){## some error occur
    $volumeConst->printErrMsg($retVal);
    exit 1; 
}

### get friendIP
my $friendIP = $nsguiCommon->getFriendIP();
if(defined($friendIP)){
    my $exitVal = $nsguiCommon->isActive($friendIP);
    if($exitVal != 0 ){
        $volumeConst->printErrMsg($volumeConst->ERR_FRIEND_NODE_DEACTIVE);
        exit 1;
    }
}

### delete in /var/spool/cron/snapshot in both node
$retVal = $volumeCommon->modifyCron($mp , $lvpath , $friendIP , "delete");
if($retVal ne $success){
	$volumeConst->printErrMsg($retVal);
	exit 1;
}
$succMsg = sprintf($volumeConst->MSG_FS_UMOUNT_1 , $mp);
print STDOUT $succMsg."\n"; 
exit 0;


##############sub function##################
###Function : Get /etc/group[0|1]/
###Parameter:
###         none
###Return:
###         none
sub getEtcPath(){
	my $groupN = $nsguiCommon->getMyNodeNo();
	my $etcPath = ($groupN == 0)? $fsConst->FILE_ETC_GROUP_0:$fsConst->FILE_ETC_GROUP_1;
	return $etcPath;
}


