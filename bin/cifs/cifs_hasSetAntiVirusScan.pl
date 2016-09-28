#!/usr/bin/perl
#       Copyright (c) 2007-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: cifs_hasSetAntiVirusScan.pl,v 1.5 2008/05/16 09:26:23 chenbc Exp $"
#Function:
#         Whether specified cifs share has been set as Anti-Virus Scan target or not.
#Parameters:
#          $groupNumber
#          $domainName
#          $computerName
#          $shareName
#Returns:
#       no  : specified cifs share has not be set as antiVirus scan target.
#       yes : sepcified cifs share has been set as antiVirus scan target.
#errorCode:
#

use NS::ServerProtectCommon;
use NS::CIFSCommon;
use NS::CIFSConst;
use NS::NsguiCommon;
use NS::CodeConvert;
use NS::ScheduleScanCommon;
use NS::ConfCommon;
my $spCommon = new NS::ServerProtectCommon;
my $cifsCommon = new NS::CIFSCommon;
my $const = new NS::CIFSConst;
my $comm = new NS::NsguiCommon;
my $codeConvert = new NS::CodeConvert;
my $ssCommon = new NS::ScheduleScanCommon;
my $confCommon = new NS::ConfCommon;

if(scalar(@ARGV)!=4){
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}
my ($groupNumber, $domainName, $computerName, $shareName) = @ARGV;

my $startIndex = 1;
my $endIndex;
my $expGroupEncoding = $cifsCommon->getExpGroupEncoding($groupNumber, $domainName, $computerName);
if(!defined($expGroupEncoding)) {
    print STDERR $const->ERRMSG_GETEXPORTGROUP."\n";
    $comm->writeErrMsg($const->ERRCODE_GETEXPORTGROUP, __FILE__, __LINE__+1);
    exit 1;
}
$shareName = $codeConvert->changeUTF8Encoding($shareName, $expGroupEncoding, $codeConvert->ENCODING_UTF8_NEC_JP);

my $fileContentAddr = $spCommon->getFileContent($groupNumber, $computerName);
if(defined($fileContentAddr)){
    my @nvavsConfContent = @$fileContentAddr;
    while(defined($startIndex)) {
        ($startIndex, $endIndex) = $spCommon->getSectionInfo("share", $startIndex, \@nvavsConfContent);
        if(defined($startIndex)) {
            for(my $index = $startIndex - 1; $index < $endIndex; $index++) {
                if($nvavsConfContent[$index] =~ /^share_name\s*=\s*\"\Q$shareName\E\"\s*$/) {
                    print "realtime_scan\n";
                    exit 0;
                }
            }
            $startIndex = $endIndex;
        }
    }
}

my $scheduleSmbContent = $ssCommon->getFileContent($groupNumber, $domainName, $computerName);
if(defined($scheduleSmbContent)){
    if($confCommon->hasSection($shareName, $scheduleSmbContent)){
        print "schedule_scan\n";
        exit 0;
    }
}

print "no\n";
exit 0;
