#!/usr/bin/perl -w
#       Copyright (c) 2004-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: cifs_isWorkingShare.pl,v 1.3 2007/06/28 01:43:22 fengmh Exp $"

#Function: check the share is busy or not 
#Parameters:
    #$groupNumber      : the group number 0 or 1
    #$domainName       : the Domain Name
    #$computerName     : the Computer Name
    #$shareName        : the Share Name
#output:
    #true  ------ the share is busy
    #false ------ the share is not busy
#exit code:
    #0 ---- success
    #1 ---- failure

use strict;
use NS::NsguiCommon;
use NS::CIFSConst;
use NS::CIFSCommon;
use NS::ConfCommon;
use NS::CodeConvert;

my $comm  = new NS::NsguiCommon;
my $const = new NS::CIFSConst;
my $cifsCommon = new NS::CIFSCommon;
my $codeConvert = new NS::CodeConvert;

if(scalar(@ARGV)!=4){
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}

my $groupNumber = shift;
my $domainName = shift;
my $computerName = shift;
my $shareName = shift;

my $expGroupEncoding = $cifsCommon->getExpGroupEncoding($groupNumber, $domainName, $computerName);
if(!defined($expGroupEncoding)) {
    print STDERR $const->ERRMSG_GETEXPORTGROUP."\n";
    $comm->writeErrMsg($const->ERRCODE_GETEXPORTGROUP,__FILE__,__LINE__+1);
    exit 1;
}
$shareName = $codeConvert->changeUTF8Encoding($shareName, $expGroupEncoding, $codeConvert->ENCODING_UTF8_NEC_JP);
if(!defined($shareName)) {
    print STDERR $const->ERRMSG_CHANGEENCODING."\n";
    $comm->writeErrMsg($const->ERRCODE_CHANGEENCODING,__FILE__,__LINE__+1);
    exit 1;
}

my $isWorking = $cifsCommon->isWorkingShare($groupNumber, $domainName, $computerName, $shareName);

print "$isWorking\n";

exit 0;