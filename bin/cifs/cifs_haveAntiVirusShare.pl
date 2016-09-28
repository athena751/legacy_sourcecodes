#!/usr/bin/perl
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: cifs_haveAntiVirusShare.pl,v 1.1 2008/12/18 07:35:57 chenbc Exp $"

#Function: 
    #judge whether any anti-virus shares exist, according to the filesystem type
#Arguments: 
    #$groupNumber       : the group number 0 or 1
    #$domainName
    #$computerName
    #$fsType            : sxfsfw | sxfs | all
#exit code:
    #0:succeed 
    #1:failed
#output:
    #yes | no
    
use strict;
use NS::NsguiCommon;
use NS::CIFSConst;
use NS::CIFSCommon;
use NS::ConfCommon;

my $comm  = new NS::NsguiCommon;
my $const = new NS::CIFSConst;
my $cifsCommon = new NS::CIFSCommon;
my $confCommon = new NS::ConfCommon;

if(scalar(@ARGV)!=4){
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}

my ($groupNumber, $domainName, $computerName, $fsType) = @ARGV;
$fsType=lc($fsType);

my $smbFileName = $cifsCommon->getSmbFileName($groupNumber, $domainName, $computerName);
if(!-f $smbFileName){
    print "no\n";
    exit 0;
}

my $smbConfContent = $cifsCommon->getSmbContent($groupNumber, $domainName, $computerName);

my ($shareNameRef, $shareSectionIndexRef) = $cifsCommon->getAllShareInfo($smbConfContent);

my $countOfShares = scalar(@$shareNameRef);
if($countOfShares == 0){
    print "no\n";
    exit 0;
}

my $fsTypeInfo = $cifsCommon->getFstypeOfAllMP($groupNumber);

push(@$shareSectionIndexRef, scalar(@$smbConfContent));
for(my $tmpIndex = 0; $tmpIndex < $countOfShares; $tmpIndex++){
    my $shareName = @$shareNameRef[$tmpIndex];
    my $beginIndex = @$shareSectionIndexRef[$tmpIndex];
    my $endIndex = @$shareSectionIndexRef[$tmpIndex + 1] - 1;
    my @section = @$smbConfContent[$beginIndex..$endIndex];
    my $shareType = $cifsCommon->getShareType($shareName, \@section);
    if($shareType eq "realtime_scan"){
        my $path = $confCommon->getKeyValue('path', $shareName, \@section);
        if(defined($path) && $path ne ''){
            if($fsType eq "all"){
                print "yes\n";
                exit 0;
            }
            my $currentType = $$fsTypeInfo{$cifsCommon->getDirectMP($path)};
            if(lc($currentType) eq $fsType){
                print "yes\n";
                exit 0;
            }
        }
    }
}
print "no\n";
exit 0;
