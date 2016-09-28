#!/usr/bin/perl -w
#
#       Copyright (c) 2005-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: volume_getavailpool.pl,v 1.8 2008/10/15 02:13:02 jiangfx Exp $"

###Function : 
###		1.	get all available pools of the system
###		2.  get available pool of the specified disk array and raid type
###Parameters:
###     type : 
###            $aid -- disk array's id
###            $raidType -- pool's type
###Output:
###     1. get information of pool
###         aid=0000
###         aname=aname
###         poolName=poolname
###         poolNo=0001h
###         raidType=1|5|10|50|6(4+PQ)|6(8+PQ)
###         totalCap=100.0
###			usedCap=50.0
###			maxFreeCap=30.0
###			totalFreeCap=50.0
###			pdNoList=00h-01h,00h-02h
###			ldNoList=0001h,0002h
###         vgList=NV_LVM_vol1,NV_LVM_vol2
###		
###         ***capacity's unit is GB . lvlist is sorted
###     3. stderr
###         Parameter's number is wrong.
###         Error occured. (error_code=0x10800000)
###Return :
###     0 -- success
###     1 -- failed

use strict;

use NS::VolumeCommon;
use NS::VolumeConst;
use NS::NsguiCommon;

my $volumeCommon = new NS::VolumeCommon;
my $volumeConst = new NS::VolumeConst;
my $nsguiCommon = new NS::NsguiCommon;

### check parameter number
if(scalar(@ARGV) != 0 && scalar(@ARGV) != 2){
    &showHelp();
    $volumeConst->printErrMsg($volumeConst->ERR_PARAM_WRONG_NUM);
    exit 1;
}

my ($aidSpecified, $raidTypeSpecified) = @ARGV;
if( (defined($aidSpecified) && ($aidSpecified eq ""))
   ||(defined($raidTypeSpecified) && ($raidTypeSpecified eq ""))){
    $aidSpecified = undef;
    $raidTypeSpecified = undef;
}

my $poolInfoHash = $volumeCommon->getAllPoolInfo();
if(defined($$poolInfoHash{$volumeConst->ERR_FLAG})){
    $volumeConst->printErrMsg($$poolInfoHash{$volumeConst->ERR_FLAG});
    exit 1;
}
my $ldVgHash = $volumeCommon->getLdPathVgNameHash();
if(defined($$ldVgHash{$volumeConst->ERR_FLAG})){
    $volumeConst->printErrMsg($$ldVgHash{$volumeConst->ERR_FLAG});
    exit 1;
}

my $diskArraysHash = $volumeCommon->getArrayInfo("0");
if(defined($$diskArraysHash{$volumeConst->ERR_FLAG})){
    $volumeConst->printErrMsg($$diskArraysHash{$volumeConst->ERR_FLAG});
    exit 1;
}

my $lunLdHash = $volumeCommon->getLunLdPathHash();
if (defined($$lunLdHash{$volumeConst->ERR_FLAG})) {
    $volumeConst->printErrMsg($$lunLdHash{$volumeConst->ERR_FLAG});
    exit 1;
}

my %poolHash = ();
foreach(sort(keys %$poolInfoHash)){
	
	my ($aid, $poolNo);
	if($_ =~ /^\s*(\S+)\((\S+)\)\s*$/){
		$aid = $1;
		$poolNo = $2;
	}##must match
    my $availNum = $volumeCommon->getAvailLdNum4Create($aid);
    if($availNum =~ /^\s*0x108000/){
        next;
    }
    if($availNum == 0){
        next;
    }
	
	my $arrayInfo = $$diskArraysHash{$aid}; ### must exist
	my $aname = $$arrayInfo[1];
	my $wwnn  = $$arrayInfo[3];
		
	my $singlePoolHash = $$poolInfoHash{$_};
    my $ldsInfoHash    = $$singlePoolHash{"ldsInfo"};
    my $ldNoList       = join(",", sort(keys %$ldsInfoHash));
	my $vgList 	       = $volumeCommon->getVgByLd($wwnn, $ldNoList, $lunLdHash, $ldVgHash);
    my %vgHash = ();
    my @tmpArray = split(/,+/, $vgList);
    foreach(@tmpArray){
        if($_ ne "##"){
            my $volName = $_;
            $volName =~ s/^\s*NV_LVM_//;
            $vgHash{$volName} = "";
        }
    }
    $vgList = join("," , sort(keys(%vgHash)));
	
	my $maxFreeSize    = $$singlePoolHash{"maxfreecap"};
	if($maxFreeSize < 1.0){
		next;
	}
	
	my %tmpHash              = ();
	$tmpHash{"aid"}          = $aid;
	$tmpHash{"aname"}        = $aname;
	$tmpHash{"raidType"}     = $$singlePoolHash{"raidtype"};
	$tmpHash{"poolName"}     = $$singlePoolHash{"poolname"};
	$tmpHash{"poolNo"}       = $poolNo;
	$tmpHash{"totalCap"}     = $$singlePoolHash{"totalcap"};
	$tmpHash{"usedCap"}      = $$singlePoolHash{"totalusedcap"};
	$tmpHash{"maxFreeCap"}   = $maxFreeSize;
	$tmpHash{"totalFreeCap"} = $$singlePoolHash{"totalfreecap"};
	$tmpHash{"pdNoList"}     = $$singlePoolHash{"physicaldisk"};
	$tmpHash{"ldNoList"}     = $ldNoList;
	$tmpHash{"vgList"}       = $vgList;
	$tmpHash{"pdtype"}       = $$singlePoolHash{"pdtype"};

   	my $raidType             = $$singlePoolHash{"raidtype"};
	
	## get manage capacity of every LD
	my $manageCapOfLD = $volumeCommon->getManageCapByPDList($raidType, $$singlePoolHash{"physicaldisk"});
	$tmpHash{"manageCapOfLD"} = $manageCapOfLD;
	 
	if(defined($aidSpecified) && defined ($raidTypeSpecified)){
	    if(($aidSpecified eq $aid) && ($raidTypeSpecified eq $raidType)){
			$poolHash{"$aid($poolNo)"} = \%tmpHash;
		}
		next;
	}

    $poolHash{"$aid($poolNo)"} = \%tmpHash;
}

foreach(sort keys %poolHash){
	my $tmpHash = $poolHash{$_};
	foreach(sort keys %$tmpHash){
	    my $key = $_;
	    my $value = $$tmpHash{$_};
		print "$key=$value\n";
	}
    print "\n";
}
exit 0;

#### sub function defination start ####
### Function: show help message;
### Paremeters:
###     none;
### Return:
###     none
### Output:
###     Usage:
###         volume_getavailpool.pl
###         volume_getavailpool.pl <aid> <raid-type>
###            
sub showHelp(){
    print (<<_EOF_);
Usage:
    volume_getavailpool.pl
    volume_getavailpool.pl <aid> <raid-type>
            
_EOF_
}

#### sub function defination end   ####

