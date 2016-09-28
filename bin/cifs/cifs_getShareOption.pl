#!/usr/bin/perl
#       Copyright (c) 2004-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: cifs_getShareOption.pl,v 1.15 2008/12/18 07:35:57 chenbc Exp $"

#Function: 
    #get the smb.conf.%L file content;
#Arguments: 
    #$groupNumber       : the group number 0 or 1
    #$domainName        : the domain Name
    #$computerName      : the computer Name
    #$shareName         : the share name
#exit code:
    #0:succeed 
    #1:failed
#output:
    #   key=value
    #
    #key:
    #shareName,connection,directory,comment,readOnly,writeList,settingPassword,
    #validUser_Group,invalidUser_Group,hostsAllow,hostsDeny,serverProtect,userName,
    #shadowCopy,oldshadowCopy,dosFiletimes,sxfsfwFiletimes,dirAccessControlAvailable
    #sharePurpose,antiVirusForShare,antiVirusForGlobal,antiVirus,browseable,pseudoABE
    

use strict;
use NS::NsguiCommon;
use NS::CIFSConst;
use NS::CIFSCommon;
use NS::ConfCommon;
use NS::CodeConvert;
use NS::ScheduleScanCommon;

my $comm       = new NS::NsguiCommon;
my $const      = new NS::CIFSConst;
my $cifsCommon = new NS::CIFSCommon;
my $confCommon = new NS::ConfCommon;
my $codeConvert = new NS::CodeConvert;
my $ssCommon = new NS::ScheduleScanCommon;

if(scalar(@ARGV)!=4){
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}

my ($groupNumber, $domainName, $computerName, $shareName) = @ARGV;

my $shareNameNoChange = $shareName;
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

my $smbContent = $cifsCommon->getSmbContent($groupNumber, $domainName, $computerName);
my @section;
my ($offset, $length) = $confCommon->getSectionInfo($shareName, $smbContent);
if(defined($offset)) {
    @section = @$smbContent[$offset-1..$offset+$length-1];
}

my $connection        = $confCommon->getKeyValue("available",   $shareName, \@section);
my $directory         = $confCommon->getKeyValue("path",        $shareName, \@section);
my $comment           = $confCommon->getKeyValue("comment",     $shareName, \@section);
my $readOnly          = $confCommon->getKeyValue("read only",   $shareName, \@section);
my $writeable         = $confCommon->getKeyValue("writeable",   $shareName, \@section);
my $writeList         = $confCommon->getKeyValue("write list",  $shareName, \@section);
my $public            = $confCommon->getKeyValue("public",      $shareName, \@section);
my $guestOk           = $confCommon->getKeyValue("guest ok",    $shareName, \@section);
my $validUser_Group   = $confCommon->getKeyValue("valid users", $shareName, \@section);
my $invalidUser_Group = $confCommon->getKeyValue("invalid users",$shareName, \@section);
my $hostsAllow        = $confCommon->getKeyValue("hosts allow", $shareName, \@section);
my $hostsDeny         = $confCommon->getKeyValue("hosts deny",  $shareName, \@section);
my $writeBack         = $confCommon->getKeyValue("write back",  $shareName, \@section);
my $userName          = $confCommon->getKeyValue("username",    $shareName, \@section);
my $shadowCopy        = $confCommon->getKeyValue("sxfs shadow copy",  $shareName,\@section);
my $dirAclValid       = $confCommon->getKeyValue("dir access control", $shareName, \@section);
my $shareExist        = $cifsCommon->isShareNameUsed($groupNumber, $domainName, $computerName, $shareName);
my $oldFileTimes      = "";
my $sharePurpose      = $cifsCommon->getShareType($shareName, \@section);

defined($connection)        or $connection        = "";
defined($directory)         or $directory         = "";
defined($comment)           or $comment           = "";
defined($readOnly)          or $readOnly          = "";
defined($writeable)         or $writeable         = "";
defined($writeList)         or $writeList         = "";
defined($public)            or $public            = "";
defined($guestOk)           or $guestOk           = "";
defined($validUser_Group)   or $validUser_Group   = "";
defined($invalidUser_Group) or $invalidUser_Group = "";
defined($hostsAllow)        or $hostsAllow        = "";
defined($hostsDeny)         or $hostsDeny         = "";
defined($writeBack)         or $writeBack         = "";
defined($userName)          or $userName          = "";
defined($shadowCopy)        or $shadowCopy        = "";
defined($dirAclValid)       or $dirAclValid       = "";
defined($shareExist)        or $shareExist       = "";
defined($sharePurpose)      or $sharePurpose      = "normal";

my $antiVirusForGlobal = "";
my $noScan = "";
my $antiVirusForShare = "";
my $antiVirus = "";
my $browseable = "";
my $pseudoABE = "no";
my $fileSystemType = "";

if($sharePurpose eq "normal") {
    $noScan             = $confCommon->getKeyValue("no scan", $shareName, \@section);
    $antiVirusForGlobal = $confCommon->getKeyValue("virus scan mode", "global", $smbContent);
    defined ($noScan)            or $noScan            = "no";
    defined($antiVirusForGlobal) or $antiVirusForGlobal = "no";
    $antiVirusForGlobal = $cifsCommon->equalsIgnoreCase($antiVirusForGlobal, "yes");
    $antiVirusForShare  = $cifsCommon->equalsIgnoreCase($noScan, "yes") eq "no" ? "yes" : "no";
    $antiVirus          = $cifsCommon->getFinalAntiVirus($noScan, $antiVirusForGlobal);
    $pseudoABE          = $confCommon->getKeyValue("pseudo abe", $shareName, \@section);
    defined($pseudoABE) or $pseudoABE = "no";
    $pseudoABE          = $cifsCommon->convertBoolean($pseudoABE, "no");
} else {
    $browseable         = $confCommon->getKeyValue("browseable",  $shareName, \@section);
    defined($browseable)        or $browseable        = "yes";
    $browseable         = $cifsCommon->convertBoolean($browseable, "no");
}

