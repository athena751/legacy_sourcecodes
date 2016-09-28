#!/usr/bin/perl -w
#
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: ddr_getMv.pl,v 1.6 2008/07/21 05:45:23 xingyh Exp $"


## Function:
##     make pair of Mv which GUI ddr_rdr add pair page required
##
## Parameters:
##  
## Output:
##     STDOUT
##       The sequence of DdrVolInfoBean member:
##         	name=$mvName
##	        mp=$mp
##	        capacity=$capacity
##	        aname=$aname
##	        aid=$aid
##	        wwnn=$wwnn
##	        poolNameAndNo=$poolNameAndNo
##	        raidType=$raidType
##	        codePage=$codePage       
##         
##         error message and error code
##
## Returns:
##     0 -- success 
##     1 -- failed

use strict;
use NS::NsguiCommon;
use NS::VolumeCommon;
use NS::VolumeConst;

use NS::DdrConst;
use NS::DdrCommon;

my $nsguiCommon  = new NS::NsguiCommon;
my $volumeCommon = new NS::VolumeCommon;
my $volumeConst  = new NS::VolumeConst;
my $ddrCommon = new NS::DdrCommon;
my $ddrConst  = new NS::DdrConst;

my $cmd = $ddrConst->SCRIPT_GET_CANDIDATE_MV;
my @candidateMv = `$cmd 2>/dev/null`;
if ( $? != 0 ) {
	 $ddrConst->printErrMsg($ddrConst->ERR_EXE_LOCALE_GET_CANDIDATE_MV);
     exit 1;
}
## Get candidate mv info from partner node
my $retVal;
my $partnerCandidateMv;
my $friendIP = $nsguiCommon->getFriendIP();
if ( defined($friendIP) ) {
	my $exitVal = $nsguiCommon->isActive($friendIP);
	if ( $exitVal != 0 ) {
        $volumeConst->printErrMsg($volumeConst->ERR_FRIEND_NODE_DEACTIVE);
        exit 1;
	}
	($retVal,$partnerCandidateMv) = $nsguiCommon->rshCmdWithSTDOUT( "sudo $cmd", $friendIP );
	if(!defined($retVal)){
        $ddrConst->printErrMsg($nsguiCommon->ERRCODE_RSH_COMMAND_FAILED);
        exit 1;
	}elsif($retVal != 0 ){
	    $ddrConst->printErrMsg($ddrConst->ERR_EXE_REMOTE_GET_CANDIDATE_MV);
	    exit 1;
	}
}
if(defined($partnerCandidateMv)){
    push( @candidateMv,@$partnerCandidateMv );
}
## Get pair info from this and partner node
my ($mvRvNameListHash,$errCode1)=$ddrCommon->getMvRvNameList($friendIP);
if (defined($errCode1)) {
	$ddrConst->printErrMsg($errCode1);
	exit 1;
}
## Get Vg and Ld info
my ($vgLdInfoHash,$errCode2) = $ddrCommon->getVgLdInfoHash();
if(defined($errCode2)){
	## The errors defined in VolumeConst.pm
	$volumeConst->printErrMsg($errCode2);
    exit 1;
}
my $vgdisplayInfoHash  = $$vgLdInfoHash{"vgInfo"};
my %activatedRVHash = (); 
foreach(keys %$vgdisplayInfoHash){
	my $volName = $_;
	if($volName !~ /^NV_LVM_/){
		if($volName =~ /^NV_\S+?_(\S+)$/){
			$activatedRVHash{$1} = "";
		}
	}
}


## Filter the candidate mv which has paired yet
foreach(sort(@candidateMv)){
	chomp($_);
    my ($mvName,$mp,$codePage)= split(/#/,$_);
    ## The volume cannot have pair 
    if(defined($$mvRvNameListHash{$mvName})){
    	next;
    }
    
    if($mvName !~ /^NV_LVM_\S+$/){
        next;
    }
    
    if($mvName =~ /^NV_LVM_(\S+)$/){
        if(defined($activatedRVHash{$1})){
        	next;
        }
    }
    my ($poolNameAndNo, $raidType, $capacity, $aid, $aname, $wwnn) = $ddrCommon->getStoragePoolInfo($mvName,'',$vgLdInfoHash);
    if(($poolNameAndNo eq '--')||($raidType eq '--')||($aname eq '--')||($capacity eq '--')||($aid eq '--')||($wwnn eq '--')){
        next;
    }
 
    my $splitCount;
    ($wwnn,$splitCount) = $ddrCommon->compactAndSort($wwnn);
    ## Cannot support multi diskarrays. 
    if($splitCount > 1){
         next;
    }
    ($aid,$splitCount)= $ddrCommon->compactAndSort($aid);
    ($aname,$splitCount) = $ddrCommon->compactAndSort($aname);
    ($poolNameAndNo,$splitCount) = $ddrCommon->compactAndSort($poolNameAndNo);    
    ## Output the Mv info as DdrVolInfoBean format
    print "name=$mvName\n";
    print "mp=$mp\n";
    print "capacity=$capacity\n";
    print "aname=$aname\n";
    print "aid=$aid\n";
    print "wwnn=$wwnn\n";
    print "poolNameAndNo=$poolNameAndNo\n";
    print "raidType=$raidType\n";
    print "codePage=$codePage\n";
    print "\n";
}

exit 0;

