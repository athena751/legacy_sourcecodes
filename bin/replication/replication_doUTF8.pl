#!/usr/bin/perl -w
#
#       Copyright (c) 2006-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: replication_doUTF8.pl,v 1.5 2008/05/28 01:51:28 chenb Exp $"
##
## Function:
##     deal with UTF8
##Parameters:
##     none
## Stdin:
##     none
## Output:
##     STDOUT
##		   some fail or succeed message
##     STDERR
##          error message and error code
## Returns:
##     0 -- success 
##     1 -- failed
use strict;
use NS::ReplicationCommon;
use NS::ReplicationConst;
use NS::VolumeCommon;
use NS::VolumeConst;

my $comm         = new NS::ReplicationCommon;
my $const        = new NS::ReplicationConst;
my $volumeCom    = new NS::VolumeCommon;
my $volumeConst  = new NS::VolumeConst;
my $fileCommon   = new NS::SystemFileCVS;

my $exportGroup="/export";
my $retValue;

&doReplicaUTF8();
&doOriginalUTF8();

##
## Function:
##     deal with UTF8 for replica
##Parameters:
##     none
## Stdin:
##     none
## Output:
##     STDOUT
##		   some fail or succeed message
##     STDERR
##          error message and error code
## Returns:
##     0 -- success 
##     1 -- failed
sub doReplicaUTF8(){

	my $server="";
	my $filesetName="";
	my $newfilesetName="";
	my $mountpoint="";
	my $mode="overwrite";
	my $snapshot="";
	my $interfaceIP="";

	my $errFlag = $const->ERR_FLAG;
			
	## get all replication mount point's interface
	my $interfaceHash = $comm->getInterface("import");
	if (defined($$interfaceHash{$errFlag})) {
		$const->printErrMsg($$interfaceHash{$errFlag}, __FILE__, __LINE__ + 1);
		exit 1;
	}
	
	## get all replica info
	my($replicaInfoArr, $errCode) = $comm->getReplicaInfo();
	if (defined($errCode)) {
		$const->printErrMsg($errCode, __FILE__, __LINE__ + 1);
		exit 1;
	}
	
	foreach (@$replicaInfoArr) {
		my $oneReplicaHash = $_;
		$filesetName = $$oneReplicaHash{"Fileset"};
		if($filesetName!~/#UTF-8$/){
		   next;
		}
		$newfilesetName=$filesetName;
		$newfilesetName=~s/#UTF-8$/#UTF8/;
		$mountpoint   = $$oneReplicaHash{"Mount"};
		
		$server      = $$oneReplicaHash{"Server"};
	
		## get replication data's time
		$snapshot = $$oneReplicaHash{"Snapshot"};
		if ($snapshot=~/^\s*only snapshot\s*$/) {
			$snapshot = "--snaponly";
		} elsif ($snapshot=~/^\s*no snapshot\s*$/) {
			$snapshot = "";
		} else {
			$snapshot = "--snap";
		}
	
		$interfaceIP = (defined($$interfaceHash{$mountpoint})) ? $$interfaceHash{$mountpoint}:"";
        $interfaceIP=~s/\(.+\)$//;
		
        ## delete replica
        print("Deleting replica with fileset name  $filesetName ...\n");
        $retValue = $comm->rmImport($mountpoint);
        if ($retValue ne $const->SUCCESS) {
             print("Failed to delete replica $filesetName .\n\n");
             exit 1;
        }
		print("Succeeded to delete replica $filesetName .\n\n");
		
		## create replica
		print("Creating replica $newfilesetName ...\n");
		### 1.run the command
		my $cmd = $const->CMD_SYNCCONF_IMPORT;
		$cmd = "$cmd -f --mode $mode $snapshot ${server}:${newfilesetName} $mountpoint";
		if(system($cmd)!=0){
		    print("Failed to create replica $newfilesetName .\n\n");
		    exit 1;
		}
			
		### 2.set bind ip by command
		if(defined($interfaceIP) && ($interfaceIP ne "")){    
		    $cmd = $const->CMD_SYNCCONF_BIND_IMPORT;
		    my $ret = $comm->retry("${cmd} ${mountpoint} ${interfaceIP}");
		    if($ret == 1){
		        $comm->dumpConf(); 
		        print("Failed to bind IP to replica $newfilesetName .\n\n");
		        exit 1;
		    }
		}
		
		### 3.write mvdsync files
		$comm->dumpConf();
		
		print("Succeeded to create replica $newfilesetName .\n\n");
	}
}

