#!/usr/bin/perl -w
#
#       Copyright (c) 2001-2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: volume_getdiskarrayinfo.pl,v 1.4 2005/12/22 03:05:12 liuyq Exp $"

###Function : get disk array 's id , name , and avail pdgs;
###Parameter :
###     none
###Return:
###     0 : success
###     1 : failed
###Output : 
###     1.stdout
###       aid=0000
###       aname=aname
###       atype=xxh
###       pdgList=00h,01h
###       wwnn=nnnnnnnnnnnnnnnn
###
###     2.stderr
###       Parameter's number is wrong.
###       Error occured. (error_code=0x10800000)

use strict;
use NS::VolumeCommon;
use NS::VolumeConst;   

my $volumeCommon = new NS::VolumeCommon;
my $volumeConst  = new NS::VolumeConst;

my $diskArraysHash = $volumeCommon->getArrayInfo("0");
if(defined($$diskArraysHash{$volumeConst->ERR_FLAG})){
    $volumeConst->printErrMsg($$diskArraysHash{$volumeConst->ERR_FLAG});
    exit 1;
}
my %arrayHash = ();
foreach(sort keys %$diskArraysHash){
	my $singleArrayInfo = $$diskArraysHash{$_};
	my %tmpHash = ();
	$tmpHash{"aid"}   = $$singleArrayInfo[0];
	$tmpHash{"aname"} = $$singleArrayInfo[1];
	$tmpHash{"atype"} = $$singleArrayInfo[2];
	$tmpHash{"wwnn"}  = $$singleArrayInfo[3];	


    my $availNum = $volumeCommon->getAvailLdNum4Create($_);
    if($availNum =~ /^\s*0x108000/){
        next;
    }
    if($availNum == 0){
        next;
    }
    
	my $pdgHash = $volumeCommon->getAvailPdgs($$singleArrayInfo[0]);
	if(defined($$pdgHash{$volumeConst->ERR_FLAG})){
	    next;
	}
	if(scalar(keys %$pdgHash) == 0){
		$tmpHash{"pdgList"} = "----";
	}else{
        $tmpHash{"pdgList"} = join(",", sort(keys %$pdgHash));	
    }

	$arrayHash{$_} = \%tmpHash;
}

foreach(sort keys %arrayHash){
	my $tmpHash = $arrayHash{$_};
	foreach(sort keys %$tmpHash){
	    my $key   = $_;
	    my $value = $$tmpHash{$_};
		print "$key=$value\n";
	}
	print "\n";
}
exit 0;
