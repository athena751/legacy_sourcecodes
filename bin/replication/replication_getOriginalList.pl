#!/usr/bin/perl -w
#
#       Copyright (c) 2005-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: replication_getOriginalList.pl,v 1.6 2008/07/29 03:38:22 chenb Exp $"


	  #Function: 
        #get original List
    #Parameters:
        #$exportGroup
            
    #Returns:
        # 0 success
        # 1 failed
        
use strict;
use NS::ReplicationCommon;
use NS::ReplicationConst;
use NS::VolumeCommon;
use NS::VolumeConst;
use NS::NsguiCommon;

my $comm = new NS::ReplicationCommon;
my $const = new NS::ReplicationConst;
my $volumeCom=new NS::VolumeCommon;
my $volumeConst  = new NS::VolumeConst;
my $nsguiCommon = new NS::NsguiCommon;

my $paranum = scalar(@ARGV);

# there should be one parameter: exportGroup
if($paranum!=1 && $paranum!=2){
    $const->printErrMsg($const->ERR_PARAMETER_COUNT, __FILE__ , __LINE__);
    exit(1);
}

my $exportGroup=shift;
my $groupNo = shift;
my ($ptrOriginalList, $errCode)=$comm->getOriginalStatus($exportGroup);

if(defined($errCode)){
    $const->printErrMsg($errCode , __FILE__ , __LINE__);
    exit(1);
}

## get mounted mount point
my $mountMPHash = $volumeCom->getMountMP();
my $errFlag = $const->ERR_FLAG;
if (defined($$mountMPHash{$errFlag})) {
	$volumeConst->printErrMsg($$mountMPHash{$errFlag});
	exit 1;
}

my $ptrBandwidth;

($ptrBandwidth, $errCode)=$comm->getBandwidth();

if(defined($errCode)){
    $const->printErrMsg($errCode , __FILE__ , __LINE__);
    exit(1);
}


my $ptrInterface;
if(!defined($groupNo)){
	$groupNo = $nsguiCommon->getMyNodeNo();	
}
($ptrInterface, $errCode)=$comm->getInterface4Maintenance("export", $groupNo);

if(defined($errCode)){
    $const->printErrMsg($errCode , __FILE__ , __LINE__);
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
	my $volSyncInFileset = $comm->hasReplicaSyncInFileset("localhost" ,$keyOri);
	# $volSyncInFileset is "0", "0x12400050", "0x12400051", "0x12400052"
	if ($volSyncInFileset eq $const->INFO_VOLSYNC_IN_FILESET 
		|| $volSyncInFileset eq $const->ERR_EXECUTE_SYNCINFO){
		$volSyncInFileset = 1;
	}

	my $ptrOneOriginal=$originalList{$keyOri};
	my %oneOriginal=%$ptrOneOriginal;
	

    my $tmpMP=$oneOriginal{"Directory"};  
    my $repliMethod = $oneOriginal{"Replication Method"};
    if ($repliMethod =~/^\s*Full\s+FCL\s*$/) {
    	$repliMethod = $const->CONST_REPLI_METHOD_FULL;
    } else {
    	$repliMethod = $const->CONST_REPLI_METHOD_SPLIT;
    }
  	##need to get schedule from cron file	
	my ($minute, $hour) = ("--","--");
	if($repliMethod eq $const->CONST_REPLI_METHOD_SPLIT){
		my $schedule = $comm->getSchedule($groupNo, $tmpMP);
		if(defined($schedule)){
			if($schedule=~/^\s*0x124000/){
				$const->printErrMsg($schedule , __FILE__ , __LINE__);
    			exit(1);
			}else{
				($minute ,$hour) = split(/\s+/ ,$schedule);
			}
		}
	}
	
  print("filesetName=".$keyOri."\n");
	if($oneOriginal{"Clients"} eq "" || $oneOriginal{"Clients"}  eq "localhost"){
		 print("connectionAvailable=no\n");
	}
	else{
		 print("connectionAvailable=yes\n");
	}

  my $tmpHost=$oneOriginal{"Clients"};
  $tmpHost=~s/^\s+|\s+$//g;             #remove  sapce in de head and tail of the string
  
  
	print("replicaHost=".$tmpHost."\n");	
	print("mountPoint=".$tmpMP."\n");
		 
    if(exists $interfaceList{$keyOri}) {
      print("transInterface=".$interfaceList{$keyOri}."\n");
	  }
	  else {
	  	print("transInterface=\n");
	  }
	  #no interface
	if(exists $bandwidthList{$keyOri}){
		  print("bandWidth=". $bandwidthList{$keyOri}."\n");
	  }
	else {
	  	print("bandWidth=0\n");
	}
	
	
	## get mount point's mount status
	my $hasMounted = (defined($$mountMPHash{$tmpMP})) ? "yes" : "no";
	print("hasMounted=$hasMounted\n");
    
	print("type=". $oneOriginal{"Type"}."\n");
	
	print("repliMethod=${repliMethod}\n");
	
	print("hour=${hour}\n");
	print("minute=${minute}\n");
	  
	print("volSyncInFileset=${volSyncInFileset}\n");
	print("\n");
}

exit 0;