##
## Function:
##     deal with UTF8 for replica
##Parameters:
##     none
## Stdin:
##     none
## Output:
##     STDOUT
##		   some fail or succeed message
##     STDERR
##          error message and error code
## Returns:
##     0 -- success 
##     1 -- failed
sub doOriginalUTF8(){

	my $filesetName="";
	my $newfilesetName="";
	my $transIP="";
	my $bandwidth="";
	my $mountpoint="";
	my $clients="";
	
	my ($ptrOriginalList, $errCode)=$comm->getOriginalStatus($exportGroup);
	
	if(defined($errCode)){
	    $const->printErrMsg($errCode , __FILE__ , __LINE__ + 1);
	    exit(1);
	}
	
	my $ptrBandwidth;
	
	($ptrBandwidth, $errCode)=$comm->getBandwidth();
	
	if(defined($errCode)){
	    $const->printErrMsg($errCode , __FILE__ , __LINE__ + 1);
	    exit(1);
	}
	
	my $ptrInterface;
	
	($ptrInterface, $errCode)=$comm->getInterface("export");
	
	if(defined($errCode)){
	    $const->printErrMsg($errCode , __FILE__ , __LINE__ + 1);
	    exit(1);
	}
		
	my %originalList=%$ptrOriginalList;
	my %bandwidthList=%$ptrBandwidth;
	my %interfaceList=%$ptrInterface;
	
	my @keysOriginal=keys(%originalList);
	my @keysBandwidth=keys(%bandwidthList);
	my @keysInterface=keys(%interfaceList);
	
	foreach my $keyOri(@keysOriginal)
	{
	    my $ptrOneOriginal=$originalList{$keyOri};
	    my %oneOriginal=%$ptrOneOriginal;
	
	    if($keyOri !~ /#UTF-8$/){
	        next;
	    }
	    ###file set name finished with "#UTF-8"
	    $filesetName=$keyOri;
	    $newfilesetName=$filesetName;
	    $newfilesetName=~s/#UTF-8$/#UTF8/;
	    ###interface ip      
        if(exists $interfaceList{$keyOri}) {
        $transIP=$interfaceList{$keyOri};
        $transIP=~s/\(.+\)$//;
        }else{
           $transIP="";
        }
	
        ### bandwidth
        if(exists $bandwidthList{$keyOri}){
			   $bandwidth=$bandwidthList{$keyOri};
        }else{
	           $bandwidth=0;
        }
	
        ### mountpoint
        $mountpoint=$oneOriginal{"Directory"};;
        
        ### replica hosts
        my $tmpHost=$oneOriginal{"Clients"};
        if( $tmpHost=~/^\s*localhost\s*$/ ){
        	$tmpHost="#";
        }elsif( $tmpHost=~/^\s*all\s*$/ ){
        	$tmpHost="-a";
        }else{        	
            $tmpHost=~s/\blocalhost\b//g;         #remove "localhost"
            $tmpHost=~s/,+/ /g;                    # replcace "," with sapce
            $tmpHost=~s/^\s+|\s+$//g; 
        }
        $clients=$tmpHost;
        
        print("Deleting original  $filesetName ...\n");
        $retValue = $comm->deleteOriginal($filesetName, $mountpoint);
	        
        ### delete the original
        if ($retValue ne $const->SUCCESS) {
            print("Failed to delete original $filesetName .\n\n");
	        exit 1;
        }
        print("Succeeded to delete original $filesetName .\n\n");
        print("creating original $newfilesetName ...\n");
        ### create original
        $retValue = $comm->createOriginal( $newfilesetName, $transIP, $bandwidth, $mountpoint, $clients, "");
	
        if ($retValue ne $const->SUCCESS) {
            print("Failed to create original $newfilesetName .\n\n");
            exit 1;
        }
        print("Succeeded to create original $newfilesetName .\n\n");
	}    	
}
