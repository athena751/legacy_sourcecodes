#!/usr/bin/perl -w
#
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: ddr_getCandidateMvInfo.pl,v 1.1 2008/04/19 10:00:11 liuyq Exp $"

## Function:
##     get mv candidate volume infomation from "cfstab","vg_assing","/bin/mount", "codePage" in local
##
## Parameters:
##
## Output:
##     STDOUT
##         volumeName#mount point#codePage
##
##     STDERR
##         error message and error code
##
## Returns:
##     0 -- success
##     1 -- cat cfstab failed
##     2 -- mount command failed
##     3 -- get codepage failed

use strict;
use NS::NsguiCommon;
use NS::VolumeCommon;
use NS::VolumeConst;
use NS::DdrCommon;
use NS::DdrConst;
use NS::APICommon

my $nsguiCommon = new NS::NsguiCommon;
my $volumeCommon = new NS::VolumeCommon;
my $volumeConst  = new NS::VolumeConst;
my $ddrCommon = new NS::DdrCommon;
my $ddrConst =  new NS::DdrConst;
my $apiCommon    = new NS::APICommon;
my @result = ();
my $cfstabMpHash = $volumeCommon->getMountOptionsFromCfstab();
if (defined($$cfstabMpHash{$ddrConst->ERR_FLAG})){
    $volumeConst->printErrMsg($$cfstabMpHash{$ddrConst->ERR_FLAG});
    exit 1;
}
my $mountPointHash = $volumeCommon->getMountMP();
if(defined($$mountPointHash{$volumeConst->ERR_FLAG})){
    $volumeConst->printErrMsg($$mountPointHash{$volumeConst->ERR_FLAG});
    exit 2;
}
my $etcPath = $ddrCommon->getEtcPath();
my $codePageHash = $apiCommon->getExportGroupInfo($etcPath);
if(!defined($codePageHash)){
	$ddrConst->printErrMsg($ddrConst->ERR_GET_CODEPAGE);
	exit 3;
}
##change codingPage for jsp
foreach (sort(keys %$cfstabMpHash)){
	my $mp = $_;
	my $optHash = $$cfstabMpHash{$mp};
	## MvdSync volume can not make pair
	if(defined($$optHash{'repli'}) && ($$optHash{'repli'} eq 'on')){
	    next;
	}
	if(!defined($$mountPointHash{$mp})){
	    next;
	}
	my $exportGroup = $ddrCommon->slipExportGroup($mp);
	my $codePage = $$codePageHash{$exportGroup};
	if(!defined($codePage)){
		next;
	}
	$codePage = $ddrCommon->toGuiCodePage($codePage);
    my $volName;
	my $lvPath = $$optHash{'lvpath'};
	if(defined($lvPath)&&($lvPath =~ /^\/dev\/\S+\/(\S+)$/)){
	    $volName = $1;
	}else{
	    next;
	}
	push (@result,$volName."#".$mp."#".$codePage."\n");
}
print (@result);
exit 0;
