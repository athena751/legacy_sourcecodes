#!/usr/bin/perl -w
#
#       Copyright (c) 2006-2009 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: volume_hasasync.pl,v 1.10 2009/01/09 03:10:49 xingyh Exp $"
use strict;
use NS::VolumeCommon;
use NS::VolumeConst;
use NS::NsguiCommon;
use NS::SystemFileCVS;

my $volumeCommon = new NS::VolumeCommon;
my $volumeConst  = new NS::VolumeConst;
my $nsguiCommon  = new NS::NsguiCommon;
my $fileCommon = new NS::SystemFileCVS;

my $hasActiveAsync = 0;
my $tmpFile = $volumeConst->FILE_ASYNC_TMP;
my $hash = $volumeCommon->getAsyncVolFromFile($tmpFile);
my $friendIP = $nsguiCommon->getFriendIP();

if(defined($$hash{$volumeConst->ERR_FLAG})){
	goto ExecuteOnFriendNode;
}
my $cmd_ps  = "/bin/ps -ef --cols 500 2>/dev/null";
my @retVal = `$cmd_ps`;

##root     14058     1  0 11:23 pts/0    00:00:00 /usr/bin/perl -w /home/nsadmin/bin/volume_async_operation.pl
##root     14058     1  0 11:23 pts/0    00:00:00 /usr/bin/perl -w /home/nsadmin/bin/replication_async_createreplica_operation.
my $strVolume  = "/usr/bin/perl -w /home/nsadmin/bin/volume_async_operation.pl";
my $strReplica = "/usr/bin/perl -w /home/nsadmin/bin/replication_async_createreplica_operation";

if(scalar(grep(/$strVolume/, @retVal)) >0 || scalar(grep(/$strReplica/, @retVal)) > 0){
	$hasActiveAsync = 1;	
}
my $needModify = 0;
foreach(keys %$hash){
	my $oneAsync = $$hash{$_};
	if(defined($$oneAsync{"operation"}) && 
	   defined($$oneAsync{"mp"}) && 
	   defined($$oneAsync{"resultCode"})){

        if(($hasActiveAsync == 0) 
            && ($$oneAsync{"resultCode"} eq $volumeConst->SUCCESS_CODE)){
            $$oneAsync{"resultCode"} = $volumeConst->ERR_PROCESS_HAS_DIED;
            $$hash{$_} = $oneAsync;
            $needModify = 1;
        }
		my $operation  = $$oneAsync{"operation"};
        my $mp         = $$oneAsync{"mp"};
        my $resultCode = $$oneAsync{"resultCode"};
        print "$operation $mp $resultCode\n";
	}
}

if($needModify == 1 &&
    $fileCommon->checkout($tmpFile) == 0){

	if ($volumeCommon->writeAsyncVolToFile($hash, $tmpFile) != 0 || 
	    $fileCommon->checkin($tmpFile) != 0){
	    $fileCommon->rollback($tmpFile);
	}
}
if($hasActiveAsync == 0){
	$volumeCommon->unlockFile();
	
	## delete all file /tmp/paralleAsyncVol_* 
	my $tmpFileFullPath = $volumeConst->PREFFIX_ASYN_VOL_FILE;
	my $cmd_rm = $volumeConst->CMD_RM;
	system("$cmd_rm -f $tmpFileFullPath* 2>/dev/null");
}

my $syncLock = $volumeConst->LOCK_ASYNC_VOL;
if (defined($ARGV[0]) && ($ARGV[0] eq "1")) {
    ## get lockProcess's file info from FIP node
    my ($retVal, $infoRef) = $volumeCommon->getInfoFromActiveNode($syncLock); 

	## file exist
    if ($retVal == 0) {
        ## unlock process when no volume is  creating or extending in both node
        my ($retCode, $allPIDs) = $volumeCommon->getAllPIDs();
        if ($retCode eq $volumeConst->SUCCESS_CODE) {
            my $reallyUnlock = 1;            
            foreach (keys %$allPIDs) {
                my $myPIDs = $$allPIDs{$_};
                if (defined($myPIDs) && (scalar(@$myPIDs) > 0)) {
                    $reallyUnlock = 0;
                    last;
                }   
            }
            
            if ($reallyUnlock) {
                $volumeCommon->unlockProcess("force");
            }
        }
    }
}

ExecuteOnFriendNode:
if (defined($ARGV[0]) && $ARGV[0] eq "1" &&
    defined($friendIP) &&
    $nsguiCommon->isActive($friendIP) == 0){
    my $cmd_hasasync = "sudo /home/nsadmin/bin/volume_hasasync.pl 0";
    my($exitCode, $retValAry) = $nsguiCommon->rshCmdWithSTDOUT($cmd_hasasync, $friendIP);
    if (defined($exitCode) && $exitCode == 0) { ## not failed to execute rsh command
        chomp(@$retValAry);
        foreach(@$retValAry){
            print "$_\n";
        }
    }
}
exit 0;