my $fsType;
if($directory ne "") {
    $fsType = $cifsCommon->isSXFS_MP($directory, $groupNumber);
}
if(defined($fsType) && $fsType == 0) {
    $oldFileTimes = $confCommon->getKeyValue("sxfsfw filetimes", $shareName, \@section);
    $fileSystemType = "sxfsfw";
} elsif (defined($fsType) && $fsType != 0) {
    $oldFileTimes = $confCommon->getKeyValue("dos filetimes", $shareName, \@section);
    $fileSystemType = "sxfs";
}
defined($oldFileTimes)      or $oldFileTimes      = "";

$connection = $cifsCommon->convertBoolean($connection, "yes");
$readOnly   = $cifsCommon->convertBoolean($readOnly,   "yes");
$writeable  = $cifsCommon->convertBoolean($writeable,  "yes");
$public     = $cifsCommon->convertBoolean($public,     "no");
$guestOk    = $cifsCommon->convertBoolean($guestOk,    "no");
$writeBack  = $cifsCommon->convertBoolean($writeBack,  "yes");
$dirAclValid= $cifsCommon->convertBoolean($dirAclValid,  "no");
$shareExist= $cifsCommon->convertBoolean($shareExist,  "no");
$oldFileTimes = $cifsCommon->convertBoolean($oldFileTimes, "no");

$shadowCopy  = $cifsCommon->convertBoolean($shadowCopy,  "no");
my $oldshadowCopy = $shadowCopy;

my $readOnlyIndex  = $confCommon->getKeyIndex("read only",   $shareName, \@section);
my $writeableIndex = $confCommon->getKeyIndex("writeable",   $shareName, \@section);
my $publicIndex    = $confCommon->getKeyIndex("public",      $shareName, \@section);
my $guestOkIndex   = $confCommon->getKeyIndex("guest ok",    $shareName, \@section);

#proccess readOnly
if ($readOnlyIndex < $writeableIndex){
    $readOnly = ($writeable eq "yes") ? "no" : "yes";
}

#proccess settingPassword
my $settingPassword = ($public eq "yes") ? "no" : "yes";
if ($publicIndex < $guestOkIndex){
    $settingPassword = ($guestOk eq "yes") ? "no" : "yes";
}

#proccess serverProtect
my $serverProtect = ($writeBack eq "yes") ? "no" : "yes";

#proccess comment
$comment=~s/^\"|\"$//g;

my $directoryForPrint = $codeConvert->changeUTF8Encoding($directory, $expGroupEncoding, $codeConvert->ENCODING_UTF_8);
my $commentForPrint = $codeConvert->changeUTF8Encoding($comment, $expGroupEncoding, $codeConvert->ENCODING_UTF_8);
$directory = defined($directoryForPrint) ? $directoryForPrint : $directory;
$comment = defined($commentForPrint) ? $commentForPrint : $comment;

print "shareName=$shareNameNoChange\n";
print "connection=$connection\n";
print "directory=$directory\n";
print "comment=$comment\n";
print "readOnly=$readOnly\n";
print "writeList=$writeList\n";
print "settingPassword=$settingPassword\n";
print "validUser_Group=$validUser_Group\n";
print "invalidUser_Group=$invalidUser_Group\n";
print "hostsAllow=$hostsAllow\n";
print "hostsDeny=$hostsDeny\n";
print "serverProtect=$serverProtect\n";
print "userName=$userName\n";
print "shadowCopy=$shadowCopy\n";
print "oldshadowCopy=$oldshadowCopy\n";
print "dirAccessControlAvailable=$dirAclValid\n";
print "oldFileTimes=$oldFileTimes\n";
print "shareExist=$shareExist\n";
print "sharePurpose=$sharePurpose\n";
print "browseable=$browseable\n";
print "antiVirusForGlobal=$antiVirusForGlobal\n";
print "antiVirusForShare=$antiVirusForShare\n";
print "antiVirus=$antiVirus\n";

my $validUserForScheduleScan = "";
my $allowHostForScheduleScan = "";
if($sharePurpose eq "realtime_scan"){
	my $ssFileContent = $ssCommon->getFileContent($groupNumber, $domainName, $computerName);
	if(defined($ssFileContent)){
        $validUserForScheduleScan = $confCommon->getKeyValue('valid users', 'global', $ssFileContent);
        $allowHostForScheduleScan = $ssCommon->getScanServer($ssFileContent);
    }
    defined($validUserForScheduleScan) or $validUserForScheduleScan = "";
    defined($allowHostForScheduleScan) or $allowHostForScheduleScan = "";
}
print "validUserForScheduleScan=$validUserForScheduleScan\n";
print "allowHostForScheduleScan=$allowHostForScheduleScan\n";
print "pseudoABE=$pseudoABE\n";
print "fsType=$fileSystemType\n";

exit 0;
